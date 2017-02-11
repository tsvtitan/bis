set @cnt=0;
insert into param_values (param_value_id,param_id,name,description,priority)
select cast(SUBSTRING(GET_UNIQUE_ID(),1,32) as char(32)) as param_value_id,
       'E7F33B7C110F96E240BC3C739F3172EB' as param_id,
			 t.name as name,
			 t.name as description,
			 t.priority
  from (select distinct(street_name) as name,
	             @cnt:=@cnt+1 as priority
					from del
                    order by 1) t
