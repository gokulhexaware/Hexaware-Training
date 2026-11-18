
db = db.getSiblingDB("insurancepolicy");

db.claims_notes.drop();

db.claims_notes.insertMany([
    {
        claim_id: 1,
        policy_id: 1001,
        customer_name: "Arun",
        status: "Settled",
        damage_category: "Medical",
        reported_date: ISODate("2026-10-29"),
        settled_date: ISODate("2026-11-08"),
        claim_amount: 3000
    },
    {
        claim_id: 2,
        policy_id: 1003,
        customer_name: "Bala",
        status: "Approved",
        damage_category: "Vehicle Damage",
        reported_date: ISODate("2026-11-03"),
        settled_date: null,
        claim_amount: 5000
    },
    {
        claim_id: 3,
        policy_id: 1004,
        customer_name: "Chitra",
        status: "Settled",
        damage_category: "Medical",
        reported_date: ISODate("2026-10-09"),
        settled_date: ISODate("2026-10-24"),
        claim_amount: 4000
    },
    {
        claim_id: 4,
        policy_id: 1005,
        customer_name: "Deepak",
        status: "Rejected",
        damage_category: "Death Benefit",
        reported_date: ISODate("2026-08-30"),
        settled_date: null,
        claim_amount: 7000
    },
    {
        claim_id: 5,
        policy_id: 1007,
        customer_name: "Ezhil",
        status: "Settled",
        damage_category: "Vehicle Damage",
        reported_date: ISODate("2026-10-19"),
        settled_date: ISODate("2026-10-29"),
        claim_amount: 2500
    },
    {
        claim_id: 6,
        policy_id: 1008,
        customer_name: "Chitra",
        status: "Pending",
        damage_category: "Travel Delay",
        reported_date: ISODate("2026-11-13"),
        settled_date: null,
        claim_amount: 1500
    }
]);


// 1. claims per status

db.claims_notes.aggregate([
    {
        $match: {
            status: { $exists: true }
        }
    },
    {
        $group: {
            _id: "$status",
            total_claims: { $sum: 1 },
            total_claim_amount: { $sum: "$claim_amount" }
        }
    },
    {
        $sort: {
            total_claims: -1,
            _id: 1
        }
    }
]);


// 2. average settlement time

db.claims_notes.aggregate([
    {
        $match: {
            settled_date: { $ne: null }
        }
    },
    {
        $group: {
            _id: null,
            average_settlement_days: {
                $avg: {
                    $dateDiff: {
                        startDate: "$reported_date",
                        endDate: "$settled_date",
                        unit: "day"
                    }
                }
            },
            settled_claims: { $sum: 1 }
        }
    },
    {
        $sort: {
            average_settlement_days: 1
        }
    }
]);


// 3. top three damage categories

db.claims_notes.aggregate([
    {
        $match: {
            damage_category: { $exists: true }
        }
    },
    {
        $group: {
            _id: "$damage_category",
            total_claims: { $sum: 1 },
            total_claim_amount: { $sum: "$claim_amount" }
        }
    },
    {
        $sort: {
            total_claims: -1,
            _id: 1
        }
    },
    {
        $limit: 3
    }
]);
