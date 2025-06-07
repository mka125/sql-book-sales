
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

