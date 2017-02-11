execute block
as
  declare params blob;
  declare session_id varchar(100);
  declare data varchar(3000);
  declare ip varchar(50);
begin
  ip='192.168.0.7';

/*  select first 1
         session_id
    from s_sessions
   where user_name='tsv'
   order by date_create desc
    into :session_id; */

   session_id='0274A4E433B38BDC44E13BEE3011DA19';

  Params=config_write(Params,'4925FD4AC61EB0ED4A3D5A8DB899F072','Message','Сейчас будет осуществлен выход из программы!');
  Params=config_write(Params,'4925FD4AC61EB0ED4A3D5A8DB899F072','SessionId',:session_id);

/*  Params=Null;
  Params=config_write(Params,'C1EC37D36E9BBDCA4AC356699242A3AF','Message','Сейчас будет осуществлен выход из программы!'||CHR(13)||CHR(10)||' и затем перезагрузка компьютера');
  Params=config_write(Params,'C1EC37D36E9BBDCA4AC356699242A3AF','Mode','1');
  Params=config_write(Params,'C1EC37D36E9BBDCA4AC356699242A3AF','TimeOut','9999');
  Params=config_write(Params,'C1EC37D36E9BBDCA4AC356699242A3AF','SessionId',session_id);

  */

  udp(ip,'55514',Params);

--  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Command','c:\restart.cmd');
--  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Mode','1');
--  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','TimeOut','1000');

/*  data=Null;
  data='shutdown /r /f /t 30';
 -- data='taskkill /im taxi.exe /f';
--  data=data||CHR(13)||CHR(10)||'ping -n 1 -w 1000 0.0.0.1 >nul';
--  data=data||CHR(13)||CHR(10)||'shutdown /r /f /t 10';

  data=data||CHR(13)||CHR(10)||'start /d u:\bin\ /b taxi.exe /config imtaxi2.ini /noupdate';
  data=data||CHR(13)||CHR(10)||'erase /q /f c:\restart.cmd';

  Params=Null;
  Params=config_write(Params,'9C8128FF91DA927F4A6E3E2B7EFB2E9F','FileName','c:\restart.cmd');
  Params=config_write(Params,'9C8128FF91DA927F4A6E3E2B7EFB2E9F','Data',:data);


--  Params=string_to_blob('[4925FD4AC61EB0ED4A3D5A8DB899F072]');

  udp(ip,'56000',Params);

  Params=Null;
  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Command','c:\restart.cmd');
  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Mode','0');

  udp(ip,'56000',Params);

  Params=Null;
  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Command','c:\restart.cmd');
  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Mode','0');

  udp(ip,'56000',Params);

  Sleep(5000);

  Params=Null;
  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Command','shutdown /a');
  Params=config_write(Params,'34A9DFB84291BCAA4E25E9CF0A4B95AE','Mode','0');

  udp(ip,'56000',Params);
   */

end
