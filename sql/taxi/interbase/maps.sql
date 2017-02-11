
select http_get('maps.googleapis.com','','/maps/api/directions/json','','',
                '?origin=56.010786602,92.876454738&destination=56.010786602,92.86645473&region=ru&sensor=false',1000) as n
  from rdb$database

select http_get('gws.ingit.ru','','/GWCgi.exe','','',
                '?cmd=route&map=cover.cvr&l0=92.866641&f0=56.011297&l1=92.876175&f1=56.010856',1000) as n
  from rdb$database

select http_get('api-maps.yandex.ru','','/modules/1.1/router-editor/src/xml/router.xml','','',
                '?key=ANpUFEkBAAAAf7jmJwMAHGZHrcKNDsbEqEVjEUtCmufxQMwAAAAAAAAAAAAvVrubVT4btztbduoIgTLAeFILaQ==&rll=92.87645473,56.010786602~92.86645473,56.010786602',1000) as n
  from rdb$database

select http_get('maps.rambler.ru','','/search/','','',
                '?a=georoute&n=1&gn=2&type=route,plan,indexes&method=optimal&traffic=false&x1=92.876454738&y1=56.010786602&x2=92.86645473&y2=56.010786602',1000) as n
  from rdb$database
