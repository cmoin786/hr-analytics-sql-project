create database employees_db;


create table departments(
DepartmentID varchar(20) primary key,
DepartmentName varchar(20),
Location varchar(20)
);



create table employees(

EmployeeID varchar(20) primary key,
EmployeeName varchar(20),
Gender varchar(20),
Age int,
DepartmentID varchar(20),
JobTitle varchar(20),
Salary int,
HireDate date,
City varchar(20),
FOREIGN key (DepartmentID) REFERENCES departments (DepartmentID)
);


create table attendance(

AttendanceID varchar(20) primary key,
EmployeeID varchar(20),
AttendanceDate date,
Status varchar(20),
WorkingHours int,
foreign key (EmployeeID) REFERENCES employees(EmployeeID)
);


drop table attendance;

create table projects(
ProjectID varchar(20) primary key,
ProjectName varchar(20),
DepartmentID varchar(20),
Budget int,
StartDate date,
foreign key (DepartmentID) REFERENCES departments(DepartmentID)
);



create table emp_project(
EmployeeID  varchar(20),
ProjectID  varchar(20),
HoursWorked int,
foreign key (EmployeeID) REFERENCES employees (EmployeeID),
foreign key (projectid) REFERENCES projects(projectid)
);

copy departments
from 'C:\data analyst\sql\employees database project sql\departments.csv'
delimiter ','
csv header;



copy employees
from 'C:\data analyst\sql\employees database project sql\employees3.csv'
delimiter ','
csv header;


copy attendance
from 'C:\data analyst\sql\employees database project sql\attendances.csv'
delimiter ','
csv header;


copy projects
from 'C:\data analyst\sql\employees database project sql\projects.csv'
delimiter ','
csv header;


copy emp_project
from 'C:\data analyst\sql\employees database project sql\employees projects.csv'
delimiter ','
csv header;


-- Show all employees.

select employeeid, EmployeeName from employees;


-- Show employee names and salaries.

select EmployeeName, salary from employees

-- Find employees from Delhi.

select employeeid, employeename, city from employees where city = 'Delhi';


-- Show employees whose salary is greater than 50000.

select employeeid, employeename, salary from employees where salary > 50000;

-- Find female employees.

select employeeid, employeename, gender from employees where lower(gender) = 'female'


-- Show employees hired after 2022.

select employeeid, employeename, hiredate from employees where hiredate > '2022-01-01';

-- Find employees between age 25 and 30.

select employeeid, employeename,age from employees where age between 25 and 30;

-- Show employees sorted by salary descending.

select employeeid, employeename, salary from employees
order by salary desc;

-- Count total employees.

select count(employeeid) as total_employee from employees

-- Find average salary.

select round(avg(salary)::numeric,2) as avg_salary from employees;




-- Find highest salary employee.

select employeeid, employeename, salary from employees
order by salary desc
limit 5;

-- Find lowest salary employee.


select employeeid, employeename, salary from employees
order by salary asc
limit 5;

-- Department-wise average salary.

select departmentname, round(avg(salary)::numeric,2) as avg_salary from employees as e
join departments as d
on e.departmentid = d.departmentid
group by departmentname;

-- Count employees in each department.

select d.departmentid, departmentname, count(employeeid) as total_employee from employees as e
join departments as d 
on e.departmentid = d.departmentid
group by d.departmentid, departmentname
order by total_employee desc;


-- Find total working hours by employee.

select e.employeeid, employeename, sum(HoursWorked) as total_working_hours from employees as e
join emp_project as ep
on e.employeeid = ep.employeeid
group by e.employeeid, employeename;

-- Show employees working more than 8 hours.

select e.employeeid, employeename, workinghours from employees as e
join  attendance as a 
on e.employeeid = a.employeeid
where workinghours > 8 ;

-- Find employees whose names start with 'A'.

select * from employees where employeename like 'A%'

-- Show top 3 highest salaries.

select employeeid, employeename, salary from employees
order by salary desc
limit 3;


-- Find second highest salary.

select * from employees
order by salary desc
limit 1
offset 1


