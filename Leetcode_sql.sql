
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


#176. Second Highest Salary
select 
ifnull(
    (select salary
        from employee
        group by salary #it focused on salary, doesnt care id
        order by salary desc
        limit 1 offset 1), null)  SecondHighestSalary #limit offset to shift to second


#178. Rank Scores
#test about dense_rank()
select
score,
dense_rank()over(order by score desc) as 'rank'
from scores
#no group by
order by 1 desc;


#185. Department Top Three Salaries
#Write an SQL query to find the employees who are high earners in each of the departments.
# top 3 high salary and may be duplicate salary
with tem as(
select
d.name as department,
e.name as employee,
salary,
dense_rank()over(partition by d.id order by salary desc) as rnk
from department d, employee e
where d.id = e.departmentid

) 
select 
Department,
Employee,
Salary
from tem
where rnk <=3
order by 1, 3 desc

#184. Department Highest Salary
#highest salaries in each department
with tem as
(
select
em.*,
dp.name as Department,
dense_rank()over(partition by dp.name order by salary desc) as rnk
from employee em, department dp
where em.departmentid = dp.id
)
select 
Department,
name as Employee,
salary
from tem
where rnk = 1;
##########################alternative way without window functions
SELECT
    Department.name AS 'Department',
    Employee.name AS 'Employee',
    Salary
FROM
    Employee
        JOIN
    Department ON Employee.DepartmentId = Department.Id #join the table to get the department name
WHERE
    (Employee.DepartmentId , Salary) IN  #find the two values from the subquery
    (   SELECT
            DepartmentId, MAX(Salary)#build a subquery in aggregation that contains the highest earns of each department
        FROM
            Employee
        GROUP BY DepartmentId
    )
;


#177. Nth Highest Salary
#the N highest salary
#same logic by using dense_rank
#but need to limit to one row in case duplicated salary amounts
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select
      salary 
      from
      (select
      *,
      dense_rank()over(order by salary desc) as rnk
      from employee
      order by salary desc) tem
      where rnk = N 
      limit 1
  );
END



#578. Get Highest Answer Rate Question
with tem as (select
question_id,
count(answer_id) as answer_times,
sum(case when action="answer" then 1 else 0 end)
             /(sum(case when action="show" then 1 else 0 end)) as answer_rate,
dense_rank()over (partition by question_id order by count(answer_id) desc) as rnk
from SurveyLog
group by 1
)

select
question_id as survey_log
from 
tem
where answer_rate = (select Max(answer_rate) from tem) 
order by 1
limit 1;
###################alternative,,,,simple and easy
SELECT
    question_id survey_log
FROM SurveyLog
GROUP BY question_id
ORDER BY SUM(action = 'answer') / SUM(action = 'show') DESC, question_id ASC
LIMIT 1

#570. Managers with at Least 5 Direct Reports
#Write an SQL query to report the managers with at least five direct reports.
with temp as
(
select managerid, #find the managerid with at least 5 direct reports
    count(id) as cnt
    from employee
    group by 1 
    having count(id) >= 5
)
select #find the name that match the managerid
name 
from employee
where id in (
select managerid from temp)
################
select
name 
from employee
where id in (
select managerid
    from employee
    group by 1 
    having count(id) >= 5)



#1777. Product's Price for Each Store
select
product_id,
min(case when store = 'store1' then price end) as 'store1',
min(case when store = 'store2' then price end) as 'store2',
min(case when store = 'store3' then price end) as 'store3'
from Products
group by 1 #After group by the product_id, you need to use aggregate function to obtain the price for each store.
#You can use max(), min(), sum() or avg(), but not count().
#Otherwise, it will just return the first row of the group by result, e.g. [0, 95, NULL, NULL]


#574. Winning Candidate
#Write an SQL query to report the name of the winning candidate (i.e., the candidate who got the largest number of votes).
select
name 
from
(select 
c.id,
c.name,
count(v.id) as cnt_vote
from candidate c, vote v
where c.id = v.candidateID
group by 1,2
order by 3 desc) sub
limit 1;


#585. Investments in 2016
#Write an SQL query to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
#have the same tiv_2015 value as one or more other policyholders, and
#are not located in the same city like any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
#Round tiv_2016 to two decimal places.
select
    round(sum(i1.tiv_2016), 2) as tiv_2016
from insurance i1
where i1.tiv_2015 in (
                    select tiv_2015 
                    from insurance 
                    group by 1 having count(*)>1
                    )
    and concat(i1.lat, i1.lon) not in (      #Concat the LAT and LON as a whole to represent the location information.

                                select concat(lat, lon )
                                from insurance 
                                group by 1 
                                having count(*)>1
                                    );
