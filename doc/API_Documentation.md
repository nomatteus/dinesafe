Dinesafe API Documentation
==========================

(This is a work in progress. I am writing the documentation before the API, so 
I can be clear what I need to build.)

Note: This is a private API and is not for general public use. If you want to 
use it, please contact me and we can work something out. 

Establishments
--------------

An establishment is a restaurant, supermarket, food store, etc. (see a full
list of establishment types in Appendix A). 

An establishment has the following fields:

* `id` (integer): A unique ID for the establishment.
* `latest_name` (string): The latest name for establishment (see below for "latest" explanation).
* `latest_type` (string): The latest type for establishment (see Appendix A).
* `address` (string): The street address of the establishment. (All addresses
are presumed to be in Toronto.)
* `latlng` (string): comma-separated lat and lng values
* `distance` (float, in km): when performing a search with `near` values, 
distance is returned as km between the establishment and the lat,lng
specified in the `near` parameter.

**Query for establishments by calling the url:**

    http://dinesafe.to/api/1.0/establishments.json

**Parameters:**

* `page`: Page Number. Use for pagination (default: 1)
* `near`: Lat Long pair, separated by comma. Proximity search.
* `search`: String. Text search of establishment name.

Parameters can be combined, i.e. `near` and `search` will return search results
for `search`, ordered by proximity to `near`.

**Explanation of *Latest* Fields**

Everytime an establishment is updated with new inspections, the latest_name
and latest_type are updated with the establishment's name and type as of
the latest inspection. Most of the time, this will always be the same, but
in some cases the establishment name changes, so a history of the establishment
name must be stored. 

You will see when querying for inspections that establishment_name is
also returned there. You can compare the establishment_name with the
latest\_name, and if different display the establishment\_name to the 
user in some way.

The basic problem that might arise if the above was not this way (i.e.
if we only stored the latest name as the definitive name) is that in
some cases inspections would still be linked to a restaurant even if
it changed names/owners. (This would be the case if the establishment
ID reported by Dinesafe stays the same. I've noticed in some cases
it does, but not sure if it's the standard to re-use establishment
IDs, or if those were just special/unique cases.)

Inspections
-----------

This is effectively a single establishment "detail view".

* `id` (integer): A unique ID for the establishment.
* `infractions` (array): An array of infractions for this inspection.
An infraction has the following fields:
    * `details` (string): Detail of infraction. (i.e. "Operator fail to properly remove liquid waste")
    * `severity` (string): Severity value is one of: "C - Crucial", "S - Significant", "M - Minor"
    * `action` (string): Action taken, if any.
    * `court_outcome` (string): Court outcome, if any.
    * `amount_fined` (integer): Amount fined, if any. Default is 0.
* `establishment_name` (string): The name for establishment as of this inspection.
* `establishment_type` (string): The type for establishment as of this inspection.
* `minimum_inspections_per_year` (integer): Minimum inspections per year for this establishment, as of this inspection
* `status` (string): Status of establishment as of this inspection. As of November 2012, the value of `status` will be one of: "Pass", "Conditional Pass", "Closed", or "Out of Business".
* `distance`: Returned if `near` parameter set on API call. 
(Same as `distance` parameter returned by establishment list.)

**Query for inspections by calling the url:**

    http://dinesafe.dev/api/1.0/establishments/<establishment_id>.json?near=43.65100,-79.47702

Replace `<establishment_id>` with the ID of the establishment you would
like to retrieve inspections for, as returned by the establishments
API call above.

**Parameters:**

* `near`: Lat Long pair, separated by comma. Including this will return
a `distance` field.


Appendix A - Establishment Types
--------------------------------

