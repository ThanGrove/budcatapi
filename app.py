from flask import Flask, Response, redirect

# import json

app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello Brilliant World!"


@app.route('/xmltest/<nm>')
def xmlpathfile(nm):

    with open('static/xml/{}.xml'.format(nm), 'r') as fin:
        rawxml = fin.read().encode('utf8')
        return Response(rawxml, mimetype='text/xml')


@app.route('/xmltest/<coll>/<ed>/<tnum>')
def xmlpathcolled(coll, ed, tnum):
    clean_path(coll, ed, tnum)
    edstr = '' if ed == 'main' else '-{}'.format(ed)
    filenm = '{}{}-{}-bib.xml'.format(coll, edstr, tnum)
    with open('static/xml/{}'.format(filenm), 'r') as fin:
        rawxml = fin.read().encode('utf8')
        return Response(rawxml, mimetype='text/xml')


def clean_path(c, e, tn):
    if c != c.lower() or e != e.lower or len(tn) != 4:
        c = c.lower()
        e = e.lower()
        tn = tn.zfill(4)
        redirect('/xmltest/{}/{}/{}'.format(c, e, tn), code=301)


if __name__ == '__main__':
    app.run()