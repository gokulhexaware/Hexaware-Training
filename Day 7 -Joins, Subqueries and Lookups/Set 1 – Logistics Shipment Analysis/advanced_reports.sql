create database retailsales7;
use retailsales7;
-- 1. create tables
create table log_hubs (
    hub_id int primary key,
    hub_name varchar(50) not null,
    city varchar(50) not null
);
create table log_carriers (
    carrier_id int primary key,
    carrier_name varchar(50) not null,
    contact_number varchar(15)
);

create table log_customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50)
);
create table log_employees (
    employee_id int primary key,
    employee_name varchar(50) not null,
    supervisor_id int null,
    job_title varchar(50),
    foreign key (supervisor_id)
        references log_employees(employee_id)
);
create table log_shipments (
    shipment_id int primary key,
    customer_id int not null,
    carrier_id int not null,
    origin_hub_id int not null,
    destination_hub_id int not null,
    employee_id int not null,
    shipping_cost decimal(10,2) not null,
    ship_date date not null,
    expected_delivery_date date not null,
    actual_delivery_date date null,
    foreign key (customer_id)
        references log_customers(customer_id),
    foreign key (carrier_id)
        references log_carriers(carrier_id),
    foreign key (origin_hub_id)
        references log_hubs(hub_id),
    foreign key (destination_hub_id)
        references log_hubs(hub_id),
    foreign key (employee_id)
        references log_employees(employee_id)
);
create table log_delivery_events (
    event_id int primary key,
    shipment_id int not null,
    event_type varchar(50) not null,
    event_date datetime not null,
    location varchar(50),
    notes varchar(200),

    foreign key (shipment_id)
        references log_shipments(shipment_id)
);
-- 2. insert sample data

insert into log_hubs values
(1, 'chennai hub', 'chennai'),
(2, 'coimbatore hub', 'coimbatore'),
(3, 'madurai hub', 'madurai'),
(4, 'salem hub', 'salem');

insert into log_carriers values
(1, 'speed express', '9876543210'),
(2, 'tamil cargo', '9876543211'),
(3, 'prime logistics', '9876543212');

insert into log_customers values
(1, 'virat enterprises', 'chennai'),
(2, 'rohit traders', 'madurai'),
(3, 'dhoni industries', 'coimbatore'),
(4, 'rahul stores', 'salem');

insert into log_employees values
(1, 'arun kumar', null, 'manager'),
(2, 'vijay', 1, 'supervisor'),
(3, 'surya', 1, 'supervisor'),
(4, 'karthi', 2, 'delivery executive'),
(5, 'ashwin', 2, 'delivery executive');

insert into log_shipments values
(1001, 1, 1, 1, 2, 4, 450.00, '2026-10-01', '2026-10-03', '2026-10-06'),
(1002, 1, 2, 2, 3, 5, 300.00, '2026-10-02', '2026-10-04', '2026-10-04'),
(1003, 1, 1, 3, 4, 4, 600.00, '2026-10-03', '2026-10-06', '2026-10-11'),
(1004, 1, 3, 4, 1, 5, 250.00, '2026-10-04', '2026-10-07', '2026-10-11'),
(1005, 2, 2, 1, 3, 4, 200.00, '2026-10-05', '2026-10-08', '2026-10-09'),
(1006, 2, 3, 2, 4, 5, 700.00, '2026-10-06', '2026-10-09', '2026-10-13'),
(1007, 3, 1, 3, 2, 4, 550.00, '2026-10-07', '2026-10-10', '2026-10-12'),
(1008, 4, 2, 1, 2, 5, 150.00, '2026-10-08', '2026-10-11', null);

insert into log_delivery_events values
(1, 1001, 'picked up', '2026-10-01 09:00', 'chennai', 'shipment collected'),
(2, 1001, 'in transit', '2026-10-02 10:00', 'coimbatore', 'shipment moving'),
(3, 1001, 'delivered', '2026-10-06 15:00', 'coimbatore', 'delivered late'),
(4, 1002, 'picked up', '2026-10-02 09:00', 'coimbatore', 'shipment collected'),
(5, 1002, 'delivered', '2026-10-04 12:00', 'madurai', 'delivered on time'),
(6, 1003, 'picked up', '2026-10-03 08:00', 'madurai', 'shipment collected'),
(7, 1003, 'delivered', '2026-10-11 16:00', 'salem', 'delivered late'),
(8, 1005, 'picked up', '2026-10-05 10:00', 'chennai', 'shipment collected'),
(9, 1005, 'delivered', '2026-10-09 14:00', 'madurai', 'delivered late'),
(10, 1006, 'picked up', '2026-10-06 11:00', 'coimbatore', 'shipment collected'),
(11, 1006, 'delivered', '2026-10-13 17:00', 'salem', 'delivered late'),
(12, 1007, 'picked up', '2026-10-07 09:00', 'madurai', 'shipment collected');

-- 3. ten business questions using joins

-- question 1: shipments delayed by more than two days with carrier names

select
    s.shipment_id,
    c.carrier_name,
    s.expected_delivery_date,
    s.actual_delivery_date,
    datediff(day, s.expected_delivery_date,
        s.actual_delivery_date) as delay_days
from log_shipments s
inner join log_carriers c
    on s.carrier_id = c.carrier_id
where s.actual_delivery_date is not null
  and datediff(day, s.expected_delivery_date,
        s.actual_delivery_date) > 2;

-- question 2: hubs with no outbound shipments

select
    h.hub_id,
    h.hub_name,
    h.city
