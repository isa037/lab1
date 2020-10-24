library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg.all;
entity full_FIR is
port	(
         DIN0, DIN1, DIN2: in signed(7 downto 0); 
		   b0,b1,b2,b3,b4,b5,b6,b7,b8: in std_logic_vector (7 downto 0);	--9 Coefficienti da 8 bit
		   DOUT0, DOUT1, DOUT2: out signed(7 downto 0);
		   CLK, RST_n, VIN: in std_logic;
		   VOUT: out std_logic
		   );
end entity;

architecture struct of full_FIR is

component my_fir is
	port ( DIN0, DIN1, DIN2: in signed(7 downto 0); 	--DIN0: x[3k]; DIN1: x[3k+1]; DIN2: x[3k+2];
		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
		   DOUT0, DOUT1, DOUT2: out signed(7 downto 0);  --DOUT0: y[3k]; DOUT1: y[3k+1]; DIN2: x[3k+2];
		   CLK, reg_rst: std_logic;
		   EN_OUT, EN_IN_REG: std_logic
		);
end component;

component control is
	port ( VIN, clk,reg_rst: in std_logic;
			VOUT, EN_OUT, EN_IN_REG: out std_logic );
end component;

signal EN_OUT_tmp, EN_IN_REG_tmp: std_logic;
signal coeff_array : array8(8 downto 0);

begin
coeff_array(0)<= signed(b0);
coeff_array(1)<= signed(b1);
coeff_array(2)<= signed(b2);
coeff_array(3)<= signed(b3);
coeff_array(4)<= signed(b4);
coeff_array(5)<= signed(b5);
coeff_array(6)<= signed(b6);
coeff_array(7)<= signed(b7);
coeff_array(8)<= signed(b8);

FIR: my_fir  port map (
	DIN0=>DIN0,
	DOUT0=>DOUT0,
	DIN1=>DIN1,
	DOUT1=>DOUT1,
	b=>coeff_array,
	DIN2=>DIN2,
	DOUT2=>DOUT2,
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
