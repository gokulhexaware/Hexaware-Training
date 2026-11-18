create database insurancepolicy;
use insurancepolicy;
create table customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    date_of_birth date not null,
    city varchar(40)
);

create table products (
    product_id int primary key,
    product_name varchar(50) not null
);

create table agents (
    agent_id int primary key,
    agent_name varchar(50) not null
);

create table policies (
    policy_id int primary key,
    customer_id int not null,
    product_id int not null,
    agent_id int not null,
    start_date date not null,
    end_date date not null,
    premium_amount decimal(10,2) not null,
    status varchar(20) not null,
    foreign key (customer_id) references customers(customer_id),
    foreign key (product_id) references products(product_id),
    foreign key (agent_id) references agents(agent_id)
);

create table premiums (
    premium_id int primary key,
    policy_id int not null,
    payment_date date not null,
    amount decimal(10,2) not null,
    payment_status varchar(20) not null,
    foreign key (policy_id) references policies(policy_id)
);

create table claims (
    claim_id int primary key,
    policy_id int not null,
    claim_date date not null,
    claim_amount decimal(10,2) not null,
    claim_status varchar(20) not null,
    settlement_date date null,
    damage_category varchar(40),
    foreign key (policy_id) references policies(policy_id)
);
insert into customers values
(1, 'Arun', '1990-05-12', 'Chennai'),
(2, 'Bala', '1985-08-20', 'Coimbatore'),
(3, 'Chitra', '1998-02-15', 'Madurai'),
(4, 'Deepak', '1978-11-10', 'Chennai'),
(5, 'Ezhil', '2001-06-25', 'Salem');

insert into products values
(1, 'Health Insurance'),
(2, 'Life Insurance'),
(3, 'Vehicle Insurance'),
(4, 'Travel Insurance');

insert into agents values
(1, 'Karthik'),
(2, 'Meena'),
(3, 'Ravi'),
(4, 'Priya'),
(5, 'Suresh');

insert into policies values
(1001, 1, 1, 1, dateadd(day, -300, cast(getdate() as date)), dateadd(day, 10, cast(getdate() as date)), 12000, 'Active'),
(1002, 1, 2, 1, dateadd(day, -500, cast(getdate() as date)), dateadd(day, 20, cast(getdate() as date)), 18000, 'Active'),
(1003, 2, 3, 2, dateadd(day, -100, cast(getdate() as date)), dateadd(day, 45, cast(getdate() as date)), 9000, 'Active'),
(1004, 3, 1, 3, dateadd(day, -700, cast(getdate() as date)), dateadd(day, 5, cast(getdate() as date)), 15000, 'Active'),
(1005, 4, 2, 4, dateadd(day, -900, cast(getdate() as date)), dateadd(day, -20, cast(getdate() as date)), 20000, 'Expired'),
(1006, 2, 4, 2, dateadd(day, -60, cast(getdate() as date)), dateadd(day, 25, cast(getdate() as date)), 6000, 'Active'),
(1007, 5, 3, 5, dateadd(day, -1200, cast(getdate() as date)), dateadd(day, 90, cast(getdate() as date)), 11000, 'Active'),
(1008, 3, 4, 3, dateadd(day, -200, cast(getdate() as date)), dateadd(day, 15, cast(getdate() as date)), 7000, 'Active');


insert into premiums values
(1, 1001, dateadd(day, -30, cast(getdate() as date)), 12000, 'Paid'),
(2, 1002, dateadd(day, -25, cast(getdate() as date)), 18000, 'Paid'),
(3, 1003, dateadd(day, -20, cast(getdate() as date)), 9000, 'Paid'),
(4, 1004, dateadd(day, -15, cast(getdate() as date)), 15000, 'Paid'),
(5, 1005, dateadd(day, -100, cast(getdate() as date)), 20000, 'Paid'),
(6, 1006, dateadd(day, -10, cast(getdate() as date)), 6000, 'Paid'),
(7, 1007, dateadd(day, -5, cast(getdate() as date)), 11000, 'Paid'),
(8, 1008, dateadd(day, -2, cast(getdate() as date)), 7000, 'Paid');


insert into claims values
(1, 1001, dateadd(day, -20, cast(getdate() as date)), 3000, 'Settled', dateadd(day, -10, cast(getdate() as date)), 'Medical'),
(2, 1003, dateadd(day, -15, cast(getdate() as date)), 5000, 'Approved', null, 'Vehicle Damage'),
(3, 1004, dateadd(day, -40, cast(getdate() as date)), 4000, 'Settled', dateadd(day, -25, cast(getdate() as date)), 'Medical'),
(4, 1005, dateadd(day, -80, cast(getdate() as date)), 7000, 'Rejected', null, 'Death Benefit'),
(5, 1007, dateadd(day, -30, cast(getdate() as date)), 2500, 'Settled', dateadd(day, -20, cast(getdate() as date)), 'Vehicle Damage'),
(6, 1008, dateadd(day, -5, cast(getdate() as date)), 1500, 'Pending', null, 'Travel Delay');


