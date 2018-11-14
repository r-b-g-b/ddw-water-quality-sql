"""
Requires dataset: https://dataset.readthedocs.io/
"""
import dataset
from dbfread import DBF

# Change to "dataset.connect('people.sqlite')" if you want a file.
db = dataset.connect('mysql://root:my-secret-pw@172.17.0.3/edt')

table = db['chemical']

path = '/home/robert/data/ca-water-challenge/edt-library/chemical.dbf'

for record in DBF(path, lowernames=True):
    table.insert(record)
