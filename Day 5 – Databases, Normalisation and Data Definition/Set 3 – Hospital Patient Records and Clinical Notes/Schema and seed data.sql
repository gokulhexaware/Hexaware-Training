create database hospitalrecords7;
use hospitalrecords7;

-- creating departments table

create table departments (
    department_id int primary key,
    department_name varchar(50) not null,
    location varchar(50)
);


-- creating doctors table

create table doctors (
    doctor_id int primary key,
    doctor_name varchar(100) not null,
    specialization varchar(100),
    department_id int,

    constraint fk_doctors_department
        foreign key (department_id)
        references departments(department_id)
);


-- creating patients table

create table patients (
    patient_id int primary key,
    patient_name varchar(100) not null,
    age int,
    gender varchar(10),
    phone varchar(15),
    address varchar(100)
);


-- creating visits table

create table visits (
    visit_id int primary key,
    patient_id int,
    doctor_id int,
    visit_date date,
    diagnosis varchar(200),
    prescription varchar(200),
    status varchar(20)
        constraint df_visits_status default ('Open'),

    constraint fk_visits_patient
        foreign key (patient_id)
        references patients(patient_id),

    constraint fk_visits_doctor
        foreign key (doctor_id)
        references doctors(doctor_id),

    constraint chk_visit_date
        check (
            visit_date >= '20000101'
            and visit_date <= cast(getdate() as date)
        )
);

-- inserting department records

insert into departments values
(1, 'Cardiology', 'First Floor'),
(2, 'Neurology', 'Second Floor'),
(3, 'Orthopaedics', 'Third Floor'),
(4, 'Paediatrics', 'First Floor'),
(5, 'Dermatology', 'Second Floor'),
(6, 'ENT', 'Third Floor'),
(7, 'General Medicine', 'Ground Floor'),
(8, 'Dental', 'First Floor'),
(9, 'Ophthalmology', 'Second Floor'),
(10, 'Gynaecology', 'Third Floor');


-- inserting doctor records

insert into doctors values
(1, 'Dr. Arun Kumar', 'Heart Specialist', 1),
(2, 'Dr. Priya', 'Neurologist', 2),
(3, 'Dr. Karthik', 'Bone Specialist', 3),
(4, 'Dr. Meena', 'Child Specialist', 4),
(5, 'Dr. Suresh', 'Skin Specialist', 5),
(6, 'Dr. Divya', 'ENT Specialist', 6),
(7, 'Dr. Vijay', 'General Physician', 7),
(8, 'Dr. Anitha', 'Dentist', 8),
(9, 'Dr. Rahul', 'Eye Specialist', 9),
(10, 'Dr. Kavitha', 'Gynaecologist', 10);


-- inserting patient records

insert into patients
(patient_id, patient_name, age, gender, phone, address)
values
(1, 'Arun Kumar', 25, 'Male', '9876500001', 'Chennai'),
(2, 'Karthik', 30, 'Male', '9876500002', 'Madurai'),
(3, 'Vijay', 28, 'Male', '9876500003', 'Coimbatore'),
(4, 'Surya', 35, 'Male', '9876500004', 'Trichy'),
(5, 'Ajith', 42, 'Male', '9876500005', 'Salem'),
(6, 'Priya', 24, 'Female', '9876500006', 'Chennai'),
(7, 'Meena', 32, 'Female', '9876500007', 'Madurai'),
(8, 'Rahul', 40, 'Male', '9876500008', 'Bangalore'),
(9, 'Divya', 27, 'Female', '9876500009', 'Coimbatore'),
(10, 'Kavitha', 45, 'Female', '9876500010', 'Trichy');


-- adding insurance_id column

alter table patients
add insurance_id varchar(30);


-- updating insurance details

