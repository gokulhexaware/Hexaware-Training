
use('retail_inventory');

// creating reviews collection with validation

db.createCollection('product_reviews', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: [
                'customer_name',
                'product_sku',
                'rating',
                'review_text',
                'reviewed_at'
            ],
            properties: {
                customer_name: {
                    bsonType: 'string',
                    description: 'customer name is required'
                },
                product_sku: {
                    bsonType: 'string'
                },
                rating: {
                    bsonType: 'int',
                    minimum: 1,
                    maximum: 5
                },
                review_text: {
                    bsonType: 'string'
                },
                reviewed_at: {
                    bsonType: 'date'
                }
            }
        }
    },
    validationLevel: 'strict',
    validationAction: 'error'
});


// inserting customer reviews

db.product_reviews.insertMany([
    {
        customer_name: 'Arun Kumar',
        product_sku: 'SKU-101',
        rating: 5,
        review_text: 'Good quality bat and nice grip.',
        reviewed_at: new Date('2026-10-10')
    },
    {
        customer_name: 'Karthik',
        product_sku: 'SKU-102',
        rating: 4,
        review_text: 'Helmet is comfortable.',
        reviewed_at: new Date('2026-10-11')
    },
    {
        customer_name: 'Vijay',
        product_sku: 'SKU-103',
        rating: 5,
        review_text: 'Gloves are worth the price.',
        reviewed_at: new Date('2026-10-12')
    },
    {
        customer_name: 'Surya',
        product_sku: 'SKU-104',
        rating: 3,
        review_text: 'Good product but delivery was late.',
        reviewed_at: new Date('2026-10-13')
    },
    {
        customer_name: 'Ajith',
        product_sku: 'SKU-105',
        rating: 4,
        review_text: 'Shoes are comfortable for running.',
        reviewed_at: new Date('2026-10-14')
    },
    {
        customer_name: 'Rohit',
        product_sku: 'SKU-106',
        rating: 5,
        review_text: 'Nice training kit.',
        reviewed_at: new Date('2026-10-15')
    },
    {
        customer_name: 'Virat',
        product_sku: 'SKU-107',
        rating: 4,
        review_text: 'Good football for practice.',
        reviewed_at: new Date('2026-10-16')
    },
    {
        customer_name: 'Dhoni',
        product_sku: 'SKU-108',
        rating: 5,
        review_text: 'Very useful fitness gloves.',
        reviewed_at: new Date('2026-10-17')
    },
    {
        customer_name: 'Hardik',
        product_sku: 'SKU-109',
        rating: 3,
        review_text: 'Average racket for beginners.',
        reviewed_at: new Date('2026-10-18')
    },
    {
        customer_name: 'Raina',
        product_sku: 'SKU-101',
        rating: 5,
        review_text: 'Excellent bat for cricket.',
        reviewed_at: new Date('2026-10-19')
    }
]);


// displaying all reviews

db.product_reviews.find();


// finding reviews with rating 5

db.product_reviews.find({
    rating: 5
});


// updating a customer review

db.product_reviews.updateOne(
    { customer_name: 'Karthik', product_sku: 'SKU-102' },
    {
        $set: {
            review_text: 'The helmet is comfortable and has good quality.',
            rating: 5
        }
    }
);


// checking the updated review

db.product_reviews.find({
    customer_name: 'Karthik'
});


// deleting a review

db.product_reviews.deleteOne({
    customer_name: 'Surya',
    product_sku: 'SKU-104'
});


// displaying final review records

db.product_reviews.find();