#################alternative with window functions
select round(sum(tiv_2016),2) as tiv_2016
from(select tiv_2016, count() over (partition by lat, lon) as location_counts, count() over(partition by tiv_2015) as 2015counts
from Insurance
)a
where 2015counts>1 and location_counts<2


#602. Friend Requests II: Who Has the Most Friends
WITH data AS
(
SELECT requester_id AS id
FROM RequestAccepted

UNION ALL

SELECT accepter_id AS id
FROM RequestAccepted

)#combine the acceptid and requesterid together and then do the aggregation

SELECT id, COUNT(*) AS num
FROM data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1


#612. Shortest Distance in a Plane
#The distance between two points p1(x1, y1) and p2(x2, y2) is sqrt((x2 - x1)2 + (y2 - y1)2).
#Write an SQL query to report the shortest distance between any two points from the Point2D table. Round the distance to two decimal points.
Input: 
Point2D table:
+----+----+
| x  | y  |
+----+----+
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
+----+----+

SELECT
    ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))),2) AS shortest
FROM
    point2d p1 #self join
        JOIN
    point2d p2 ON (p1.x <= p2.x AND p1.y < p2.y)
        OR (p1.x <= p2.x AND p1.y > p2.y)
        OR (p1.x < p2.x AND p1.y = p2.y)
;

#511. Game Play Analysis I
#Write an SQL query to report the first login date for each player.
select
player_id,
min(event_date) as first_login
from activity
group by 1




    
    
 #512. Game Play Analysis II
 #Write an SQL query to report the device that is first logged in for each player.
 #will need to re-do   
select a.player_id, a.device_id
from (
    select player_id, 
            device_id, 
            rank() over(partition by player_id order by event_date asc) as date_rank
    from Activity) as a
    where a.date_rank = 1 


#534. Game Play Analysis III
#Write an SQL query to report for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.
select
player_id,
event_date,
sum(games_played )over (partition by player_id order by event_date)  games_played_so_far #window function here to calculate the sum  of games_played on each row
#rank()over(partition by player_id order by event_date desc) as rnk
from activity
group by 1,2
order by 1, 2 


#550. Game Play Analysis IV
#Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
with cte as 
(select 
player_id, 
datediff(lead(event_date, 1) over(partition by player_id order by event_date) , event_date) as next_login, #next one - the exist one
rank() over(partition by player_id order by event_date) as rr #find the smallest event_date (the earliest date)
from activity)

select round(count(distinct cte.player_id)/count(distinct s.player_id),2) as fraction 
from cte 
right join activity s 
on cte.player_id = s.player_id and cte.rr =1 and cte.next_login = 1; #for the same id, match the date, find the next date and first event date 
#################alternative
# datediff(date1, date2) is date1 - date2
with total_players as
(
select count(distinct player_id) as total_count from activity
),
next_day_players as (
select count(distinct a1.player_id) as next_day_count
from (select player_id, min(event_date) as event_date from activity group by player_id) a1
join activity a2 on a1.player_id=a2.player_id and a2.event_date=DATE_ADD(a1.event_date, INTERVAL 1 DAY)
)
select round(next_day_count/total_count,2) as fraction from total_players join next_day_players;
############alternative
with cte as(
    select *,
    min(event_date) over(partition by player_id) as first_day,
    date_add(min(event_date) over(partition by player_id), interval 1 day) as next_day
from Activity),
cons_user as(
    select count(distinct player_id) as cons
    from cte 
    where event_date = next_day
)

select round(cons / count(distinct player_id),2) as fraction
from cons_user, cte




#613. Shortest Distance in a Line
#Write an SQL query to report the shortest distance between any two points from the Point table.
select 
distance as shortest
from (
select
p1.x x1,
p2.x x2,
min(abs(p1.x -p2.x)) as distance,
rank()over (order by min(p1.x - p2.x)) as rnk
from point p1, point p2
    where p1.x != p2.x
) data
where rnk =1


#614. Second Degree Follower
#A second-degree follower is a user who:

#--follows at least one user, and
#--is followed by at least one user.
#Write an SQL query to report the second-degree users and the number of their followers.
#Return the result table ordered by follower in alphabetical order.

select followee as follower, 
count(distinct follower) as num
from follow
where followee in (select follower from follow)
group by 1
order by follower;


#619. Biggest Single Number
#A single number is a number that appeared only once in the MyNumbers table.

