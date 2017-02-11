
begin
  declare
  @id varchar(37);
  SET @id=newid();
  SET @id=substring(@id,25,12)+substring(@id,20,4)+substring(@id,15,4)+substring(@id,10,4)+substring(@id,1,8);
  select @id, len(@id);
  
end