select '13FCA4E7C4DEBC764E68E0DB403D2520' as account_id,
       (case
         when name like 'Квартиры%' then 'E39C9F906766ADFD4EFB456CD9954110'
         when name like 'Гаражи%' then '57A68A886F6FB9494E7654104F06984F'
         when name like 'Дачи%' then 'A636412AA55C83774BC65F32E1F735E7'
         when name like 'Загородние дома%' then 'F96E23A585B4A0524B7516CD021D1D61'
         when name like 'Здания%' then 'C58D99195DC896CE4DC68042324D49FA'
         when name like 'Новостройки%' then '041A24C573F0811048AE3AC4BC1AA9B0'
         when name like 'Производства%' then '8F6DF19321BC91FF4B730E301C73BF69'
         when name like 'Рестораны, кафе%' then '98355291AF3DA5BD4F1D0571EEBFFEF6'
         when name like 'Склады, базы%' then 'D2A7B184DB49BCE04D7523B9D00B6E2B'
         when name like 'Таунхаусы%' then 'E97F9E7E469F946A4D785DAE8065AB4C'
         when name like 'Торговые помещения%' then 'AD7FB1A7A902ACFC4B07D9F675632BB2'
         when name like 'Частные дома%' then '82BB537F2358BE7E4DD45F921F2EFED0'
         else NULL
        end) as type_id,
       (case
         when name like '%продам' then '9BB38FBAEE8B88A54FD02C983AE5C607'
         when name like '%куплю' then 'A7D600213026BBCE43F7B4676A8DC7F1'
         when name like '%сдам' then '31B977EB8E80ABEB4BB4215FD6777072'
         when name like '%сниму' then '8B5206B8E53DB842408847A0C46E0A1D'
         when name like '%обменяю' then 'D5F0B39F9E48A9304EA0A28ABFA2132F'
         else NULL
        end) as operation_id 
  from presentations

