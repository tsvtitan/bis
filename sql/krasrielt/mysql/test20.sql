select r.*
  from  s_sell_apartments   r
     join (select op1.object_id from (
select op1.object_id , count(*)  as  ct
  from object_params op1
 where (case op1.param_id
           when  'E774322A3928ADC74A75A4E8815D6C4A' then CONVERT(op1.value using cp1251)='Красноярск г.'
          when '1255AFCAF6C78D89419113A51DAEF97A' then CONVERT(op1.value using cp1251)='Красноярск ГО'
          when '0538CA0399AB9FA9468D1A4741BA5090' then CONVERT(op1.value using cp1251)='Железнодорожный'
           when 'E7F33B7C110F96E240BC3C739F3172EB' then CONVERT(op1.value using cp1251) LIKE '%т%'
           when 'A753A13C38F2846842B225E8FE9608F5' then CONVERT(OP1.VALUE,DECIMAL(15,2))>=18.0 AND CONVERT(OP1.VALUE,DECIMAL(15,2))<=62.0
                  end )
group by  op1.object_id
) op1
where op1.ct =5
) op on op.object_id=r.object_id