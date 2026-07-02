"""
Task 3 Observation

Without joinedload():
One query fetches enrollments, then additional queries are issued
to fetch related Student and Course objects (N+1 problem).

With joinedload():
All Enrollment, Student and Course data are fetched in a single SQL query.
"""

from sqlalchemy.orm import sessionmaker, joinedload

from models import engine, Department, Student, Course, Enrollment

Session = sessionmaker(bind=engine)

session = Session()

d1 = Department(dept_name="Computer Science")
d2 = Department(dept_name="Mechanical")
d3 = Department(dept_name="Electronics")

session.add_all([d1, d2, d3])
session.commit()

s1 = Student(
    name="Alice",
    email="alice@gmail.com",
    enrollment_year=2022,
    department=d1,
)

s2 = Student(
    name="Bob",
    email="bob@gmail.com",
    enrollment_year=2023,
    department=d1,
)

s3 = Student(
    name="Charlie",
    email="charlie@gmail.com",
    enrollment_year=2022,
    department=d2,
)

s4 = Student(
    name="David",
    email="david@gmail.com",
    enrollment_year=2024,
    department=d3,
)

s5 = Student(
    name="Eva",
    email="eva@gmail.com",
    enrollment_year=2023,
    department=d1,
)

session.add_all([s1, s2, s3, s4, s5])
session.commit()


c1 = Course(course_name="Python", credits=4)
c2 = Course(course_name="Java", credits=3)
c3 = Course(course_name="Database", credits=4)

session.add_all([c1, c2, c3])
session.commit()



e1 = Enrollment(student=s1, course=c1, grade="A")
e2 = Enrollment(student=s2, course=c2, grade="B")
e3 = Enrollment(student=s3, course=c3, grade="A")
e4 = Enrollment(student=s5, course=c1, grade="A")

session.add_all([e1, e2, e3, e4])
session.commit()



print("\nStudents in Computer Science\n")

students = (
    session.query(Student)
    .join(Department)
    .filter(Department.dept_name == "Computer Science")
)

for student in students:
    print(student.name)


print("\nEnrollment Details\n")

enrollments = session.query(Enrollment).all()

for e in enrollments:
    print(e.student.name, "->", e.course.course_name)

student = (
    session.query(Student)
    .filter(Student.email == "alice@gmail.com")
    .first()
)

student.enrollment_year = 2025

session.commit()

print("\nStudent Updated Successfully")


enrollment = session.query(Enrollment).first()

session.delete(enrollment)

session.commit()

print("Enrollment Deleted Successfully")



# TASK 3


print("\nUsing joinedload()\n")

enrollments = (
    session.query(Enrollment)
    .options(
        joinedload(Enrollment.student),
        joinedload(Enrollment.course)
    )
    .all()
)

for e in enrollments:
    print(e.student.name, "->", e.course.course_name)

session.close()