These are all the different establishment types (`est_type`s), as of
November 15, 2012. The number of establishments having each `est_type`
is specified after the colon.

    Restaurant: 6957
    Food Take Out: 2740
    Food Store (Convenience / Variety): 2489
    Supermarket: 486
    Food Court Vendor: 438
    Bakery: 421
    Food Processing Plant: 231
    Butcher Shop: 189
    Food Depot: 175
    Banquet Facility: 161
    Secondary School Food Services: 143
    Cocktail Bar / Beverage Room: 137
    Food Caterer: 127
    Hot Dog Cart: 114
    Private Club: 101
    Cafeteria - Public Access: 97
    Community Kitchen Meal Program: 82
    Ice Cream / Yogurt Vendors: 79
    Commissary: 56
    Refreshment Stand (Stationary): 56
    Fish Shop: 45
    Food Bank: 29
    Mobile Food Preparation Premises: 27
    Bake Shop: 25
    Chartered Cruise Boats: 21
    Food Vending Facility: 15
    Church Banquet Facility: 11
    Meat Processing Plant: 7
    Flea Market: 5
    Toronto A La Cart: 4
    Bottling Plant: 3
    Bed & Breakfast: 2
    Farmer's Market: 2
    Milk Products Plant: 2
    Brew Your Own Beer / Wine: 1
    Catering Vehicle: 1
    Food Cart: 1
    Locker Plant: 1


Appendix B - Example API Calls and JSON Returned
------------------------------------------------

API URI:

    http://dinesafe.dev/api/1.0/establishments.json?near=43.65100,-79.47702

