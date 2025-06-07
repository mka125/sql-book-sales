
-- List All Available Books 
SELECT isbn, book_title, author, category, rental_price
FROM books
WHERE status = 'yes'
ORDER BY book_title;


-- Total Books by Category 
SELECT category, COUNT(*) AS book_count
FROM books
GROUP BY category
ORDER BY book_count DESC;


-- Total Rental Revenue Potential 
SELECT SUM(rental_price) AS total_potential_revenue
FROM books
WHERE status = 'yes';

-- Rank Books by Rental Price within Category 
SELECT book_title, category, rental_price,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY rental_price DESC) AS price_rank
FROM books
WHERE status = 'yes';


-- Overdue Books 
SELECT i.issued_id, i.issued_book_name, i.issued_date,
       CURRENT_DATE - i.issued_date AS days_since_issued
FROM issued i
LEFT JOIN return r ON i.issued_id = r.issued_id
WHERE r.issued_id IS NULL AND CURRENT_DATE - i.issued_date > 30
ORDER BY days_since_issued DESC;

-- : Branch Performance by Issue Volume 
WITH BranchIssues AS (
    SELECT e.branch_id, b.branch_address, COUNT(i.issued_id) AS issue_count
    FROM issued i
    JOIN employee e ON i.issued_emp_id = e.emp_id
    JOIN branch b ON e.branch_id = b.branch_id
    GROUP BY e.branch_id, b.branch_address
)
SELECT branch_address, issue_count,
       DENSE_RANK() OVER (ORDER BY issue_count DESC) AS branch_rank
FROM BranchIssues

-- Identify Members with Overdue Books
SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF(DAY, ist.issued_date, GETDATE()) as over_dues_days
FROM issued_status AS ist
INNER JOIN members AS m ON m.member_id = ist.issued_member_id
INNER JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
    AND DATEDIFF(DAY, ist.issued_date, GETDATE()) > 30
ORDER BY ist.issued_member_id;

-- Update Book Status on Return
-- Insert into return_status
INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
VALUES ('RS125', 'IS130', GETDATE(), 'Good');

-- Update books
UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';

-- Branch Performance Report
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rs.return_id) AS number_of_book_return,
    SUM(bk.rental_price) AS total_revenue
INTO branch_reports
FROM issued_status AS ist
INNER JOIN employees AS e ON e.emp_id = ist.issued_emp_id
INNER JOIN branch AS b ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
INNER JOIN books AS bk ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id, b.manager_id;

-- Create a Table of Active Members
SELECT * 
INTO active_members
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id   
    FROM issued_status
    WHERE issued_date >= DATEADD(MONTH, -2, GETDATE())
);

-- Find Employees with the Most Book Issues Processed
SELECT TOP 3
    e.emp_name,
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
INNER JOIN employees AS e ON e.emp_id = ist.issued_emp_id
INNER JOIN branch AS b ON e.branch_id = b.branch_id
GROUP BY e.emp_name, b.branch_id, b.manager_id
ORDER BY no_book_issued DESC;




