
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg.all;

entity my_fir is
	port ( DIN: in signed(7 downto 0); 
		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
		   DOUT: out signed(7 downto 0);
		   CLK, reg_rst: std_logic;
		   EN_OUT, EN_IN_REG: std_logic
		);
end entity;

architecture behavioural of my_fir is

	type reg8_type is array(0 to 8) of signed(8 downto 0);
	type internal_type is array(0 to 8) of signed(7 downto 0);
	type sum_type is array (0 to 7) of signed(8 downto 0);
	type mult_type is array (0 to 8) of signed (15 downto 0);
	signal x_mult_long: mult_type;
	signal x_int : internal_type;
	signal x_mult : reg8_type;
	signal x_sum: sum_type;
	signal DOUT_tmp : signed(7 downto 0);
	

	
begin
	
	--Combinatorial logic
	
	--Moltiplicazioni
	
	prodotti: for I in 0 to 8 generate
	begin
		x_mult_long(I)<=x_int(I) * b(I);
	end generate prodotti;
	
	scarto_mult: for I in 0 to 8 generate
	begin
		x_mult(I)<=x_mult_long(I)(15 downto 7);
	end generate;
	
	--Somme
		
	x_sum(0)<=x_mult(1)+x_mult(0);
		
	somme: for I in 1 to 7 generate
	begin
		x_sum(I)<=x_sum(I-1)+x_mult(I+1);
	end generate;
	

	shifting: process(clk)		--Shift register 8x8
	begin
	if (reg_rst='0')then
	    x_int(1 to 8)<= (others=>"00000000") ;
		elsif(clk'event and clk='1')  then
			if (EN_IN_REG='1') then
				x_int(1 to 8)<= x_int(0 to 7);
			else
				x_int(1 to 8)<=x_int(1 to 8);
			end if;
	end if;
	end process;


	loading: process(clk)
	begin
	if (reg_rst='0') then
		x_int(0)<= (others=>'0');
	elsif (clk'event and clk='1') then
			x_int(0)<=DIN;
	end if;
	end process;
	
	saving: process(clk)
	begin
	if (reg_rst='0') then
		DOUT_tmp<= (others=>'0');
		elsif (clk'event and clk='1') then
			if (EN_OUT = '1') then
				DOUT_tmp<=x_sum(7)(7 downto 0);
			else
				DOUT_tmp<=DOUT_tmp;
		    end if;
	end if;
	end process;
	
	DOUT<=DOUT_tmp;

end behavioural;
