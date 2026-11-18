create database bankbranchaccounts;
use bankbranchaccounts;

create table customers (
    customer_id int identity(1,1) primary key,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null,
    address varchar(200) not null
);

create table branches (
    branch_id int identity(1,1) primary key,
    branch_name varchar(100) not null,
    branch_city varchar(100) not null,
    ifsc_code varchar(20) not null unique
);

create table relationship_managers (
    manager_id int identity(1,1) primary key,
    manager_name varchar(100) not null,
    branch_id int not null,

    constraint fk_manager_branch
        foreign key (branch_id)
        references branches(branch_id)
);

create table account_types (
    account_type_id int identity(1,1) primary key,
    account_type_name varchar(30) not null unique
);

create table accounts (
    account_id int identity(1,1) primary key,
    account_number varchar(20) not null unique,
    account_type_id int not null,
    branch_id int not null,
    manager_id int not null,
    balance decimal(12,2) not null default 0,
    opened_date date not null default getdate(),

    constraint fk_accounts_type
        foreign key (account_type_id)
        references account_types(account_type_id),

    constraint fk_accounts_branch
        foreign key (branch_id)
        references branches(branch_id),

    constraint fk_accounts_manager
        foreign key (manager_id)
        references relationship_managers(manager_id),

    constraint chk_savings_balance
        check (
            account_type_id <> 1
            or balance >= 0
        )
);

create table account_holders (
    customer_id int not null,
    account_id int not null,

    constraint pk_account_holders
        primary key (customer_id, account_id),

    constraint fk_holders_customer
        foreign key (customer_id)
        references customers(customer_id),

    constraint fk_holders_account
        foreign key (account_id)
        references accounts(account_id)
        on delete cascade
);
-- adding account types

insert into account_types (account_type_name) values
('Savings'),
('Current'),
('Salary');


-- adding branches

insert into branches (branch_name, branch_city, ifsc_code) values
('Chennai Main Branch', 'Chennai', 'BANK000001'),
('Coimbatore Branch', 'Coimbatore', 'BANK000002'),
('Madurai Branch', 'Madurai', 'BANK000003'),
('Trichy Branch', 'Trichy', 'BANK000004'),
('Salem Branch', 'Salem', 'BANK000005'),
('Bangalore Branch', 'Bangalore', 'BANK000006'),
('Mumbai Branch', 'Mumbai', 'BANK000007'),
('Delhi Branch', 'Delhi', 'BANK000008'),
('Hyderabad Branch', 'Hyderabad', 'BANK000009'),
('Kochi Branch', 'Kochi', 'BANK000010');


-- adding relationship managers

insert into relationship_managers (manager_name, branch_id) values
('Rohit Sharma', 1),
('Virat Kohli', 2),
('MS Dhoni', 3),
('Hardik Pandya', 4),
('Ravindra Jadeja', 5),
('Suriya', 6),
('Vijay', 7),
('Ajith', 8),
('Karthi', 9),
('Dhanush', 10);


-- adding customers

insert into customers
(customer_name, email, phone, address) values
('Arun Kumar', 'arun@gmail.com', '9876543210', 'Chennai'),
('Karthik', 'karthik@gmail.com', '9876543211', 'Madurai'),
('Vijay', 'vijay@gmail.com', '9876543212', 'Coimbatore'),
('Surya', 'surya@gmail.com', '9876543213', 'Trichy'),
('Ajith', 'ajith@gmail.com', '9876543214', 'Salem'),
('Dhoni', 'dhoni@gmail.com', '9876543215', 'Bangalore'),
('Virat', 'virat@gmail.com', '9876543216', 'Mumbai'),
('Rohit', 'rohit@gmail.com', '9876543217', 'Delhi'),
('Hardik', 'hardik@gmail.com', '9876543218', 'Hyderabad'),
('Jadeja', 'jadeja@gmail.com', '9876543219', 'Kochi');


-- adding accounts

insert into accounts
(account_number, account_type_id, branch_id,
 manager_id, balance, opened_date) values

('ACC1001', 1, 1, 1, 75000, '2026-07-05'),
('ACC1002', 2, 2, 2, 120000, '2026-07-12'),
('ACC1003', 1, 3, 3, 45000, '2026-07-18'),
('ACC1004', 3, 4, 4, 85000, '2026-08-02'),
('ACC1005', 1, 5, 5, 95000, '2026-08-15'),
('ACC1006', 2, 6, 6, 150000, '2026-08-20'),
('ACC1007', 1, 7, 7, 65000, '2026-09-01'),
('ACC1008', 3, 8, 8, 55000, '2026-09-10'),
('ACC1009', 1, 9, 9, 30000, '2026-10-05'),
('ACC1010', 2, 10, 10, 200000, '2026-10-15');


-- linking customers with accounts

insert into account_holders (customer_id, account_id) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(1, 3),
(2, 5);


-- displaying all accounts

select * from accounts;


-- updating customer information

select * from customers
where customer_id = 3;

update customers
set phone = '9988776655'
where customer_id = 3;

select * from customers
where customer_id = 3;


-- updating account balance

update accounts
set balance = 90000
where account_number = 'ACC1001';

select * from accounts
where account_number = 'ACC1001';


-- deleting a test account

insert into accounts
(account_number, account_type_id, branch_id,
 manager_id, balance, opened_date)
values
('ACC1099', 1, 1, 1, 10000, '2026-08-25');

select * from accounts
where account_number = 'ACC1099';

delete from accounts
where account_number = 'ACC1099';

select * from accounts
where account_number = 'ACC1099';


-- using AND

select *
from accounts
where balance > 50000
and account_type_id = 1;


-- using OR

select *
from accounts
where branch_id = 1
or branch_id = 2;


-- using IN

select *
from accounts
where account_type_id in (1, 3);


-- using BETWEEN

select *
from accounts
where balance between 50000 and 150000;


-- accounts opened in the previous calendar quarter
-- with a balance above 50000

select
    a.account_number,
    c.customer_name,
    at.account_type_name,
    b.branch_name,
    a.balance,
    a.opened_date
from accounts a
inner join account_holders ah
    on a.account_id = ah.account_id
inner join customers c
    on ah.customer_id = c.customer_id
inner join account_types at
    on a.account_type_id = at.account_type_id
inner join branches b
    on a.branch_id = b.branch_id
where a.opened_date >=
    dateadd(quarter, datediff(quarter, 0, getdate()) - 1, 0)
and a.opened_date <
    dateadd(quarter, datediff(quarter, 0, getdate()), 0)
and a.balance > 50000;


-- testing DROP, TRUNCATE and DELETE

create table account_test (
    test_id int identity(1,1) primary key,
    customer_name varchar(50)
);

insert into account_test (customer_name) values
('Virat'),
('Dhoni'),
('Rohit');

select * from account_test;


-- DELETE example

delete from account_test
where test_id = 2;

select * from account_test;

insert into account_test (customer_name)
values ('Jadeja');

select * from account_test;


-- rollback example for DELETE

begin transaction;

delete from account_test
where test_id = 1;

select * from account_test;

rollback transaction;

select * from account_test;


-- TRUNCATE example

truncate table account_test;

select * from account_test;

insert into account_test (customer_name)
values ('Hardik');

select * from account_test;


-- rollback example for TRUNCATE

begin transaction;

truncate table account_test;

select * from account_test;

rollback transaction;

select * from account_test;


-- DROP example

begin transaction;

drop table account_test;

select
    object_id('account_test') as table_after_drop;

rollback transaction;

select
    object_id('account_test') as table_after_rollback;

select * from account_test;


-- removing the test table

drop table account_test;
