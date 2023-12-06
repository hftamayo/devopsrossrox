// mongo-script.js

const dbName = 'TopicstoreDb';
const collectionName = 'Topics';
const db = db.getSiblingDB(dbName);

db.createCollection(collectionName);
function convertToUTF8(str) {
   return Buffer.from(str, 'latin1').toString('utf8');
}

const data = [
    { "Name": "chivo01" },
    { "Name": "chivo02" },
    { "Name": "chivo03" },
    { "Name": "chivo04" },
    { "Name": "chivo05" },
    { "Name": "chivo06" },
    { "Name": "chivo07" },
    { "Name": "chivo08" },
    { "Name": "chivo09" }
];

const convertedData = data.map(item => ({ "Name": convertToUTF8(item.Name) }));

db[collectionName].insertMany(convertedData);
