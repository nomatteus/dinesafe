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

iOS
---

 - Plan out data models

General
-------