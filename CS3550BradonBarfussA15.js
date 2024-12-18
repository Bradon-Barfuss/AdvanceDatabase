
/* QUESTION 1 */
db.zipcodes.aggregate([
    {$match: { state: "UT"}},
    {$group: {_id: "$city", totalPopulation: {$sum: "$pop"}}},
    {$sort: {totalPopulation: -1}}
])


/* question 2 */
db.zipcodes.aggregate([
    {$match: { state: "CA"}},
    {$group: {_id: "$city", totalPopulation: {$sum: "$pop"}}},
    {$match: {totalPopulation: {$gte: 400000}}},
])


/*question 3 */
db.zipcodes.aggregate([
    {$group: {_id: "$state", statePopulation: {$sum: "$pop"}}},
    {$match: {statePopulation: {$gte: 5000000}}},
])


/* question 4 */
db.zipcodes.aggregate([
    {$match: { state: "WI"}},
    {$group: {_id: {state: "$state", city: "$city"}}},
    {$count: "cityforWI"}
])


/* question 5 */
db.zipcodes.aggregate([
    {$group: {_id: {state: "$state", city: "$city"}, totalcitypop: {$sum: "$pop"}}},
    {$group: {_id: "$_id.state", avgCityPop: {$avg: "$totalcitypop"}}},
    {$sort: {avgCityPop: -1}}
])


/*question 6*/
db.zipcodes.aggregate([
    {$group: {_id: {state: "$state", city: "$city"}, pop: {$sum: "$pop"}}},
    {$sort: {pop: 1}},
    { $group: {_id: "$_id.state",
     biggestCity: {$last: "$_id.city"},
    biggestPop: {$last : "$pop"}}},
    {$sort: {BiggestCity :-1}}
]);

/* question 7*/
db.zipcodes.aggregate([{
    $group: {_id: {state: "$state"}, numZipCodes: {$sum:1}}},
    {$sort: {numZipCodes : 1}},
    {$limit: 1}
]);

/* question 8 */
db.zipcodes.aggregate([
    {
    $unwind: "$loc"
    },
    {
    $group:
        {_id:{state: "$state", city: "$city"},
        longitude: {$first: "$loc"}
        }
    },
    {$sort: {longitude: -1}},
    {$limit: 1}
]);


/* question 9*/
db.zipcodes.aggregate([
    {
    $unwind: "$loc"
    },
    {
    $group:
        {_id:{state: "$state", city: "$city"},
        latitude: {$first: "$loc"}
        }
    },
    {$sort: {latitude: 1}},
    {$limit: 1}
]);


/* question 10 */
db.zipcodes.createIndex({loc: "2dsphere"});
db.zipcodes.find({
    loc: {$nearSphere:
    {
        $geometry: {
            type: "Point", 
            coordinates: [-80.0, 25.0]
        },
        $minDistance: 0,
        $maxDistance: 50000
    }}
})
