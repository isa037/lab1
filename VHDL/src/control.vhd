
library ieee;
use ieee.std_logic_1164.all;

entity control is

	port ( VIN, clk,reg_rst: in std_logic;
			VOUT, EN_OUT, EN_IN_REG: out std_logic );
end entity;

architecture behavioural of control is

	signal EN_IN_REG_tmp, EN_OUT_tmp, VOUT_tmp  : std_logic;

begin

	first_reg: process(clk)
	begin
	if (reg_rst='0') then
		EN_IN_REG_tmp<= '0';
	elsif (clk'event and clk='1') then
		EN_IN_REG_tmp<=VIN;
	--else
	--	EN_IN_REG_tmp<=EN_IN_REG_tmp;
	end if;
	end process;
	
	second_reg: process(clk)
	begin
	if (reg_rst='0') then
		EN_OUT_tmp<= '0';
	elsif (clk'event and clk='1') then
		EN_OUT_tmp<=EN_IN_REG_tmp;
	--else
	--	EN_OUT_tmp<=EN_OUT_tmp;
	end if;
	end process;

	third_reg: process(clk)
	begin
	if (reg_rst='0') then
		VOUT_tmp<= '0';
	elsif (clk'event and clk='1') then
		VOUT_tmp<=EN_OUT_tmp;
	--else
	--	VOUT_tmp<=VOUT_tmp;
	end if;
	end process;
	
	EN_IN_REG<=EN_IN_REG_tmp;
	EN_OUT<=EN_OUT_tmp;
	VOUT<=VOUT_tmp;

end behavioural;

