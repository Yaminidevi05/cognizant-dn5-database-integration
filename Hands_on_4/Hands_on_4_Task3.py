import mysql.connector
import time

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="college_db"
)

cursor = conn.cursor()

query_count = 0

start = time.time()

cursor.execute("SELECT * FROM enrollments")
enrollments = cursor.fetchall()
query_count += 1

for enrollment in enrollments:
    student_id = enrollment[1]

    cursor.execute(
        "SELECT first_name,last_name FROM students WHERE student_id=%s",
        (student_id,)
    )

    cursor.fetchone()
    query_count += 1

end = time.time()

print("Queries executed:", query_count)
print("Time:", end-start)

conn.close()


import mysql.connector
import time

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="college_db"
)

cursor = conn.cursor()

start = time.time()

cursor.execute("""
SELECT e.enrollment_id,
       s.first_name,
       s.last_name,
       e.course_id,
       e.grade
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
""")

rows = cursor.fetchall()

end = time.time()

print("Queries executed: 1")
print("Time:", end-start)

conn.close()

print("N+1 Version:")
print("13 queries executed")

print("JOIN Version:")
print("1 query executed")

print("Reduction = 12 fewer database round-trips")

"""
N+1 Problem:

1 query fetches all enrollments.

For each enrollment another query fetches
student information.

If there are 10,000 enrollments:

1 + 10,000

= 10,001 queries

Optimized JOIN approach:

Only 1 query

Reduction:

10,000 fewer database queries.
"""