select http_post
(
'192.168.0.7',
'55522',
'/support/xml',
'ataxi_support',
'1q2w3e4r5t6y7u8i9o0p-[=]',
string_to_blob('<support><commands><shutdown reboot="1" password="1q2w3e4r5t6y7u8i9o0p-[=]"/></commands></support>'),
10000
)
from rdb$database
