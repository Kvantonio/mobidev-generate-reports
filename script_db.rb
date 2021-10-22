require 'pg'

conn = PG::Connection.open(dbname:'Test_base', password:"12345678")

res  = conn.exec('CREATE TABLE Test(
                        column1 int,
                        column2 int,
                        column3 int,
                        column4 int,
                        column5 int
                        );')

res  = conn.exec('ALTER TABLE Test DROP COLUMN column5;')
res  = conn.exec('ALTER TABLE Test ADD COLUMN column6 VARCHAR(256);')

res  = conn.exec('drop table Test')