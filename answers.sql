-- Library Management System Database

-- Create database
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- Members table (1-M with Loans)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    membership_date DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Authors table (M-M with Books through book_authors)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year INT,
    death_year INT,
    nationality VARCHAR(50),
    biography TEXT
);

-- Publishers table (1-M with Books)
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL UNIQUE,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100)
);

-- Categories table (M-M with Books through book_categories)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Books table (1-M with BookItems, M-M with Authors and Categories)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    publication_year INT,
    edition INT,
    description TEXT,
    page_count INT,
    language VARCHAR(30),
    CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) 
        REFERENCES publishers(publisher_id) ON DELETE SET NULL
);

-- Book-Authors relationship table (M-M)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Book-Categories relationship table (M-M)
CREATE TABLE book_categories (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_bc_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_bc_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- BookItems table (physical copies, 1-M with Loans)
CREATE TABLE book_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) UNIQUE NOT NULL,
    acquisition_date DATE NOT NULL,
    price DECIMAL(10,2),
    condition ENUM('New', 'Good', 'Fair', 'Poor', 'Withdrawn') DEFAULT 'Good',
    location VARCHAR(50),
    status ENUM('Available', 'Checked Out', 'Lost', 'Damaged', 'In Processing') DEFAULT 'Available',
    CONSTRAINT fk_item_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- Loans table (M-1 with Members and BookItems)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    return_date DATETIME,
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT fk_loan_item FOREIGN KEY (item_id) REFERENCES book_items(item_id),
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Fines table (1-1 with Loans)
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    CONSTRAINT fk_fine_loan FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Reservations table (M-1 with Members and Books)
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiration_date DATETIME NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') DEFAULT 'Pending',
    CONSTRAINT fk_reservation_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_reservation_member FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Staff table (for library employees)
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    CONSTRAINT chk_staff_email CHECK (email LIKE '%@%.%')
);

-- Sample data insertion

-- Insert publishers
INSERT INTO publishers (publisher_name, address, phone, email, website) VALUES
('Penguin Random House', '1745 Broadway, New York, NY 10019', '212-782-9000', 'info@penguinrandomhouse.com', 'www.penguinrandomhouse.com'),
('HarperCollins', '195 Broadway, New York, NY 10007', '212-207-7000', 'contact@harpercollins.com', 'www.harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020', '212-698-7000', 'inquiries@simonandschuster.com', 'www.simonandschuster.com'),
('Macmillan Publishers', '120 Broadway, New York, NY 10271', '646-307-5151', 'press@macmillan.com', 'www.macmillan.com');

-- Insert authors
INSERT INTO authors (first_name, last_name, birth_year, death_year, nationality, biography) VALUES
('George', 'Orwell', 1903, 1950, 'British', 'Eric Arthur Blair, better known by his pen name George Orwell, was an English novelist, essayist, journalist, and critic.'),
('J.K.', 'Rowling', 1965, NULL, 'British', 'Joanne Rowling, better known by her pen name J.K. Rowling, is a British author and philanthropist.'),
('J.R.R.', 'Tolkien', 1892, 1973, 'British', 'John Ronald Reuel Tolkien was an English writer, poet, philologist, and academic.'),
('Jane', 'Austen', 1775, 1817, 'British', 'Jane Austen was an English novelist known primarily for her six major novels.'),
('Stephen', 'King', 1947, NULL, 'American', 'Stephen Edwin King is an American author of horror, supernatural fiction, suspense, and fantasy novels.');

-- Insert categories
INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Imaginary stories and narratives'),
('Non-Fiction', 'Factual writing based on real events and information'),
('Science Fiction', 'Fiction dealing with futuristic concepts, space travel, time travel, etc.'),
('Fantasy', 'Fiction set in imaginary universes, often with magic or supernatural elements'),
('Horror', 'Fiction intended to scare, unsettle, or frighten the reader'),
('Romance', 'Fiction focusing on love and romantic relationships'),
('Biography', 'Non-fiction accounts of people''s lives');

-- Insert books
INSERT INTO books (isbn, title, publisher_id, publication_year, edition, description, page_count, language) VALUES
('978-0451524935', '1984', 1, 1949, 1, 'A dystopian novel set in a totalitarian society ruled by the Party.', 328, 'English'),
('978-0439554930', 'Harry Potter and the Philosopher''s Stone', 2, 1997, 1, 'The first novel in the Harry Potter series.', 223, 'English'),
('978-0547928227', 'The Hobbit', 3, 1937, 1, 'Fantasy novel about the quest of home-loving Bilbo Baggins.', 310, 'English'),
('978-1503290563', 'Pride and Prejudice', 4, 1813, 1, 'Romantic novel of manners set in rural England.', 279, 'English'),
('978-1501142970', 'It', 1, 1986, 1, 'Horror novel about an evil entity that preys on children.', 1138, 'English');

