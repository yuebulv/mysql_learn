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

#函数
/*
	count
	
*/



