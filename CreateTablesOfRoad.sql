#建公路相关数据表
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

USE road CREATE TABLE IF NOT EXISTS TF (
  桩号 VARCHAR (30) PRIMARY KEY,
  挖方面积 FLOAT,
  填方面积 FLOAT,
  中桩填挖 FLOAT,
  路基左宽 FLOAT,
  路基右宽 FLOAT,
  基缘左高 FLOAT,`road`
  基缘右高 FLOAT,
  左坡脚距 FLOAT,
  右坡脚距 FLOAT,
  左坡脚高 FLOAT,
  右坡脚高 FLOAT,
  左沟缘距 FLOAT,
  右沟缘距 FLOAT,
  左护坡道宽 FLOAT,
  右护坡道宽 FLOAT,
  左沟底高 FLOAT,
  右沟底高 FLOAT,
  左沟心距 FLOAT,
  右沟心距 FLOAT,
  左沟深度 FLOAT,
  右沟深度 FLOAT,
  左用地宽 FLOAT,
  右用地宽 FLOAT,
  清表面积 FLOAT,
  顶超面积 FLOAT,
  左超面积 FLOAT,
  右超面积 FLOAT,
  计排水沟 FLOAT,
  左沟面积填 FLOAT,
  左沟面积挖 FLOAT,
  右沟面积填 FLOAT,
  右沟面积挖 FLOAT,
  路槽面积填 FLOAT,
  路槽面积挖 FLOAT,
  清表宽度 FLOAT,
  清表厚度 FLOAT,
  挖1类面积 FLOAT,
  挖2类面积 FLOAT,
  挖3类面积 FLOAT,
  挖4类面积 FLOAT,
  挖5类面积 FLOAT,
  挖6类面积 FLOAT,
  左路槽 B FLOAT,
  右路槽 B FLOAT,
  左路槽 C FLOAT,
  右路槽 C FLOAT,
  左垫层 FLOAT,
  右垫层 FLOAT,
  左路床 FLOAT,
  右路床 FLOAT,
  左土肩培土 FLOAT,
  右土肩培土 FLOAT,
  左包边土 FLOAT,
  右包边土 FLOAT,
  左边沟回填 FLOAT,
  右边沟回填 FLOAT,
  左截沟填 FLOAT,
  左截沟挖 FLOAT,
  右截沟填 FLOAT,
  右截沟挖 FLOAT,
  挖台阶面积 FLOAT
) ;

CREATE TABLE IF NOT EXISTS LJ(
	桩号	VARCHAR(30) PRIMARY KEY,
	地面标高	FLOAT,
	设计标高	FLOAT,
	左侧土路肩宽度	FLOAT,
	左侧硬路肩宽度	FLOAT,
	左侧路面宽度	FLOAT,
	左半幅中分带宽度	FLOAT,
	右半幅中分带宽度	FLOAT,
	右侧路面宽度	FLOAT,
	右侧硬路肩宽度	FLOAT,
	右侧土路肩宽度	FLOAT,
	左侧土路肩高差	FLOAT,
	左侧硬路肩高差	FLOAT,
	左侧路面高差	FLOAT,
	左半幅中分带高差	FLOAT,
	中心设计高差	FLOAT,
	右半幅中分带高差	FLOAT,
	右侧路面高差	FLOAT,
	右侧硬路肩高差	FLOAT,
	右侧土路肩高差	FLOAT
);
#------------------------------------------HDM_BEGIN------------------------------------------
#step1存储过程
DROP PROCEDURE IF EXISTS test;
#step2为HDM表循环添加字段
#参数insertcount设定HDM中的最大列数
DELIMITER $
CREATE PROCEDURE test(IN insertcount INT,IN tablename VARCHAR(30),OUT b VARCHAR(20))
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i<insertcount DO
		SET @s=CONCAT('h',i);#自定义字段名
		SET @strsql=CONCAT('ALTER TABLE ', tablename,' ADD COLUMN ',@s,' FLOAT');#mysql不允百许变量直接作为字段名或表度名进行查询
		PREPARE stmt1 FROM @strsql;
		EXECUTE stmt1;
		SET i=i+1;
	END WHILE;
	SELECT @s INTO b;
END $

#step1向HDM表中添加数据
#前提要建好test存储过程 
DROP TABLE IF EXISTS HDM;
CREATE TABLE IF NOT EXISTS HDM(
	桩号	VARCHAR(30) 
);
CALL test(999,'HDM',@c);
#step2向HDM表中添加数据
LOAD DATA LOCAL INFILE 'E:/A/A.HDM' INTO TABLE HDM;
#FIELDS TERMINATED BY ','
#LINES TERMINATED BY '\r\n';
#step3 删除空行
DELETE FROM HDM
WHERE LENGTH(TRIM(桩号))=1;
#------------------------------------------HDM_END-----------------------------------------

#------------------------------------------3DR_BEGIN-----------------------------------------
#step1向3DR表中添加数据,类似于向HDM中添加数据
#前提要建好test存储过程 
DROP TABLE IF EXISTS 3DR;
CREATE TABLE IF NOT EXISTS 3DR(
	桩号	VARCHAR(30) 
);
CALL test(299,'3dr',@c);
#step2向3DR表中添加数据
LOAD DATA LOCAL INFILE 'E:/A/A.3DR ' INTO TABLE 3DR;
#FIELDS TERMINATED BY ','
#LINES TERMINATED BY '\r\n';
#step3 删除空行

DELETE FROM 3DR
WHERE LENGTH(TRIM(桩号))=1;
#------------------------------------------3DR_END-----------------------------------------
SELECT 桩号,h1 FROM `hdm`
WHERE LENGTH(桩号)=1;
WHERE LENGTH(TRIM(桩号))=1;
LIMIT 5;



TRUNCATE TABLE hdm;

