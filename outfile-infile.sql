CREATE DATABASE road;
USE road;
SELECT * INTO OUTFILE 'data.txt' FIELDS TERMINATED BY ',' FROM boys;

USE girls

SELECT * FROM hdm
INTO OUTFILE "e:\data.txt"
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA LOCAL INFILE 'E:/data.txt' INTO TABLE boys
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n';

DELETE FROM boys
WHERE id>4;


USE road
DROP TABLE IF EXISTS tf;