-- Insert book-authors relationships
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert book-categories relationships
INSERT INTO book_categories (book_id, category_id) VALUES
(1, 1), (1, 3),
(2, 1), (2, 4),
(3, 1), (3, 4),
(4, 1), (4, 6),
(5, 1), (5, 5);

-- Insert book items
INSERT INTO book_items (book_id, barcode, acquisition_date, price, condition, location, status) VALUES
(1, 'LIB-10001', '2020-01-15', 12.99, 'Good', 'Fiction Aisle 1', 'Available'),
(1, 'LIB-10002', '2020-01-15', 12.99, 'Fair', 'Fiction Aisle 1', 'Available'),
(2, 'LIB-20001', '2019-05-22', 14.99, 'Good', 'Children''s Section', 'Available'),
(2, 'LIB-20002', '2019-05-22', 14.99, 'New', 'Children''s Section', 'Checked Out'),
(3, 'LIB-30001', '2021-03-10', 10.99, 'Good', 'Fantasy Section', 'Available'),
(4, 'LIB-40001', '2018-11-05', 9.99, 'Fair', 'Classics Section', 'Available'),
(5, 'LIB-50001', '2022-02-18', 18.99, 'New', 'Horror Section', 'Available'),
(5, 'LIB-50002', '2022-02-18', 18.99, 'Good', 'Horror Section', 'Available');

-- Insert members
INSERT INTO members (first_name, last_name, email, phone, address, date_of_birth, membership_date, membership_status) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St, Anytown, USA', '1985-07-15', '2020-03-10', 'Active'),
('Sarah', 'Johnson', 'sarah.j@email.com', '555-0102', '456 Oak Ave, Somewhere, USA', '1990-11-22', '2021-01-05', 'Active'),
('Michael', 'Brown', 'michael.b@email.com', '555-0103', '789 Pine Rd, Nowhere, USA', '1978-04-30', '2019-08-15', 'Expired'),
('Emily', 'Davis', 'emily.d@email.com', '555-0104', '321 Elm St, Anywhere, USA', '1995-02-14', '2022-05-20', 'Active'),
('David', 'Wilson', 'david.w@email.com', '555-0105', '654 Maple Dr, Everywhere, USA', '1982-09-05', '2021-11-11', 'Suspended');

-- Insert staff
INSERT INTO staff (first_name, last_name, email, phone, position, hire_date, salary) VALUES
('Robert', 'Taylor', 'robert.t@library.org', '555-0201', 'Head Librarian', '2015-06-10', 65000.00),
('Jennifer', 'Miller', 'jennifer.m@library.org', '555-0202', 'Assistant Librarian', '2018-02-15', 48000.00),
('Thomas', 'Anderson', 'thomas.a@library.org', '555-0203', 'Cataloging Specialist', '2019-09-03', 42000.00),
('Lisa', 'Martinez', 'lisa.m@library.org', '555-0204', 'Circulation Desk', '2020-07-22', 38000.00),
('James', 'Lee', 'james.l@library.org', '555-0205', 'IT Support', '2021-01-10', 45000.00);

-- Insert loans
INSERT INTO loans (item_id, member_id, checkout_date, due_date, return_date, late_fee) VALUES
(4, 2, '2023-01-10 14:30:00', '2023-01-24', '2023-01-23 10:15:00', 0.00),
(1, 1, '2023-02-05 11:20:00', '2023-02-19', '2023-02-20 09:45:00', 1.50),
(3, 4, '2023-03-15 16:10:00', '2023-03-29', NULL, 0.00),
(7, 2, '2023-03-20 10:45:00', '2023-04-03', NULL, 0.00);

-- Insert fines
INSERT INTO fines (loan_id, amount, issue_date, payment_date, status) VALUES
(2, 1.50, '2023-02-20', '2023-02-21', 'Paid');

-- Insert reservations
INSERT INTO reservations (book_id, member_id, reservation_date, expiration_date, status) VALUES
(3, 1, '2023-03-01 09:00:00', '2023-03-08 09:00:00', 'Fulfilled'),
(5, 3, '2023-03-10 14:30:00', '2023-03-17 14:30:00', 'Expired'),
(2, 4, '2023-03-25 11:15:00', '2023-04-01 11:15:00', 'Pending');