-- Calculate annual salary.

select employeeid, employeename, salary, salary*12 as annual_salary from employees






-- Show employee names with department names.

select employeename, departmentname from employees as e
join departments as d
on e.departmentid = d.departmentid;

-- Show employees and project names.

select employeename, projectname from employees as e
join departments as d
on e.departmentid = d.departmentid
join projects as p
on p.departmentid = d.departmentid;

-- Find employees working on AI Chatbot project.

select employeename, projectname from employees as e
join departments as d
on e.departmentid = d.departmentid
join projects as p
on p.departmentid = d.departmentid
where projectname = 'AI Chatbot';

-- Show department location with employee names.

select employeename, Location from employees as e
join departments as d
on e.departmentid = d.departmentid;

-- Find employees without projects.

select * from employees as e
left join projects as p
on p.departmentid = e.departmentid
where projectname isnull;

-- Show project budget with employee names.

select employeename, budget from employees as e
left join projects as p
on p.departmentid = e.departmentid;

-- Find departments with more than 2 employees.

select departmentname, count(employeeid) as total_employee from employees as e
join departments as d
on d.departmentid = e.departmentid
group by  departmentname
having count(employeeid) > 2;

-- Show attendance with employee names.

select employeename,AttendanceID,AttendanceDate,Status,WorkingHours from employees as e
join attendance as a
on e.employeeid = a.employeeid;

-- Find employees absent on 2025-05-01.

select e.employeeid, employeename,Status from employees as e
join attendance as a
on e.employeeid = a.employeeid
where lower(Status) = 'absent';


-- Show project hours worked by each employee.

select e.employeeid,
       e.employeename,
       p.projectname,
       ep.hoursworked
from employees e
join emp_project ep
on e.employeeid = ep.employeeid
join projects p
on ep.projectid = p.projectid;



-- Department-wise employee count.

select departmentname , count(employeeid) as total_employee from employees as e
join departments as d
on d.departmentid = e.departmentid
group by departmentname;


-- City-wise average salary.

select city, round(avg(salary)::numeric,2) as avg_salary from employees as e
join departments as d
on d.departmentid = e.departmentid
group by city;

-- Gender-wise salary total.

select gender, sum(salary) as total_salary from employees
group by gender;

-- Department-wise maximum salary.

select departmentname, max(salary) as max_salary from employees as e
join departments as d
on e.departmentid = d.departmentid
group by departmentname;

-- Find total project budget by department.

select departmentname, budget from departments as d
join projects as p
on d.departmentid = p.departmentid;


-- Count attendance status.

select status, count(employeeid) as total_attendance from attendance
group by status;

-- Find average working hours.

select round(avg(hoursworked)::numeric,2) as avg_working_hours from emp_project;

-- Show departments where average salary > 60000.

select departmentname, round(avg(salary)::numeric,2) as avg_salary from departments as d
join employees as e
on d.departmentid = e.departmentid
group by departmentname
having avg(salary) > 60000;

-- Find cities having more than 2 employees.

select location as city, count(employeeid) as total_employee from employees as e
join departments as d
on d.departmentid = e.departmentid
group by location
having count(employeeid) >2;


-- Department-wise total project hours.

select departmentname, sum(HoursWorked) as total_HoursWorked from employees as e
join departments as d
on e.departmentid = d.departmentid
join emp_project as ep
on ep.employeeid = e.employeeid
group by departmentname;



-- Rank employees by salary.

select employeeid, employeename, salary,
rank() over(order by salary desc) as salry_rank
from employees;


-- Department-wise salary ranking.

select departmentname, salary,
rank()over(partition by departmentname order by salary desc) as salary_rank
from employees as e
join departments as d
on d.departmentid = e.departmentid;



-- Find highest salary in each department.

with high_depart_salary as (
select departmentname, salary,
rank() over(partition by departmentname order by salary desc) as salary_rank
from employees as e
join departments as d
on d.departmentid = e.departmentid)

select * from high_depart_salary where salary_rank = 1;


-- Show previous employee salary using LAG().

