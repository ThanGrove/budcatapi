#!/bin/zsh

. venv/bin/activate
export FLASK_APP=catalogapi
export FLASK_ENV=development
flask run