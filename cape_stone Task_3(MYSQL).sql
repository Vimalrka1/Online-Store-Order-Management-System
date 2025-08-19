create database OnlineStore;
use OnlineStore;

create table Customers (
CUSTOMER_ID int primary key, 
NAME varchar (25), 
EMAIL varchar (200),
PHONE bigint, 
ADDRESS varchar (200));

Insert into Customers values 
(211,'Shankar','Shankar@gmail.com',9176221122,'Madavaram, Chennai'),
(222,'Mukesh','Mukesh@gmail.com',9176220413,'Kodambakkam,Chennai'),
(233,'Praveen','Praveen@gmail.com',9176220474,'Anna Nagar,Chennai'),
(244,'Shrinath','Shrinath@gmail.com',9176110415,'Saidapet,Chennai'),
(255,'Vignesh','Vignesh@gmail.com',9176239116,'velachery,Chennai'),
(266,'Vimalrka','Vimalrka@gmail.com',9135674171,'Tambaram,Chennai'),
(277,'Kamaraj','Kamaraj@gmail.com',9176220418,'Medavakkam,Chennai'),
(288,'Sekar','Sekar@gmail.com',9176231418,'Anna Nagar,Chennai'),
(299,'Lokesh','Lokesh@gmail.com',9176276751,'Anna Nagar,Chennai'),
(311,'Joshua','Joshua@gmail.com',9176220498,'velachery,Chennai');

Create table Products (
PRODUCT_ID int, 
PRODUCT_NAME varchar(200), 
CATEGORY varchar(25), 
PRICE int, 
STOCK int);

alter table Products
modify  PRICE decimal;

Insert into Products values
('B0CK2QHML3','SKY-TOUCH Dog Treats: 400g Chicken Wrapped','PET_FOOD',21.4,3),
('B0C3RJVT3M','SKY-TOUCH Auto Close Safety Baby Gate, Extra Wide Child Gate 75-84cm','TEMPORARY_GATE',127.6,12),
('B0B9J4577K','SKY-TOUCH Baby Proofing Plug Covers,Plug Socket Covers,Outlet Covers','BABY_PRODUCT',14.5,4),
('B0DHLJDDJ3','SKY-TOUCH 80 Pieces Baby Disposable Changing Mats,Waterproof Baby Changing Pads','CHANGING_PAD',56.3,82),
('B0CJM5X73Z','SKY-TOUCH Auto Close Safety Baby Gate','TEMPORARY_GATE',96.3,7),
('B0CSK48PWX','SKY-TOUCH Auto Close Safety Baby Gate, 80.00 x 6.00 x 75.00 cm Durable Fence Barrier','TEMPORARY_GATE',96.2,23),
('B09QQQVGT3','SKY TOUCH 5pcs Muslin Baby Washcloths and Towels, Natural Organic Cotton Baby Washcloths','TOWEL',18.1,22),
('B0DJ6TT47R','SKY-TOUCH Handprint and Footprint Frame Makers Kit, Newborn Baby Prints Photo Keepsake Frames','PICTURE_FRAME',27.9,1),
('B0CKXCDW97','SKY-TOUCH Auto Close Safety Baby Gate, Extra Wide Child Gate 75-84cm + 10cm','TEMPORARY_GATE',117.2,3);


Create table Orders (
ORDER_ID int, 
CUSTOMER_ID int, 
PRODUCT_ID varchar(10), 
QUANTITY int, 
ORDER_DATE DATE,
foreign key (CUSTOMER_ID) references Customers(CUSTOMER_ID),
foreign key (PRODUCT_ID) references Products(PRODUCT_ID));


Insert into Orders values
(101,211,'B09QQQVGT3',1,'2025-04-25'),
(102,222,'B0DJ6TT47R',2,'2025-05-26'),
(103,233,'B0C3RJVT3M',4,'2025-07-27'),
(104,244,'B0B9J4577K',5,'2025-04-21'),
(105,255,'B0DHLJDDJ3',3,'2025-04-22'),
(106,266,'B0C3RJVT3M',2,'2025-07-28'),
(107,277,'B0CSK48PWX',1,'2025-05-31'),
(108,288,'B0C3RJVT3M',2,'2025-03-18'),
(109,299,'B0B9J4577K',3,'2025-02-08'),
(110,311,'B0C3RJVT3M',4,'2025-05-30');

select * from orders;

/*Order Management:
#a) Retrieve all orders placed by a specific customer.*/

select *, (select c.NAME
from Customers c
where c.CUSTOMER_ID = o.CUSTOMER_ID) as Customer_Name
from orders o;

#Find products that are out of stock.

select stock,product_id
from products
where stock <=1;

#c) Calculate the total revenue generated per product.

select P.product_id,P.PRICE,SUM(P.PRICE * o.QUANTITY) as Total_revenue
from products p
join orders o on p.PRODUCT_ID = o.PRODUCT_ID
GROUP BY p.product_id, p.PRODUCT_NAME;

#d) Retrieve the top 5 customers by total purchase amount.

select c.NAME,P.product_id,P.PRICE,sum(P.PRICE * o.QUANTITY) as Total_revenue
from products p
join orders o on p.PRODUCT_ID = o.PRODUCT_ID
join customers c on c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY p.product_id, p.PRODUCT_NAME,c.NAME
order by Total_revenue desc
limit 5;

#e) Find customers who placed orders in at least two different product categories.

select c.NAME,P.product_id
from products p
join orders o on p.PRODUCT_ID = o.PRODUCT_ID
join customers c on c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY c.NAME,P.product_id
having count(DISTINCT P.product_id) >= 2;

#a) Find the month with the highest total sales.

select date_format(ORDER_DATE,'%M')as Months,sum(p.price*o.QUANTITY) as total_sales
from orders o
join products p on p.PRODUCT_ID = o.PRODUCT_ID
group by months
order by Total_sales desc
limit 1;

#b) Identify products with no orders in the last 6 months.

SELECT p.product_id, p.product_name, o.ORDER_ID
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id AND 
o.order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) 
WHERE o.order_id IS NULL;

#c) Retrieve customers who have never placed an order.

select c.name,o.ORDER_ID
from customers c		
left join orders o on c.CUSTOMER_ID	= o.CUSTOMER_ID
where o.order_id is null;

#d) Calculate the average order value across all orders 

SELECT AVG(OrderTotal.TotalOrderValue) AS AverageOrderValue
FROM
    (SELECT o.order_id, SUM(p.price * o.quantity) AS TotalOrderValue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY o.order_id) AS OrderTotal;