JSON RETURN:

    {
       "data":[
          {
             "id":9060707,
             "latest_name":"ASTRA FAMOUS DELI",
             "latest_type":"Food Take Out",
             "address":"2238 BLOOR ST W",
             "latlng":"(43.6511038,-79.4769993)",
             "distance":0.0116746338396286
          },
          {
             "id":10374862,
             "latest_name":"17 STEPS RESTAURANT AND BAR",
             "latest_type":"Restaurant",
             "address":"2241 BLOOR ST W",
             "latlng":"(43.6508421,-79.477041)",
             "distance":0.0176585449947069
          },
          {
             "id":9012254,
             "latest_name":"PIZZA PIZZA",
             "latest_type":"Restaurant",
             "address":"2241 BLOOR ST W",
             "latlng":"(43.6508421,-79.477041)",
             "distance":0.0176585449947069
          },
          {
             "id":10292559,
             "latest_name":"MAC'S",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2244 BLOOR ST W",
             "latlng":"(43.6510748,-79.4771688)",
             "distance":0.0145938435729655
          },
          {
             "id":10390730,
             "latest_name":"LAURA SECORD HALLMARK STORE",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2243 BLOOR ST W",
             "latlng":"(43.6509346,-79.4771996)",
             "distance":0.0161947533441043
          },
          {
             "id":10209243,
             "latest_name":"PEACH TREE HEALTH FOODS",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2239 BLOOR ST W",
             "latlng":"(43.6508826,-79.4768622)",
             "distance":0.0182303267318777
          },
          {
             "id":10412054,
             "latest_name":"ALI BABA'S MIDDLE EASTERN CUISINE",
             "latest_type":"Restaurant",
             "address":"2246 BLOOR ST W",
             "latlng":"(43.6509642,-79.4772235)",
             "distance":0.0168686443468721
          },
          {
             "id":10379684,
             "latest_name":"BREAD AND ROSES",
             "latest_type":"Restaurant",
             "address":"2232 BLOOR ST W",
             "latlng":"(43.6511569,-79.4767983)",
             "distance":0.0249787295102733
          },
          {
             "id":10379376,
             "latest_name":"ROWE FARMS",
             "latest_type":"Butcher Shop",
             "address":"2230 BLOOR ST W",
             "latlng":"(43.651069,-79.4767031)",
             "distance":0.0266557074626073
          },
          {
             "id":10447822,
             "latest_name":"THE WORKS GOURMET BURGER BISTRO",
             "latest_type":"Restaurant",
             "address":"2245 BLOOR ST W",
             "latlng":"(43.6509248,-79.4773401)",
             "distance":0.0271077512535918
          },
          {
             "id":10302560,
             "latest_name":"THE HOT OVEN BAKERY",
             "latest_type":"Bakery",
             "address":"2226 BLOOR ST W",
             "latlng":"(43.6511936,-79.4766287)",
             "distance":0.0381815311900012
          },
          {
             "id":9059943,
             "latest_name":"SIMPLY THAI CUISINE",
             "latest_type":"Restaurant",
             "address":"2253 BLOOR ST W",
             "latlng":"(43.650729,-79.477602)",
             "distance":0.0557459665182527
          },
          {
             "id":10278948,
             "latest_name":"SHAKEY'S ORIGINAL BAR & GRILL",
             "latest_type":"Restaurant",
             "address":"2255 BLOOR ST W",
             "latlng":"(43.6507367,-79.4776156)",
             "distance":0.0562186178646808
          },
          {
             "id":9416375,
             "latest_name":"HEALTH PRODUCTS",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2221 BLOOR ST W",
             "latlng":"(43.6509692,-79.4763314)",
             "distance":0.0555699032109953
          },
          {
             "id":9009828,
             "latest_name":"MCDONALD'S RESTAURANT",
             "latest_type":"Restaurant",
             "address":"2218 BLOOR ST W",
             "latlng":"(43.6511722,-79.4761936)",
             "distance":0.0692685280411905
          },
          {
             "id":9011656,
             "latest_name":"PARKLAND MEAT PRODUCTS",
             "latest_type":"Meat Processing Plant",
             "address":"2216 BLOOR ST W",
             "latlng":"(43.6512936,-79.4761145)",
             "distance":0.079922726923697
          },
          {
             "id":10329523,
             "latest_name":"QUEENS PASTA CAFE",
             "latest_type":"Restaurant",
             "address":"2263 BLOOR ST W",
             "latlng":"(43.6506425,-79.4779452)",
             "distance":0.0844819076652118
          },
          {
             "id":9012637,
             "latest_name":"QUEEN'S PASTA TAKE-OUT",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"256 BERESFORD AVE ",
             "latlng":"(43.6506418,-79.4779488)",
             "distance":0.0847744201679337
          },
          {
             "id":10448844,
             "latest_name":"Zaza Espresso Bar",
             "latest_type":"Food Take Out",
             "address":"256 BERESFORD AVE ",
             "latlng":"(43.6506418,-79.4779488)",
             "distance":0.0847744201679337
          },
          {
             "id":10247994,
             "latest_name":"GREEN THUMB",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2268 BLOOR ST W",
             "latlng":"(43.6508461,-79.4782093)",
             "distance":0.0973133754649113
          },
          {
             "id":9014634,
             "latest_name":"STARBUCKS COFFEE ",
             "latest_type":"Restaurant",
             "address":"2210 BLOOR ST W",
             "latlng":"(43.651351,-79.4758667)",
             "distance":0.10077681764644
          },
          {
             "id":9017370,
             "latest_name":"WEST END MEDICAL PHARMACY",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2209 BLOOR ST W",
             "latlng":"(43.6512483,-79.4757313)",
             "distance":0.107416891473615
          },
          {
             "id":10416403,
             "latest_name":"COBS BREAD",
             "latest_type":"Food Store (Convenience / Variety)",
             "address":"2204 BLOOR ST W",
             "latlng":"(43.6514064,-79.4757011)",
             "distance":0.115464126627888
          },
          {
             "id":9396806,
             "latest_name":"THE SWAN & FIRKIN",
             "latest_type":"Restaurant",
             "address":"2205 BLOOR ST W",
             "latlng":"(43.6512514,-79.4756355)",
             "distance":0.114974035760531
          },
          {
             "id":9016175,
             "latest_name":"THE YELLOW GRIFFEN",
             "latest_type":"Restaurant",
             "address":"2202 BLOOR ST W",
             "latlng":"(43.6514205,-79.4756153)",
             "distance":0.122443935550255
          },
          {
             "id":9041814,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"2200 BLOOR ST W",
             "latlng":"(43.6514318,-79.4755617)",
             "distance":0.12691509780057
          },
          {
             "id":10442776,
             "latest_name":"YOGURTY'S FROYO",
             "latest_type":"Restaurant",
             "address":"2203 BLOOR ST W",
             "latlng":"(43.6512915,-79.4755191)",
             "distance":0.125170921893739
          },
          {
             "id":10410861,
             "latest_name":"THE KENNEDY PUBLIC HOUSE",
             "latest_type":"Restaurant",
             "address":"2199 BLOOR ST W",
             "latlng":"(43.6511632,-79.475322)",
             "distance":0.137968585056141
          },
          {
             "id":10392418,
             "latest_name":"SUSHI & THAI",
             "latest_type":"Restaurant",
             "address":"2279 BLOOR ST W",
             "latlng":"(43.6504864,-79.47865)",
             "distance":0.143198893968186
          },
          {
             "id":10229889,
             "latest_name":"VILLA RESTAURANT",
             "latest_type":"Restaurant",
             "address":"2277 BLOOR ST W",
             "latlng":"(43.6505185,-79.4786861)",
             "distance":0.144506231902148
          }
       ]
    }

