Dinesafe Toronto API
====================

NOTE: This is the old `README`, and some parts may no longer apply.

Setup
-----

Setup `GOOGLE_MAPS_BROWSER_API_KEY` if needed (only required for displaying
app pages on Dinesafe site, not API).

Create `.env.development.local` file. Add: 

```
GOOGLE_MAPS_BROWSER_API_KEY=<your_api_key>
```

Transferring The Database
-------------------------

### Dump Database - Production

Run as `deploy` user.

    pg_dump -U postgres -h localhost dinesafe_production -f ~/db_dumps/dinesafe_production_$(date +%Y-%m-%d).dump --password --format=c

### Download Database - Production

    rsync --partial --progress --rsh=ssh <user>@<hostname>:~/db_dumps/<filename>.dump db/dumps/

### Dump Database

    pg_dump dinesafe_development -f doc/database_dumps/dinesafe_dev_$(date +%Y-%m-%d).dump --format=c

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

Rake Tasks
----------

**Run this to update all Dinesafe data:**

    rake dinesafe:update_data_new

Toronto Open Data
-----------------

[View data on Toronto Open Data](https://open.toronto.ca/dataset/dinesafe/)

For convenience, info from this link has been copied below.

**Refreshed**
Daily

**Format**
XML

**Data Features**


| Column                    | Description                                     |
|---------------------------|-------------------------------------------------|
| _id                       | Unique row identifier for Open Data database    |
| Rec #                     | Unique ID fo ran entire record in this dataset  |
| Establishment ID          | Unique identifier for an establishment          |
| Inspection ID             | Unique ID for an inspection                     |
| Establishment Name        | Business name of the establishment              |
| Establishment Type        | Establishment type ie restaurant, mobile cart   |
| Establishment Address     | Municipal address of the establishment          |
| Establishment Status      | Pass, Conditional Pass, Closed                  |
| Min. Inspections Per Year | Every eating and drinking establishment in the City of Toronto receives a minimum of 1, 2, or 3 inspections each year depending on the specific type of establishment, the food preparation processes, volume and type of food served and other related criteria. Low risk premises that offer for sale only pre-packaged non-hazardous food shall be inspected once every two years. The inspection frequency for these low risk premises is shown as "O" (Other) on the report and in the data set |
| Infraction Details        | Description of the Infraction                   |
| Inspection Date           | Calendar date the inspection was conducted      |
| Severity                  | Level of the infraction, i.e. S - Significant, M - Minor, C - Crucial |
| Action                    | Enforcement activity based on the infractions noted during a food safety inspection |
| Outcome                   | The registered court decision resulting from the issuance of a ticket or summons for outstanding infractions to the Health Protection and Promotion Act |
| Amount Fined              | Fine determined in a court outcome              |
| Latitude                  | Latitude of establishment                       |
| Longitude                 | Longitude of establishment                      |


**Website**
http://www.toronto.ca/fooddisclosure

**Contact**
Toronto Public Health
PublicHealth@toronto.ca


**Data**
DineSafe
