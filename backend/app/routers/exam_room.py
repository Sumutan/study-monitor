"""
考场查询模块

功能：学生登录后查询自己的准考证对应的座位号和考场。
API:
    GET /api/exam-room/my — 获取当前学生的考场信息
"""

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.models import User, ExamRoom
from app.utils.jwt_helper import get_current_user

router = APIRouter(prefix="/api/exam-room", tags=["考场查询"])


@router.get("/my")
async def get_my_exam_room(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    获取当前登录学生的考场信息

    通过当前用户的 account（准考证号）查询 exam_rooms 表，
    返回座位号和考场。
    """
    account = (current_user.account or "").strip()
    if not account:
        return {"code": 1, "msg": "账号信息为空"}

    result = await db.execute(
        select(ExamRoom).where(ExamRoom.admission_number == account)
    )
    exam_room = result.scalar_one_or_none()

    if not exam_room:
        return {"code": 1, "msg": "未找到您的考场信息，请联系老师"}

    return {
        "code": 0,
        "data": {
            "student_name": exam_room.student_name,
            "admission_number": exam_room.admission_number,
            "seat_number": exam_room.seat_number,
            "exam_room": exam_room.exam_room,
        },
    }