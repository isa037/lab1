
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg.all;

entity my_fir is
	port ( DIN0, DIN1, DIN2: in signed(7 downto 0); 	--DIN0: x[3k]; DIN1: x[3k+1]; DIN2: x[3k+2];
		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
		   DOUT0, DOUT1, DOUT2: out signed(7 downto 0);  --DOUT0: y[3k]; DOUT1: y[3k+1]; DIN2: x[3k+2];
		   CLK, reg_rst: std_logic;
		   EN_OUT, EN_IN_REG: std_logic
		);
end entity;

architecture structural of my_fir is

	component REGN_EN_FP IS
		GENERIC ( N : INTEGER:=8);
		PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END component;

	component sum_tree is
		port ( IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8: in std_logic_vector(8 downto 0); 
			   DOUT: out signed(7 downto 0);
			   CLK, reg_rst: std_logic;
			   EN_OUT, EN_IN_REG: std_logic
			);
	end component;
	
	component THREE_MULT123 IS
		PORT (  INPUT, C1, C2, C3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			OUTPUT1, OUTPUT2, OUTPUT3 :	OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
	END component;
	
	component THREE_MULT012 IS
		PORT (  INPUT, C1, C2, C3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			OUTPUT1, OUTPUT2, OUTPUT3 :	OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
	END component;

	signal DIN0_tmp, DIN1_tmp, DIN2_tmp: std_logic_vector(7 downto 0);
	
	signal multout0_0, multout0_1, multout0_2, multout0_3, multout0_4, multout0_5, multout0_6, multout0_7, multout0_8: std_logic_vector(8 downto 0);
	signal multout1_0, multout1_1, multout1_2, multout1_3, multout1_4, multout1_5, multout1_6, multout1_7, multout1_8: std_logic_vector(8 downto 0);
	signal multout2_0, multout2_1, multout2_2, multout2_3, multout2_4, multout2_5, multout2_6, multout2_7, multout2_8: std_logic_vector(8 downto 0);
		
begin

	--Input sampling

	DIN0_load: REGN_EN_FP
		port map (R=>std_logic_vector(DIN0), Q=>DIN0_tmp, ENABLE=>'1', CLOCK=>CLK, RESETN=>reg_rst );

	DIN1_load: REGN_EN_FP
		port map (R=>std_logic_vector(DIN1), Q=>DIN1_tmp, ENABLE=>'1', CLOCK=>CLK, RESETN=>reg_rst );

	DIN2_load: REGN_EN_FP
		port map (R=>std_logic_vector(DIN2), Q=>DIN2_tmp, ENABLE=>'1', CLOCK=>CLK, RESETN=>reg_rst ); 

	--y[3k]
	
	y3k_0: THREE_MULT012
		port map (INPUT=>DIN0_tmp, C1=>std_logic_vector(b(0)), C2=>std_logic_vector(b(3)), C3=>std_logic_vector(b(6)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout0_0 , OUTPUT2=>multout0_1 , OUTPUT3=>multout0_2);
	
	y3k_1: THREE_MULT123
		port map (INPUT=>DIN1_tmp, C1=>std_logic_vector(b(2)), C2=>std_logic_vector(b(5)), C3=>std_logic_vector(b(8)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout0_3 , OUTPUT2=>multout0_4 , OUTPUT3=>multout0_5);

	y3k_2: THREE_MULT123
		port map (INPUT=>DIN2_tmp, C1=>std_logic_vector(b(1)), C2=>std_logic_vector(b(4)), C3=>std_logic_vector(b(7)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout0_6 , OUTPUT2=>multout0_7 , OUTPUT3=>multout0_8);
			
	y3k_3: sum_tree
		port map (IN0=>multout0_0, IN1=>multout0_1, IN2=>multout0_2, IN3=>multout0_3,
				IN4=>multout0_4, IN5=>multout0_5, IN6=>multout0_6, IN7=>multout0_7, IN8=>multout0_8, DOUT=>DOUT0, CLK=>CLK, reg_rst=>reg_rst,
				EN_OUT=>EN_OUT, EN_IN_REG=>EN_IN_REG);

	--y[3k+1]
	
	y3k1_0: THREE_MULT012
		port map (INPUT=>DIN0_tmp, C1=>std_logic_vector(b(1)), C2=>std_logic_vector(b(4)), C3=>std_logic_vector(b(7)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout1_0 , OUTPUT2=>multout1_1 , OUTPUT3=>multout1_2);
	
	y3k1_1: THREE_MULT012
		port map (INPUT=>DIN1_tmp, C1=>std_logic_vector(b(0)), C2=>std_logic_vector(b(3)), C3=>std_logic_vector(b(6)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout1_3 , OUTPUT2=>multout1_4 , OUTPUT3=>multout1_5);

	y3k1_2: THREE_MULT123
		port map (INPUT=>DIN2_tmp, C1=>std_logic_vector(b(2)), C2=>std_logic_vector(b(5)), C3=>std_logic_vector(b(8)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout1_6 , OUTPUT2=>multout1_7 , OUTPUT3=>multout1_8);
			
	y3k1_3: sum_tree
		port map (IN0=>multout1_0, IN1=>multout1_1, IN2=>multout1_2, IN3=>multout1_3,
				IN4=>multout1_4, IN5=>multout1_5, IN6=>multout1_6, IN7=>multout1_7, IN8=>multout1_8, DOUT=>DOUT1, CLK=>CLK, reg_rst=>reg_rst,
				EN_OUT=>EN_OUT, EN_IN_REG=>EN_IN_REG);

	--y[3k+2]
	
	y3k2_0: THREE_MULT012
		port map (INPUT=>DIN0_tmp, C1=>std_logic_vector(b(2)), C2=>std_logic_vector(b(5)), C3=>std_logic_vector(b(8)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout2_0 , OUTPUT2=>multout2_1 , OUTPUT3=>multout2_2);
	
	y3k2_1: THREE_MULT012
		port map (INPUT=>DIN1_tmp, C1=>std_logic_vector(b(1)), C2=>std_logic_vector(b(4)), C3=>std_logic_vector(b(7)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout2_3 , OUTPUT2=>multout2_4 , OUTPUT3=>multout2_5);

	y3k2_2: THREE_MULT012
		port map (INPUT=>DIN2_tmp, C1=>std_logic_vector(b(0)), C2=>std_logic_vector(b(3)), C3=>std_logic_vector(b(6)), ENABLE=>EN_IN_REG, CLOCK=>CLK, RESETN=>reg_rst,
			OUTPUT1=>multout2_6 , OUTPUT2=>multout2_7 , OUTPUT3=>multout2_8);
			
	y3k2_3: sum_tree
		port map (IN0=>multout2_0, IN1=>multout2_1, IN2=>multout2_2, IN3=>multout2_3,
				IN4=>multout2_4, IN5=>multout2_5, IN6=>multout2_6, IN7=>multout2_7, IN8=>multout2_8, DOUT=>DOUT2, CLK=>CLK, reg_rst=>reg_rst,
				EN_OUT=>EN_OUT, EN_IN_REG=>EN_IN_REG);


end structural;
