import os
import subprocess
from flask import Flask, Response, redirect


def create_app(test_config=None):
    # create and config the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev'
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test cofig if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    @app.route('/')
    def home():
        return redirect('/hello')

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return "Hello, trichiliochosm!"

    @app.route('/configtest')
    def myconfig():
        tvar = app.config['TESTVAR']
        gbvar = app.config['GLOBVAR'] if 'GLOBVAR' in app.config else 'Not found!'
        outhtml = '<div><ul><li>Testvar: {}</li><li>Other: {}</li></ul></div>'.format(tvar, str(gbvar))
        return Response(outhtml)

    @app.route('/xsltest')
    def xlstest():
        cmdstr = 'java -cp lib/saxon-he-10.2.jar net.sf.saxon.Transform -t ' \
                 '-s:xml/kt-c-3002-bib.xml -xsl:xsl/tbib.xsl'
        #         '-o:cache/kt-c-3002-bib.html'
        cmd = cmdstr.split(' ')
        result = subprocess.run(cmd, capture_output=True, encoding='utf8')
        outhtml = '<div><h1>Result</h1><ul>' \
                  '<li><b>Res</b>: ' + str(result.stdout) + '</li>' \
                  '<li><b>Return Code</b>: ' + str(result.returncode) + '</li>' \
                  '<li><b>Err</b>: ' + str(result.stderr) + '</li>' \
                  '</ul></div>'
        return Response(outhtml)

        # cmd = ['pwd']
        # result = subprocess.run(cmd, capture_output=True)
        # print(result)
        # outhtml = '<div><h1>Result</h1><p>cwd = ' + str(result.stdout) + '</p></div>'
        # return Response(outhtml)

    return app

