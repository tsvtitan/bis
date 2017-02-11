select * from object_params

insert into object_params (object_param_id,object_id,param_id,value,date_create,account_id)
values ('50042BC9EA12A5184F59537F0704F2C2','380209','E774322A3928ADC74A75A4E8815D6C4A',CONVERT('Красноярск2' USING cp1251),'2007-10-27','13FCA4E7C4DEBC764E68E0DB403D2520')

delete from object_params
where object_param_id='50042BC9EA12A5184F59537F0704F2C2' 

select * from S_APARTMENT_rolls

select * from s_params

select * from s_types

select * from object_params