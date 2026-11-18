use('retailsales');
// 1. clear previous sample data
db.log_delivery_events.deleteMany({});
db.log_shipments.deleteMany({});
db.log_employees.deleteMany({});
db.log_customers.deleteMany({});
db.log_carriers.deleteMany({});
db.log_hubs.deleteMany({});
// 2. insert hubs
db.log_hubs.insertMany([
    { hub_id: 1, hub_name: "chennai hub", city: "chennai" },
    { hub_id: 2, hub_name: "coimbatore hub", city: "coimbatore" },
    { hub_id: 3, hub_name: "madurai hub", city: "madurai" },
    { hub_id: 4, hub_name: "salem hub", city: "salem" }
]);

// 3. insert carriers

db.log_carriers.insertMany([
    { carrier_id: 1, carrier_name: "speed express" },
    { carrier_id: 2, carrier_name: "tamil cargo" },
    { carrier_id: 3, carrier_name: "prime logistics" }
]);

// 4. insert customers

db.log_customers.insertMany([
    { customer_id: 1, customer_name: "virat enterprises", city: "chennai" },
    { customer_id: 2, customer_name: "rohit traders", city: "madurai" },
    { customer_id: 3, customer_name: "dhoni industries", city: "coimbatore" },
    { customer_id: 4, customer_name: "rahul stores", city: "salem" }
]);

// 5. insert employees

db.log_employees.insertMany([
    { employee_id: 1, employee_name: "arun kumar", supervisor_id: null, job_title: "manager" },
    { employee_id: 2, employee_name: "vijay", supervisor_id: 1, job_title: "supervisor" },
    { employee_id: 3, employee_name: "surya", supervisor_id: 1, job_title: "supervisor" },
    { employee_id: 4, employee_name: "karthi", supervisor_id: 2, job_title: "delivery executive" },
    { employee_id: 5, employee_name: "ashwin", supervisor_id: 2, job_title: "delivery executive" }
]);

// 6. insert shipments

db.log_shipments.insertMany([
    {
        shipment_id: 1001, customer_id: 1, carrier_id: 1,
        origin_hub_id: 1, destination_hub_id: 2, employee_id: 4,
        shipping_cost: 450,
        ship_date: ISODate("2026-10-01"),
        expected_delivery_date: ISODate("2026-10-03"),
        actual_delivery_date: ISODate("2026-10-06")
    },
    {
        shipment_id: 1002, customer_id: 1, carrier_id: 2,
        origin_hub_id: 2, destination_hub_id: 3, employee_id: 5,
        shipping_cost: 300,
        ship_date: ISODate("2026-10-02"),
        expected_delivery_date: ISODate("2026-10-04"),
        actual_delivery_date: ISODate("2026-10-04")
    },
    {
        shipment_id: 1003, customer_id: 1, carrier_id: 1,
        origin_hub_id: 3, destination_hub_id: 4, employee_id: 4,
        shipping_cost: 600,
        ship_date: ISODate("2026-10-03"),
        expected_delivery_date: ISODate("2026-10-06"),
        actual_delivery_date: ISODate("2026-10-11")
    },
    {
        shipment_id: 1004, customer_id: 1, carrier_id: 3,
        origin_hub_id: 4, destination_hub_id: 1, employee_id: 5,
        shipping_cost: 250,
        ship_date: ISODate("2026-10-04"),
        expected_delivery_date: ISODate("2026-10-07"),
        actual_delivery_date: ISODate("2026-10-11")
    },
    {
        shipment_id: 1005, customer_id: 2, carrier_id: 2,
        origin_hub_id: 1, destination_hub_id: 3, employee_id: 4,
        shipping_cost: 200,
        ship_date: ISODate("2026-10-05"),
        expected_delivery_date: ISODate("2026-10-08"),
        actual_delivery_date: ISODate("2026-10-09")
    },
    {
        shipment_id: 1006, customer_id: 2, carrier_id: 3,
        origin_hub_id: 2, destination_hub_id: 4, employee_id: 5,
        shipping_cost: 700,
        ship_date: ISODate("2026-10-06"),
        expected_delivery_date: ISODate("2026-10-09"),
        actual_delivery_date: ISODate("2026-10-13")
    },
    {
        shipment_id: 1007, customer_id: 3, carrier_id: 1,
        origin_hub_id: 3, destination_hub_id: 2, employee_id: 4,
        shipping_cost: 550,
        ship_date: ISODate("2026-10-07"),
        expected_delivery_date: ISODate("2026-10-10"),
        actual_delivery_date: ISODate("2026-10-12")
    },
    {
        shipment_id: 1008, customer_id: 4, carrier_id: 2,
        origin_hub_id: 1, destination_hub_id: 2, employee_id: 5,
        shipping_cost: 150,
        ship_date: ISODate("2026-10-08"),
        expected_delivery_date: ISODate("2026-10-11"),
        actual_delivery_date: null
    }
]);

