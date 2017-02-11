select convert(t.param_value_id using utf8) from (
select get_unique_id() as param_value_id,
       '0538CA0399AB9FA9468D1A4741BA5090' as param_id,
			 t.region_name as name,
			 t.region_name as description,
			 t.priority
  from (select distinct(region_name) as region_name,
	             @cnt=@cnt+1 as priority
					from del) t 
) t