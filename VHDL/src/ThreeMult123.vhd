LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY THREE_MULT123 IS
	PORT (  INPUT, C1, C2, C3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			OUTPUT1, OUTPUT2, OUTPUT3 :	OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END THREE_MULT123;

ARCHITECTURE STRUCTURAL OF THREE_MULT123 IS

	COMPONENT REGN_EN_FP IS
		GENERIC ( N : INTEGER:=8);
		PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT MULTIPLIER IS
		GENERIC ( N, M, K : INTEGER:=24);
		PORT (	A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				B : IN signed(M-1 DOWNTO 0);
				OUTPUT :	OUT STD_LOGIC_VECTOR(K-1 DOWNTO 0));
	END COMPONENT;
	
	signal output1_tmp : std_logic_vector(7 downto 0);
	type ThreeOfEight is array(0 to 2) of std_logic_vector(7 downto 0);
	signal output2_tmp : ThreeOfEight;
	type FourOfEight is array(0 to 3) of std_logic_vector(7 downto 0);
	signal output3_tmp : FourOfEight;

BEGIN

	--First mult, reg
	REG1: REGN_EN_FP
		generic map(N=>8)
		port map( R=>INPUT, Q=>output1_tmp ,ENABLE=>ENABLE, CLOCK=>CLOCK, RESETN=>RESETN);

	--First Product
	MULT1: MULTIPLIER
		generic map(N=>8, M=>8, K=>9)
		port map (A=>output1_tmp, B=>signed(C1), OUTPUT=>OUTPUT1);

	--Second mult, sr
		
	SR2: for I in 0 to 1 generate
	begin
		SR2_REG: REGN_EN_FP
			generic map (N=>8)
			port map (R=>output2_tmp(I), Q=>output2_tmp(I+1), ENABLE=>ENABLE,CLOCK=>CLOCK,RESETN=>RESETN);
	end generate SR2;
		

	output2_tmp(0)<=INPUT;

	--Second Product
	MULT2: MULTIPLIER
		generic map(N=>8, M=>8, K=>9)
		port map (A=>output2_tmp(2), B=>signed(C2), OUTPUT=>OUTPUT2);
		
	--Third mult, sr
		
	SR3: for I in 0 to 2 generate
	begin
		SR3_REG: REGN_EN_FP
			generic map (N=>8)
			port map (R=>output3_tmp(I), Q=>output3_tmp(I+1), ENABLE=>ENABLE,CLOCK=>CLOCK,RESETN=>RESETN);
	end generate SR3;
		

	output3_tmp(0)<=INPUT;

	--Third Product
	MULT3: MULTIPLIER
		generic map(N=>8, M=>8, K=>9)
		port map (A=>output3_tmp(3), B=>signed(C3), OUTPUT=>OUTPUT3);
	

END STRUCTURAL;


