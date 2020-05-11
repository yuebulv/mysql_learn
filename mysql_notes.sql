#模糊查询
/*
like
	特点：一般和通配符搭配使用
		通配符：
		% 任意多个字符，包含0个字符
		_ 任意单个字符	
between A and B
	B要大于等于A，否刚查不到数据
	
in 
	in 里面不支持通配符
is null|is not null
*/
SELECT * FROM myemployees 
WHERE last_name LIKE '_\_%';#查找第二个字符为_的姓名，\为转义字符
#where last_name like '_$_%' escape '$'; 和上一句等价，escape定义一个转义字符

#一、字符函数
#1.length
SELECT LENGTH('张ab');#UTF8一个汉字三个字节
#2.concat 拼接字符
#3.upper、lower 大小写转换
#4.substr/substring 截取字符
#5.instr 返回子串在字符中的位置，如果找不到返回0
#6.trim 去除字符前后指定字符，默认值是空格
	SELECT LENGTH(TRIM('   张   山  ')) AS output;
	SELECT TRIM('aa' FROM 'aaa张aa山aaa') AS out_put;
#7.lpad/rpad 用指定字符实现左/右填充指定长度
#8.replace 替换

#二流程控制函数
SELECT salary 原工资，department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
ELSE salary
END AS 新
FROM employees;

SELECT salary,
CASE
WHEN salary>20000 THEN 'A'
ELSE 'D'
END AS 新
FROM employees;

#用户变量
#声明并初始化
SET @name='john';
SELECT @name=100;

#赋值
#select 字段 into 变量名
#from 表；

#查看
#select @用户变量名;

#2、局部变量
/*
	作用域：仅仅在定义它的begin end 中有效
	放在begin end 中第一句话
*/
#1）声明
DECLARE 变量名 类型;
DECLARE 变量名 类型 DEFAULT 值;
#2) 赋值
方式一：
	SET 局部变量名=值
	SET 局部变量名:=值
	SELECT @局部变量名:=值;
方式二
	SELECT 字段 INTO 局部变量名
	FROM 表;
#3）使用
	SELECT 局部变量名;
	
#存储过程
#1空参列表
#案例:添加数据
DELIMITER $
CREATE PROCEDURE mypy()
BEGIN
	INSERT INTO admin(username,PASSWORD)
	VALUES('jo','000'),('rose','000');
END $

CALL mypy()
SELECT * FROM admin;



CREATE PROCEDURE test(IN username VARCHAR(20),IN loginpwd VARCHAR(20))
BEGIN
	INSERT INTO admin(admin.username,PASSWORD)
	VALUES(username,loginpwd);
END $
CALL test('admin','000')
#2带In的存储过程
#案例：查询输入的账号，密码是否在数据库中
DELIMITER $
CREATE PROCEDURE myp4(IN username VARCHAR(20),IN PASSWORD VARCHAR(20))
BEGIN
	DECLARE result INT DEFAULT 0;#声明并初始化
	SELECT COUNT(*) INTO result
	FROM admin
	WHERE admin.username=username
	AND admin.password=PASSWORD;
	SELECT IF(result>0,'成功','失败');
END $

CALL myp4('张飞','8888')
#3带out的存储过程
#案例：输入女神名，输出女神对应的男神名及魅力值
DELIMITER $
CREATE PROCEDURE myp5(IN beautyname VARCHAR(20),OUT boyname VARCHAR(20),OUT usercp INT)
BEGIN
	SELECT bo.boyname,bo.usercp INTO boyname,usercp
	FROM boys bo
	INNER JOIN beauty b ON bo.id=b.boyfriend_id
	WHERE b.name=beautyname;
END $

CALL myp5('小昭',@bname,@usercp);
	
SELECT @bname,@usercp;
#4.创建带inout模式参数的存储过程
#案例：传入a/b两个值，最终a/b都翻倍并返回
DELIMITER $
CREATE PROCEDURE myp8(INOUT a INT,INOUT b INT)
BEGIN
	SET a=a*2;
	SET b=b*2;
END $
SET @m=10;
SET @n=20;
CALL myp8(@m,@n);
SELECT @m,@n
#二、删除存储过程
#语法：drop procedure 存储过程名
DROP PROCEDURE myp4;
#函数
/*
函数与存储过程的区别
存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
函数：有且仅有1个返回，适合做处理数据后返回一个结果
*/
#一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN
	函数体