---

API URI:

    http://dinesafe.dev/api/1.0/establishments.json?near=43.65100,-79.47702&search=sunset

JSON RETURN:

    {
       "data":[
          {
             "id":9041814,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"2200 BLOOR ST W",
             "latlng":"(43.6514318,-79.4755617)",
             "distance":0.12691509780057
          },
          {
             "id":10282141,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"1422 DUNDAS ST W",
             "latlng":"(43.6496766,-79.4294587)",
             "distance":3.83370782007718
          },
          {
             "id":10429769,
             "latest_name":"Sunset Grill",
             "latest_type":"Restaurant",
             "address":"2610 WESTON RD ",
             "latlng":"(43.7112552,-79.5353838)",
             "distance":8.19089573400649
          },
          {
             "id":10397367,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"120 BLOOR ST E",
             "latlng":"(43.6710294,-79.3831614)",
             "distance":7.88188559600645
          },
          {
             "id":10318159,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"1 RICHMOND ST W",
             "latlng":"(43.6514514,-79.3801689)",
             "distance":7.80113812040144
          },
          {
             "id":9062600,
             "latest_name":"O/A SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"2313 YONGE ST ",
             "latlng":"(43.7078665,-79.3984165)",
             "distance":8.95307035140237
          },
          {
             "id":10418540,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"45 WICKSTEED AVE ",
             "latlng":"(43.7106445,-79.3619008)",
             "distance":11.4044565924646
          },
          {
             "id":10417108,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"1602 DANFORTH AVE ",
             "latlng":"(43.6836091,-79.3230909)",
             "distance":12.9188647032036
          },
          {
             "id":9014986,
             "latest_name":"SUNSET GRILL",
             "latest_type":"Restaurant",
             "address":"2006 QUEEN ST E",
             "latlng":"(43.6702415,-79.2995934)",
             "distance":14.4506445663525
          },
          {
             "id":10417497,
             "latest_name":"ISLAND SUNSET RESTAURANT & LOUNGE",
             "latest_type":"Restaurant",
             "address":"1139 MORNINGSIDE AVE ",
             "latlng":"(43.8004487,-79.1990018)",
             "distance":27.8968402941018
          }
       ]
    }

---

API URI:

    http://dinesafe.dev/api/1.0/establishments/9060707.json

