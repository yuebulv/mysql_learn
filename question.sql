#------------------------------------------PRJ_BEGIN------------------------------------------
#step1向PRJ表中添加数据
#求解决导入数据文字乱码
DROP TABLE IF EXISTS PRJ;
CREATE TABLE IF NOT EXISTS PRJ(
	KEY_PRJ	VARCHAR(50) ,
	VALUE_PRJ  VARCHAR(50) 
);

LOAD DATA LOCAL INFILE 'E:/A/A(S103)2020.3.8.Prj' INTO TABLE PRJ
FIELDS TERMINATED BY '=';
LINES TERMINATED BY '\r\n';
SELECT * FROM PRJ;
#------------------------------------------PRJ_BEGIN------------------------------------------
;

DELETE 
FROM 3dr
WHERE
	3dr.桩号 IN(
		SELECT 
			*
		FROM 
			（
				SELECT
					a.桩号
				FROM
					3dr a
				
				WHERE 
					LENGTH(TRIM(a.桩号))<2
				HAVING 
					a.桩号<=0
			）ee
	);