END
/*
注意：
1.参数列表包含两部分：参数名和参数类型
2.函数体肯定会有return语句
3.函数体中仅有一句话，则可以省略begin end
4.使用delimiter语句设置结束标记
*/
#二、调用函数
SELECT 函数名（函数列表）


#1.无参有返回（略）
#1.有参有返回
#案例2：根据部门名，返回该部门的平均工资
USE myemployees
DELIMITER $
CREATE FUNCTION myf2(deptname VARCHAR(20)) RETURNS DOUBLE #注意这里是returns 复数，函数最后面是return单数
BEGIN
	DECLARE sal DOUBLE;#这是也可以定义用户变量
	SELECT AVG(salary) INTO sal
	FROM employees e
	JOIN departments d ON e.department_id=d.department_id
	WHERE d.department_name=deptname;
	RETURN sal;
END $	`myemployees`

SELECT myf2('IT')$

DROP FUNCTION MYF3;




SELECT * FROM `employees`;
DESC `departments`;

SELECT IFNULL(`commission_pct`,0) AS 奖金率,
	commission_pct
FROM 
	`employees`;
#分组查询
/*
语法：
	select 分组函数，列（要求出现在group by的后面）
	from 表
	【where 筛选条件】
	group by 分组的列表
	【order by 子名】
注意：
	查询列表必须特殊，要求是分组函数和group by后出现的字段
特点：
1、和分组函数一同查询的字段必须是group by后出现的字段
2、筛选分为两类：分组前筛选和分组后筛选
		针对的表			位置		连接的关键字
分组前筛选	原始表				group by前	where
	
分组后筛选	group by后的结果集    		group by后	having

问题1：分组函数做筛选能不能放在where后面
答：不能

问题2：where——group by——having

一般来讲，能用分组前筛选的，尽量使用分组前筛选，提高效率

3、分组可以按单个字段也可以按多个字段
4、可以搭配着排序使用
*/
SELECT MAX(salary) AS 最高工资,job_id
FROM employees
GROUP BY job_id
ORDER BY 最高工资 DESC;	

SELECT MIN(salary),`manager_id`
FROM `employees`
WHERE `manager_id`>102
GROUP BY `manager_id`
HAVING MIN(salary) >5000;

#进阶6：连接查询
/*
含义：又称多表查询，当查询的字段来自于多个表时，就会用到连接查询

笛卡尔乘积现象：表1 有m行，表2有n行，结果=m*n行

发生原因：没有有效的连接条件
如何避免：添加有效的连接条件

分类：

	按年代分类：
	sql92标准:仅仅支持内连接
	sql99标准【推荐】：支持内连接+外连接（左外和右外）+交叉连接
	
	按功能分类：
		内连接：
			等值连接
			非等值连接
			自连接
		外连接：
			左外连接
			右外连接
			全外连接
		
		交叉连接
*/
SELECT LAST_NAME,`department_name`
FROM `employees`,`departments`
WHERE employees.`department_id`=departments.`department_id`
#2、为表起别名
/*
①提高语句的简洁度
②区分多个重名的字段
注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定
*/
SELECT salary,`department_id`,`job_id`
FROM `employees`
WHERE `department_id`=90
AND `job_id` LIKE 'AD_VP';

#案例：查询每个工种的工种名和员工的个数，并且按员工个数降序

SELECT job_title,COUNT(*)
FROM employees e,jobs j
WHERE e.`job_id`=j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;

#7、可以实现三表连接？

#案例：查询员工名、部门名和所在的城市
SELECT last_name,department_name,city
FROM employees e,departments d,locations l
WHERE e.`department_id`=d.`department_id`
AND d.`location_id`=l.`location_id`
AND city LIKE 's%'

ORDER BY department_name DESC;

#2、非等值连接


#案例1：查询员工的工资和工资级别


SELECT salary,grade_level
FROM employees e,job_grades g
WHERE salary BETWEEN g.`lowest_sal` AND g.`highest_sal`
AND g.`grade_level`='A';

