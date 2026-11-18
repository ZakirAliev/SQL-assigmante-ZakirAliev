# SQL and Database Design Assignments

University coursework on SQL and relational database design. It has one MySQL script (SalesDB setup, 10 basic tasks and 28 scenario queries) and two ER diagrams (sales database and university course registration).

## Files

- `SalesDB_Assignments_Solutions.sql` - table creation, sample data and all SQL tasks
- `Assignment4_Sales_ERD.pdf` / `Assignment4_ERD.png` - ER diagram for the sales database
- `Assignment5_University_ERD.pdf` / `Assignment5_ERD.png` - ER diagram for the university registration database

## SQL script

Written for MySQL. The script does the following in order:

1. Creates the `SalesDB` database and the tables `Customers`, `Products`, `Employees` and `Orders`, then inserts sample data.
2. Part I: 10 basic tasks (SELECT, WHERE, ORDER BY, LIKE, JOIN, GROUP BY, INSERT/UPDATE/DELETE).
3. Assignment 1: customer analysis (7 tasks).
4. Assignment 2: order and delivery queries (9 tasks).
5. Assignment 3: products and employee performance (12 tasks).

To run it:

```sql
SOURCE SalesDB_Assignments_Solutions.sql;
```

Note: the script starts with `DROP DATABASE IF EXISTS SalesDB;`, so it will delete an existing database with the same name.

## ER diagrams

**Assignment 4 (sales database):** Customers, Products, Employees and Orders. Each of Customers, Products and Employees has a 1:N relationship with Orders. Employees also has a 1:N relationship with itself (manager and employees).

![Assignment 4](Assignment4_ERD.png)

**Assignment 5 (university registration):** Students, Instructors, Courses and Enrollments. Students and Courses are many-to-many, so the Enrollments table is used between them. A unique key on (StudentID, CourseID) stops a student from registering for the same course twice.

![Assignment 5](Assignment5_ERD.png)

