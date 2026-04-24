-- 50  qustions learning sql...

CREATE DATABASE ORG;
SHOW DATABASES;
USE ORG;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

ALTER TABLE WORKER MODIFY SALARY INT;
TRUNCATE TABLE WORKER;
SELECT * FROM WORKER;


INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');
        

        
CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT,
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
(1, 5000, TIMESTAMP(STR_TO_DATE('16-02-20', '%y-%m-%d'), CURRENT_TIME())),
(2, 3000, TIMESTAMP(STR_TO_DATE('16-06-11', '%y-%m-%d'), CURRENT_TIME())),
(3, 4000, TIMESTAMP(STR_TO_DATE('16-02-20', '%y-%m-%d'), CURRENT_TIME())),
(1, 4500, TIMESTAMP(STR_TO_DATE('16-02-20', '%y-%m-%d'), CURRENT_TIME())),
(2, 3500, TIMESTAMP(STR_TO_DATE('16-06-11', '%y-%m-%d'), CURRENT_TIME()));
        
SELECT * FROM BONUS;
drop TABLE BONUS;


CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');
 
 select* from title;
 
 
 select first_name as worker_name from worker ;
 
 select upper(first_name) as worker_name from worker;
 
 select distinct department from worker;
 
 select substring(first_name,1,3) from worker;
 
select instr(first_name,'b') from worker where first_name = 'Amitabh';

select rtrim(first_name) from worker;
select ltrim(first_name) from worker;

select distinct department,length(department) as length_of_department from worker;

select  replace(first_name,'a','A') from worker;

select concat(first_name," ",last_name) as full_name from worker;

select * from worker ORDER by first_name;

select * from worker order by first_name, department DESC;

select * from worker where first_name IN ('Vipul', 'Satish');

select * from worker where first_name NOT IN ('Vipul', 'Satish');

select * from worker where department LIKE 'Admin%';


select * from worker where first_name LIKE '%a%';

select * from worker where first_name LIKE '%a';

select * from worker where first_name LIKE '_____h';

select * from worker where salary between 100000 AND 500000;

select * from worker where YEAR(joining_date) = 2014 AND MONTH(joining_date) = 02;

select department, count(*) from worker where department = 'Admin';

select concat(first_name, ' ', last_name) as full_name from worker
where salary between 50000 and 100000;

select department, count(worker_id) AS no_of_worker from worker group by department
ORDER BY no_of_worker desc;

select w.* from worker as w inner join title as t on w.worker_id = t.worker_ref_id where t.worker_title = 'Manager';

select worker_title, count(*) as count from title group by worker_title having count > 1;

select * from worker where MOD (WORKER_ID, 2) != 0; 
select * from worker where MOD (WORKER_ID, 2) <> 0; 
select * from worker where MOD (WORKER_ID, 2) = 0;


-- Q-28. Write an SQL query to clone a new table from another table.
CREATE TABLE worker_clone LIKE worker;
INSERT INTO worker_clone select * from worker;
select * from worker_clone;


-- Q-29. Write an SQL query to fetch intersecting records of two tables.
select worker.* from worker inner join worker_clone using(worker_id);

-- Q-30. Write an SQL query to show records from one table that another table does not have.
-- MINUS
select worker.* from worker left join worker_clone using(worker_id) WHERE worker_clone.worker_id is NULL;

-- Q-31. Write an SQL query to show the current date and time.
-- DUAL
select curdate();
select now();

-- Q-32. Write an SQL query to show the top n (say 6) records of a table order by descending salary.
select * from worker order by salary desc LIMIT 6;


-- Q-33. Write an SQL query to determine the nth (say n=5) highest salary from a table.
select distinct salary from worker order by salary desc LIMIT 1 offset 4;
select distinct salary from worker order by salary desc LIMIT 4,1; -- offset 4 skip 4 then return next 1 row


select w.salary from worker w where 4 = (select count(distinct(w2.salary)) from worker w2 where w2.salary > w.salary);

SELECT salary,rnk
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM worker
) t
WHERE rnk = 5;

-- Q-35. Write an SQL query to fetch the list of employees with the same salary.
select w1.* from worker w1, worker w2 where w1.salary = w2.salary and w1.worker_id != w2.worker_id;

	
-- Q-36. Write an SQL query to show the second highest salary from a table using sub-query.
select max(salary) from worker
where salary not in (select max(salary) from worker);

select max(salary) from worker where salary < (select max(salary) from worker);

select distinct(salary) from worker order by salary desc limit 1,1;

select salary from 
	(select distinct salary, dense_rank() over(order by salary desc) as rnk
		FROM worker) w 
where w.rnk = 2;



-- Q-37. Write an SQL query to show one row twice in results from a table.
select * from worker
UNION ALL
select * from worker ORDER BY worker_id;

-- Q-38. Write an SQL query to list worker_id who does not get bonus.
select worker_id from worker where worker_id not in (select worker_ref_id from bonus);

-- Q-39. Write an SQL query to fetch the first 50% records from a table.
select * from worker where worker_id <= ( select count(worker_id)/2 from worker);

-- Q-40. Write an SQL query to fetch the departments that have less than 4 people in it.
select department, count(department) as depCount from worker group by department having depCount < 4;


-- Q-41. Write an SQL query to show all departments along with the number of people in there.
select department, count(department) as depCount from worker group by department;


-- Q-42. Write an SQL query to show the last record from a table.
select * from worker where worker_id = (select max(worker_id) from worker);

-- Q-43. Write an SQL query to fetch the first row of a table.
select * from worker where worker_id = (select min(worker_id) from worker);

-- Q-44. Write an SQL query to fetch the last five records from a table.
(select * from worker order by worker_id desc limit 5) order by worker_id;

-- Q-45. Write an SQL query to print the name of employees having the highest salary in each department.
select w.department, w.first_name, w.salary from
 (select max(salary) as maxsal, department from worker group by department) temp
inner join worker w on temp.department = w.department and temp.maxsal = w.salary;

select department,salary from (
	select * , rank() over(partition by department order by salary desc) as rnk from worker) as t 
where t.rnk = 1;

-- Q-46. Write an SQL query to fetch three max salaries from a table using co-related subquery
select distinct salary from worker w1
where 3 >= (select count(distinct salary) from worker w2 where w1.salary <= w2.salary) order by w1.salary desc;

-- DRY RUN AFTER REVISING THE CORELATED SUBQUERY CONCEPT FROM LEC-9.
select distinct salary from worker order by salary desc limit 3;

-- Q-47. Write an SQL query to fetch three min salaries from a table using co-related subquery
select distinct salary from worker w1
where 3 >= (select count(distinct salary) from worker w2 where w1.salary >= w2.salary) order by w1.salary desc;

-- Q-48. Write an SQL query to fetch nth max salaries from a table.
select distinct salary from worker w1
where n >= (select count(distinct salary) from worker w2 where w1.salary <= w2.salary) order by w1.salary desc;

-- Q-49. Write an SQL query to fetch departments along with the total salaries paid for each of them.
select department , sum(salary) as depSal from worker group by department order by depSal desc;

-- Q-50. Write an SQL query to fetch the names of workers who earn the highest salary.
select first_name, salary from worker where salary = (select max(Salary) from worker);