select employeename, salary,
lag(salary) over() as previous_emp_salary
from employees


-- Show next employee salary using LEAD().

select employeename, salary,
lead(salary)over() as next_emp_salary
from employees

-- Calculate cumulative salary.

select employeeid,
       employeename,
       salary,
       sum(salary) over(order by employeeid) as cumulative_salary
from employees;

-- Find salary difference from department average.

select employeeid,
       employeename,
       departmentid,
       salary,
       avg(salary) over(partition by departmentid) as dept_avg_salary,
       salary - avg(salary) over(partition by departmentid) as salary_difference
from employees;


-- Divide employees into salary quartiles.

select employeename,salary,
ntile(4) over(order by employeeid) as rk from employees; 


-- Show running total of working hours.

select employeeid,hoursworked,
sum(hoursworked) over(order by employeeid asc) as running_working_hours
from emp_project;

-- Find top 2 salaries in each department.

with top_2 as (
select departmentname, salary,
rank() over(partition by departmentname order by salary desc)
from employees as e
join departments as d
on e.departmentid = d.departmentid )
select * from top_2 where rank <=2 ;




-- Categorize salary:
-- Above 80000 → High
-- 50000–80000 → Medium
-- Below 50000 → Low

select employeeid, employeename, salary,
case
when salary >80000 then 'High'
when salary between 50000 and 80000 then 'Medium'
else 'Low'
end as Categorize_salary
from employees;


-- Attendance status meaning:

-- Present → Working
-- Leave → On Leave
-- Absent → Not Working


select attendanceid, employeeid, status,
case
when status ='Present' then 'working'
when status = 'Leave' then 'on leave'
else 'not working'
end as status_meaning
from attendance;


-- Bonus calculation:

-- IT → 20%
-- Sales → 15%
-- Others → 10%


select departmentid, departmentname,
case 
when departmentname = 'IT' then 20
when departmentname = 'Sales' then 15
else 10
end as bonus_
from departments ;



-- Find employees earning more than department average.

select *
from employees e
where salary > (
    select avg(salary)
    from employees
    where departmentid = e.departmentid
);

-- Find duplicate cities.

select city, count(employeeid) as total_city from employees
group by city 
having count(employeeid)  > 1;


-- Find employees working on multiple projects.

select employeeid,employeename, count(projectid) as total_project from employees as e
join projects as p
on p.departmentid = e.departmentid
group by employeeid,employeename 
having count(projectid) > 1


-- Find department with highest average salary.

select departmentname, avg(Salary) as avg_salary from employees as e
join departments as d
on d.departmentid = e.departmentid
group by departmentname
order by avg_salary desc 
limit 1;

-- Monthly hiring trend.

select EXTRACT(month from hiredate) as months, count(employeeid) as total_hire from employees
group by EXTRACT(month from hiredate)
order by months asc;


-- Project-wise total hours worked.

select projectname, sum(hoursworked) as total_hours from projects as p
join emp_project as em
on p.projectid = em.projectid
group by projectname
order by total_hours desc;

-- Find employee contribution percentage in projects.

select ep.employeeid,
       e.employeename,
       ep.projectid,
       p.projectname,
       ep.hoursworked,
       round(
           (ep.hoursworked * 100.0) /
           sum(ep.hoursworked) over(partition by ep.projectid),
           2
       ) as contribution_percentage
from emp_project ep
join employees e
on ep.employeeid = e.employeeid
join projects p
on ep.projectid = p.projectid;


-- Generate attendance performance report.

select e.employeeid , employeename,AttendanceID,AttendanceDate,Status,WorkingHours from employees as e
join attendance as a
on a.employeeid = e.employeeid;


-- Find most active employee.

select e.employeeid, employeename, HoursWorked from employees as e
join emp_project as em
on e.employeeid = em.employeeid
order by HoursWorked desc
limit 1

-- Salary percentage of company total salary.

select employeename,
       salary,
       round(
           (salary * 100.0) / sum(salary) over(),
           2
       ) as salary_percentage
from employees;



