// Font: https://www.youtube.com/watch?v=EjcAqAJjmEo
// A copar-enganxar a mongosh o bé: https://stackoverflow.com/a/4837678

// CODE-ALONG

// show databases
show dbs

// Crea i usa database o només usa si ja existeix
// Compte, fins que no li posem cap collection no apareixerà a 'show dbs'
use newDB

// delete current database
db.dropDatabase()

// Print nom del database que estiguem fent servir at the moment
db

// Crea col·lecció
db.createCollection('clients')

// Elimina col·lecció
db.clients.drop()

// show collections from the database
show collections

// Inserta document a la col·lecció
db.clients.insertOne({
    id: 0,
    company: "asdf",
    address: "221b Baker Street, London",
    overdue_invoices: 24,
    products: ["coffee", "sugar"],
    date: Date(),
    contacts: {
        name: "Jim Neal",
        position: "owner",
        phone_number: 5550011
        }
})

// Query the data
db.clients.find()

// Delete document
// Compte: id és la que hem posat nosaltres, Mongo genera _id automàticament per la seva gestió, nosaltres hauríem de tenir la nostra amb significat de negoci independent de _id.
db.clients.deleteMany({id: 0})

// Inserta múltiples documents
db.clients.insertMany([
{
    id: 0,
    company: "asdf",
    address: "221b Baker Street, London",
    overdue_invoices: 20,
    products: ["coffee", "sugar"],
    date: Date(),
    contacts: {
        name: "Jim Neal",
        position: "owner",
        phone_number: 5550011
        }
}, {
    id: 1,
    company: "qwer",
    address: "221b Baker Street, London",
    overdue_invoices: 20,
    products: ["coffee", "sugar"],
    date: Date(),
    contacts: {
        name: "Jim Neal",
        position: "owner",
        phone_number: 5550011
        }
}, {
    id: 2,
    company: "zxcv",
    address: "221b Baker Street, London",
    overdue_invoices: 22,
    products: ["coffee", "sugar"],
    date: Date(),
    contacts: {
        name: "Jim Neal",
        position: "owner",
        phone_number: 5550011
        }
}
])

// QUERYING

// choose a document based on a criteria
db.clients.find({overdue_invoices: 20})

// sorting: 1 for ascending, -1 for descending
db.clients.find().sort({id:1})

// Counting
db.clients.find({overdue_invoices: 20}).count()

// Updating values + inserció de nous fields
db.clients.updateOne({id: 2}, {
    $set: {
        overdue_invoices: 40,
        imported: "James Ltd."
    }
})

db.clients.find({id:2})

// Incrementing - incrementa en 7 unitats les 20 que ja tenia
db.clients.updateOne({id:1}, {
    $inc: {
    overdue_invoices: 7
    }
})

db.clients.find({id:1})

// Renaming

db.clients.updateOne({id:1}, {
    $rename:{
        company: "legal_name"
    }
})

db.clients.find({id:1})

// Update array
db.clients.updateOne({id:0},{
    $set:{
        products:["vanilla", "milk"]
    }
})

db.clients.find()