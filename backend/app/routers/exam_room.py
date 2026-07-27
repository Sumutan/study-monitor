"""考场查询接口"""
from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.utils.jwt_helper import get_current_user
from app.models.models import User, ExamRoom
from app.database import get_db

router = APIRouter(prefix="/api/exam-room", tags=["exam-room"])


@router.get("/my")
async def get_my_exam_room(current_user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    """当前学生查询自己的考场信息"""
    result = await db.execute(
        select(ExamRoom).where(ExamRoom.admission_number == current_user.account)
    )
    exam = result.scalar_one_or_none()
    if not exam:
        return {"code": 1, "msg": "未找到考场信息"}
    return {
        "code": 0,
        "data": {
            "student_name": exam.student_name,
            "admission_number": exam.admission_number,
            "seat_number": exam.seat_number,
            "exam_room": exam.exam_room,
        }
    }