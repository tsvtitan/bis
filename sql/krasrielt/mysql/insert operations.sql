select get_unique_id()

call i_operation ('9BB38FBAEE8B88A54FD02C983AE5C607','Продам','Продам',1)
call i_operation ('A7D600213026BBCE43F7B4676A8DC7F1','Куплю','Куплю',2)
call i_operation ('D5F0B39F9E48A9304EA0A28ABFA2132F','Обменяю','Обменяю',3)
call i_operation ('31B977EB8E80ABEB4BB4215FD6777072','Сдам','Сдам',4)
call i_operation ('8B5206B8E53DB842408847A0C46E0A1D','Сниму','Сниму',5)

select * from s_operations order by priority