#Write an SQL query to report the largest single number. If there is no single number, report null.
select max(num) as num
from (select num
      from mynumbers
      group by 1 #dont forget group here
     having count(num) = 1) data;




#################################################################
#615. Average Salary: Departments VS Company
#Write an SQL query to report the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary by month
#company avg salary by month
with avg_all as(
    select left(pay_date,7) as pay_month,
    avg(amount) as avg_all
    from salary
    group by 1
),
#avg department salary by month
avg_dep as(
    select left(pay_date,7) as pay_month,
    department_id,
    avg(amount) avg_dep
    from salary s join employee e
    on s.employee_id=e.employee_id
    group by 1,2
)
#compare
select 
d.pay_month,
department_id,
case 
when avg_dep = avg_all then "same"
when avg_dep > avg_all then "higher"
else "lower" 
end as comparison
from avg_dep d, avg_all a
where d.pay_month = a.pay_month;
########################################################################


#1050. Actors and Directors Who Cooperated At Least Three Times
#Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor has cooperated with the director at least three times.
#take advantage on timestamp
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
having count(timestamp) >=3;
######################################################
#concat and groupby
select
actor_id,
director_id
from actordirector
group by 1,2
having count(concat(actor_id, director_id)) >=3;


#1479. Sales by Day of the Week
#You are the business owner and would like to obtain a sales report for category items and the day of the week.
#Write an SQL query to report how many units in each category have been ordered on each day of the week.
#Return the result table ordered by category.
select t1.item_category as Category
        ,sum(case when dayname(order_date) = 'Monday' then quantity else 0 end) as Monday
        ,sum(case when dayname(order_date) = 'Tuesday' then quantity else 0 end) as Tuesday
        ,sum(case when dayname(order_date) = 'Wednesday' then quantity else 0 end) as Wednesday
        ,sum(case when dayname(order_date) = 'Thursday' then quantity else 0 end) as Thursday
        ,sum(case when dayname(order_date) = 'Friday' then quantity else 0 end) as Friday
        ,sum(case when dayname(order_date) = 'Saturday' then quantity else 0 end) as Saturday
        ,sum(case when dayname(order_date) = 'Sunday' then quantity else 0 end) as Sunday

from Items t1
left join Orders t2 using(item_id)
group by 1
order by category
############################################################
select 
item_category as Category,
sum(case when weekday(order_date) =0 then quantity else 0 end) as "Monday",
sum(case when weekday(order_date) =1 then quantity else 0 end) as "Tuesday",
sum(case when weekday(order_date) =2 then quantity else 0 end) as "Wednesday",
sum(case when weekday(order_date) =3 then quantity else 0 end) as "Thursday",
sum(case when weekday(order_date) =4 then quantity else 0 end) as "Friday",
sum(case when weekday(order_date) =5 then quantity else 0 end) as "Saturday",
sum(case when weekday(order_date) =6 then quantity else 0 end) as "Sunday"

from Items as i  
left join Orders as o
on i.item_id =o.item_id
group by item_category 
order by  item_category;


#1596. The Most Frequently Ordered Products for Each Customer
#Write an SQL query to find the most frequently ordered product(s) for each customer.
#The result table should have the product_id and product_name for each customer_id who ordered at least one order. Return the result table in any order.
select
customer_id 
,product_id 
,product_name
from
(select
c.customer_id 
,o.product_id 
,product_name 
,dense_rank()over(partition by customer_id order by count(order_id) desc) as rank_no
from products as p
 join orders as o
on p.product_id = o.product_id
 join customers as c
on c.customer_id = o.customer_id
group by 1,2
) data
where rank_no =1
######################################easier way,ignore the customers table
with rnk as (
    SELECT *, rank() over (partition by customer_id order by count(product_id) desc) as rk 
    from orders
    group by customer_id, product_id)

SELECT rnk.customer_id, rnk.product_id, product_name from rnk
left join products p
on rnk.product_id = p.product_id 
where rk = 1


#1270. All People Report to the Given Manager
#Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.The indirect relation between managers will not exceed three managers as the company is small.
# Write your MySQL query statement below
select distinct employee_id from Employees where manager_id in
(select distinct employee_id from Employees where manager_id IN
(select distinct employee_id from Employees where manager_id =1 ) )
and employee_id !=1
####alternative way with temp table
WITH cte AS (
    SELECT e1.employee_id, 
    e1.manager_id AS m1, 
    e2.manager_id AS m2, 
    e3.manager_id AS m3
    FROM employees e1 
    LEFT JOIN employees e2 
    ON e1.manager_id = e2.employee_id
    LEFT JOIN employees e3 
    ON e2.manager_id = e3.employee_id
)

