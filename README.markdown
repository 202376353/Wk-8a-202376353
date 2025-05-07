# Library Management System Database

## Description
This project is a comprehensive relational database for a Library Management System implemented in MySQL. It manages books, members, authors, publishers, categories, book items, loans, fines, reservations, and staff. The database supports key library operations such as tracking book availability, member borrowing history, fines, and reservations, with well-defined relationships (1-1, 1-M, M-M) and constraints (PK, FK, NOT NULL, UNIQUE).

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Database Structure](#database-structure)
- [Contributing](#contributing)
- [Contact](#contact)

## Installation
To set up the Library Management System database locally, follow these steps:

1. Ensure MySQL is installed on your system.
2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/library-management-system.git
   ```
3. Navigate to the project directory:
   ```bash
   cd library-management-system
   ```
4. Create the database and import the SQL file:
   ```bash
   mysql -u your_username -p < library_management.sql
   ```
   Replace `your_username` with your MySQL username. Enter your password when prompted. The `library_management.sql` file creates the database, tables, and inserts sample data.

## Usage
After importing the SQL file, you can interact with the database using MySQL commands or tools like MySQL Workbench or phpMyAdmin. Example queries to explore the database:
```sql
-- View all available books
SELECT b.title, bi.barcode, bi.status 
FROM books b 
JOIN book_items bi ON b.book_id = bi.book_id 
WHERE bi.status = 'Available';

-- View member borrowing history
SELECT m.first_name, m.last_name, b.title, l.checkout_date, l.due_date
FROM members m
JOIN loans l ON m.member_id = l.member_id
JOIN book_items bi ON l.item_id = bi.item_id
JOIN books b ON bi.book_id = b.book_id;
```

The `library_management.sql` file contains all `CREATE TABLE` statements, constraints, and sample data for testing.

## Database Structure
The database consists of the following tables with their relationships and constraints:

- **members**: Stores member details (e.g., name, email, membership status). 
- **authors**: Stores author information (e.g., name, nationality).
- **publishers**: Stores publisher details (e.g., name, contact info).
- **categories**: Stores book categories (e.g., Fiction, Fantasy).
- **books**: Stores book metadata (e.g., ISBN, title, publisher). 
- **book_authors**: Junction table for books-authors M-M relationship. 
- **book_categories**: Junction table for books-categories M-M relationship. 
- **book_items**: Stores physical book copies (e.g., barcode, condition). 
- **loans**: Tracks borrowing records (e.g., checkout date, due date).
- **fines**: Stores fine details (e.g., amount, status).
- **reservations**: Manages book reservations (e.g., reservation date, status).
- **staff**: Stores library employee details (e.g., position, salary).



**Sample Data**:
The SQL file includes sample data for all tables, such as 5 books, 5 authors, 8 book items, 5 members, 5 staff, and related loans, fines, and reservations.

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

Please read our [Contributing Guidelines] for more details.



## Contact
For questions or feedback:
- Email: sinothandojohnson3@gmail.com
