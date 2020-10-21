
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

architecture structural of my_fir is

	component REG_EN_FP IS
		GENERIC ( N : INTEGER:=8);
		PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END component;

	component ADDER IS
		GENERIC ( N : INTEGER:=9);
		PORT (	A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				OUTPUT :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END component;

	component MULTIPLIER IS
		GENERIC ( N, M : INTEGER:=24);
		PORT (	A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				B : IN signed(M-1 DOWNTO 0);
				OUTPUT :	OUT STD_LOGIC_VECTOR(M+N-1 DOWNTO 0));
	END component;

	type 9da9 is array (0 to 8) of std_logic_vector(8 downto 0);
	signal pipe1_in, pipe1_out : 9da9;
	type 5da9 is array (0 to 4) of std_logic_vector(8 downto 0);
	signal pipe2_in, pipe2_out : 5da9;
	type 3da9 is array (0 to 2) of std_logic_vector(8 downto 0);
	signal pipe3_in, pipe3_out : 3da9;
	type 2da9 is array (0 to 1) of std_logic_vector(8 downto 0);
	signal pipe4_in, pipe4_out : 2da9;
	type 4da9 is array (0 to 3) of std_logic_vector(8 downto 0);
	signal somma1_out : 4da9;
	signal somma1_inA, somma1_inB : 4da9;
	type 2da9 is array (0 to 1) of std_logic_vector(8 downto 0);
	signal somma2_out : 2da9;
	signal somma2_inA, somma2_inB : 2da9;

	signal somma3_inA, somma3_inB, somma3_outA: std_logic_vector(8 downto 0);
	signal somma4_inA, somma4_inB, somma4_outA: std_logic_vector(8 downto 0);
	signal DOUT_tmp: std_logic_vector(8 downto 0);

	type 9da8 is array(0 to 8) of std_logic_vector(7 downto 0);
	signal mult1_inA: 9da8;
	type 9da15 is array(o to 8) of std_logic_vector(15 downto 0);
	signal mult1_out: 9da15;
	signal x_int: 9da8;

begin
	
	--Componenti
	
	pipe1: for I in 0 to 8 generate
	begin
		pipe1_reg: REG_EN_FP 
			generic map (N=>9);
			port map (R=> pipe1_in(I), Q=>pipe1_out(I),ENABLE=>EN_IN_REG,CLOCK=>CLK,RESETN=>reg_rst);
	end generate pipe1;

	somma1: for I in 0 to 3 generate
	begin
		somma1_sum: ADDER
			port map ( A=>somma1_inA(I) , B=>somma1_inB(I) ,OUTPUT => somma1_out);
	end generate somma1;

	pipe2: for I in 0 to 4 generate
	begin
		pipe2_reg: REG_EN_FP 
			generic map (N=>9);
			port map (R=> pipe2_in(I), Q=>pipe2_out(I),ENABLE=>EN_IN_REG,CLOCK=>CLK,RESETN=>reg_rst);
	end generate pipe2;

	somma2: for I in 0 to 1 generate
	begin
		somma2_sum: ADDER
			port map ( A=>somma2_inA(I) , B=>somma2_inB(I) ,OUTPUT => somma2_out);
	end generate somma2;

	pipe3: for I in 0 to 2 generate
	begin
		pipe3_reg: REG_EN_FP 
			generic map (N=>9);
			port map (R=> pipe3_in(I), Q=>pipe3_out(I),ENABLE=>EN_IN_REG,CLOCK=>CLK,RESETN=>reg_rst);
	end generate pipe3;

	somma3_sum: ADDER
		port map (A=> somma3_inA, somma3_inB, OUTPUT=> somma3_out);

	pipe4: for I in 0 to 1 generate
	begin
		pipe4_reg: REG_EN_FP 
			generic map (N=>9);
			port map (R=> pipe4_in(I), Q=>pipe4_out(I),ENABLE=>EN_IN_REG,CLOCK=>CLK,RESETN=>reg_rst);
	end generate pipe4;

	somma4_sum: ADDER
		port map (A=> somma4_inA, somma4_inB, OUTPUT=> somma4_out);

	mult1: for I in 0 to 8 generate
	begin
		mult1_mult: MULTIPLIER
			generic map (N=>8, M=>8);
			port map (A=>mult1_inA(I), B=>b(I), OUTPUT=> mult1_out(I));
	end generate mult1;

	loading: REG_EN_FP
		generic map (N=>8);
		port map (R=> DIN, Q=>x_int(0), ENABLE=>'1', CLOCK=>CLK, RESETN=>reg_reset);

	saving: REG_EN_FP
		generic map (N=>9);
		port map (R=> somma4_out, Q=>DOUT_tmp, ENABLE=>EN_OUT, CLOCK=>CLK, RESETN=>reg_reset);

	shift_reg: for I in 0 to 7 generate
	begin
		shift_reg_reg: REG_EN_FP
			generic map (N=>8);
			port map (R=>x_int(I), Q=>x_int(I+1), ENABLE=>EN_IN_REG,CLOCK=>CLK,RESETN=>reg_rst);
	end generate shift_reg;

	--Collegamenti

	x_int<=mult1_inA;
	pipe1_in<=mult1_out(15 downto 7);
	somma1_inA(0)<=pipe1_out(0);
	somma1_inB(0)<=pipe1_out(1);
	somma1_inA(1)<=pipe1_out(2);
	somma1_inB(1)<=pipe1_out(3);
	somma1_inA(2)<=pipe1_out(4);
	somma1_inB(2)<=pipe1_out(5);
	somma1_inA(3)<=pipe1_out(6);
	somma1_inB(3)<=pipe1_out(7);
	pipe2_in(4)<=pipe1_out(8);

	pipe2_in(0 to 3)<=somma1_out;

	somma2_inA(0)<=pipe2_out(0);
	somma2_inB(0)<=pipe2_out(1);
	somma2_inA(1)<=pipe2_out(2);
	somma2_inB(1)<=pipe2_out(3);

	pipe3_in(2)<=pipe2_out(4);

	pipe3_in(0 to 1)<=somma2_out;

	somma3_inA<=pipe3_out(0);
	somma3_inB<=pipe3_out(1);
	pipe4_in(0)<=somma3_out;
	pipe4_in(1)<=pipe3_out(2);

	somma4_inA<=pipe4_out(0);
	somma4_inB<=pipe4_out(1);
	
	DOUT<=DOUT_tmp(7 downto 0);
	

end structural;
