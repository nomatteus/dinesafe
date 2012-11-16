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
* `name` (string): The establishment's name.
* `est_type` (string): The establishment's type (see Appendix A).
* `address` (string): The street address of the establishment. (All addresses
are presumed to be in Toronto.)
* `postal_code` (string): The postal code of the establishment.
* `latlng` (string): comma-separated lat and lng values

Query for establishments by calling the url:

    http://dinesafe.to/api/1.0/establishments.json

Parameters:

* `page`: Page Number. Use for pagination (default: 1)
* `near`: Lat Long pair, separated by comma. Proximity search.
* `search`: String. Text search of establishment name.

Parameters can be combined, i.e. `near` and `search` will return search results
for `search`, ordered by proximity to `near`.

Inspections
-----------

...TODO...


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

