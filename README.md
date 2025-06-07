# sql-book-sales
SQL queries for a Library Management System to manage books, employees, members, issues, returns, and branches

2.	Database Schema: 
o	Tables: books (isbn, book_title, author, category, rental_price, status, publisher), employee (emp_id, emp_name, position, branch_id, salary), member (member_id, member_name, reg_date), issued (issued_id, issued_book_isbn, issued_member_id, issued_emp_id, issued_date), return (issued_id, return_date), branch (branch_id, branch_address).
o	Relationships: Primary keys (e.g., isbn, emp_id) and foreign keys (e.g., issued_book_isbn references books.isbn).

	Purpose: List available books for borrowing.
	Explanation: Filters books with status = 'yes', sorts by title.

	Purpose: Show book distribution by category.
	Explanation: Aggregates with COUNT and GROUP BY, sorts by count.

	Purpose: Calculate potential revenue from available books.
	Explanation: Uses SUM to aggregate rental_price for available books.

	Purpose: Rank books by price within each category.
	Explanation: Uses DENSE_RANK window function with PARTITION BY for category-wise ranking.

	
	Purpose: Identify books not returned after 30 days.
	Explanation: Uses LEFT JOIN to find unreturned books, calculates days since issued.

	Purpose: Rank branches by book issue volume.
	Explanation: Uses CTE for issue counts, DENSE_RANK for ranking.

•  Technical Skills: 
•	Basic SQL: SELECT, WHERE, ORDER BY.
•	Aggregations: COUNT, SUM, AVG, GROUP BY.
•	Joins: INNER JOIN, LEFT JOIN.
•	Window Functions: DENSE_RANK, LAG, FIRST_VALUE.
•	Date Functions: EXTRACT, CURRENT_DATE.
•	CTEs: Modular query design.
•  Business Insights: 
•	Inventory: Track available books and category distribution.
•	Borrowing: Identify overdue books, member borrowing patterns.
•	Performance: Rank branches by issue volume.
•	Revenue: Calculate potential and actual revenue.

Project Overview: 
•	Description: A set of SQL queries for a Sales Management System to analyze cities, customers, products, and sales data.
•	Purpose: Provide insights into sales trends, customer behavior, product performance, and city-based sales metrics.

