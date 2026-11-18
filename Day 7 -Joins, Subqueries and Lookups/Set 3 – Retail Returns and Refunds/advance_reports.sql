create database retailreturnrefund;
use retailreturnrefund;
create table retail_stores (
    store_id int primary key,
    store_name varchar(50) not null,
    region varchar(50) not null,
    city varchar(50) not null
);
create table retail_customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50),
    phone varchar(15)
);
create table retail_products (
    product_id int primary key,
    product_name varchar(50) not null,
    category varchar(50),
    unit_price decimal(10,2) not null
);
create table retail_employees (
    employee_id int primary key,
    employee_name varchar(50) not null,
    manager_id int null,
    store_id int not null,
    job_title varchar(50),
    foreign key (manager_id) references retail_employees(employee_id),
    foreign key (store_id) references retail_stores(store_id)
);
create table retail_sales (
    sale_id int primary key,
    product_id int not null,
    customer_id int not null,
    store_id int not null,
    quantity int not null,
    sale_date date not null,
    foreign key (product_id) references retail_products(product_id),
    foreign key (customer_id) references retail_customers(customer_id),
    foreign key (store_id) references retail_stores(store_id),
    check (quantity > 0)
);
create table retail_returns (
    return_id int primary key,
    sale_id int not null,
    return_quantity int not null,
    return_date date not null,
    return_reason varchar(100),
    foreign key (sale_id) references retail_sales(sale_id),
    check (return_quantity > 0)
);
create table retail_refunds (
    refund_id int primary key,
    return_id int not null,
    refund_amount decimal(10,2) not null,
    refund_date date not null,
    foreign key (return_id) references retail_returns(return_id),
    check (refund_amount >= 0)
);
create table retail_feedback (
    feedback_id int primary key,
    return_id int not null,
    rating int not null,
    feedback_text varchar(200),
    feedback_date date not null,
    foreign key (return_id) references retail_returns(return_id),
    check (rating between 1 and 5)
);
insert into retail_stores values
(1,'chennai central','south','chennai'),
(2,'coimbatore city','south','coimbatore'),
(3,'madurai mall','south','madurai'),
(4,'salem outlet','west','salem');
insert into retail_customers values
(1,'arun kumar','chennai','9876500001'),
(2,'vijay kumar','coimbatore','9876500002'),
(3,'surya prakash','madurai','9876500003'),
(4,'karthik rajan','salem','9876500004'),
(5,'ashwin kumar','chennai','9876500005');
insert into retail_products values
(1,'smartphone','electronics',20000),
(2,'laptop','electronics',50000),
(3,'office chair','furniture',5000),
(4,'water bottle','accessories',500),
(5,'headphones','electronics',3000);
insert into retail_employees values
(1,'rajesh',null,1,'store manager'),
(4,'kumar',null,2,'store manager'),
(6,'ashwin',null,3,'store manager'),
(8,'karthik',null,4,'store manager');
insert into retail_employees values
(2,'vijay',1,1,'sales executive'),
(3,'arun',1,1,'sales executive'),
(5,'surya',4,2,'sales executive'),
(7,'rahul',6,3,'sales executive');
insert into retail_sales values
(101,1,1,1,50,'2026-09-01'),
(102,1,2,2,50,'2026-09-02'),
(103,2,1,1,50,'2026-09-03'),
(104,2,3,2,50,'2026-09-04'),
(105,3,2,1,25,'2026-09-05'),
(106,3,3,2,25,'2026-09-06'),
(107,4,4,3,100,'2026-09-07');
insert into retail_returns values
(201,101,10,'2026-10-01','damaged product'),
(202,102,5,'2026-10-02','wrong item'),
(203,103,2,'2026-10-03','defective product'),
(204,104,3,'2026-10-04','damaged product'),
(205,105,4,'2026-10-05','quality issue'),
(206,106,4,'2026-10-06','wrong size'),
(207,107,2,'2026-10-07','product not required');
insert into retail_refunds values
(301,201,1000,'2026-10-02'),
(302,202,500,'2026-10-03'),
(303,203,200,'2026-10-04'),
(304,204,300,'2026-10-05'),
(305,205,400,'2026-10-06'),
(306,206,400,'2026-10-07');
insert into retail_feedback values
(401,201,2,'product quality was poor','2026-10-03'),
(402,202,3,'received incorrect item','2026-10-04'),
(403,203,1,'product was defective','2026-10-05'),
(404,205,4,'return process was good','2026-10-07'),
(405,207,3,'return completed successfully','2026-10-08');
with sold as (
    select product_id,sum(quantity) as total_sold
    from retail_sales
    group by product_id
),
returned as (
    select s.product_id,sum(r.return_quantity) as total_returned
    from retail_sales s
    inner join retail_returns r on s.sale_id=r.sale_id
    group by s.product_id
)
select p.product_id,p.product_name,s.total_sold,
       coalesce(r.total_returned,0) as total_returned,
       cast(coalesce(r.total_returned,0)*100.0/s.total_sold as decimal(10,2)) as return_rate
from retail_products p
inner join sold s on p.product_id=s.product_id
left join returned r on p.product_id=r.product_id
where coalesce(r.total_returned,0)*100.0/s.total_sold>10;
select distinct c.customer_id,c.customer_name
from retail_customers c
inner join retail_sales s on c.customer_id=s.customer_id
inner join retail_returns r on s.sale_id=r.sale_id
where not exists (
    select 1 from retail_refunds f
    where f.return_id=r.return_id
);
with store_refunds as (
    select st.store_id,st.store_name,
           coalesce(sum(f.refund_amount),0) as total_refunds
    from retail_stores st
    left join retail_sales s on st.store_id=s.store_id
    left join retail_returns r on s.sale_id=r.sale_id
    left join retail_refunds f on r.return_id=f.return_id
    group by st.store_id,st.store_name
),
ranked_stores as (
    select *,dense_rank() over(order by total_refunds desc) as refund_rank
    from store_refunds
)
select store_id,store_name,total_refunds
from ranked_stores
where refund_rank=1;
select e.employee_id,e.employee_name,e.job_title,
       m.employee_name as manager_name
