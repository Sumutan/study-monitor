#!/usr/bin/env python3
"""作业图片压缩工具 —— 上传时自动压缩

策略：JPEG q90 + 最长边4096px + 去EXIF
与 compress_v2.py 保持一致，但 q90 适合实时处理（q95留给离线全量）
"""
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