// 7. insert delivery events

db.log_delivery_events.insertMany([
    { event_id: 1, shipment_id: 1001, event_type: "picked up", event_date: ISODate("2026-10-01T09:00:00Z"), location: "chennai" },
    { event_id: 2, shipment_id: 1001, event_type: "in transit", event_date: ISODate("2026-10-02T10:00:00Z"), location: "coimbatore" },
    { event_id: 3, shipment_id: 1001, event_type: "delivered", event_date: ISODate("2026-10-06T15:00:00Z"), location: "coimbatore" },
    { event_id: 4, shipment_id: 1002, event_type: "picked up", event_date: ISODate("2026-10-02T09:00:00Z"), location: "coimbatore" },
    { event_id: 5, shipment_id: 1002, event_type: "delivered", event_date: ISODate("2026-10-04T12:00:00Z"), location: "madurai" },
    { event_id: 6, shipment_id: 1003, event_type: "picked up", event_date: ISODate("2026-10-03T08:00:00Z"), location: "madurai" },
    { event_id: 7, shipment_id: 1003, event_type: "delivered", event_date: ISODate("2026-10-11T16:00:00Z"), location: "salem" },
    { event_id: 8, shipment_id: 1005, event_type: "picked up", event_date: ISODate("2026-10-05T10:00:00Z"), location: "chennai" },
    { event_id: 9, shipment_id: 1005, event_type: "delivered", event_date: ISODate("2026-10-09T14:00:00Z"), location: "madurai" },
    { event_id: 10, shipment_id: 1006, event_type: "picked up", event_date: ISODate("2026-10-06T11:00:00Z"), location: "coimbatore" },
    { event_id: 11, shipment_id: 1006, event_type: "delivered", event_date: ISODate("2026-10-13T17:00:00Z"), location: "salem" },
    { event_id: 12, shipment_id: 1007, event_type: "picked up", event_date: ISODate("2026-10-07T09:00:00Z"), location: "madurai" }
]);

// 8. pipeline 1: shipments with delivery events

db.log_shipments.aggregate([
    {
        $lookup: {
            from: "log_delivery_events",
            localField: "shipment_id",
            foreignField: "shipment_id",
            as: "delivery_events"
        }
    },
    {
        $project: {
            _id: 0,
            shipment_id: 1,
            shipping_cost: 1,
            delivery_events: 1
        }
    },
    {
        $sort: { shipment_id: 1 }
    }
]);

// 9. pipeline 2: customers with their shipments

db.log_customers.aggregate([
    {
        $lookup: {
            from: "log_shipments",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "shipments"
        }
    },
    {
        $project: {
            _id: 0,
            customer_id: 1,
            customer_name: 1,
            city: 1,
            shipments: 1
        }
    },
    {
        $sort: { customer_id: 1 }
    }
]);

// 10. pipeline 3: carriers with delay statistics

db.log_carriers.aggregate([
    {
        $lookup: {
            from: "log_shipments",
            let: { current_carrier: "$carrier_id" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                { $eq: ["$carrier_id", "$$current_carrier"] },
                                { $ne: ["$actual_delivery_date", null] }
                            ]
                        }
                    }
                },
                {
                    $addFields: {
                        delay_days: {
                            $dateDiff: {
                                startDate: "$expected_delivery_date",
                                endDate: "$actual_delivery_date",
                                unit: "day"
                            }
                        }
                    }
                },
                {
                    $group: {
                        _id: "$carrier_id",
                        total_shipments: { $sum: 1 },
                        average_delay: { $avg: "$delay_days" },
                        maximum_delay: { $max: "$delay_days" }
                    }
                }
            ],
            as: "delay_statistics"
        }
    },
    {
        $project: {
            _id: 0,
            carrier_id: 1,
            carrier_name: 1,
            delay_statistics: 1
        }
    },
    {
        $sort: { carrier_id: 1 }
    }
]);

// 11. verify collections

db.log_hubs.find();
db.log_carriers.find();
db.log_customers.find();
db.log_employees.find();
db.log_shipments.find();
db.log_delivery_events.find();