from retail_employees e
left join retail_employees m on e.manager_id=m.employee_id
order by e.employee_id;
select r.return_id,p.product_name,c.customer_name,
       st.store_name,r.return_quantity,r.return_date,r.return_reason
from retail_returns r
inner join retail_sales s on r.sale_id=s.sale_id
inner join retail_products p on s.product_id=p.product_id
inner join retail_customers c on s.customer_id=c.customer_id
inner join retail_stores st on s.store_id=st.store_id
order by r.return_id;
select p.product_id,p.product_name
from retail_products p
left join retail_sales s on p.product_id=s.product_id
left join retail_returns r on s.sale_id=r.sale_id
group by p.product_id,p.product_name
having count(r.return_id)=0;
select st.store_id,st.store_name,
       coalesce(sum(f.refund_amount),0) as total_refunds
from retail_stores st
left join retail_sales s on st.store_id=s.store_id
left join retail_returns r on s.sale_id=r.sale_id
left join retail_refunds f on r.return_id=f.return_id
group by st.store_id,st.store_name
order by total_refunds desc;
select r.return_id,r.return_reason,f.feedback_id,f.rating,f.feedback_text
from retail_returns r
left join retail_feedback f on r.return_id=f.return_id
order by r.return_id;
select c.customer_id,c.customer_name
from retail_customers c
where c.customer_id in (
    select s.customer_id
    from retail_sales s
    inner join retail_returns r on s.sale_id=r.sale_id
);
select st.store_id,st.store_name
from retail_stores st
left join retail_sales s on st.store_id=s.store_id
left join retail_returns r on s.sale_id=r.sale_id
group by st.store_id,st.store_name
having count(r.return_id)=0;
select c.customer_id,c.customer_name
from retail_customers c
where c.customer_id in (
    select s.customer_id
    from retail_sales s
    inner join retail_returns r on s.sale_id=r.sale_id
);
select c.customer_id,c.customer_name
from retail_customers c
where c.customer_id not in (
    select s.customer_id
    from retail_sales s
    inner join retail_returns r on s.sale_id=r.sale_id
    union all
    select cast(null as int)
);
select c.customer_id,c.customer_name
from retail_customers c
where not exists (
    select 1
    from retail_sales s
    inner join retail_returns r on s.sale_id=r.sale_id
    where s.customer_id=c.customer_id
);
with store_refunds as (
    select st.store_id,st.store_name,st.region,
           coalesce(sum(f.refund_amount),0) as total_refunds
    from retail_stores st
    left join retail_sales s on st.store_id=s.store_id
    left join retail_returns r on s.sale_id=r.sale_id
    left join retail_refunds f on r.return_id=f.return_id
    group by st.store_id,st.store_name,st.region
)
select sr.store_id,sr.store_name,sr.region,sr.total_refunds
from store_refunds sr
where exists (
    select 1 from store_refunds other
    where other.region=sr.region and other.store_id<>sr.store_id
)
and sr.total_refunds > any (
    select other.total_refunds
    from store_refunds other
    where other.region=sr.region and other.store_id<>sr.store_id
);
with store_refunds as (
    select st.store_id,st.store_name,st.region,
           coalesce(sum(f.refund_amount),0) as total_refunds
    from retail_stores st
    left join retail_sales s on st.store_id=s.store_id
    left join retail_returns r on s.sale_id=r.sale_id
    left join retail_refunds f on r.return_id=f.return_id
    group by st.store_id,st.store_name,st.region
)
select sr.store_id,sr.store_name,sr.region,sr.total_refunds
from store_refunds sr
where exists (
    select 1 from store_refunds other
    where other.region=sr.region and other.store_id<>sr.store_id
)
and sr.total_refunds > all (
    select other.total_refunds
    from store_refunds other
    where other.region=sr.region and other.store_id<>sr.store_id
);
with product_sales as (
    select product_id,sum(quantity) as total_sold
    from retail_sales
    group by product_id
),
product_returns as (
    select s.product_id,sum(r.return_quantity) as total_returned
    from retail_sales s
    inner join retail_returns r on s.sale_id=r.sale_id
    group by s.product_id
),
product_rates as (
    select p.product_id,p.product_name,
           cast(coalesce(r.total_returned,0)*100.0/nullif(s.total_sold,0) as decimal(10,2)) as return_rate
    from retail_products p
    inner join product_sales s on p.product_id=s.product_id
    left join product_returns r on p.product_id=r.product_id
)
select product_id,product_name,return_rate
from product_rates
where return_rate > (
    select avg(return_rate)
    from product_rates
);
with store_refunds as (
    select st.store_id,st.store_name,
           coalesce(sum(f.refund_amount),0) as total_refunds
    from retail_stores st
    left join retail_sales s on st.store_id=s.store_id
    left join retail_returns r on s.sale_id=r.sale_id
    left join retail_refunds f on r.return_id=f.return_id
    group by st.store_id,st.store_name
)
select store_id,store_name,total_refunds
from store_refunds
where total_refunds > (
    select avg(total_refunds)
    from store_refunds
);
select * from retail_stores;
select * from retail_customers;
select * from retail_products;
select * from retail_employees;
select * from retail_sales;
select * from retail_returns;
select * from retail_refunds;
select * from retail_feedback;