from log_hubs h
left join log_shipments s
    on h.hub_id = s.origin_hub_id
where s.shipment_id is null;

-- question 3: display shipments and their delivery events,
-- including shipments without events

select
    s.shipment_id,
    s.shipping_cost,
    e.event_type,
    e.event_date,
    e.location
from log_shipments s
left join log_delivery_events e
    on s.shipment_id = e.shipment_id
order by s.shipment_id, e.event_date;

-- question 4: display all shipment and event records
-- using a full outer join

select
    s.shipment_id,
    s.shipping_cost,
    e.event_id,
    e.event_type,
    e.location
from log_shipments s
full outer join log_delivery_events e
    on s.shipment_id = e.shipment_id
order by s.shipment_id, e.event_id;

-- question 5: display employees and their supervisors

select
    e.employee_name as employee_name,
    e.job_title,
    m.employee_name as supervisor_name
from log_employees e
left join log_employees m
    on e.supervisor_id = m.employee_id;

-- question 6: display shipment, customer, carrier and hub details

select
    s.shipment_id,
    c.customer_name,
    cr.carrier_name,
    oh.hub_name as origin_hub,
    dh.hub_name as destination_hub,
    s.shipping_cost
from log_shipments s
inner join log_customers c
    on s.customer_id = c.customer_id
inner join log_carriers cr
    on s.carrier_id = cr.carrier_id
inner join log_hubs oh
    on s.origin_hub_id = oh.hub_id
inner join log_hubs dh
    on s.destination_hub_id = dh.hub_id;

-- question 7: customers who have not made any shipments

select
    c.customer_id,
    c.customer_name
from log_customers c
left join log_shipments s
    on c.customer_id = s.customer_id
where s.shipment_id is null;

-- question 8: display all hubs with their outbound shipment counts

select
    h.hub_name,
    count(s.shipment_id) as total_shipments
from log_hubs h
left join log_shipments s
    on h.hub_id = s.origin_hub_id
group by h.hub_id, h.hub_name
order by h.hub_id;

-- question 9: display shipments whose shipping cost is
-- greater than at least one other shipment from the same origin hub

select
    s.shipment_id,
    s.origin_hub_id,
    s.shipping_cost
from log_shipments s
where s.shipping_cost > any (
    select s2.shipping_cost
    from log_shipments s2
    where s2.origin_hub_id = s.origin_hub_id
      and s2.shipment_id <> s.shipment_id
);

-- question 10: display delivery events with shipment and customer details

select
    e.event_id,
    e.event_type,
    e.event_date,
    s.shipment_id,
    c.customer_name
from log_delivery_events e
inner join log_shipments s
    on e.shipment_id = s.shipment_id
inner join log_customers c
    on s.customer_id = c.customer_id;

-- 4. subqueries using IN, EXISTS, ANY and ALL

-- customers who shipped to every hub using IN

select
    c.customer_id,
    c.customer_name
from log_customers c
where c.customer_id in (
    select s.customer_id
    from log_shipments s
    group by s.customer_id
    having count(distinct s.destination_hub_id) =
        (select count(*) from log_hubs)
);

-- shipments that have at least one delivery event using EXISTS

select
    s.shipment_id,
    s.shipping_cost
from log_shipments s
where exists (
    select 1
    from log_delivery_events e
    where e.shipment_id = s.shipment_id
);

-- carriers whose average delay is above the overall average
-- using ALL

select
    c.carrier_id,
    c.carrier_name,
    avg(cast(datediff(day, s.expected_delivery_date,
        s.actual_delivery_date) as decimal(10,2))) as average_delay
from log_carriers c
inner join log_shipments s
    on c.carrier_id = s.carrier_id
where s.actual_delivery_date is not null
group by c.carrier_id, c.carrier_name
having avg(cast(datediff(day, s.expected_delivery_date,
        s.actual_delivery_date) as decimal(10,2))) >
    all (
        select avg(cast(datediff(day, expected_delivery_date,
            actual_delivery_date) as decimal(10,2)))
        from log_shipments
        where actual_delivery_date is not null
    );

-- 5. rewrite two subqueries as joins

-- first version: customers without shipments using NOT EXISTS

select
    c.customer_id,
    c.customer_name
from log_customers c
where not exists (
    select 1
    from log_shipments s
    where s.customer_id = c.customer_id
);

-- rewritten using LEFT JOIN

select
    c.customer_id,
    c.customer_name
from log_customers c
left join log_shipments s
    on c.customer_id = s.customer_id
where s.shipment_id is null;

-- second version: shipments having delivery events using EXISTS

select
    s.shipment_id,
    s.shipping_cost
from log_shipments s
where exists (
    select 1
    from log_delivery_events e
    where e.shipment_id = s.shipment_id
);

-- rewritten using INNER JOIN

select distinct
    s.shipment_id,
    s.shipping_cost
from log_shipments s
inner join log_delivery_events e
    on s.shipment_id = e.shipment_id;

-- 6. nested subquery:
-- second-highest distinct shipping cost for each origin hub

select
    h.hub_id,
    h.hub_name,
    (
        select max(s.shipping_cost)
        from log_shipments s
        where s.origin_hub_id = h.hub_id
          and s.shipping_cost < (
              select max(s2.shipping_cost)
              from log_shipments s2
              where s2.origin_hub_id = h.hub_id
          )
    ) as second_highest_shipping_cost
from log_hubs h
order by h.hub_id;

-- 7. verification queries

select * from log_hubs;
select * from log_carriers;
select * from log_customers;
select * from log_employees;
select * from log_shipments;
select * from log_delivery_events;
