DataDriver ��� FIBPlus.
----------------------

��������� ��������� ���� ��� - ����� ������ �������� ��� � package.

� ���� ������������ "����������" FIBPlus (������� query ��� �� ��������
����������� TDataSet, � "��������" �� ��� ������ - �� ��� �������; ��� ����,
��������� execute procedure ���� ������ ����� ���) Command � CommandType, ������
cthStoredProc, ����� ����� ������������ ������ ��� execute procedure.

���� �� SP ���������� �����-���� ������, �� ���� ������ �������� ������� �
CommandType = cthSelectQuery � �������� ���������� ����:

  select from our_sp1(param1).


Serguei S. Borisoff