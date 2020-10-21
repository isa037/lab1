library ieee;
use ieee.std_logic_1164.all;

entity control is
	port ( VIN, clk,reg_rst: in std_logic;
		   VOUT, EN_OUT, EN_IN_REG: out std_logic );
end entity;

architecture structural of control is

	COMPONENT FFN_EN_FP IS
		PORT (R : IN STD_LOGIC;
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT STD_LOGIC);
	END COMPONENT;
	
	signal ctrl: std_logic_vector(6 downto 0);

begin

	control_sr: for I in 0 to 5 generate
	begin
		control_reg: FFN_EN_FP
			port map (R=>ctrl(I), Q=>ctrl(I+1), ENABLE=>'1',CLOCK=>CLK,RESETN=>reg_rst);
	end generate control_sr;
	
	ctrl(0)<=VIN;
	EN_IN_REG<=ctrl(1);
	EN_OUT<=ctrl(5);
	VOUT<=ctrl(6);

end structural;

