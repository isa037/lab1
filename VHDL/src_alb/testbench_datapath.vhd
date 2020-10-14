library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;

entity testbench_datapath is 
end entity ; 

architecture cpk of testbench_datapath is 
component my_fir is
port  ( DIN: in signed(7 downto 0); 
		   b: in array8(8 downto 0);	--Coefficienti
		   DOUT: out signed(7 downto 0);
		   CLK, reg_rst:in std_logic;
		   EN_OUT: in std_logic;
		   EN_IN_REG:in std_logic
		);
end component;

component coeffs is
port(b:  OUT array8(0 to 8));
end component;

signal DIN_test: signed(7 downto 0); 
signal b_test: array8(8 downto 0);	--Coefficienti
signal DOUT_test: signed(7 downto 0);
signal CLK_test, reg_rst_test: std_logic;
signal EN_OUT_test: std_logic;
signal EN_IN_REG_test: std_logic;
	
begin

coefficienti: coeffs port map (
	b(0)=>b_test(0), b(1)=>b_test(1), b(2)=>b_test(2), b(3)=>b_test(3), b(4)=>b_test(4), b(5)=>b_test(5), b(6)=>b_test(6), b(7)=>b_test(7), b(8)=>b_test(8)
);

FIR : my_fir port map (
DIN => DIN_test,
b => b_test,
DOUT => DOUT_test,
reg_rst=> reg_rst_test,
EN_OUT=> EN_OUT_test,
EN_IN_REG=> EN_IN_REG_test, 
CLK=> CLK_test);
clock_gen : process
		begin
			CLK_test<='0';
			wait for 0.5 ns;
			CLK_test<='1';
			
			wait for 0.5 ns;
	end process;
stimuli: process 
begin 
--idle con reg_rst attivo
--b_test<="100000000";
reg_rst_test<='1';
DIN_test<="00000000";
EN_IN_REG_test<='0';
EN_OUT_test<='0';
wait for 1 ns ;
--idle con reg_rst disattivo
--b_test<="00000010";
reg_rst_test<='0';
DIN_test<="00000000";
EN_IN_REG_test<='0';
EN_OUT_test<='0';
wait for 1 ns;
--shifting 
	--primo dato in ingresso
	
	reg_rst_test<='0';
	DIN_test<="00001000";
	EN_IN_REG_test<='1';
	EN_OUT_test<='0'; 
	wait for 1 ns;
	--secondo dato in ingresso
	
	reg_rst_test<='0';
	DIN_test<="00000010";
	EN_IN_REG_test<='1';
	EN_OUT_test<='0';
	wait for 1 ns;
-- wait
    --b_test<="000100000";
	reg_rst_test<='0';
	DIN_test<="00000011";
	EN_IN_REG_test<='0';
	EN_OUT_test<='0';
	wait for 1 ns;
-- ritorno nello shifting
	--terzo dato in ingresso
	--b_test<="001000000";
	reg_rst_test<='0';
	DIN_test<="00000011";
	EN_IN_REG_test<='1';
	EN_OUT_test<='0';
	wait for 1 ns;
-- regime 
--b_test<="010000000";
reg_rst_test<='0';
DIN_test<="00000011";
EN_IN_REG_test<='1';
EN_OUT_test<='1';
wait for 1 ns;
--idle con reg_rst attivo
--b_test<="011111111";
reg_rst_test<='1';
DIN_test<="00000000";
EN_IN_REG_test<='1';
EN_OUT_test<='1';
wait for 10 ns;
reg_rst_test<='0';
wait for 1 ns;
DIN_test<=to_signed(0,8);
wait for 1 ns;
DIN_test<=to_signed(39,8);
wait for 1 ns;
DIN_test<=to_signed(0,8);
wait for 1 ns;
DIN_test<=to_signed(103,8);
wait for 1 ns;
DIN_test<=to_signed(0,8);
wait for 1 ns;
DIN_test<=to_signed(127,8);
wait for 1 ns;
DIN_test<=to_signed(-1,8);
wait for 1 ns;
DIN_test<=to_signed(103,8);
wait for 1 ns;
DIN_test<=to_signed(-1,8);
wait for 1 ns;
DIN_test<=to_signed(39,8);
wait for 1 ns;
DIN_test<=to_signed(-1,8);
wait for 1 ns;
DIN_test<=to_signed(-40,8);
wait for 1 ns;
DIN_test<=to_signed(-1,8);
wait for 1 ns;
DIN_test<=to_signed(-104,8);
wait for 1 ns;
DIN_test<=to_signed(-1,8);
wait for 1 ns;
DIN_test<=to_signed(-128,8);
wait for 1 ns;
DIN_test<=to_signed(0,8);
wait for 1 ns;
DIN_test<=to_signed(-104,8);
wait;

end process;
end cpk;