-- 1. policies expiring in the next 30 days

select
    p.policy_id,
    c.customer_name,
    pr.product_name,
    p.end_date,
    datediff(day, cast(getdate() as date), p.end_date) as days_to_expiry,
    concat('POL-****', right(cast(p.policy_id as varchar(10)), 3)) as masked_policy_number
from policies p
join customers c on p.customer_id = c.customer_id
join products pr on p.product_id = pr.product_id
where p.end_date >= cast(getdate() as date)
  and p.end_date <= dateadd(day, 30, cast(getdate() as date))
  and p.status = 'Active'
order by p.end_date;


-- 2. premium collected per product

select
    pr.product_name,
    sum(pm.amount) as total_premium_collected
from products pr
join policies p on pr.product_id = p.product_id
join premiums pm on p.policy_id = pm.policy_id
where pm.payment_status = 'Paid'
group by pr.product_name
order by total_premium_collected desc;


-- 3. customers with more than one active policy

select
    c.customer_id,
    upper(c.customer_name) as customer_name,
    count(p.policy_id) as active_policy_count
from customers c
join policies p on c.customer_id = p.customer_id
where p.status = 'Active'
group by c.customer_id, c.customer_name
having count(p.policy_id) > 1;


-- 4. claim ratio per product

with premium_totals as (
    select
        p.product_id,
        sum(pm.amount) as total_premium
    from policies p
    join premiums pm on p.policy_id = pm.policy_id
    where pm.payment_status = 'Paid'
    group by p.product_id
),
claim_totals as (
    select
        p.product_id,
        sum(cl.claim_amount) as total_claims
    from policies p
    join claims cl on p.policy_id = cl.policy_id
    group by p.product_id
)
select
    pr.product_name,
    isnull(pt.total_premium, 0) as total_premium,
    isnull(ct.total_claims, 0) as total_claims,
    round(
        isnull(ct.total_claims, 0) * 100.0 /
        nullif(pt.total_premium, 0), 2
    ) as claim_ratio_percentage
from products pr
left join premium_totals pt on pr.product_id = pt.product_id
left join claim_totals ct on pr.product_id = ct.product_id
order by claim_ratio_percentage desc;


-- 5. policies without claims

select
    p.policy_id,
    c.customer_name,
    pr.product_name,
    p.premium_amount,
    p.status
from policies p
join customers c on p.customer_id = c.customer_id
join products pr on p.product_id = pr.product_id
left join claims cl on p.policy_id = cl.policy_id
where cl.claim_id is null;


-- 6. average premium by policy age band

select
    case
        when datediff(year, p.start_date, cast(getdate() as date)) < 2
            then 'New Policy (0-1 years)'
        when datediff(year, p.start_date, cast(getdate() as date)) between 2 and 5
            then 'Medium Policy (2-5 years)'
        else 'Old Policy (6+ years)'
    end as policy_age_band,
    round(avg(p.premium_amount), 2) as average_premium,
    count(*) as policy_count
from policies p
group by
    case
        when datediff(year, p.start_date, cast(getdate() as date)) < 2
            then 'New Policy (0-1 years)'
        when datediff(year, p.start_date, cast(getdate() as date)) between 2 and 5
            then 'Medium Policy (2-5 years)'
        else 'Old Policy (6+ years)'
    end
order by average_premium desc;


-- 7. monthly new policies

select
    format(p.start_date, 'yyyy-MM') as policy_month,
    count(*) as new_policy_count
from policies p
group by format(p.start_date, 'yyyy-MM')
order by policy_month;


-- 8. top 5 agents by premium collected

select top 5
    a.agent_id,
    upper(a.agent_name) as agent_name,
    sum(pm.amount) as total_premium_collected
from agents a
join policies p on a.agent_id = p.agent_id
join premiums pm on p.policy_id = pm.policy_id
where pm.payment_status = 'Paid'
group by a.agent_id, a.agent_name
order by total_premium_collected desc;


-- WHERE and HAVING example

select
    c.customer_name,
    count(p.policy_id) as active_policy_count
from customers c
join policies p on c.customer_id = p.customer_id
where p.status = 'Active'
group by c.customer_id, c.customer_name
having count(p.policy_id) > 1;


-- customer-friendly policy details using string and date functions

select
    concat(upper(c.customer_name), ' - ', pr.product_name) as customer_policy,
    concat('POL-****', right(cast(p.policy_id as varchar(10)), 3)) as masked_policy_number,
    format(p.start_date, 'dd-MMM-yyyy') as policy_start_date,
    datediff(year, p.start_date, cast(getdate() as date)) as policy_age_years,
    case
        when p.end_date < cast(getdate() as date) then 'Expired'
        when p.end_date <= dateadd(day, 30, cast(getdate() as date)) then 'Expiring Soon'
        else 'Active'
    end as due_date_status
from policies p
join customers c on p.customer_id = c.customer_id
join products pr on p.product_id = pr.product_id
order by p.policy_id;