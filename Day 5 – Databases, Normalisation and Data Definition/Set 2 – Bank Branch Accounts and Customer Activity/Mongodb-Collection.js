
use('bankbranchaccounts');


// creating a capped collection

db.createCollection('customer_activity', {
    capped: true,
    size: 1048576,
    max: 1000
});


// inserting 20 customer activity records

db.customer_activity.insertMany([
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-10T08:00:00')
    },
    {
        customer_id: 1002,
        event_type: 'login',
        device: 'desktop',
        location: 'Madurai',
        event_time: new Date('2026-11-10T09:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'balance_check',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-10T09:30:00')
    },
    {
        customer_id: 1003,
        event_type: 'login',
        device: 'mobile',
        location: 'Coimbatore',
        event_time: new Date('2026-11-11T08:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'desktop',
        location: 'Chennai',
        event_time: new Date('2026-11-11T10:00:00')
    },
    {
        customer_id: 1004,
        event_type: 'transfer',
        device: 'mobile',
        location: 'Trichy',
        event_time: new Date('2026-11-11T11:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'logout',
        device: 'desktop',
        location: 'Chennai',
        event_time: new Date('2026-11-11T11:30:00')
    },
    {
        customer_id: 1005,
        event_type: 'login',
        device: 'mobile',
        location: 'Salem',
        event_time: new Date('2026-11-12T08:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-12T09:00:00')
    },
    {
        customer_id: 1006,
        event_type: 'login',
        device: 'desktop',
        location: 'Bangalore',
        event_time: new Date('2026-11-12T10:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'balance_check',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-13T08:30:00')
    },
    {
        customer_id: 1007,
        event_type: 'login',
        device: 'mobile',
        location: 'Mumbai',
        event_time: new Date('2026-11-13T09:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'desktop',
        location: 'Chennai',
        event_time: new Date('2026-11-13T10:00:00')
    },
    {
        customer_id: 1008,
        event_type: 'transfer',
        device: 'mobile',
        location: 'Delhi',
        event_time: new Date('2026-11-14T08:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-14T09:00:00')
    },
    {
        customer_id: 1009,
        event_type: 'login',
        device: 'desktop',
        location: 'Hyderabad',
        event_time: new Date('2026-11-15T08:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-15T10:00:00')
    },
    {
        customer_id: 1010,
        event_type: 'login',
        device: 'mobile',
        location: 'Kochi',
        event_time: new Date('2026-11-16T08:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'desktop',
        location: 'Chennai',
        event_time: new Date('2026-11-16T10:00:00')
    },
    {
        customer_id: 1001,
        event_type: 'login',
        device: 'mobile',
        location: 'Chennai',
        event_time: new Date('2026-11-17T09:00:00')
    }
]);


// displaying all customer activities

db.customer_activity.find();


// finding activities of one customer

db.customer_activity.find({
    customer_id: 1001
});


// finding login activities

db.customer_activity.find({
    event_type: 'login'
});


// finding the last five login events of customer 1001

db.customer_activity.find({
    customer_id: 1001,
    event_type: 'login'
})
.sort({
    event_time: -1
})
.limit(5);
