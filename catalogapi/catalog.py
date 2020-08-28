from flask import Blueprint, Response, Markup, render_template, jsonify
from flask_restplus import Resource, Api
import subprocess
import json

catbp = Blueprint('catalog', __name__, url_prefix='/catalog', template_folder='templates')
api = Api(catbp)


@catbp.route('/')
def catindex():
    mytitle = "Catalog API Index"
    head = "Catalog Section"
    msg = Markup("<p>The catalog section has APIs relating to catalog records.</p>")
    return render_template('index.html', title=mytitle, header=head, text=msg)


@api.route('/bibltest')
class BiblTest(Resource):
    def get(self):
        return {'title': 'A bibl worthy', 'props': ['bold', 'exiciting', 'caring'], 'self': str(self)}


@api.route('/bibl/<string:cat>/<int:tnum>')
class BiblNoEd(Resource):
    def get(self, cat, tnum):
        return {
            'title': 'A bibl worthy',
            'cat': cat,
            'tnum': tnum,
        }


@api.route('/bibl/<string:cat>/<string:ed>/<int:tnum>')
class BiblEd(Resource):
    def get(self, cat, ed, tnum):
        filename = "{}-{}-{}-bib".format(cat, ed, tnum)
        cmdstr = 'java -cp lib/saxon-he-10.2.jar net.sf.saxon.Transform -t ' \
                 '-s:xml/{}.xml -xsl:xsl/bibl-summary.xsl'.format(filename)
        # cmdstr = 'pwd'
        cmd = cmdstr.split(' ')
        result = subprocess.run(cmd, capture_output=True, encoding='utf8')
        # return Response(result.stdout)
        biblsum = json.loads(result.stdout)
        # print(result.stdout)
        return biblsum


