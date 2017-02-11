select * from s_persons

select * from s_accounts

select get_unique_id()

call i_person ('1DD2383A0D6CA35047F05016F92FBE32','Гость','Гость')

select get_unique_id()

call i_account ('13FCA4E7C4DEBC764E68E0DB403D2520','1DD2383A0D6CA35047F05016F92FBE32',
               'Гость',NULL,'Не зарегистрированный пользователь',NULL,NULL,0)
							
select get_unique_id()

call i_param ('B2C984E12A56AF2B43287451384D7613','Территория',
              'Административно-территориальная единица',0,0,NULL)
							
select get_unique_id()							

call i_param ('189AD4575FD398A34116354F23E1663F','Населенный пункт',
              'Населенный пункт',0,0,NULL)

select get_unique_id()							

call i_param ('99EC4469C96491624BF2CC19E9A9405B','Улица',
              'Улица в населенном пункте',0,0,NULL)

select get_unique_id()							

call i_param_value ('C0D899D8B5DBB7084C309BF8DA7B0283','B2C984E12A56AF2B43287451384D7613',
                    'Красноярский край','Красноярский край',NULL)
										
select get_unique_id()																	

call i_param_value ('2F936324FC3AA0214000A0F2B767C067','B2C984E12A56AF2B43287451384D7613',
                    'Хакасия','Хакаская автономная область',NULL)

select get_unique_id()																	

call i_param_value ('92CD3C57955B9A7E4024DD2137095098','99EC4469C96491624BF2CC19E9A9405B',
                    'Ленина','ул.Ленина',NULL)
