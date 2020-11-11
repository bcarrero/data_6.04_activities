/* 6_04_ activity 1
In this activity, you will be using data from files_for_activities/mysql_dump.sql. Refer to the case study files to find more information. Please answer the following questions.
    */

#    How many accounts do we have?    
    select count(loan_id) from loan;

# How many of the accounts are defaulted?  
    select count(loan_id) from loan
    where status = 'B';
#  What is the percentage of defaulted people in the dataset?  
  select (sub1.defaulted / sub2.credits)*100 from 
	(select count(loan_id) as defaulted from loan
    where status = 'B') as sub1,
    (select count(account_id) as credits from account) as sub2;
    
      select (sub1.defaulted / sub2.credits)*100 from 
	(select count(loan_id) as defaulted from loan
    where status = 'B') as sub1,
    (select count(loan_id) as credits from loan) as sub2;
# What can we conclude from here?

/*
6.04 Activity 2
Keep working on the same dataset.
Find the account_id, amount and date of the first transaction of the defaulted people 
if its amount is at least twice the average of non-default people transactions.
*/
select account_id, amount from loan
where status = 'B'
order by account_id;

select t.account_id, date, t.amount from trans as t
join (select account_id, amount from loan
where status = 'B'
order by account_id) as sub1
group by t.account_id;

select t.account_id, min(t.date), t.amount from trans as t
join (select account_id, amount from loan
where status = 'B'
order by account_id) as sub1
group by t.account_id
having amount >=(select 2*avg(amount) from trans);

/*
6.04 Activity 3
Keep working on the same dataset.
Create a pivot table showing the average amount of transactions using frequency for each district.
*/
select district_id from trans as t
join account as a on a.account_id=t.account_id;

select a.district_id, 
avg(case when a.frequency ='POPLATEK MESICNE' then Amount end) as POPLATEK_MESICNE,
avg(case when a.frequency ='POPLATEK TYDNE' then Amount end) as POPLATEK_TYDNE,
avg(case when a.frequency ='POPLATEK PO OBRATU' then Amount end) as POPLATEK_PO_OBRATU
from trans as t
join account as a on a.account_id=t.account_id
group by district_id
order by district_id;


select d.A2,
avg(case when a.frequency ='POPLATEK MESICNE' then Amount end) as POPLATEK_MESICNE,
avg(case when a.frequency ='POPLATEK TYDNE' then Amount end) as POPLATEK_TYDNE,
avg(case when a.frequency ='POPLATEK PO OBRATU' then Amount end) as POPLATEK_PO_OBRATU
from trans as t
join account as a on a.account_id=t.account_id
join district as d on d.A1 =a.district_id
group by d.A2
order by d.A2;

select district.A2 as district, account.frequency, round(avg(trans.amount),2) as avg_amount
from trans
join account
on trans.account_id = account.account_id
join district
on district.A1 = account.district_id
group by district.A2, account.frequency;

use sakila;

select title, release_year from film
where release_year = 2006; 

drop procedure movies_released_2006;
delimiter //
create procedure movies_released_2006 (out param1 int)
begin
select count(title) into param1 from film
where release_year = 2006; 
end
//
delimiter ; -- don't forget the space between delimiter and ;

call movies_released_2006(@x);

select @x;