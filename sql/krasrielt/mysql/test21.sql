set @cnt=0;

insert into `param_values` (param_value_id,param_id,name,description,priority)

select cast(SUBSTRING(GET_UNIQUE_ID(),1,32) as char(32)) as param_value_id,
        '1255AFCAF6C78D89419113A51DAEF97A' as param_id,
        d.region_name as name,
        d.region_name as description,
        d.priority
from (
select DISTINCT(d.region_name) as region_name,
       @cnt:=@cnt+1 as priority
 from del d) d
