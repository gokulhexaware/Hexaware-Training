create database retailsales;
use retailsales;

create table customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(40) not null,
    phone varchar(15),
    email varchar(80)
);

create table products (
    product_id int primary key,
    product_name varchar(60) not null,
    category varchar(40) not null,
    unit_price decimal(10,2) not null check (unit_price >= 0)
);

create table orders (
    order_id int primary key,
    customer_id int not null,
    order_date date not null,
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    order_item_id int primary key,
    order_id int not null,
    product_id int not null,
    quantity int not null check (quantity > 0),
    unit_price decimal(10,2) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

create table payments (
    payment_id int primary key,
    order_id int not null unique,
    payment_date date not null,
    payment_method varchar(30),
    amount decimal(10,2) not null,
    foreign key (order_id) references orders(order_id)
);

insert into customers values
(1, 'Arun', 'Chennai', '9876543210', 'arun@gmail.com'),
(2, 'Bala', 'Coimbatore', '9876543211', 'bala@gmail.com'),
(3, 'Chitra', 'Chennai', '9876543212', 'chitra@gmail.com'),
(4, 'Deepak', 'Madurai', '9876543213', 'deepak@gmail.com'),
(5, 'Ezhil', 'Coimbatore', '9876543214', 'ezhil@gmail.com');

insert into products values
(1, 'Cricket Bat', 'Sports', 1500),
(2, 'Cricket Ball', 'Sports', 300),
(3, 'Headphones', 'Electronics', 2000),
(4, 'Smart Phone', 'Electronics', 12000),
(5, 'Notebook', 'Stationery', 100),
(6, 'Pen', 'Stationery', 20);

insert into orders values
(1001, 1, '2026-01-05'),
(1002, 1, '2026-01-10'),
(1003, 1, '2026-02-02'),
(1004, 1, '2026-02-15'),
(1005, 2, '2026-01-07'),
(1006, 2, '2026-03-03'),
(1007, 3, '2026-02-04'),
(1008, 4, '2026-03-03');

insert into order_items values
(1, 1001, 1, 1, 1500),
(2, 1001, 2, 2, 300),
(3, 1002, 3, 1, 2000),
(4, 1003, 4, 1, 12000),
(5, 1004, 5, 10, 100),
(6, 1005, 1, 1, 1500),
(7, 1006, 6, 10, 20),
(8, 1007, 3, 2, 2000),
(9, 1008, 4, 1, 12000),
(10, 1008, 5, 5, 100);

insert into payments values
(1, 1001, '2026-01-05', 'UPI', 2100),
(2, 1002, '2026-01-10', 'Card', 2000),
(3, 1003, '2026-02-02', 'UPI', 12000),
(4, 1005, '2026-01-07', 'Cash', 1500),
(5, 1006, '2026-03-03', 'UPI', 200),
(6, 1007, '2026-02-04', 'Card', 4000),
(7, 1008, '2026-03-03', 'UPI', 12500);


-- 1. top 5 products by revenue

select top 5
    p.product_id,
    p.product_name,
    sum(oi.quantity * oi.unit_price) as total_revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
order by total_revenue desc;


-- 2. month-wise sales

select
    format(o.order_date, 'yyyy-MM') as sales_month,
    round(sum(oi.quantity * oi.unit_price), 2) as monthly_sales,
    concat('Rs. ', format(sum(oi.quantity * oi.unit_price), 'N2')) as formatted_sales
from orders o
join order_items oi on o.order_id = oi.order_id
group by format(o.order_date, 'yyyy-MM')
order by sales_month;


-- 3. customers with more than 3 orders

select
    c.customer_id,
    upper(c.customer_name) as customer_name,
    count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) > 3;


-- 4. average basket value per city

with order_totals as (
    select
        o.order_id,
        c.city,
        sum(oi.quantity * oi.unit_price) as basket_value
    from orders o
    join customers c on o.customer_id = c.customer_id
    join order_items oi on o.order_id = oi.order_id
    group by o.order_id, c.city
)
select
    city,
    round(avg(basket_value), 2) as average_basket_value
from order_totals
group by city
order by average_basket_value desc;


-- 5. orders without payment using left join

select
    o.order_id,
    c.customer_name,
    o.order_date,
    datediff(day, o.order_date, cast(getdate() as date)) as days_since_order
from orders o
join customers c on o.customer_id = c.customer_id
left join payments p on o.order_id = p.order_id
where p.payment_id is null;


-- 6. customers with no orders

select
    c.customer_id,
    c.customer_name,
    c.city
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;


-- 7. product category revenue share

with category_sales as (
    select
        p.category,
        sum(oi.quantity * oi.unit_price) as category_revenue
    from products p
    join order_items oi on p.product_id = oi.product_id
    group by p.category
)
select
    category,
    category_revenue,
    round(
        category_revenue * 100.0 /
        (select sum(category_revenue) from category_sales), 2
    ) as revenue_percentage
from category_sales
order by revenue_percentage desc;


-- 8. day with the highest sales

select top 1
    o.order_date,
    sum(oi.quantity * oi.unit_price) as daily_sales
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_date
order by daily_sales desc;


-- NULL behaviour in COUNT(*) COUNT(column) and AVG

select
    count(*) as total_order_rows,
    count(p.payment_id) as orders_with_payment,
    avg(p.amount) as average_payment_amount
from orders o
left join payments p on o.order_id = p.order_id;


-- customer-friendly output using string and date functions

select
    concat(upper(c.customer_name), ' - ', c.city) as customer_details,
    format(o.order_date, 'dd-MMM-yyyy') as formatted_order_date,
    datediff(day, o.order_date, cast(getdate() as date)) as days_since_order,
    round(sum(oi.quantity * oi.unit_price), 2) as order_total
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_name, c.city, o.order_date
order by o.order_date;
