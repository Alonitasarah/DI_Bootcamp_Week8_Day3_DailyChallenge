CREATE TABLE Customer (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL
);

CREATE TABLE Customer_Profile (
  id SERIAL PRIMARY KEY,
  isLoggedIn BOOLEAN DEFAULT false,
  customer_id INTEGER REFERENCES Customer(id)
);


INSERT INTO Customer ( first_name, last_name ) VALUES ( 'John', 'Doe' );
INSERT INTO Customer ( first_name, last_name ) VALUES ( 'Jerome', 'Lalu' );
INSERT INTO Customer ( first_name, last_name ) VALUES ( 'Lea', 'Rive' );


INSERT INTO Customer_Profile (isLoggedIn, customer_id)
VALUES (true, (SELECT id FROM Customer WHERE first_name = 'John' AND last_name = 'Doe'));
INSERT INTO customer_Profile (isLoggedIn, customer_id)
VALUES (false, (SELECT id FROM Customer WHERE first_name = 'Jerome' AND last_name = 'Lalu'));


SELECT c.first_name
FROM Customer c
JOIN Customer_Profile cp ON c.id = cp.customer_id
WHERE cp.isLoggedIn = true;

SELECT c.first_name, COALESCE(cp.isLoggedIn, false) AS isLoggedIn
FROM Customer c
LEFT JOIN Customer_Profile cp ON c.id = cp.customer_id;


SELECT COUNT(*)
FROM Customer c
LEFT JOIN Customer_Profile cp ON c.id = cp.customer_id
WHERE cp.isLoggedIn = false OR cp.isLoggedIn IS NULL;

--PART 2

CREATE TABLE Book (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  author VARCHAR(100) NOT NULL
);

CREATE TABLE Student (
  student_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  age INTEGER NOT NULL CHECK (age <= 15)
);


INSERT INTO Book (title, author) VALUES ('Alice In Wonderland', 'Lewis Carroll');
INSERT INTO Book (title, author) VALUES ('Harry Potter', 'J.K Rowling');
INSERT INTO Book (title, author) VALUES ('To kill a mockingbird', 'Harper Lee');


INSERT INTO Student (name, age) VALUES ('John', 12);
INSERT INTO Student (name, age) VALUES ('Lera', 11);
INSERT INTO Student (name, age) VALUES ('Patrick', 10);
INSERT INTO Student (name, age) VALUES ('Bob', 14);

CREATE TABLE Library (
  book_fk_id INTEGER REFERENCES Book(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
  student_fk_id INTEGER REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  borrowed_date DATE,
  PRIMARY KEY (book_fk_id, student_fk_id)
);


INSERT INTO Library (book_fk_id, student_id, borrowed_date)
VALUES (
  (SELECT book_id FROM Book WHERE title = 'Alice In Wonderland'),
  (SELECT student_id FROM Student WHERE name = 'John'),
  '2022-02-15'
);


INSERT INTO Library (book_fk_id, student_id, borrowed_date)
VALUES (
  (SELECT book_id FROM Book WHERE title = 'To kill a mockingbird'),
  (SELECT student_id FROM Student WHERE name = 'Bob'),
  '2021-03-03'
);


INSERT INTO Library (book_fk_id, student_id, borrowed_date)
VALUES (
  (SELECT book_id FROM Book WHERE title = 'Alice In Wonderland'),
  (SELECT student_id FROM Student WHERE name = 'Lera'),
  '2021-05-23'
);


INSERT INTO Library (book_fk_id, student_id, borrowed_date)
VALUES (
  (SELECT book_id FROM Book WHERE title = 'Harry Potter'),
  (SELECT student_id FROM Student WHERE name = 'Bob'),
  '2021-08-12'
);


SELECT * FROM Library;

SELECT s.name AS student_name, b.title AS book_title
FROM Library l
JOIN Student s ON l.student_id = s.student_id
JOIN Book b ON l.book_fk_id = b.book_id;


SELECT AVG(s.age) AS avg_age
FROM Library l
JOIN Student s ON l.student_id = s.student_id
JOIN Book b ON l.book_fk_id = b.book_id
WHERE b.title = 'Alice In Wonderland';

DELETE FROM Student WHERE name = 'John';