SELECT employee_id FROM cte 
WHERE m3 = 1 
AND employee_id != 1;


#262. Trips and Users
#Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.
# #of of cancellation by day 
# #of of cancellation by day 
with cancel_no as (
    select request_at as day,
    count(id) as cancel_no #my solution does not have 10-02
    from trips t 
     join  users u
    on u.users_id = t.client_id 
    join users u2    
    on u2.users_id=t.driver_id
    where u.banned = "No" and u2.banned = "No" and status like "cancelled%" 
    group by 1
),
# total # rides
total_no as (
    select  request_at as day,
     count(id) as total_no
    from trips t 
     join  users u
    on u.users_id = t.client_id 
     join users u2    
    on u2.users_id=t.driver_id
    where u.banned = "No" and u2.banned ="No" and request_at between '2013-10-01' and '2013-10-03'
    group by 1
)

select t.Day,
round(ifnull(cancel_no/total_no, 0), 2) as "cancellation rate"
from cancel_no c 
right join total_no t
on c.day = t.day;
####################alternative way assign value 0 to cancellation temp table in regards to 10-02
with cancels as 
(
select request_at as Day, sum(case when status='completed' then 0 else 1 end) as count_stats from Trips t inner join Users u on t.client_id = u.users_id
    inner join Users d on t.driver_id = d.users_id
where u.banned = 'No'
    and d.banned = 'No'
and request_at between '2013-10-01' and '2013-10-03' group by request_at
    ),
    total_req as 
(select request_at as Day , count(*) as total from Trips t inner join Users u on t.client_id = u.users_id
    inner join Users d on t.driver_id = d.users_id
where u.banned = 'No'
    and d.banned = 'No'
and request_at between '2013-10-01' and '2013-10-03' group by request_at)
select t.Day, round((count_stats/total),2) as "Cancellation Rate" from cancels c 
left outer join total_req t on c.Day = t.Day;



#1164. Product Price at a Given Date
#Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
# create sale data as of 08-16
with early_data as (
    select product_id, new_price, change_date, 
    row_number() over(partition by product_id order by change_date desc) as rnk
    from Products
    where change_date <= "2019-08-16" 
)
select distinct
p.product_id,
ifnull(d.new_price, 10) as price
from products p
left outer join early_data d
on p.product_id =d.product_id
where rnk = 1 or rnk is null #need to pay extra attention to rnk is null, it will filter out product_id =3
#group by 1



#1811. Find Interview Candidates
#Write an SQL query to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:

#The user won any medal in three or more consecutive contests.
#The user won the gold medal in three or more different contests (not necessarily consecutive).

#The user won the gold medal in three or more different contests
with gold as(
select #contest_id,
gold_medal as user_id
from Contests c
group by 1
having count(*)>= 3
),
# The user won any medal in three or more consecutive contests.
all_others as (
select contest_id, gold_medal as user_id
from Contests c1
union all
select contest_id, silver_medal as user_id
from Contests c2
union all
select contest_id, bronze_medal as user_id
from Contests c3
),

other_sort as(
select
user_id, contest_id,
lead(contest_id, 1) over(partition by user_id order by contest_id) as p1,
lead(contest_id, 2) over(partition by user_id order by contest_id) as p2
from all_others
),

int_ids as(
select 
user_id from gold
union
select 
user_id
from other_sort
where p2 = p1 + 1 and p1=contest_id + 1
)

select name, mail
from users u
inner join int_ids i
on u.user_id = i.user_id



##1084. Sales Analysis III
####Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.
# Write your MySQL query statement below
with other_time as (select distinct product_id, sale_date
                    from Sales 
                    where sale_date not between '2019-01-01' and '2019-03-31')
##find the sales not the time period

select distinct
s.product_id,
product_name
from Sales s
left join  Product p
on p.product_id=s.product_id
where s.product_id not in (select product_id from other_time) ##ensure the product not in the outside period sales
and s.sale_date between '2019-01-01' and '2019-03-31' 

##########using subquery is faster 
# Write your MySQL query statement below


select distinct
s.product_id,
product_name
from Sales s
left join  Product p
on p.product_id=s.product_id
where s.product_id not in (select distinct product_id
                    from Sales 
                    where sale_date not between '2019-01-01' and '2019-03-31')





#####1581. Customer Who Visited but Did Not Make Any Transactions
#Write an SQL query to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
# Write your MySQL query statement below

