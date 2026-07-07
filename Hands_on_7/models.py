from sqlalchemy import Column, Integer, String, ForeignKey  # type: ignore[import]
from sqlalchemy.orm import declarative_base, relationship  # type: ignore[import]

Base = declarative_base()


class Department(Base):

    __tablename__="departments"

    department_id=Column(Integer,primary_key=True)
    department_name=Column(String(100))

    students=relationship("Student",back_populates="department")


class Student(Base):

    __tablename__="students"

    student_id=Column(Integer,primary_key=True)
    student_name=Column(String(100))
    age=Column(Integer)

    department_id=Column(Integer,
                         ForeignKey("departments.department_id"))

    department=relationship("Department",
                            back_populates="students")

    enrollments=relationship("Enrollment",
                             back_populates="student")


class Professor(Base):

    __tablename__="professors"

    professor_id=Column(Integer,primary_key=True)
    professor_name=Column(String(100))


class Course(Base):

    __tablename__="courses"

    course_id=Column(Integer,primary_key=True)
    course_name=Column(String(100))

    professor_id=Column(Integer,
                        ForeignKey("professors.professor_id"))

    enrollments=relationship("Enrollment",
                             back_populates="course")


class Enrollment(Base):

    __tablename__="enrollments"

    enrollment_id=Column(Integer,primary_key=True)

    student_id=Column(Integer,
                      ForeignKey("students.student_id"))

    course_id=Column(Integer,
                     ForeignKey("courses.course_id"))

    student=relationship("Student",
                         back_populates="enrollments")

    course=relationship("Course",
                        back_populates="enrollments")