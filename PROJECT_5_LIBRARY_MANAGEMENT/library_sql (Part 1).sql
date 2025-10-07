Select * from books;
Select * from branch;
Select * from employees;
Select * from issued_status;
Select * from members;
Select * from return_status;


---Project Task---
---Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"---
insert into books values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
---Task 2: Update an Existing Member's Address---
UPDATE MEMBERS
SET MEMBER_ADDRESS = '125 Oak St'
WHERE MEMBER_ID = 'C103';
---Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.---
DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID = 'IS121';
---Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.---
SELECT * FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID = 'E101';
---Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.---
Select 
	issued_emp_id,
	count(*) as net
from issued_status
group by 1
having count(*) > 1
---Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**---
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
---Task 7. Retrieve All Books in a Specific Category:---
SELECT * FROM books
WHERE category = 'Classic';
---Task 8: Find Total Rental Income by Category:---
SELECT 
	b.category,
	sum(b.rental_price),
	count(*)
from books as b
join
issued_status as ist
on b.isbn = ist.issued_book_isbn
group by 1
---Task 9 : List Members Who Registered in the Last 180 Days:---
select * from members
where reg_date >= CURRENT_DATE - INTERVAL '180 days';
---Task 10: List Employees with Their Branch Manager's Name and their branch details:---
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id
---Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:---
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;
---Task 12: Retrieve the List of Books Not Yet Returned---
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