exec('
    update patients
    set insurance_id = ''INS1001''
    where patient_id = 1;

    update patients
    set insurance_id = ''INS1002''
    where patient_id = 2;

    update patients
    set insurance_id = ''INS1003''
    where patient_id = 3;
');


-- inserting visit records

insert into visits
(visit_id, patient_id, doctor_id, visit_date,
 diagnosis, prescription, status)
values
(1, 1, 1, '2026-10-02', 'High Blood Pressure',
 'Regular medication', 'Open'),

(2, 2, 2, '2026-10-05', 'Migraine',
 'Pain relief tablets', 'Closed'),

(3, 3, 3, '2026-10-08', 'Knee Pain',
 'Physiotherapy', 'Open'),

(4, 4, 4, '2026-10-10', 'Fever',
 'Paracetamol', 'Closed'),

(5, 5, 5, '2026-10-12', 'Skin Allergy',
 'Skin cream', 'Open'),

(6, 6, 6, '2026-10-15', 'Ear Infection',
 'Ear drops', 'Closed'),

(7, 7, 7, '2026-10-18', 'Common Cold',
 'Cough syrup', 'Open'),

(8, 8, 8, '2026-11-02', 'Tooth Pain',
 'Dental treatment', 'Open'),

(9, 9, 9, '2026-11-05', 'Eye Infection',
 'Eye drops', 'Closed'),

(10, 10, 10, '2026-11-10', 'Back Pain',
 'Rest and medication', 'Open');


-- renaming visits table

exec sp_rename 'visits', 'patient_visits';


-- creating billing table

create table billing (
    bill_id int primary key,
    visit_id int,
    bill_amount decimal(10,2),
    payment_status varchar(20) default ('Pending'),

    constraint fk_billing_visit
        foreign key (visit_id)
        references patient_visits(visit_id),

    constraint chk_billing_amount
        check (bill_amount >= 0)
);


-- inserting billing records

insert into billing
(bill_id, visit_id, bill_amount, payment_status)
values
(1, 1, 1500, 'Pending'),
(2, 2, 1200, 'Paid'),
(3, 3, 2000, 'Pending'),
(4, 4, 800, 'Paid'),
(5, 5, 1000, 'Pending'),
(6, 6, 900, 'Paid'),
(7, 7, 700, 'Pending'),
(8, 8, 2500, 'Pending'),
(9, 9, 1300, 'Paid'),
(10, 10, 1800, 'Pending');


-- dropping the bill amount constraint

alter table billing
drop constraint chk_billing_amount;


-- inserting a temporary visit for testing

insert into patient_visits
(visit_id, patient_id, doctor_id, visit_date,
 diagnosis, prescription)
values
(99, 1, 1, '2026-11-17',
 'Constraint Test', 'Test record');


-- inserting a negative bill after dropping the constraint

insert into billing
(bill_id, visit_id, bill_amount, payment_status)
values
(99, 99, -500, 'Pending');


-- displaying the negative bill

select * from billing
where bill_id = 99;


-- deleting the temporary billing record

delete from billing
where bill_id = 99;


-- restoring the bill amount constraint

alter table billing
add constraint chk_billing_amount
check (bill_amount >= 0);


-- deleting the temporary visit

delete from patient_visits
where visit_id = 99;


-- inserting one more visit

insert into patient_visits
(visit_id, patient_id, doctor_id, visit_date,
 diagnosis, prescription)
values
(11, 1, 1, '2026-11-15',
 'Regular Checkup', 'Routine health check');


-- updating visit information

update patient_visits
set diagnosis = 'Normal Blood Pressure',
    status = 'Closed'
where visit_id = 1;


-- inserting a temporary visit for deletion

insert into patient_visits
(visit_id, patient_id, doctor_id, visit_date,
 diagnosis, prescription)
values
(12, 2, 2, '2026-11-16',
 'Temporary Checkup', 'General examination');


-- deleting the temporary visit

delete from patient_visits
where visit_id = 12;


-- retrieving patients who visited in October 2026

select
    p.patient_id,
    p.patient_name,
    v.visit_date,
    v.diagnosis,
    v.status
from patients p
inner join patient_visits v
    on p.patient_id = v.patient_id
where v.visit_date >= '20261001'
and v.visit_date < '20261101';


-- retrieving doctors from Cardiology department

select
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    dep.department_name
from doctors d
inner join departments dep
    on d.department_id = dep.department_id
where dep.department_name like '%Cardio%';


-- displaying final records

select * from departments;
select * from doctors;
select * from patients;
select * from patient_visits;
select * from billing;