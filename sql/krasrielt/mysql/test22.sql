-- insert into `param_value_depends` (what_param_value_id,from_param_value_id)


select d.*,
       pv1.param_value_id as from_param_value_id,
       pv2.param_value_id as what_param_value_id
from
(
select d.region_name,
       Concat(Trim(SUBSTRING(d.town_name,3,100)),' ',Trim(SUBSTRING(d.town_name,1,3))) as town_name2,
       Concat(d.town_name,', ',d.region_name) as town_name3
  from del d) d
join
(select param_value_id,name from param_values where param_id='1255AFCAF6C78D89419113A51DAEF97A') pv1
on pv1.name=d.region_name
join
(select param_value_id,description from param_values where param_id='E774322A3928ADC74A75A4E8815D6C4A') pv2
on pv2.description=d.town_name3

order by d.region_name, d.town_name2

