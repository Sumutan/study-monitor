#!/usr/bin/env python3
"""作业图片压缩工具 —— 上传时自动压缩

策略：JPEG q90 + 最长边4096px + 去EXIF
与 compress_v2.py 保持一致，但 q90 适合实时处理（q95留给离线全量）
"""
import io
import logging
from pathlib import Path
from PIL import Image, ImageFile, ImageOps

ImageFile.LOAD_TRUNCATED_IMAGES = True
Image.MAX_IMAGE_PIXELS = None

logger = logging.getLogger(__name__)

IMAGE_EXTS = {".jpg", ".jpeg", ".png"}
MIN_SIZE_TO_COMPRESS = 200 * 1024      # 200KB以下不压缩
MAX_DIMENSION = 4096
JPEG_QUALITY = 90
DEFAULT_COMPRESS_QUALITY = 85   # 通用上传接口默认压缩质量


def compress_image_bytes(content: bytes, quality: int = DEFAULT_COMPRESS_QUALITY) -> dict:
    """内存中压缩图片字节流，供各上传接口在落盘前调用（压缩后再写入磁盘）。

    Args:
        content: 原始图片字节
        quality: JPEG 压缩质量，默认 85

    Returns:
        dict: {"content": bytes, "compressed": bool, "orig_kb": float, "new_kb": float, "reason": str}
        content 始终为最终应写入磁盘的字节（未压缩时原样返回）
    """
    if not content:
        return {"content": content, "compressed": False, "orig_kb": 0, "new_kb": 0, "reason": "empty"}

    orig_size = len(content)
    if orig_size < MIN_SIZE_TO_COMPRESS:
        return {"content": content, "compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": "too_small"}

    try:
        img = Image.open(io.BytesIO(content))
        if img.format not in ("JPEG", "PNG"):
            return {"content": content, "compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": "not_supported_format"}

        img = ImageOps.exif_transpose(img)

        if img.mode in ("RGBA", "P", "LA"):
            bg = Image.new("RGB", img.size, (255, 255, 255))
            if img.mode == "P":
                img = img.convert("RGBA")
            bg.paste(img, mask=img.split()[-1] if "A" in img.mode else None)
            img = bg
        elif img.mode != "RGB":
            img = img.convert("RGB")

        w, h = img.size
        if max(w, h) > MAX_DIMENSION:
            if w >= h:
                new_w, new_h = MAX_DIMENSION, int(h * MAX_DIMENSION / w)
            else:
                new_h, new_w = MAX_DIMENSION, int(w * MAX_DIMENSION / h)
            img = img.resize((new_w, new_h), Image.LANCZOS)

        buf = io.BytesIO()
        img.save(buf, "JPEG", quality=quality, optimize=True, progressive=True)
        new_content = buf.getvalue()
        new_size = len(new_content)

        if new_size >= orig_size:
            return {"content": content, "compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": "larger_than_orig"}

        ratio = (1 - new_size / orig_size) * 100
        logger.info(f"[compress_bytes] {orig_size/1024:.0f}KB -> {new_size/1024:.0f}KB (-{ratio:.0f}%)")
        return {"content": new_content, "compressed": True, "orig_kb": orig_size/1024, "new_kb": new_size/1024, "ratio": round(ratio, 1), "reason": "ok"}

    except Exception as e:
        logger.warning(f"[compress_bytes] error {e}")
        return {"content": content, "compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": f"error:{e}"}


def compress_image_on_upload(filepath: str) -> dict:
    """上传后自动压缩图片，原地替换。

    Args:
        filepath: 图片绝对路径

    Returns:
        dict: {"compressed": bool, "orig_kb": float, "new_kb": float, "reason": str}
    """
    p = Path(filepath)
    if not p.exists() or p.suffix.lower() not in IMAGE_EXTS:
        return {"compressed": False, "reason": "not_image_or_not_found"}

    orig_size = p.stat().st_size
    if orig_size < MIN_SIZE_TO_COMPRESS:
        return {"compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": "too_small"}

    tmp_path = p.with_suffix(p.suffix + ".tmp")
    try:
        img = Image.open(p)
        img = ImageOps.exif_transpose(img)

        if img.mode in ("RGBA", "P", "LA"):
            bg = Image.new("RGB", img.size, (255, 255, 255))
            if img.mode == "P":
                img = img.convert("RGBA")
            bg.paste(img, mask=img.split()[-1] if "A" in img.mode else None)
            img = bg
        elif img.mode != "RGB":
            img = img.convert("RGB")

        w, h = img.size
        if max(w, h) > MAX_DIMENSION:
            if w >= h:
                new_w, new_h = MAX_DIMENSION, int(h * MAX_DIMENSION / w)
            else:
                new_h, new_w = MAX_DIMENSION, int(w * MAX_DIMENSION / h)
            img = img.resize((new_w, new_h), Image.LANCZOS)

        img.save(tmp_path, "JPEG", quality=JPEG_QUALITY, optimize=True, progressive=True)
        new_size = tmp_path.stat().st_size

        if new_size >= orig_size:
            tmp_path.unlink(missing_ok=True)
            return {"compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": "larger_than_orig"}

        os_rename = __import__("os").rename
        os_rename(str(tmp_path), str(p))
        ratio = (1 - new_size / orig_size) * 100
        logger.info(f"[compress] {p.name}: {orig_size/1024:.0f}KB -> {new_size/1024:.0f}KB (-{ratio:.0f}%)")
        return {"compressed": True, "orig_kb": orig_size/1024, "new_kb": new_size/1024, "ratio": round(ratio, 1), "reason": "ok"}

    except Exception as e:
        if tmp_path.exists():
            tmp_path.unlink(missing_ok=True)
        logger.warning(f"[compress] {p.name}: error {e}")
        return {"compressed": False, "orig_kb": orig_size/1024, "new_kb": orig_size/1024, "reason": f"error:{e}"}
