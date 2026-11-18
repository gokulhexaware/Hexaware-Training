create database telecombilling;
use telecombilling;
create table plans (
    plan_id int primary key,
    plan_name varchar(40) not null,
    data_limit_gb decimal(8,2) not null,
    monthly_fee decimal(10,2) not null
);

create table subscribers (
    subscriber_id int primary key,
    subscriber_name varchar(50) not null,
    phone_number varchar(15),
    circle varchar(40) not null,
    plan_id int not null,
    data_used_gb decimal(8,2),
    foreign key (plan_id) references plans(plan_id)
);

create table call_records (
    call_id int primary key,
    subscriber_id int not null,
    call_date datetime not null,
    call_minutes int not null,
    foreign key (subscriber_id) references subscribers(subscriber_id)
);

create table invoices (
    invoice_id int primary key,
    subscriber_id int not null,
    invoice_date date not null,
    due_date date not null,
    amount decimal(10,2) not null,
    payment_status varchar(20) not null,
    foreign key (subscriber_id) references subscribers(subscriber_id)
);

insert into plans values
(1, 'Basic', 2.00, 199.00),
(2, 'Smart', 5.00, 399.00),
(3, 'Premium', 10.00, 699.00);

insert into subscribers values
(1, 'Anbu', '9000000001', 'Chennai', 1, 1.50),
(2, 'Bala', '9000000002', 'Coimbatore', 2, 6.20),
(3, 'Chitra', '9000000003', 'Chennai', 3, 8.50),
(4, 'Deepak', '9000000004', 'Madurai', 1, 2.80),
(5, 'Ezhil', '9000000005', 'Coimbatore', 2, 4.00),
(6, 'Farah', '9000000006', 'Chennai', 3, 12.50),
(7, 'Gopi', '9000000007', 'Madurai', 1, 0.50),
(8, 'Hari', '9000000008', 'Chennai', 2, 3.20);

insert into call_records values
(1, 1, '2026-10-01 09:15:00', 15),
(2, 1, '2026-10-02 10:30:00', 20),
(3, 2, '2026-10-03 11:00:00', 40),
(4, 2, '2026-10-04 12:00:00', 25),
(5, 3, '2026-10-05 13:00:00', 60),
(6, 4, '2026-10-06 14:00:00', 30),
(7, 5, '2026-10-07 15:00:00', 10),
(8, 6, '2026-10-08 16:00:00', 35),
(9, 6, '2026-10-09 17:00:00', 45),
(10, 8, '2026-10-10 18:00:00', 15);

insert into invoices values
(1001, 1, '2026-10-01', '2026-10-15', 199.00, 'Paid'),
(1002, 2, '2026-10-05', '2026-10-20', 399.00, 'Unpaid'),
(1003, 3, '2026-10-10', '2026-10-25', 699.00, 'Paid'),
(1004, 4, '2026-11-01', '2026-11-15', 199.00, 'Unpaid'),
(1005, 5, '2026-10-15', '2026-10-30', 399.00, 'Unpaid'),
(1006, 6, '2026-11-05', '2026-11-20', 699.00, 'Unpaid'),
(1007, 8, '2026-10-20', '2026-11-04', 399.00, 'Paid'),
(1008, 1, '2026-11-01', '2026-11-15', 199.00, 'Paid');


-- 1. total call minutes per plan

select
    p.plan_name,
    coalesce(sum(cr.call_minutes), 0) as total_call_minutes
from plans p
left join subscribers s on p.plan_id = s.plan_id
left join call_records cr on s.subscriber_id = cr.subscriber_id
group by p.plan_id, p.plan_name
order by total_call_minutes desc;


-- 2. subscribers exceeding their data limit

select
    s.subscriber_id,
    upper(s.subscriber_name) as subscriber_name,
    p.plan_name,
    s.data_used_gb,
    p.data_limit_gb,
    round(s.data_used_gb - p.data_limit_gb, 2) as extra_data_gb
from subscribers s
join plans p on s.plan_id = p.plan_id
where s.data_used_gb > p.data_limit_gb
order by extra_data_gb desc;


-- 3. month-wise revenue

select
    format(invoice_date, 'yyyy-MM') as billing_month,
    sum(amount) as monthly_revenue
from invoices
group by format(invoice_date, 'yyyy-MM')
order by billing_month;


-- 4. invoices overdue by more than 15 days

select
    concat('INV-', format(i.invoice_id, '0000')) as invoice_number,
    s.subscriber_name,
    i.due_date,
    datediff(day, i.due_date, cast(getdate() as date)) as overdue_days,
    i.amount,
    case
        when i.payment_status = 'Paid' then 'Paid'
        when i.due_date < dateadd(day, -15, cast(getdate() as date))
             then 'Overdue more than 15 days'
        else 'Not overdue by 15 days'
    end as due_date_status
from invoices i
join subscribers s on i.subscriber_id = s.subscriber_id
where i.payment_status = 'Unpaid'
  and i.due_date < dateadd(day, -15, cast(getdate() as date))
order by i.due_date;


-- 5. subscribers with no usage

select
    s.subscriber_id,
    s.subscriber_name,
    s.circle,
    s.phone_number
from subscribers s
left join call_records cr on s.subscriber_id = cr.subscriber_id
where cr.call_id is null;


-- 6. average revenue per user by circle

select
    s.circle,
    count(distinct s.subscriber_id) as total_subscribers,
    coalesce(sum(i.amount), 0) as total_revenue,
    round(
        coalesce(sum(i.amount), 0) /
        nullif(count(distinct s.subscriber_id), 0), 2
    ) as average_revenue_per_user
from subscribers s
left join invoices i on s.subscriber_id = i.subscriber_id
group by s.circle
order by average_revenue_per_user desc;


-- 7. plan popularity

select
    p.plan_name,
    count(s.subscriber_id) as subscriber_count
from plans p
left join subscribers s on p.plan_id = s.plan_id
group by p.plan_id, p.plan_name
order by subscriber_count desc;


-- 8. top 10 data consumers

select top 10
    s.subscriber_id,
    concat(upper(s.subscriber_name), ' - ', s.circle) as subscriber_details,
    p.plan_name,
    s.data_used_gb,
    p.data_limit_gb
from subscribers s
join plans p on s.plan_id = p.plan_id
order by s.data_used_gb desc;


-- NULL effect on SUM and AVG

select
    s.subscriber_id,
    s.subscriber_name,
    count(*) as joined_rows,
    count(cr.call_id) as actual_call_records,
    sum(cr.call_minutes) as total_call_minutes,
    avg(cr.call_minutes) as average_call_minutes
from subscribers s
left join call_records cr on s.subscriber_id = cr.subscriber_id
group by s.subscriber_id, s.subscriber_name
order by s.subscriber_id;


-- customer-friendly invoice output using string and date functions

select
    concat('INV-', format(i.invoice_id, '0000')) as invoice_number,
    upper(s.subscriber_name) as subscriber_name,
    format(i.invoice_date, 'dd-MMM-yyyy') as invoice_date,
    format(i.due_date, 'dd-MMM-yyyy') as due_date,
    i.amount,
    case
        when i.payment_status = 'Paid' then 'Paid'
        when i.due_date < cast(getdate() as date) then 'Payment overdue'
        else 'Payment pending'
    end as due_date_status,
    datediff(day, i.due_date, cast(getdate() as date)) as days_from_due_date
from invoices i
join subscribers s on i.subscriber_id = s.subscriber_id
order by i.invoice_id;
