from setuptools import setup, find_packages

requires = [
    'flask',
    'flask-sqlalchemy',
    'psycopg2',
]

setup(
    name='Catalog API',
    version='0.0',
    description='',
    author='Than Grove',
    author_email='',
    keywords='buddhist texts catalog xml',
    packages=find_packages(),
    include_package_data=True,
    install_requires=requires
)
