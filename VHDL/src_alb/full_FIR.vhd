library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg.all;
entity full_FIR is
port	(
           DIN: in signed(7 downto 0); 
		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
		   DOUT: out signed(7 downto 0);
		   CLK, RST_n, VIN: in std_logic;
		   VOUT: out std_logic
		   );
end entity;

architecture struct of full_FIR is

component my_fir is
	port ( DIN: in signed(7 downto 0); 
		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
		   DOUT: out signed(7 downto 0);
		   CLK, reg_rst: std_logic;
		   EN_OUT, EN_IN_REG: std_logic
		);
end component;

component control is
	port ( VIN, clk,reg_rst: in std_logic;
			VOUT, EN_OUT, EN_IN_REG: out std_logic );
end component;

signal EN_OUT_tmp, EN_IN_REG_tmp: std_logic;

begin
FIR: my_fir  port map (
	DIN=>DIN,
	DOUT=>DOUT,
	b=>b,
	CLK=>CLK,
	reg_rst=>RST_n,
	EN_OUT=>EN_OUT_tmp,
	EN_IN_REG=>EN_IN_REG_tmp);
		
	
controllo: control port map(
	VIN =>VIN,
	VOUT =>VOUT,
	clk=>CLK,
	EN_OUT=> EN_OUT_tmp,
	EN_IN_REG=> EN_IN_REG_tmp,
	reg_rst =>RST_n );
	

end struct;