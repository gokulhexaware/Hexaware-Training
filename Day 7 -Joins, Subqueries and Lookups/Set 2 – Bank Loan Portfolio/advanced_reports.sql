create database BankLoanPortfolio;
use BankLoanPortfolio;

create table bank_branches (
    branch_id int primary key,
    branch_name varchar(50) not null,
    city varchar(50) not null
);

create table bank_customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50),
    phone varchar(15)
);

create table bank_loans (
    loan_id int primary key,
    customer_id int not null,
    branch_id int not null,
    loan_amount decimal(12,2) not null,
    loan_date date not null,
    instalments_total int not null,
    instalments_paid int not null,
    overdue_instalments int not null default 0,

    foreign key (customer_id)
        references bank_customers(customer_id),

    foreign key (branch_id)
        references bank_branches(branch_id),

    check (loan_amount > 0),
    check (instalments_total > 0),
    check (instalments_paid >= 0),
    check (overdue_instalments >= 0)
);

create table bank_repayments (
    repayment_id int primary key,
    loan_id int not null,
    repayment_date date not null,
    repayment_amount decimal(12,2) not null,

    foreign key (loan_id)
        references bank_loans(loan_id),

    check (repayment_amount > 0)
);

create table bank_guarantors (
    guarantor_id int primary key,
    loan_id int not null,
    guarantor_customer_id int not null,

    foreign key (loan_id)
        references bank_loans(loan_id),

    foreign key (guarantor_customer_id)
        references bank_customers(customer_id)
);

insert into bank_branches values
(1, 'chennai main branch', 'chennai'),
(2, 'coimbatore branch', 'coimbatore'),
(3, 'madurai branch', 'madurai'),
(4, 'salem branch', 'salem');


insert into bank_customers values
(1, 'arun kumar', 'chennai', '9876500001'),
(2, 'vijay kumar', 'coimbatore', '9876500002'),
(3, 'surya prakash', 'madurai', '9876500003'),
(4, 'karthik rajan', 'salem', '9876500004'),
(5, 'ashwin kumar', 'chennai', '9876500005'),
(6, 'rahul dev', 'coimbatore', '9876500006');


insert into bank_loans values
(1001, 1, 1, 500000, '2026-01-10', 24, 10, 1),
(1002, 1, 2, 300000, '2026-02-15', 18, 8, 0),
(1003, 2, 1, 800000, '2025-11-20', 36, 12, 4),
(1004, 2, 2, 200000, '2026-03-05', 12, 5, 2),
(1005, 3, 3, 900000, '2025-09-10', 48, 15, 5),
(1006, 4, 1, 150000, '2026-04-12', 12, 3, 0),
(1007, 5, 2, 400000, '2026-05-18', 24, 6, 1),
(1008, 6, 3, 600000, '2026-06-20', 36, 4, 2);


insert into bank_repayments values
(1, 1001, '2026-10-05', 25000),
(2, 1001, '2026-10-25', 25000),
(3, 1002, '2026-10-10', 20000),
(4, 1003, '2026-07-15', 30000),
(5, 1003, '2026-10-15', 30000),
(6, 1004, '2026-08-20', 15000),
(7, 1005, '2026-09-12', 35000),
(8, 1007, '2026-10-18', 20000),
(9, 1008, '2026-10-22', 25000),
(10, 1006, '2026-07-01', 10000);


insert into bank_guarantors values
(1, 1001, 2),
(2, 1002, 3),
(3, 1003, 1),
(4, 1004, 5),
(5, 1005, 2),
(6, 1006, 6),
(7, 1007, 4),
(8, 1008, 1);

select
    l.loan_id,
    c.customer_name,
    b.branch_name,
    l.loan_amount,
    l.overdue_instalments
from bank_loans l
inner join bank_customers c
    on l.customer_id = c.customer_id
inner join bank_branches b
    on l.branch_id = b.branch_id
where l.overdue_instalments > 3;

-- question 2:
-- find customers who have loans in more than one branch

select
    c.customer_id,
    c.customer_name,
    count(distinct l.branch_id) as total_branches
from bank_customers c
inner join bank_loans l
    on c.customer_id = l.customer_id
group by c.customer_id, c.customer_name
having count(distinct l.branch_id) > 1;

select distinct
    g.guarantor_customer_id,
    gc.customer_name as guarantor_name,
    l.customer_id as borrower_customer_id,
    bc.customer_name as borrower_name,
    l.loan_id
from bank_guarantors g
inner join bank_customers gc
    on g.guarantor_customer_id = gc.customer_id
inner join bank_loans l
    on g.loan_id = l.loan_id
inner join bank_customers bc
    on l.customer_id = bc.customer_id
where exists (
    select 1
    from bank_loans borrower_loan
    where borrower_loan.customer_id = g.guarantor_customer_id
);

-- question 4:
-- find branches with no loans

select
    b.branch_id,
    b.branch_name,
    b.city
