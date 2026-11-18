create database retail_inventory;
use retail_inventory;
create table suppliers (
    supplier_id int primary key,
    supplier_name varchar(100) not null,
    supplier_phone varchar(15) not null unique
);

create table categories (
    category_id int primary key,
    category_name varchar(50) not null unique
);

create table warehouses (
    warehouse_id int primary key,
    warehouse_name varchar(100) not null,
    warehouse_location varchar(100) not null
);

create table products (
    product_id int primary key,
    sku varchar(20) not null unique,
    product_name varchar(100) not null,
    category_id int not null,
    supplier_id int not null,
    product_price decimal(10,2) not null
        check (product_price >= 0),

    constraint fk_products_categories
        foreign key (category_id)
        references categories(category_id),

    constraint fk_products_suppliers
        foreign key (supplier_id)
        references suppliers(supplier_id)
);

create table inventory (
    inventory_id int primary key,
    product_id int not null,
    warehouse_id int not null,
    quantity int not null default 0
        check (quantity >= 0),
    reorder_level int not null default 5
        check (reorder_level >= 0),

    constraint fk_inventory_products
        foreign key (product_id)
        references products(product_id)
        on delete cascade,

    constraint fk_inventory_warehouses
        foreign key (warehouse_id)
        references warehouses(warehouse_id),

    constraint uq_product_warehouse
        unique (product_id, warehouse_id)
);
insert into suppliers values
(1, 'Chennai Sports', '9876543210'),
(2, 'Madurai Traders', '9876543211'),
(3, 'Kovai Supplies', '9876543212'),
(4, 'Mumbai Sports Hub', '9876543213'),
(5, 'Delhi Wholesale', '9876543214'),
(6, 'Bangalore Distributors', '9876543215'),
(7, 'Trichy Stores', '9876543216'),
(8, 'Salem Enterprises', '9876543217'),
(9, 'Hyderabad Suppliers', '9876543218'),
(10, 'Kochi Traders', '9876543219');

insert into categories values
(1, 'Cricket'),
(2, 'Football'),
(3, 'Badminton'),
(4, 'Tennis'),
(5, 'Fitness'),
(6, 'Sports Shoes'),
(7, 'Sports Clothing'),
(8, 'Accessories'),
(9, 'Outdoor Games'),
(10, 'Gym Equipment');

insert into warehouses values
(1, 'Chennai Warehouse', 'Chennai'),
(2, 'Madurai Warehouse', 'Madurai'),
(3, 'Coimbatore Warehouse', 'Coimbatore'),
(4, 'Mumbai Warehouse', 'Mumbai'),
(5, 'Delhi Warehouse', 'Delhi'),
(6, 'Bangalore Warehouse', 'Bangalore'),
(7, 'Trichy Warehouse', 'Trichy'),
(8, 'Salem Warehouse', 'Salem'),
(9, 'Hyderabad Warehouse', 'Hyderabad'),
(10, 'Kochi Warehouse', 'Kochi');

insert into products values
(1, 'SKU-101', 'Virat Cricket Bat', 1, 1, 2500.00),
(2, 'SKU-102', 'Rohit Cricket Helmet', 1, 2, 1800.00),
(3, 'SKU-103', 'Dhoni Wicket Gloves', 1, 3, 1200.00),
(4, 'SKU-104', 'Jadeja Cricket Pads', 1, 4, 1500.00),
(5, 'SKU-105', 'Hardik Sports Shoes', 6, 5, 3200.00),
(6, 'SKU-106', 'Ashwin Training Kit', 7, 6, 2100.00),
(7, 'SKU-107', 'Rahul Football', 2, 7, 900.00),
(8, 'SKU-108', 'Suriya Fitness Gloves', 5, 8, 650.00),
(9, 'SKU-109', 'Vijay Badminton Racket', 3, 9, 1400.00),
(10, 'SKU-110', 'Ajith Cricket Bag', 8, 10, 1100.00);

insert into inventory values
(1, 1, 1, 25, 5),
(2, 2, 2, 15, 5),
(3, 3, 3, 30, 10),
(4, 4, 4, 20, 5),
(5, 5, 5, 12, 4),
(6, 6, 6, 18, 5),
(7, 7, 7, 40, 10),
(8, 8, 8, 35, 8),
(9, 9, 9, 22, 5),
(10, 10, 10, 8, 3);


-- testing invalid inserts

begin try
    insert into suppliers
    values (1, 'Duplicate Supplier', '9000000000');
end try
begin catch
    print 'duplicate key error: ' + error_message();
end catch;

begin try
    insert into inventory
    values (11, 999, 1, 10, 5);
end try
begin catch
    print 'missing parent error: ' + error_message();
end catch;

begin try
    insert into inventory
    values (12, 1, 2, -10, 5);
end try
begin catch
    print 'negative quantity error: ' + error_message();
end catch;

begin try
    insert into suppliers
    values (11, null, '9000000001');
end try
begin catch
    print 'null value error: ' + error_message();
end catch;


-- correcting supplier phone number

select * from suppliers
where supplier_id = 3;

update suppliers
set supplier_phone = '9988776655'
where supplier_id = 3;

select * from suppliers
where supplier_id = 3;


-- removing discontinued product

select * from products
where sku = 'SKU-110';

select * from inventory
where product_id = 10;

delete from products
where sku = 'SKU-110';

select * from products
where sku = 'SKU-110';

select * from inventory
where product_id = 10;


-- checking the final records

select * from suppliers;
select * from categories;
select * from warehouses;
select * from products;
select * from inventory;