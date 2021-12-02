
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


#595. Big Countries
#straight forward apply filters
select
name,
population,
area
from world
where area >= 3000000
    or population >= 25000000；

#596. Classes More Than 5 Students
# Write your MySQL query statement below
select class
from courses
group by 1 #i still forgot this line until error comes up
having count(student) >=5;

#597. Friend Requests I: Overall Acceptance Rate
# Write your MySQL query statement below
select 
round(#if null is a key, count distinct pairs is another key
    ifnull(count(distinct requester_id, accepter_id)/
      count(distinct sender_id, send_to_id), 0), 2
          ) as accept_rate
from requestaccepted, 
friendrequest;

#1303. Find the Team Size
#i try not to use join
with team_size as
(select
team_id,
count(employee_id) team_size
from employee
group by 1)

select
employee_id,
team_size
from employee emp, team_size ts
where emp.team_id = ts.team_id


#1083. Sales Analysis II
#Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.
#the traditional logic is to get the buyerid from who bought s8 and then take the buyer_id from who did not buy iphone and then take the overlap
#the below solution is an alternative way
select
buyer_id
from sales s, product p
where s.product_id = p.product_id 
#    and s.product_id != 2 and s.product_id !=3
group by 1 
having sum(product_name = 'S8')>0 and sum(product_name = "iPhone") = 0
order by 1 #very smart way in the having clause to filter out iphone and only retain the s8

#Consecutive Available Seats
# Write your MySQL query statement below
select distinct #distinct to avoid duplicate
c1.seat_id

from cinema c1 
 join cinema c2
on abs(c1.seat_id - c2.seat_id) = 1 #abs is the tricky part
where c1.free = 1 and c2.free = 1
order by 1;

#607. Sales Person
#Write an SQL query to report the names of all the salespersons who did not have any orders related to the company with the name "RED".
#find the list of that only contains salesperons in company red, and then use it as filter to find salesperson not in that list.
select 
s.name
from salesperson s
where s.sales_id not in (
                        select sales_id 
                        from orders a
                        left join company b
                        on a.com_id =b.com_id
                        where b.name='RED' )

#1069. Product Sales Analysis II
# Write an SQL query that reports the total quantity sold for every product id. 
#simple by most widely used
select
p.product_id,
sum(s.quantity) as total_quantity
from product p, sales s
where p.product_id = s.Product_id
group by 1;


#1068. Product Sales Analysis I
# Write your MySQL query statement below
#Write an SQL query that reports the product_name, year, and price for each sale_id in the Sales table.
with sub as(
select
s.sale_id,
p.product_name, 
s.year, 
s.price 
from product p, sales s
where p.product_id = s.product_id
group by 1)

select 
product_name, 
year, 
price 
from sub
#########use inner join is faster
SELECT
    t1.product_name,
    t2.year,
    t2.price
FROM
    product t1
INNER JOIN
    sales t2
ON
    t1.product_id = t2.product_id;


#1369. Get the Second Most Recent Activity
#Write an SQL query to show the second most recent activity of each user.
select username, activity, startDate, endDate
from
(select *,
 rank() over(partition by username order by startDate desc) as activity_order,
 rank() over(partition by username order by startDate asc) as activity_order_rev
 from UserActivity) tab
 where activity_order = 2 or (activity_order = 1 and activity_order = activity_order_rev);
##############same method
select
username,
activity,
startdate,
enddate
from (select
        username,
        activity,
        startdate,
        enddate,#doesnt matter using row_number or rank
        row_number()over(partition by username order by startdate desc, enddate desc) as row_no_desc,
        row_number()over(partition by username order by startdate, enddate ) as row_no_asc
        #reverse rank to find the 2nd most recent, rank to check those only have one activity record
        from useractivity
        ) row_no
where row_no_desc = 2 #second most recent
    or (row_no_desc =1 and row_no_desc = row_no_asc); #deal with thoes only have one activity

#580. Count Student Number in Departments
#Write an SQL query to report the respective department name and number of students majoring in each department for all departments in the Department table (even ones with no current students).
select
dept_name as dept_name,
ifnull(count(student_id), 0) as student_number
from department d
left join student s
    on s.dept_id = d.dept_id
group by 1
order by 2 desc, 1;


#569. Median Employee Salary
#using indexing 

with median_id as (
    select *, 
    row_number() over(partition by company order by salary) as r_num, c
    ount(company) over(partition by company) as c_cnt
    from employee
)

select id, company, salary
from median_id
where r_num  between c_cnt/2.0 and c_cnt/2.0 + 1



#569. Median Employee Salary
#Write an SQL query to find the median salary of each company.
# Write your MySQL query statement below
select
id,
company,
salary
from (select
        id,
        company,
        salary,
        row_number()over(partition by company order by salary) as row_no, #order by here to sort the salary so that we can take the median later on
        count(id)over(partition by company) as cnt #it is for later calculation
        from employee
        group by 1,2) sub
where row_no between cnt/2 and cnt/2+1

#180. Consecutive Numbers
#Write an SQL query to find all numbers that appear at least three times consecutively.
# Write your MySQL query statement below
select distinct
l1.num as ConsecutiveNums
from logs l1, logs l2, logs l3
where #same num  consecutively show 3 times
        l1.id = l2.id - 1 
    and l2.id = l3.id - 1
    and l1.num = l2.num #easy forget
    and l2.num = l3.num
###########alternative with window function
SELECT DISTINCT num AS ConsecutiveNums
FROM (SELECT num, (ROW_NUMBER() OVER (ORDER BY id) - ROW_NUMBER() OVER (PARTITION BY num ORDER BY id)) cons
    FROM Logs) tmp
GROUP BY cons, num
HAVING COUNT(*) >= 3
