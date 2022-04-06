/* This is coded in Mode */

/* Graph daily signups */
select date_trunc('day', created_at) as day,
  count(distinct user_id) as signups
from tutorial.yammer_users
where date_trunc('day', created_at) between '2014-04-01' and '2014-08-31'
group by day
order by day;

/* Graph activated users */
select date_trunc('day', created_at) as day,
  count(distinct user_id) as all_signups,
  count(activated_at) as active_signups
from tutorial.yammer_users
where date_trunc('day', created_at) between '2014-04-01' and '2014-08-31'
group by day
order by day;

/* Graph exsiting users: Calculates how old a user is (in days) when a login happens */
select occurred_at, 
  tutorial.yammer_events.user_id, 
  extract(day from cast('2014-09-01' as timestamp) - activated_at) as user_age
from tutorial.yammer_events
left join tutorial.yammer_users
  on tutorial.yammer_users.user_id = tutorial.yammer_events.user_id
where event_name = 'login' 
  and occurred_at between '2014-05-01' 
  and '2014-09-01';

/* Creating yser cohorts by age */
select date_trunc('week',occurred_at) as week,
  count(distinct case when user_age < 7 then user_id else null end) as "0 week",
  count(distinct case when user_age >= 7 and user_age < 14 then user_id else null end) as "1 week",
  count(distinct case when user_age >= 14 and user_age < 21 then user_id else null end) as "2 weeks",
  count(distinct case when user_age >= 21 and user_age < 28 then user_id else null end) as "3 weeks",
  count(distinct case when user_age >= 28 and user_age < 35 then user_id else null end) as "4 weeks",
  count(distinct case when user_age >= 35 and user_age < 42 then user_id else null end) as "5 weeks",
  count(distinct case when user_age >= 42 and user_age < 49 then user_id else null end) as "6 weeks",
  count(distinct case when user_age >= 49 and user_age < 56 then user_id else null end) as "7 weeks",
  count(distinct case when user_age >= 56 and user_age < 63 then user_id else null end) as "8 weeks",
  count(distinct case when user_age >= 63 and user_age < 70 then user_id else null end) as "9 weeks",
  count(distinct case when user_age >= 70 then user_id else null end) as "> 10 weeks"
from (select occurred_at,  
    tutorial.yammer_events.user_id, 
    extract(day from cast('2014-09-01' as timestamp) - activated_at) as user_age
  from tutorial.yammer_events
  left join tutorial.yammer_users
    on tutorial.yammer_users.user_id = tutorial.yammer_events.user_id
  where event_name = 'login' 
    and occurred_at between '2014-05-01' 
    and '2014-09-01') as user_age_table
group by week
order by week;