from bank_branches b
left join bank_loans l
    on b.branch_id = l.branch_id
where l.loan_id is null;

select
    l.loan_id,
    c.customer_name,
    b.branch_name,
    b.city,
    l.loan_amount,
    l.loan_date
from bank_loans l
inner join bank_customers c
    on l.customer_id = c.customer_id
inner join bank_branches b
    on l.branch_id = b.branch_id
order by l.loan_id;

-- question 6:
-- display all loans and their repayment details,
-- including loans without repayments

select
    l.loan_id,
    l.loan_amount,
    r.repayment_id,
    r.repayment_date,
    r.repayment_amount
from bank_loans l
left join bank_repayments r
    on l.loan_id = r.loan_id
order by l.loan_id, r.repayment_date;

select distinct
    c.customer_id,
    c.customer_name
from bank_customers c
inner join bank_loans l
    on c.customer_id = l.customer_id
left join bank_repayments r
    on l.loan_id = r.loan_id
where r.repayment_id is null;

-- question 8:
-- calculate total loan amount for every branch

select
    b.branch_id,
    b.branch_name,
    count(l.loan_id) as total_loans,
    coalesce(sum(l.loan_amount), 0) as total_loan_amount
from bank_branches b
left join bank_loans l
    on b.branch_id = l.branch_id
group by b.branch_id, b.branch_name
order by b.branch_id;


select
    c.customer_id,
    c.customer_name,
    count(l.loan_id) as total_loans
from bank_customers c
inner join bank_loans l
    on c.customer_id = l.customer_id
group by c.customer_id, c.customer_name

select
    l.loan_id,
    c.customer_name as borrower_name,
    gc.customer_name as guarantor_name,
    l.loan_amount
from bank_loans l
inner join bank_customers c
    on l.customer_id = c.customer_id
left join bank_guarantors g
    on l.loan_id = g.loan_id
left join bank_customers gc
    on g.guarantor_customer_id = gc.customer_id
order by l.loan_id;

with customer_branch_exposure as (
    select
        customer_id,
        branch_id,
        sum(loan_amount) as total_exposure
    from bank_loans
    group by customer_id, branch_id
)
select
    e.customer_id,
    c.customer_name,
    b.branch_name,
    e.total_exposure
from customer_branch_exposure e
inner join bank_customers c
    on e.customer_id = c.customer_id
inner join bank_branches b
    on e.branch_id = b.branch_id
where e.total_exposure > (
    select avg(x.total_exposure)
    from customer_branch_exposure x
    where x.branch_id = e.branch_id
)
order by e.branch_id, e.customer_id;

-- question 12:
-- uncorrelated subquery:
-- compare customer exposure against pre-calculated
-- average exposure for each branch

select
    e.customer_id,
    c.customer_name,
    b.branch_name,
    e.total_exposure,
    a.average_exposure
from (
    select
        customer_id,
        branch_id,
        sum(loan_amount) as total_exposure
    from bank_loans
    group by customer_id, branch_id
) e
inner join bank_customers c
    on e.customer_id = c.customer_id
inner join bank_branches b
    on e.branch_id = b.branch_id
inner join (
    select
        x.branch_id,
        avg(x.total_exposure) as average_exposure
    from (
        select
            customer_id,
            branch_id,
            sum(loan_amount) as total_exposure
        from bank_loans
        group by customer_id, branch_id
    ) x
    group by x.branch_id
) a
    on e.branch_id = a.branch_id
where e.total_exposure > a.average_exposure
order by e.branch_id, e.customer_id;

select
    c.customer_id,
    c.customer_name
from bank_customers c
where exists (
    select 1
    from bank_loans l
    inner join bank_repayments r
        on l.loan_id = r.loan_id
    where l.customer_id = c.customer_id
      and r.repayment_date >= dateadd(day, -60, cast(getdate() as date))
      and r.repayment_date < dateadd(day, 1, cast(getdate() as date))
);

select
    c.customer_id,
    c.customer_name
from bank_customers c
where exists (
    select 1
    from bank_loans l
    where l.customer_id = c.customer_id
)
and not exists (
    select 1
    from bank_loans l
    inner join bank_repayments r
        on l.loan_id = r.loan_id
    where l.customer_id = c.customer_id
      and r.repayment_date >= dateadd(day, -60, cast(getdate() as date))
      and r.repayment_date < dateadd(day, 1, cast(getdate() as date))
);

with branch_maximums as (
    select
        branch_id,
        max(loan_amount) as highest_loan
    from bank_loans
    group by branch_id
)
select
    b.branch_id,
    b.branch_name,
    bm.highest_loan
from branch_maximums bm
inner join bank_branches b
    on bm.branch_id = b.branch_id
where bm.highest_loan > (
    select avg(highest_loan)
    from branch_maximums
)
order by bm.highest_loan desc;


select * from bank_branches;
select * from bank_customers;
select * from bank_loans;
select * from bank_repayments;
select * from bank_guarantors;