select 
a.customer_id,
count(a.visit_id) count_no_trans
from 
(
select   ######find these customer_id first and count the number of visits
customer_id, 
visit_id
from Visits V
where visit_id not in (select visit_id from Transactions)
) a
group by customer_id;



#1148. Article Views I
Write an SQL query to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.

# Write your MySQL query statement below
select distinct #avoid show duplicate for these viewed more than one time
v1.author_id as id 
from Views v1
where author_id=viewer_id #this is the key
order by v1.author_id ;


##1141. User Activity for the Past 30 Days I
Write an SQL query to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.
# Write your MySQL query statement below
select
activity_date day,
count(distinct user_id ) active_users 
from Activity
where datediff('2019-07-27', activity_date )<30 and activity_date <'2019-07-27'   #the key point in the past 30 days expression
group by 1
#alternative 
select
activity_date day,
count(distinct user_id ) active_users 
from Activity
#where datediff('2019-07-27', activity_date )<30 and activity_date <'2019-07-27'
where activity_date between date_sub('2019-07-27',interval 29 DAY) and '2019-07-27' #ps: learn how to express the past # of days
group by 1


1633. Percentage of Users Attended a Contest
# Write your MySQL query statement below
Write an SQL query to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.
select
contest_id,
round(count(r.user_id )/(select count(user_id) all_users from Users)*100, 2) as percentage #key point is putting subquery here for calculation
from Register r
left join users u
on r.user_id=u.user_id
group by contest_id 
order by 2 desc, 1



#1211. Queries Quality and Percentage
Write an SQL query to find each query_name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.
# Write your MySQL query statement below

select 
query_name,
round(avg(rating/position),2) as quality,
round(count(case when rating<3 then rating end)/count(rating)*100,2) as poor_query_percentage #the key in the condition
from Queries 
group by query_name


#1179. Reformat Department Table
Write an SQL query to reformat the table such that there is a department id column and a revenue column for each month.
# Write your MySQL query statement below
select distinct
id,
sum(case when month ='Jan' then revenue end) as Jan_Revenue ,
sum(case when month ='Feb' then revenue end) as Feb_Revenue ,
sum(case when month ='Mar' then revenue end) as Mar_Revenue ,
sum(case when month ='Apr' then revenue end) as Apr_Revenue ,
sum(case when month ='May' then revenue end) as May_Revenue ,
sum(case when month ='Jun' then revenue end) as Jun_Revenue ,
sum(case when month ='Jul' then revenue end) as Jul_Revenue ,
sum(case when month ='Aug' then revenue end) as Aug_Revenue ,
sum(case when month ='Sep' then revenue end) as Sep_Revenue ,
sum(case when month ='Oct' then revenue end) as Oct_Revenue ,
sum(case when month ='Nov' then revenue end) as Nov_Revenue ,
sum(case when month ='Dec' then revenue end) as Dec_Revenue 
from Department 
group by id
order by id


##1731. The Number of Employees Which Report to Each Employee
For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

Write an SQL query to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id.
# Write your MySQL query statement below
select
e1.reports_to as employee_id ,
e2.name,
count(e1.employee_id ) as reports_count,
round(avg(e1.age)) average_age 
from Employees e1, Employees e2
where e1.reports_to is not null and e1.reports_to=e2.employee_id  #key in matching eID to rID
group by 1, 2
order by 1



#1241. Number of Comments per Post
The Submissions table may contain duplicate comments. You should count the number of unique comments per post.

The Submissions table may contain duplicate posts. You should treat them as one post.

The result table should be ordered by post_id in ascending order.
# Write your MySQL query statement below
select post_id,
count(distinct sub_id) as number_of_comments #distinguish comment and post
from 
    (select distinct
    sub_id as post_id
    from submissions
    where parent_id is null #post
    ) as post
left join submissions as comments
on post.post_id=comments.parent_id
 group by 1 order by 1





#1142. User Activity for the Past 30 Days II
Write an SQL query to find the average number of sessions per user for a period of 30 days ending 2019-07-27 inclusively, rounded to 2 decimal places. The sessions we want to count for a user are those with at least one activity in that time period.
# Write your MySQL query statement below

select
case when session_per_user is not null and session_per_user <>0 then round(sum(session_per_user)/count(session_per_user),2 )
else 0 end as average_sessions_per_user #ensure not null and not zero 
from 
(select distinct
user_id,
count(distinct session_id) session_per_user
from activity
where datediff('2019-07-27',activity_date) <30 and activity_date<'2019-07-27'
group by 1) a