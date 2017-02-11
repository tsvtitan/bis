select r.*
  from s_apartment_rolls r
 where r.object_id in (

select op1.object_id from (
select op1.object_id, count(*) as ct
  from object_params op1
 where (case op1.param_id 
	      when 'E774322A3928ADC74A75A4E8815D6C4A' then CONVERT(op1.value using cp1251) LIKE 'красно€рск'
				when '0538CA0399AB9FA9468D1A4741BA5090' then CONVERT(op1.value using cp1251)='∆елезнодорожный'
			  when 'E7F33B7C110F96E240BC3C739F3172EB' then CONVERT(op1.value using cp1251) LIKE '%рј%' 
				when 'A753A13C38F2846842B225E8FE9608F5' then CONVERT(OP1.VALUE,DECIMAL(15,2))>=18.0 AND CONVERT(OP1.VALUE,DECIMAL(15,2))<=62.0
			   end)
group by op1.object_id				
) op1
where op1.ct=4
)
order by 16
	
	
	
 
	