JSON RETURN:

    {
       "data":{
          "id":9060707,
          "latest_name":"ASTRA FAMOUS DELI",
          "latest_type":"Food Take Out",
          "address":"2238 BLOOR ST W",
          "latlng":"(43.6511038,-79.4769993)",
          "inspections":[
             {
                "id":102256788,
                "status":"Pass",
                "date":"2010-04-27",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102313998,
                "status":"Pass",
                "date":"2010-07-09",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102412106,
                "status":"Pass",
                "date":"2010-12-14",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102502716,
                "status":"Pass",
                "date":"2011-04-20",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102571629,
                "status":"Conditional Pass",
                "date":"2011-08-08",
                "infractions":[
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to properly remove liquid waste",
                      "id":104943,
                      "inspection_id":102571629,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to provide adequate pest control",
                      "id":104949,
                      "inspection_id":102571629,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to properly store solid waste",
                      "id":104948,
                      "inspection_id":102571629,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to provide proper equipment",
                      "id":104946,
                      "inspection_id":102571629,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to properly wash surfaces in rooms",
                      "id":104945,
                      "inspection_id":102571629,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to provide adequate lighting",
                      "id":104947,
                      "inspection_id":102571629,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to provide proper garbage containers",
                      "id":104944,
                      "inspection_id":102571629,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to properly wash equipment",
                      "id":104942,
                      "inspection_id":102571629,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to properly maintain rooms",
                      "id":104950,
                      "inspection_id":102571629,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   }
                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102571657,
                "status":"Conditional Pass",
                "date":"2011-08-22",
                "infractions":[
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:51Z",
                      "details":"Operator fail to provide adequate pest control",
                      "id":104953,
                      "inspection_id":102571657,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:10:51Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:50Z",
                      "details":"Operator fail to provide proper equipment",
                      "id":104951,
                      "inspection_id":102571657,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:51Z",
                      "details":"Operator fail to properly maintain rooms",
                      "id":104952,
                      "inspection_id":102571657,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:51Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:10:51Z",
                      "details":"Operator fail to provide adequate lighting",
                      "id":104954,
                      "inspection_id":102571657,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:10:51Z"
                   }
                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102583535,
                "status":"Pass",
                "date":"2011-09-14",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102655027,
                "status":"Conditional Pass",
                "date":"2011-12-15",
                "infractions":[
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to use proper procedure(s) to ensure food safety",
                      "id":108820,
                      "inspection_id":102655027,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to use proper utensils to ensure food safety",
                      "id":108821,
                      "inspection_id":102655027,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"IMMERSE UTENSILS IN CHLORINE SOLUTION OF LESS THAN 100 P.P.M. OF AVAILABLE CHLORINE O. REG  562/90 SEC. 75(1)(B)",
                      "id":108822,
                      "inspection_id":102655027,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to provide separate handwashing sink(s)",
                      "id":108825,
                      "inspection_id":102655027,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to provide required supplies at sinks",
                      "id":108827,
                      "inspection_id":102655027,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to provide proper garbage containers",
                      "id":108823,
                      "inspection_id":102655027,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to properly maintain equipment(NON-FOOD)",
                      "id":108826,
                      "inspection_id":102655027,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to properly wash equipment",
                      "id":108824,
                      "inspection_id":102655027,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:31:50Z"
                   }
                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102655028,
                "status":"Pass",
                "date":"2011-12-20",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102732602,
                "status":"Pass",
                "date":"2012-04-18",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102785838,
                "status":"Pass",
                "date":"2012-07-27",
                "infractions":[

                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             },
             {
                "id":102854242,
                "status":"Conditional Pass",
                "date":"2012-11-07",
                "infractions":[
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to wash hands when required",
                      "id":108828,
                      "inspection_id":102854242,
                      "severity":"C - Crucial",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:52Z",
                      "details":"Operator fail to provide separate handwashing sink(s)",
                      "id":108887,
                      "inspection_id":102854242,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:52Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to provide easily readable thermometer(s)",
                      "id":108829,
                      "inspection_id":102854242,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:52Z",
                      "details":"Operator fail to use proper procedure(s) to ensure food safety",
                      "id":108886,
                      "inspection_id":102854242,
                      "severity":"S - Significant",
                      "updated_at":"2012-11-19T01:31:52Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:52Z",
                      "details":"Operator fail to properly wash equipment",
                      "id":108885,
                      "inspection_id":102854242,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:31:52Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:50Z",
                      "details":"Operator fail to properly maintain rooms",
                      "id":108830,
                      "inspection_id":102854242,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:31:50Z"
                   },
                   {
                      "action":"Notice to Comply",
                      "amount_fined":0.0,
                      "court_outcome":"",
                      "created_at":"2012-11-19T01:31:52Z",
                      "details":"Food handler fail to wear headgear",
                      "id":108888,
                      "inspection_id":102854242,
                      "severity":"M - Minor",
                      "updated_at":"2012-11-19T01:31:52Z"
                   }
                ],
                "minimum_inspections_per_year":3,
                "establishment_name":"ASTRA FAMOUS DELI",
                "establishment_type":"Food Take Out"
             }
          ]
       }
    }