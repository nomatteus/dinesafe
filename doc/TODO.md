TODO
====

Rails App
---------

 - Move bulk of Rake task code to its own Class/methods, so they are easier to 
 test. Keep the rake tasks lean from now on. (Only instantiating classes and
 invoking methods.)
 - Improve geocoding process. Store geocoding results in separate table, so I
 can check to see if we have a geocoded result for an address before sending
 it to Google. (Not a high priority though.)
 - Improve rake tasks
    - Move geocoding code to Geocode model, then call that from the rake tasks
    - Then, possibly move the Dinesafe XML import to its own class as well.
    - Then, change the code so everything is done in one task (update dinesafe
    establishments/etc., then lookup geocode in database and query google if
    needed). This will the the task that runs as a cron job, every 2 weeks or
    whenever updated.


iOS
---

 - Plan out data models

General
-------