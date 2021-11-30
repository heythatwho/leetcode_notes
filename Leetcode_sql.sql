
#181. Employees Earning More Than Their Managers
#Write an SQL query to find the employees who earn more than their managers. in the same table
select 
em.name as employee
from employee em, employee mg #try not to use join for memory saving
where mg.id = em.managerid #Tricky part here, em.managerid instead of em.id
and mg.salary < em.salary;

#1587. Bank Account Summary II
#Write an SQL query to report the name and balance of users with a balance higher than 10000. The balance of an account is equal to the sum of the amounts of all transactions involving that account.
select
u.name as NAME,
sum(t.amount) as BALANCE #point her is to sum instead of individucal transactions
from users u, transactions t
where u.account = t.account 
group by 1
having sum(t.amount)  > 10000;

#182. Duplicate Emails
#Write an SQL query to report all the duplicate emails. test of aggregation
select 
email
from Person
group by email
having count(id) > 1;

#1407. Top Travellers
#Write an SQL query to report the distance traveled by each user.
select
name,
coalesce(sum(distance), 0) as travelled_distance
from users u
left join rides r #left join is the key here for someone with 0 distance
on u.id = r.user_id
group by 1 
order by 2 desc, 1

#1789. Primary Department for Each Employee
# Write your MySQL query statement below
select
employee_id, department_id
from employee
#where primary_flag='N'  #key issue failed to filter out duplicate employee_id
group by 1
having count(department_id) =1 and count(employee_id)=1
union
select 
employee_id, department_id
from employee
where primary_flag='Y'

#1280. Students and Examinations
select
st.student_id,
st.student_name,
sj.subject_name,
coalesce(count(xm.subject_name), 0) as attended_exams
from students st
cross join subjects sj #cross join is the key to generate a paired combination of each row of the first table with each row of the second table.
left join examinations xm
on st.student_id = xm.student_id and sj.subject_name=xm.subject_name
group by 1,2,3
order by 1,3;

#183. Customers Who Never Order
# Write your MySQL query statement below
select 
    c.name as Customers
from customers c
where c.id not in (select customerid from orders);


#196. Delete Duplicate Emails
#fing the id with duplicate email
delete from person where id not in
(select id from (select min(p1.id) id, p1.email
from person p1, person p2 
where p1.email = p2.email 
group by 2) min_id) #using subquery to find the email with smallest Ids, for whatever id not in the list should be deleted


#197. Rising Temperature
select td.id
from weather td, weather pd
where datediff(td.recordDate, pd.recordDate) =1 #date calculations are the key
    and td.temperature > pd.temperature