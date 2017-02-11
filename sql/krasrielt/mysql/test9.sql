set @cnt=0;
insert into param_values (param_value_id,param_id,name,description,priority)
select cast(SUBSTRING(GET_UNIQUE_ID(),1,32) as char(32)) as param_value_id,
       '0538CA0399AB9FA9468D1A4741BA5090' as param_id,
			 t.region_name as name,
			 t.region_name as description,
			 t.priority
  from (select distinct(region_name) as region_name,
	             @cnt:=@cnt+1 as priority
					from del) t
