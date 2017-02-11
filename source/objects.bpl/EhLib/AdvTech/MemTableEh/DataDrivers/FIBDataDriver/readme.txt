DataDriver для FIBPlus.
----------------------

Компонент регистрит себя сам - нужно только добавить его в package.

В силу особенностей "устройства" FIBPlus (базовый query там не является
наследником TDataSet, и "вытащить" из нее данные - та еще задачка; при этом,
выполнять execute procedure надо именно через нее) Command с CommandType, равным
cthStoredProc, имеет смысл использовать только для execute procedure.

Если же SP возвращает какой-либо курсор, то надо просто вызывать команду с
CommandType = cthSelectQuery с запросом следующего вида:

  select from our_sp1(param1).


Serguei S. Borisoff