# Buddhist Catalog API

A flask-built web service to provide an API to deliver content from a catalog of Buddhist texts and texts themselves 
to a SPA built in a JS Framework that allows users to browse the catalog, view the texts, and search both.

To run, do from terminal:

```
. venv/bin/activate
export FLASK_APP=.
export FLASK_ENV=development
flask run
```

or run ./scripts/start.sh

# Notes

(2020-08-28) Had to demote Werkzeug to version 0.16.1 because 1.0.x broke flask_restplus but if we need the more 
up-to-date version of Werkzeug, could use a different API helper module.



Author: Than Grove
Date Started: August 2020