
db = db.getSiblingDB("retailsales");

db.sales_orders.drop();

db.sales_orders.insertMany([
    {
        order_id: 1001,
        customer_name: "Arun",
        city: "Chennai",
        order_date: ISODate("2026-01-05"),
        payment_status: "Paid",
        total_amount: 2100,
        items: [
            { product_name: "Cricket Bat", category: "Sports", quantity: 1, unit_price: 1500 },
            { product_name: "Cricket Ball", category: "Sports", quantity: 2, unit_price: 300 }
        ]
    },
    {
        order_id: 1002,
        customer_name: "Arun",
        city: "Chennai",
        order_date: ISODate("2026-01-10"),
        payment_status: "Paid",
        total_amount: 2000,
        items: [
            { product_name: "Headphones", category: "Electronics", quantity: 1, unit_price: 2000 }
        ]
    },
    {
        order_id: 1003,
        customer_name: "Arun",
        city: "Chennai",
        order_date: ISODate("2026-02-02"),
        payment_status: "Paid",
        total_amount: 12000,
        items: [
            { product_name: "Smart Phone", category: "Electronics", quantity: 1, unit_price: 12000 }
        ]
    },
    {
        order_id: 1004,
        customer_name: "Arun",
        city: "Chennai",
        order_date: ISODate("2026-02-15"),
        payment_status: "Unpaid",
        total_amount: 1000,
        items: [
            { product_name: "Notebook", category: "Stationery", quantity: 10, unit_price: 100 }
        ]
    },
    {
        order_id: 1005,
        customer_name: "Bala",
        city: "Coimbatore",
        order_date: ISODate("2026-01-07"),
        payment_status: "Paid",
        total_amount: 1500,
        items: [
            { product_name: "Cricket Bat", category: "Sports", quantity: 1, unit_price: 1500 }
        ]
    },
    {
        order_id: 1006,
        customer_name: "Bala",
        city: "Coimbatore",
        order_date: ISODate("2026-03-03"),
        payment_status: "Paid",
        total_amount: 200,
        items: [
            { product_name: "Pen", category: "Stationery", quantity: 10, unit_price: 20 }
        ]
    },
    {
        order_id: 1007,
        customer_name: "Chitra",
        city: "Chennai",
        order_date: ISODate("2026-02-04"),
        payment_status: "Paid",
        total_amount: 4000,
        items: [
            { product_name: "Headphones", category: "Electronics", quantity: 2, unit_price: 2000 }
        ]
    },
    {
        order_id: 1008,
        customer_name: "Deepak",
        city: "Madurai",
        order_date: ISODate("2026-03-03"),
        payment_status: "Paid",
        total_amount: 12500,
        items: [
            { product_name: "Smart Phone", category: "Electronics", quantity: 1, unit_price: 12000 },
            { product_name: "Notebook", category: "Stationery", quantity: 5, unit_price: 100 }
        ]
    }
]);


// 1. month-wise sales

db.sales_orders.aggregate([
    {
        $match: {
            order_date: {
                $gte: ISODate("2026-01-01"),
                $lt: ISODate("2026-04-01")
            }
        }
    },
    {
        $group: {
            _id: {
                $dateToString: {
                    format: "%Y-%m",
                    date: "$order_date"
                }
            },
            monthly_sales: { $sum: "$total_amount" }
        }
    },
    {
        $sort: { _id: 1 }
    }
]);


// 2. top products by revenue

db.sales_orders.aggregate([
    {
        $match: {
            order_date: {
                $gte: ISODate("2026-01-01")
            }
        }
    },
    {
        $unwind: "$items"
    },
    {
        $group: {
            _id: "$items.product_name",
            total_revenue: {
                $sum: {
                    $multiply: [
                        "$items.quantity",
                        "$items.unit_price"
                    ]
                }
            }
        }
    },
    {
        $sort: { total_revenue: -1 }
    },
    {
        $limit: 5
    }
]);


// 3. average basket value per city

db.sales_orders.aggregate([
    {
        $match: {
            order_date: {
                $gte: ISODate("2026-01-01")
            }
        }
    },
    {
        $group: {
            _id: "$city",
            average_basket_value: {
                $avg: "$total_amount"
            }
        }
    },
    {
        $sort: {
            average_basket_value: -1
        }
    }
]);
