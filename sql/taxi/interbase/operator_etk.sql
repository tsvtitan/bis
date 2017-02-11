select t.num, t.contact
from
(
select contact,
       CAST(DECODE(SUBSTRING(CONTACT FROM 1 FOR 3),'+79',SUBSTRING(CONTACT FROM 3 FOR 6),NULL) AS INTEGER) AS NUM
  from out_messages
where
    date_out is null
--and SUB_STRING(contact,1,3)='+79'
--and STRING_LENGTH(contact)=12
--and
--  (
--      contact like '+7901111%'
/*   or contact like '+7901240%'
   or contact like '+7901241%'
   or contact like '+7901621%'
   or contact like '+7901646%'
   or contact like '+7901647%'
   or contact like '+7901911%'
   
   or contact like '+7902010%'
   or contact like '+7902011%'
   or contact like '+7902012%'
   or contact like '+7902013%'
   or contact like '+7902014%'
   or contact like '+7902467%'
   or contact like '+7902468%'
   or contact like '+7902550%'
   or contact like '+7902551%'
   or contact like '+7902552%'
   or contact like '+7902910%'
   or contact like '+7902911%'
   or contact like '+7902912%'
   or contact like '+7902913%'
   or contact like '+7902914%'
   or contact like '+7902915%'
   or contact like '+7902916%'
   or contact like '+7902917%'
   or contact like '+7902918%'
   or contact like '+7902919%'
   or contact like '+7902920%'
   or contact like '+7902921%'
   or contact like '+7902922%'
   or contact like '+7902923%'
   or contact like '+7902924%'
   or contact like '+7902925%'
   or contact like '+7902926%'
   or contact like '+7902927%'
   or contact like '+7902928%'
   or contact like '+7902929%'
   or contact like '+7902940%'
   or contact like '+7902941%'
   or contact like '+7902942%'
   or contact like '+7902944%'
   or contact like '+7902945%'
   or contact like '+7902946%'
   or contact like '+7902947%'
   or contact like '+7902948%'
   or contact like '+7902949%'
   or contact like '+7902950%'
   or contact like '+7902951%'
   or contact like '+7902952%'   */
--   or contact like '+7902956%' /* 956-982*/
 /*   (CAST(DECODE(SUBSTRING(CONTACT FROM 1 FOR 3),'+79',SUBSTRING(CONTACT FROM 3 FOR 6),NULL) AS INTEGER)>=902956 and
       CAST(DECODE(SUBSTRING(CONTACT FROM 1 FOR 3),'+79',SUBSTRING(CONTACT FROM 3 FOR 6),NULL) AS INTEGER)<=902982)
  
/*   or contact like '+7902990%'
   or contact like '+7902991%'
   or contact like '+7902992%'
   or contact like '+7902996%'
 */
--   or contact like '+7904890%' /* 890-899*/
   
--   or contact like '+7908010%' /* 010-026*/
--   or contact like '+7908030%' /* 030-034*/
--   or contact like '+7908220%' /* 220-224*/
--   or contact like '+7908325%' /* 325-327*/

--   or contact like '+7950302%' /* 302-307*/
--   or contact like '+7950400%'
--   or contact like '+7950401%'
--   or contact like '+7950402%'
--   or contact like '+7950403%'
--   or contact like '+7950964%' /* 964-966*/
--   or contact like '+7950967%'
--   or contact like '+7950968%'
--   or contact like '+7950970%' /* 970-999 */

--   or contact like '+7952745%' /* 745-749 */

--   or contact like '+7953255%' /* 255-259 */
--   or contact like '+7953580%' /* 580-599 */
--   )
) t
where
t.num is not null
and (
      contact like '+7901111%'
   or contact like '+7901240%'
   or contact like '+7901241%'
   or contact like '+7901621%'
   or contact like '+7901646%'
   or contact like '+7901647%'
   or contact like '+7901911%'
   or contact like '+7902010%'
   or contact like '+7902011%'
   or contact like '+7902012%'
   or contact like '+7902013%'
   or contact like '+7902014%'
--   or contact like '+7902467%'
--   or contact like '+7902468%'
   or contact like '+7902550%'
   or contact like '+7902551%'
   or contact like '+7902552%'
   or contact like '+7902910%'
   or contact like '+7902911%'
   or contact like '+7902912%'
   or contact like '+7902913%'
   or contact like '+7902914%'
   or contact like '+7902915%'
   or contact like '+7902916%'
   or contact like '+7902917%'
   or contact like '+7902918%'
   or contact like '+7902919%'
   or contact like '+7902920%'
   or contact like '+7902921%'
   or contact like '+7902922%'
   or contact like '+7902923%'
   or contact like '+7902924%'
   or contact like '+7902925%'
   or contact like '+7902926%'
   or contact like '+7902927%'
   or contact like '+7902928%'
   or contact like '+7902929%'
   or contact like '+7902940%'
   or contact like '+7902941%'
   or contact like '+7902942%'
   or contact like '+7902944%'
   or contact like '+7902945%'
   or contact like '+7902946%'
   or contact like '+7902947%'
   or contact like '+7902948%'
   or contact like '+7902949%'
   or contact like '+7902950%'
   or contact like '+7902951%'
   or contact like '+7902952%'   
   or (num>=902956 and num<=902982)
   or contact like '+7902990%'
   or contact like '+7902991%'
   or contact like '+7902992%'
 --  or contact like '+7902996%'
   or (num>=904890 and num<=904899)
   or (num>=908010 and num<=908026)
   or (num>=908030 and num<=908034)
   or (num>=908220 and num<=908224)
--   or (num>=908325 and num<=908327)
--   or (num>=950302 and num<=950307)
   or (num>=950400 and num<=950403)
--   or (num>=950964 and num<=950966)
   or contact like '+7950967%'
   or contact like '+7950968%'
   or (num>=950970 and num<=950999)
--   or (num>=952745 and num<=952749)
--   or (num>=953255 and num<=953259)
   or (num>=953580 and num<=953599)
)


