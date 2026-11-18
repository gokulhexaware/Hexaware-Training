
db = db.getSiblingDB("telecombilling");

db.usage_events.drop();

db.usage_events.insertMany([
    {
        event_id: 1,
        subscriber_id: 1,
        event_time: ISODate("2026-10-18T09:10:00Z"),
        session_duration_minutes: 15,
        data_used_mb: 120,
        cell_tower: "TOWER-A"
    },
    {
        event_id: 2,
        subscriber_id: 2,
        event_time: ISODate("2026-10-18T09:25:00Z"),
        session_duration_minutes: 20,
        data_used_mb: 250,
        cell_tower: "TOWER-A"
    },
    {
        event_id: 3,
        subscriber_id: 3,
        event_time: ISODate("2026-10-18T09:40:00Z"),
        session_duration_minutes: 30,
        data_used_mb: 300,
        cell_tower: "TOWER-B"
    },
    {
        event_id: 4,
        subscriber_id: 4,
        event_time: ISODate("2026-10-18T10:05:00Z"),
        session_duration_minutes: 10,
        data_used_mb: 80,
        cell_tower: "TOWER-A"
    },
    {
        event_id: 5,
        subscriber_id: 5,
        event_time: ISODate("2026-10-18T10:20:00Z"),
        session_duration_minutes: 25,
        data_used_mb: 180,
        cell_tower: "TOWER-C"
    },
    {
        event_id: 6,
        subscriber_id: 6,
        event_time: ISODate("2026-10-18T10:45:00Z"),
        session_duration_minutes: 40,
        data_used_mb: 400,
        cell_tower: "TOWER-B"
    },
    {
        event_id: 7,
        subscriber_id: 1,
        event_time: ISODate("2026-10-18T11:10:00Z"),
        session_duration_minutes: 12,
        data_used_mb: 100,
        cell_tower: "TOWER-A"
    },
    {
        event_id: 8,
        subscriber_id: 2,
        event_time: ISODate("2026-10-18T11:35:00Z"),
        session_duration_minutes: 18,
        data_used_mb: 220,
        cell_tower: "TOWER-C"
    },
    {
        event_id: 9,
        subscriber_id: 3,
        event_time: ISODate("2026-10-18T12:00:00Z"),
        session_duration_minutes: 35,
        data_used_mb: 350,
        cell_tower: "TOWER-B"
    },
    {
        event_id: 10,
        subscriber_id: 6,
        event_time: ISODate("2026-10-18T12:30:00Z"),
        session_duration_minutes: 28,
        data_used_mb: 280,
        cell_tower: "TOWER-A"
    }
]);


// 1. hourly usage summary

db.usage_events.aggregate([
    {
        $match: {
            event_time: {
                $gte: ISODate("2026-10-18T00:00:00Z"),
                $lt: ISODate("2026-10-19T00:00:00Z")
            }
        }
    },
    {
        $group: {
            _id: {
                $dateToString: {
                    format: "%Y-%m-%d %H:00",
                    date: "$event_time",
                    timezone: "UTC"
                }
            },
            total_data_used_mb: {
                $sum: "$data_used_mb"
            },
            total_sessions: {
                $sum: 1
            }
        }
    },
    {
        $sort: {
            _id: 1
        }
    }
]);


// 2. average session length

db.usage_events.aggregate([
    {
        $match: {
            session_duration_minutes: {
                $gt: 0
            }
        }
    },
    {
        $group: {
            _id: null,
            average_session_minutes: {
                $avg: "$session_duration_minutes"
            },
            total_sessions: {
                $sum: 1
            }
        }
    },
    {
        $project: {
            _id: 0,
            average_session_minutes: {
                $round: ["$average_session_minutes", 2]
            },
            total_sessions: 1
        }
    }
]);


// 3. busiest cell tower

db.usage_events.aggregate([
    {
        $group: {
            _id: "$cell_tower",
            total_sessions: {
                $sum: 1
            },
            total_data_used_mb: {
                $sum: "$data_used_mb"
            }
        }
    },
    {
        $sort: {
            total_sessions: -1,
            total_data_used_mb: -1
        }
    },
    {
        $limit: 1
    }
]);
