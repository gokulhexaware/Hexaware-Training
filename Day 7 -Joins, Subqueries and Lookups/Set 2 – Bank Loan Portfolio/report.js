
use('bankloanportfolio');

db.bank_branches.insertMany([
    { branch_id: 1, branch_name: "chennai main branch", city: "chennai" },
    { branch_id: 2, branch_name: "coimbatore branch", city: "coimbatore" },
    { branch_id: 3, branch_name: "madurai branch", city: "madurai" },
    { branch_id: 4, branch_name: "salem branch", city: "salem" }
]);

db.bank_customers.insertMany([
    { customer_id: 1, customer_name: "arun kumar", city: "chennai", phone: "9876500001" },
    { customer_id: 2, customer_name: "vijay kumar", city: "coimbatore", phone: "9876500002" },
    { customer_id: 3, customer_name: "surya prakash", city: "madurai", phone: "9876500003" },
    { customer_id: 4, customer_name: "karthik rajan", city: "salem", phone: "9876500004" },
    { customer_id: 5, customer_name: "ashwin kumar", city: "chennai", phone: "9876500005" },
    { customer_id: 6, customer_name: "rahul dev", city: "coimbatore", phone: "9876500006" }
]);

db.bank_loans.insertMany([
    {
        loan_id: 1001,
        customer_id: 1,
        branch_id: 1,
        loan_amount: 500000,
        loan_date: ISODate("2026-01-10"),
        instalments_total: 24,
        instalments_paid: 10,
        overdue_instalments: 1
    },
    {
        loan_id: 1002,
        customer_id: 1,
        branch_id: 2,
        loan_amount: 300000,
        loan_date: ISODate("2026-02-15"),
        instalments_total: 18,
        instalments_paid: 8,
        overdue_instalments: 0
    },
    {
        loan_id: 1003,
        customer_id: 2,
        branch_id: 1,
        loan_amount: 800000,
        loan_date: ISODate("2025-11-20"),
        instalments_total: 36,
        instalments_paid: 12,
        overdue_instalments: 4
    },
    {
        loan_id: 1004,
        customer_id: 2,
        branch_id: 2,
        loan_amount: 200000,
        loan_date: ISODate("2026-03-05"),
        instalments_total: 12,
        instalments_paid: 5,
        overdue_instalments: 2
    },
    {
        loan_id: 1005,
        customer_id: 3,
        branch_id: 3,
        loan_amount: 900000,
        loan_date: ISODate("2025-09-10"),
        instalments_total: 48,
        instalments_paid: 15,
        overdue_instalments: 5
    },
    {
        loan_id: 1006,
        customer_id: 4,
        branch_id: 1,
        loan_amount: 150000,
        loan_date: ISODate("2026-04-12"),
        instalments_total: 12,
        instalments_paid: 3,
        overdue_instalments: 0
    },
    {
        loan_id: 1007,
        customer_id: 5,
        branch_id: 2,
        loan_amount: 400000,
        loan_date: ISODate("2026-05-18"),
        instalments_total: 24,
        instalments_paid: 6,
        overdue_instalments: 1
    },
    {
        loan_id: 1008,
        customer_id: 6,
        branch_id: 3,
        loan_amount: 600000,
        loan_date: ISODate("2026-06-20"),
        instalments_total: 36,
        instalments_paid: 4,
        overdue_instalments: 2
    }
]);

db.bank_repayments.insertMany([
    { repayment_id: 1, loan_id: 1001, repayment_date: ISODate("2026-10-05"), repayment_amount: 25000 },
    { repayment_id: 2, loan_id: 1001, repayment_date: ISODate("2026-10-25"), repayment_amount: 25000 },
    { repayment_id: 3, loan_id: 1002, repayment_date: ISODate("2026-10-10"), repayment_amount: 20000 },
    { repayment_id: 4, loan_id: 1003, repayment_date: ISODate("2026-07-15"), repayment_amount: 30000 },
    { repayment_id: 5, loan_id: 1003, repayment_date: ISODate("2026-10-15"), repayment_amount: 30000 },
    { repayment_id: 6, loan_id: 1004, repayment_date: ISODate("2026-08-20"), repayment_amount: 15000 },
    { repayment_id: 7, loan_id: 1005, repayment_date: ISODate("2026-09-12"), repayment_amount: 35000 },
    { repayment_id: 8, loan_id: 1007, repayment_date: ISODate("2026-10-18"), repayment_amount: 20000 },
    { repayment_id: 9, loan_id: 1008, repayment_date: ISODate("2026-10-22"), repayment_amount: 25000 },
    { repayment_id: 10, loan_id: 1006, repayment_date: ISODate("2026-07-01"), repayment_amount: 10000 }
]);


db.bank_guarantors.insertMany([
    { guarantor_id: 1, loan_id: 1001, guarantor_customer_id: 2 },
    { guarantor_id: 2, loan_id: 1002, guarantor_customer_id: 3 },
    { guarantor_id: 3, loan_id: 1003, guarantor_customer_id: 1 },
    { guarantor_id: 4, loan_id: 1004, guarantor_customer_id: 5 },
    { guarantor_id: 5, loan_id: 1005, guarantor_customer_id: 2 },
    { guarantor_id: 6, loan_id: 1006, guarantor_customer_id: 6 },
    { guarantor_id: 7, loan_id: 1007, guarantor_customer_id: 4 },
    { guarantor_id: 8, loan_id: 1008, guarantor_customer_id: 1 }
]);


db.bank_loans.aggregate([
    {
        $lookup: {
            from: "bank_customers",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "customer_details"
        }
    },
    {
        $unwind: "$customer_details"
    },
    {
        $project: {
            _id: 0,
            loan_id: 1,
            loan_amount: 1,
            branch_id: 1,
            customer_name: "$customer_details.customer_name",
            customer_city: "$customer_details.city"
        }
    },
    {
        $sort: { loan_id: 1 }
    }
]);

// pipeline 2:
// loans combined with repayment details

db.bank_loans.aggregate([
    {
        $lookup: {
            from: "bank_repayments",
            localField: "loan_id",
            foreignField: "loan_id",
            as: "repayment_details"
        }
    },
    {
        $project: {
            _id: 0,
            loan_id: 1,
            loan_amount: 1,
            customer_id: 1,
            repayment_details: 1,
            total_repayments: {
                $size: "$repayment_details"
            }
        }
    },
    {
        $sort: { loan_id: 1 }
    }
]);

// pipeline 3:
// find the last repayment for each loan

db.bank_loans.aggregate([
    {
        $lookup: {
            from: "bank_repayments",
            let: { current_loan_id: "$loan_id" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $eq: ["$loan_id", "$$current_loan_id"]
                        }
                    }
                },
                {
                    $sort: {
                        repayment_date: -1,
                        repayment_id: -1
                    }
                },
                {
                    $limit: 1
                }
            ],
            as: "last_repayment"
        }
    },
    {
        $unwind: {
            path: "$last_repayment",
            preserveNullAndEmptyArrays: true
        }
    },
    {
        $project: {
            _id: 0,
            loan_id: 1,
            customer_id: 1,
            loan_amount: 1,
            last_repayment_date: "$last_repayment.repayment_date",
            last_repayment_amount: "$last_repayment.repayment_amount"
        }
    },
    {
        $sort: { loan_id: 1 }
    }
]);
db.bank_branches.find();
db.bank_customers.find();
db.bank_loans.find();
db.bank_repayments.find();
db.bank_guarantors.find();
