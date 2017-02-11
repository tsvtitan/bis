update accounts a
   set a. user_name=(select c.CALLSIGN
                       from cars c
                       join drivers d on d.car_id=c.car_id
                      where d.driver_id=a.account_id)
where a.account_id in (select driver_id from drivers)
