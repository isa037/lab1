LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.pkg.all;

entity coeffs is
port(	b:  OUT array8(0 to 8));
end coeffs;
 
-- Coefficienti {-1, -2, 6, 34, 51, 34, 6, -2, -1}

architecture behavioural of coeffs is
begin 
b(0)<= to_signed(-1,8);
b(1)<= to_signed(-2,8);
b(2)<= to_signed(6,8);
b(3)<= to_signed(34,8);
b(4)<= to_signed(51,8);
b(5)<= to_signed(34,8);
b(6)<= to_signed(6,8);
b(7)<= to_signed(-2,8);
b(8)<= to_signed(-1,8); 
end behavioural;