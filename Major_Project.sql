CREATE DATABASE OnlineBookStore;

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
		Book_ID SERIAL PRIMARY KEY,
		Title VARCHAR (100),
		Author VARCHAR (100),
		Genre VARCHAR(50),
		Published_Year INT,
		Price NUMERIC(10,2),
		Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


--import data into books tables
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\SQL\Books.csv'
CSV HEADER;

--IMPORT DATA INTO CUSTOMERS TABLE 
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\SQL\Customers.csv'
CSV HEADER;

--IMPORT DATA INTO ORDERS TABLE 
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\SQL\Orders.csv'
CSV HEADER;


--Basic queries

--1) Retrieve all books in the fiction genre.
SELECT * FROM Books
WHERE genre = 'Fiction';

--2) Find Books published after the year 1950
SELECT * FROM Books 
WHERE published_year>1950 ;

--3) List all the customers from Canada
SELECT * FROM Customers
WHERE country='Canada';

--4) Show orders placed in November 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available 
SELECT SUM(stock) AS total_stock
FROM Books;

--6)Find the details of the most expensive books
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

--7) Show all customers who order more than 1 quantity of books
SELECT * FROM Orders
WHERE quantity> 1;;

--8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE total_amount>20;

--9)List all genres available in the bookstore
SELECT DISTINCT genre FROM Books;

--10)Find the book with the lowest stock
SELECT * FROM Books ORDER BY stock ASC LIMIT 1;

--11) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) FROM Orders;

--Advance queries
--1) Retrieve the total number of books sold for each genre
SELECT * FROM Orders;

SELECT b.genre, SUM(o.quantity) AS total_book_sold
FROM Orders o
JOIN Books b ON 
o.book_id = b.book_id
GROUP BY b.genre;

--2) Find the average price of books in the fantasy genre.
SELECT * FROM Books;

SELECT  AVG(price) AS total_fantasy_price
FROM Books
WHERE genre = 'Fantasy';

--3) List customers who have placed atleast 2 orders
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS order_count
FROM Orders o
JOIN Customers c ON c.customer_id= o.customer_id
GROUP BY o.customer_id, c.name 
HAVING COUNT(Order_id) >=2;

--4)Find the most frequently orders book
SELECT o.Book_id, b.title, COUNT(o.order_id) AS Order_count
FROM Orders o
JOIN Books b ON o.book_id= b.book_id
GROUP BY o.Book_id, b.title
ORDER BY Order_count DESC LIMIT 1;

--5)Show the top 3 most expensive books of 'Fantasy' genre
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

--6)Retrieve the total quantity of books sold by each author
SELECT b.Author, SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN books b ON o.book_id= b.book_id
GROUP BY b.Author;

--7)List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount> 30;

--8)Find the customers who spent the most on orders 
SELECT c.customer_id, c.name, SUM(o.total_amount) AS spend_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY spend_orders DESC;


--Very important query
--9)Calculate the stock remaining after fulfilling all orders 
SELECT b.book_id, b.title, b.stock, COALESCE (SUM(o.quantity),0) AS order_quantity,
		b.stock - COALESCE (SUM(o.quantity),0) AS remaining_quantity
FROM orders o
LEFT JOIN books b ON b.book_id = o.book_id
GROUP BY b.book_id ORDER BY b.book_id;







