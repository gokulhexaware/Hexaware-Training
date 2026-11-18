
use('hospitalrecords7');


// creating clinical notes collection

db.createCollection('clinical_notes', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: [
                'patient_id',
                'diagnosis',
                'note',
                'created_at'
            ],
            properties: {
                patient_id: {
                    bsonType: 'int'
                },
                diagnosis: {
                    bsonType: 'string'
                },
                note: {
                    bsonType: 'string'
                },
                created_at: {
                    bsonType: 'date'
                },
                symptoms: {
                    bsonType: 'array',
                    items: {
                        bsonType: 'string'
                    }
                },
                vitals: {
                    bsonType: 'object'
                },
                test_results: {
                    bsonType: 'object'
                },
                follow_up: {
                    bsonType: 'object'
                }
            }
        }
    },
    validationLevel: 'strict',
    validationAction: 'error'
});


// inserting clinical notes with different structures

db.clinical_notes.insertMany([
    {
        patient_id: 1,
        diagnosis: 'High Blood Pressure',
        note: 'Patient reported headache and dizziness.',
        symptoms: [
            'Headache',
            'Dizziness'
        ],
        vitals: {
            blood_pressure: '140/90',
            pulse: 88,
            temperature: 98.6
        },
        created_at: new Date('2026-11-10')
    },
    {
        patient_id: 2,
        diagnosis: 'Migraine',
        note: 'Patient reported frequent headaches.',
        symptoms: [
            'Headache',
            'Nausea'
        ],
        vitals: {
            blood_pressure: '120/80',
            pulse: 76
        },
        created_at: new Date('2026-11-11')
    },
    {
        patient_id: 3,
        diagnosis: 'Knee Pain',
        note: 'Patient advised to complete physiotherapy.',
        test_results: {
            xray: 'No fracture found',
            condition: 'Mild joint inflammation'
        },
        follow_up: {
            required: true,
            days: 7,
            instructions: 'Visit after one week'
        },
        created_at: new Date('2026-11-12')
    },
    {
        patient_id: 4,
        diagnosis: 'Fever',
        note: 'Patient has mild fever and body pain.',
        test_results: {
            temperature: 101.2,
            blood_test: 'Normal'
        },
        follow_up: {
            required: true,
            days: 3,
            instructions: 'Review after three days'
        },
        created_at: new Date('2026-11-13')
    }
]);


// displaying all clinical notes

db.clinical_notes.find();


// finding notes by diagnosis

db.clinical_notes.find({
    diagnosis: 'Migraine'
});


// finding patients with fever

db.clinical_notes.find({
    diagnosis: 'Fever'
});


// finding all records related to knee pain

db.clinical_notes.find({
    diagnosis: 'Knee Pain'
});


// displaying all diagnoses

db.clinical_notes.find(
    {},
    {
        patient_id: 1,
        diagnosis: 1,
        created_at: 1
    }
);