#sql查询语句的定义顺序
/*
select distinct 查询列表
from 表名 别名
join 表名 别名
on 连接条件
where 筛选条件
group by 分组列表
having 分组后筛选
order by 排序列表
limit 条目数；
	
*/


#函数
/*
	count
	
*/



#DDL 数据定义语言：

#---------------------------------库的管理---------------------------------
#一、创建数据库
	CREATE DATABASE studb;
	CREATE DATABASE IF NOT EXISTS studb;
#二、删除数据库
	DELETE DATABASE studb;
	DELETE DATABASE IF EXISTS studb;

#---------------------------------表的管理---------------------------------	
#一、创建表
	CREATE TABLE IF NOT EXISTS 表名（
		字段名 字段类型 【字段约束】,
		字段名 字段类型 【字段约束】
	）;
	#一）数据类型
	/*
		1.int
		2.double/float,例double(5,2),表示最多5位，必须有2位小数；
		3.decimal:浮点型，表示钱方面使用该类型，因为不会出现精度缺失；
		4.char:固定长度字符类型，char(r);默认1个字符
		5.varchar:可变长度字符类型；
		6.text:较长文本字符串类型；
		7.date
		8.time
		9.timestamp/datetime
		10.blob二进制类型
		
	*/
	#二）常见约束
	/*
		not null
		default	默认`department_name``department_id`
		primary key 主键
		unique 唯一
		check 用于限制该字段值必须满足指定条件，mysql不支持，也不报错
		foreign key 外键，用于限制两个表的关系，要求外键的值必须来自主表的关联列
			要求：
				1.主表的关联列必须是主键
				2.主表的关联列和从表的关联列类型一致，名称无要求
	*/
	DROP TABLE IF EXISTS major;
	CREATE TABLE IF NOT EXISTS stuinfo(
		stuid INT PRIMARY KEY,
		stuname VARCHAR(20) UNIQUE NOT NULL,#唯一+非空约束
		stugender CHAR(1) DEFAULT '男' ,#默认值
		email VARCHAR(20) NOT NULL,
		majorid INT,
		CONSTRAINT fk_stuninfo_major FOREIGN KEY (majorid) REFERENCES major(id) #添加了外键，放到最后
	);
	SELECT * FROM major;

#二、修改表
语法：ALTER TABLE 表名 ADD|MODIFY|CHANGE|DROP COLUMN 字段名 字段类型 【字段约束】；
	#1.修改表名
	ALTER TABLE stuinfo RENAME TO students;
	#2.添加字段
	ALTER TABLE students ADD COLUMN borndate TIMESTAMP NOT NULL;
	#3.修改字段名
	ALTER TABLE students CHANGE COLUMN borndate birthday datatime NULL;
	#4.修改字段类型
	ALTER TABLE students MODIFY COLUMN birthday TIMESTAMP;
	#5.删除字段
	ALTER TABLE students DROP COLUMN birthday;
	#6.删除表
	DROP TABLE IF EXISTS major;
	#7.复制表的结构
	CREATE TABLE newtable2 LIKE major;
	#8.复制表结构+数据
	CREATE TABLE newtable3 SELECT * FROM girls.`beauty`;
	
	
	

#三、创建表
#一、创建表


#DML 数据操纵语言：insert update delete
#一、数据插入
/*
插入多行
语法：
	insert into 表名（字段名1，字段名3，......） 
	values (值1，值2，.....),(值1，值2，.....),(值1，值2，.....);
特点：
	字段顺序无要求
	空值可用 NULL代替，或者删除对应字段
	默认值可用 default 代替，或者字段名和值都不写
	可以省略字段名，及插入所有字段值
	#1 自增长列
		1.自增长列必须设置在一个键上，比如主键或唯一键
		2.自增长列要求数据类型为数值型
		3.一个表至多有一个自增长列；
		4.自增长列的值用null代替时，其值会用null代替
*/
#三、数据删除
/*

语法：
	1：delete #删除整行
		delete from 表名 [where 筛选条件]；
	2:truncate  #删除所有信息
			truncate table 表名；
	二者区别：
		1.delete 按条件删除，效率低，自增长列新数据从断点开始，会返回受影响行数，支持事务
		2.truncate 删除整个表然后新建一个同样结构表，效率高，自增长列新数据从1开始，不会返回受影响行数，不支持事务
特点：

*/

