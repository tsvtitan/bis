select r.* 
  from s_apartment_rolls r, 
	    (select object_id from object_params
			  where param_id='') op
 where r.object_id=op.object_id
   and r.territory_name ='������������ ����'
   and r.town_name='����������'
   and r.countroom_name='1'
	 