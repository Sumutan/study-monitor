"""考场查询接口"""
from fastapi import APIRouter, Depends
from app.dependencies import get_current_user
from app.models.models import User, ExamRoom
from app.database import get_db
from sqlalchemy.orm import Session

router = APIRouter(prefix="/api/exam-room", tags=["exam-room"])


@router.get("/my")
def get_my_exam_room(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    """当前学生查询自己的考场信息"""
    exam = db.query(ExamRoom).filter(ExamRoom.admission_number == current_user.account).first()
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