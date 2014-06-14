Dinesafe Toronto API
====================

[![Code Climate](https://codeclimate.com/github/nomatteus/dinesafe.png)](https://codeclimate.com/github/nomatteus/dinesafe)

see doc/TODO.md for todo items

Setup
-----

Create settings.yml: `cp config/settings.example.yml config/settings.yml`,
and add your own CMS username/password.

Transferring The Database
-------------------------

### Dump Database - Production

Run as `deploy` user.

    pg_dump -U postgres -h localhost dinesafe_production -f ~/db_dumps/dinesafe_production_$(date +%Y-%m-%d).dump --password --format=c

### Download Database - Production

    rsync --partial --progress --rsh=ssh <user>@<hostname>:~/db_dumps/<filename>.dump db/dumps/

### Dump Database

    pg_dump  -U mruten dinesafe_dev -f doc/database_dumps/dinesafe_dev_$(date +%Y-%m-%d).dump --format=c

### Load Database

    pg_restore -d database_name doc/database_dumps/filename.dump

NOTE: On production, make sure to switch to postgres user.

Update Sitemap XML
------------------

It's important to update the sitemap.xml file for SEO purposes.

Run this on server to generate sitemap and ping search engines:

    rake sitemap:refresh

Or, generate sitemap but don't ping search engines: 

    rake sitemap:refresh:no_ping

TODO: Move sitemap updating to a cron job.

Rake Tasks
----------

**Run this to update all Dinesafe data:**

    rake dinesafe:update_data

Or, you can run individual tasks as needed.

Update XML from Toronto Open Data:

    rake dinesafe:update_xml

Import XML to database (will only add/update changed records):

    rake dinesafe:xml_import

Geocode addresses that need it (updates geocodes table):

    rake dinesafe:geocode

Update establishment addresses from geocodes (and create blank Geocodes for unknown addresses):

    rake dinesafe:update_latlngs

Fix typos (based on list of manual fixes in task):

    rake dinesafe:fix_data_typos

The App
-------


Toronto Open Data
-----------------

[View data on toronto.ca/open](http://www1.toronto.ca/wps/portal/open_data/open_data_item_details?vgnextoid=b54a5f9cd70bb210VgnVCM1000003dd60f89RCRD&vgnextchannel=6e886aa8cc819210VgnVCM10000067d60f89RCRD)

For convenience, info from this link has been copied below.

**Owner**  
Public Health - Healthy Environments Program

**Currency**  
Current - updated bi-weekly

**Format**  
XML

**Attributes**  
`ROW_ID` - Represents the Row Number  
`ESTABLISHMENT_ID` – Unique identifier for an establishment  
`INSPECTION_ID` - Unique identifier for each Inspection  
`ESTABLISHMENT_NAME` – Business name of the establishment  
`ESTABLISHMENTTYPE` – Establishment type ie restaurant, mobile cart  
`ESTABLISHMENT_ADDRESS` – Municipal address of the establishment  
`ESTABLISHMENT_STATUS` – Pass, Conditional Pass, Closed  
`MINIMUM_INSPECTIONS_PERYEAR` – Every eating and drinking establishment in the City of Toronto receives a minimum of 1, 2, or 3 inspections each year depending on the specific type of establishment, the food preparation processes, volume and type of food served and other related criteria  
`INFRACTION_DETAILS` – Description of the Infraction  
`INSPECTION_DATE` – Calendar date the inspection was conducted  
`SEVERITY` – Level of the infraction, i.e. S – Significant, M – Minor, C – Crucial  
`ACTION` – Enforcement activity based on the infractions noted during a food safety inspection  
`COURT_OUTCOME` – The registered court decision resulting from the issuance of a ticket or summons for outstanding infractions to the Health Protection and Promotion Act  
`AMOUNT_FINED` – Fine determined in a court outcome  
Comments  
The data set is as current as the date of the extraction. It is not a substitute for the notification and posting requirements of Municipal Code Chapter 545 - Licensing.

**Website**  
http://www.toronto.ca/fooddisclosure

**Contact**  
Open Data Team  
opendata@toronto.ca

**Data**  
DineSafe