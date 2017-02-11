select get_unique_id()

call i_type ('E39C9F906766ADFD4EFB456CD9954110','Квартира','Квартира',1)
call i_type ('82BB537F2358BE7E4DD45F921F2EFED0','Частный дом','Частный дом',2)
call i_type ('A636412AA55C83774BC65F32E1F735E7','Дача','Дача',3);
call i_type ('F96E23A585B4A0524B7516CD021D1D61','Загородний дом','Загородний дом',4);
call i_type ('E97F9E7E469F946A4D785DAE8065AB4C','Таунхаус','Таунхаус',5);
call i_type ('FF514D63F9EF8E384751FA1CECEEC2BB','Офис','Офис',6);
call i_type ('C58D99195DC896CE4DC68042324D49FA','Отдельно стоящее здание','Отдельно стоящее здание',7);
call i_type ('98355291AF3DA5BD4F1D0571EEBFFEF6','Ресторан, кафе','Ресторан, кафе',8);
call i_type ('AD7FB1A7A902ACFC4B07D9F675632BB2','Торговые помещения','Торговые помещения',9);
call i_type ('57A68A886F6FB9494E7654104F06984F','Гаражи','Гаражи',10);
call i_type ('8F6DF19321BC91FF4B730E301C73BF69','Производство','Производство',11);
call i_type ('D2A7B184DB49BCE04D7523B9D00B6E2B','Склады, базы','Склады, базы',12);


select * from s_types order by priority