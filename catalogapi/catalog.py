from flask import Blueprint, Response

catalog = Blueprint('catalog', __name__, url_prefix='/catalog', template_folder='templates')

@catalog.route('/')
