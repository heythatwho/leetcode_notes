
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
#Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
select td.id
from weather td, weather pd
where datediff(td.recordDate, pd.recordDate) =1 #date calculations are the key
    and td.temperature > pd.temperature


#577. Employee Bonus
#Write an SQL query to report the name and bonus amount of each employee with a bonus less than 1000.
select 
name,
coalesce(bonus, null) as bonus
from employee emp
left join bonus bn #takes each person from the main table
on emp.empID = bn.empID
    where bonus < 1000 or bonus is null; #the tricky part is bonus is null

#1082. Sales Analysis I
#Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.
with total_sales as
(select seller_id,
sum(price) as sales_price
from sales
group by 1) #calculate the sum of sale and then filter to max total

select seller_id
from total_sales
where sales_price in (select max(sales_price) from total_sales)
##############################################alternative
SELECT seller_id
FROM (
    SELECT seller_id, RANK() OVER(ORDER BY SUM(price) DESC) AS rnk
    FROM Sales
    GROUP BY seller_id
) a
WHERE rnk = 1;

#584. Find Customer Referee
# Write an SQL query to report the IDs of the customer that are not referred by the customer with id = 2.
select
name
from customer
where referee_id != 2 or referee_id is null; #null is easy to be ignored


#586. Customer Placing the Largest Number of Orders
# Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.
#The test cases are generated so that exactly one customer will have placed more orders than any other customer.
with total as
(select 
customer_number,
count(order_number) as nums
from orders
group by 1)

select customer_number
from total
where nums in (select max(nums) from total);

###############################################alternative
SELECT
    customer_number
FROM
    orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1
;