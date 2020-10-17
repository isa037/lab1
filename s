diff --git a/VHDL/VHDL_FIR/Datapath_FIR.png b/VHDL/VHDL_FIR/Datapath_FIR.png
deleted file mode 100644
index 77b14ad..0000000
Binary files a/VHDL/VHDL_FIR/Datapath_FIR.png and /dev/null differ
diff --git a/VHDL/VHDL_FIR/MACCHINA A STATI.pub b/VHDL/VHDL_FIR/MACCHINA A STATI.pub
deleted file mode 100644
index d5fc55c..0000000
Binary files a/VHDL/VHDL_FIR/MACCHINA A STATI.pub and /dev/null differ
diff --git a/VHDL/VHDL_FIR/src/STATE_MACHINE.vhd b/VHDL/VHDL_FIR/src/STATE_MACHINE.vhd
deleted file mode 100644
index 9dc778c..0000000
--- a/VHDL/VHDL_FIR/src/STATE_MACHINE.vhd
+++ /dev/null
@@ -1,116 +0,0 @@
-LIBRARY IEEE;
-USE IEEE.STD_LOGIC_1164.ALL;
-USE IEEE.NUMERIC_STD.ALL;
-
-ENTITY FILTER_STATE_MACHINE IS
-		PORT (	VIN, CLOCK, RST_n				: IN STD_LOGIC;
-				VOUT,EN_INPUT_REG,EN_OUTPUT		: OUT STD_LOGIC;
-				);
-END ENTITY FILTER_STATE_MACHINE;
-
-ARCHITECTURE BEHAVIORAL OF FILTER_STATE_MACHINE IS
-	TYPE STATE_MACHINE IS (IDLE, FIRST_DATA_RECEIVED, SECOND_DATA_RECEIVED, THIRD_DATA_RECEIVED, PROCESS_ONE_DATA, ENDING_PROCESS_DATA, END_PROCESS_DATA,SPURIUS_DATA_RECEIVED);
-	SIGNAL Y_PR, Y_NX: STATE_MACHINE;
-
-BEGIN
--------------------------------------------------------------------------------------------------------------
------------------------------------------FINITE--STATE--MACHINE----------------------------------------------
--------------------------------------------------------------------------------------------------------------
-	--STATE UPDATE
-	PROCESS (CLOCK,RST_n )
-	BEGIN
-	IF RST_n='0' THEN
-		Y_PR<=IDLE;
-	ELSIF (CLOCK'EVENT AND CLOCK='1') THEN   
-				Y_PR<=Y_NX;
-		END IF;
-	END PROCESS;
-	--STATE TABLE
-	PROCESS ( Y_PR, VIN)
-	BEGIN
-		CASE Y_PR IS 
-			WHEN IDLE 					=>	IF VIN='1' THEN
-													Y_NX<=FIRST_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=IDLE;
-												END IF;
-							
-			WHEN FIRST_DATA_RECEIVED	=> IF VIN='1' THEN
-												Y_NX<=SECOND_DATA_RECEIVED;
-											ELSE 
-												Y_NX<=PROCESS_ONE_DATA;
-											END IF;
-			
-			WHEN SECOND_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=THIRD_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=ENDING_PROCESS_DATA;
-												END IF;
-			
-			WHEN THIRD_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=THIRD_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=ENDING_PROCESS_DATA;
-												END IF;
-												
-			WHEN ENDING_PROCESS_DATA	=> IF VIN='1' THEN
-													Y_NX<=SPURIUS_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=END_PROCESS_DATA;
-												END IF;
-			
-			WHEN END_PROCESS_DATA		=> IF VIN='1' THEN
-													Y_NX<=FIRST_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=IDLE;
-												END IF;
-			
-			WHEN PROCESS_ONE_DATA		=> IF VIN='1' THEN
-													Y_NX<=SPURIUS_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=END_PROCESS_DATA;
-												END IF;	
-			
-			WHEN SPURIUS_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=SECOND_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=PROCESS_ONE_DATA;
-												END IF;	
-												
-			WHEN OTHERS => Y_NX<=IDLE;				
-		END CASE;
-	END PROCESS; 
-   --OUTPUT GENERATION
-	PROCESS (Y_PR)
-	BEGIN
-	EN_OUTPUT <='0';
-	EN_INPUT_REG <='0';
-	VOUT <='0';
-	CASE Y_PR IS 
-			WHEN IDLE 					=>	EN_INPUT_REG <= '0';--DO NOTHING
-							
-			WHEN FIRST_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-			
-			WHEN SECOND_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-											EN_OUTPUT <= '1';
-											
-			
-			WHEN THIRD_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-											EN_OUTPUT <= '1';
-											VOUT <= '1';
-												
-			WHEN ENDING_PROCESS_DATA	=> EN_OUTPUT <= '1';
-											VOUT <= '1';
-			
-			WHEN END_PROCESS_DATA		=> VOUT <= '1';
-			
-			WHEN PROCESS_ONE_DATA		=> EN_OUTPUT <= '1';
-											
-											
-			WHEN SPURIUS_DATA_RECEIVED  => EN_INPUT_REG <= '1';
-											VOUT <= '1';
-									
-		END CASE;
-	END PROCESS; 	
-
-END BEHAVIORAL;
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/src/coeffs.vhd b/VHDL/VHDL_FIR/src/coeffs.vhd
deleted file mode 100644
index 263e554..0000000
--- a/VHDL/VHDL_FIR/src/coeffs.vhd
+++ /dev/null
@@ -1,25 +0,0 @@
-LIBRARY IEEE;
-USE ieee.std_logic_1164.all;
-USE ieee.numeric_std.all;
-
-library work;
-use work.pkg.all;
-
-entity coeffs is
-port(	b:  OUT array8(0 to 8));
-end coeffs;
- 
--- Coefficienti {-1, -2, 6, 34, 51, 34, 6, -2, -1}
-
-architecture behavioural of coeffs is
-begin 
-b(0)<= to_signed(-1,8);
-b(1)<= to_signed(-2,8);
-b(2)<= to_signed(6,8);
-b(3)<= to_signed(34,8);
-b(4)<= to_signed(51,8);
-b(5)<= to_signed(34,8);
-b(6)<= to_signed(6,8);
-b(7)<= to_signed(-2,8);
-b(8)<= to_signed(-1,8); 
-end behavioural;
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/src/control.vhd b/VHDL/VHDL_FIR/src/control.vhd
deleted file mode 100644
index 979b92b..0000000
--- a/VHDL/VHDL_FIR/src/control.vhd
+++ /dev/null
@@ -1,55 +0,0 @@
-
-library ieee;
-use ieee.std_logic_1164.all;
-
-entity control is
-
-	port ( VIN, clk,reg_rst: in std_logic;
-			VOUT, EN_OUT, EN_IN_REG: out std_logic );
-end entity;
-
-architecture behavioural of control is
-
-	signal EN_IN_REG_tmp, EN_OUT_tmp, VOUT_tmp  : std_logic;
-
-begin
-
-	first_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		EN_IN_REG_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		EN_IN_REG_tmp<=VIN;
-	else
-		EN_IN_REG_tmp<=EN_IN_REG_tmp;
-	end if;
-	end process;
-	
-	second_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		EN_OUT_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		EN_OUT_tmp<=EN_IN_REG_tmp;
-	else
-		EN_OUT_tmp<=EN_OUT_tmp;
-	end if;
-	end process;
-
-	third_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		VOUT_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		VOUT_tmp<=EN_OUT_tmp;
-	else
-		VOUT_tmp<=VOUT_tmp;
-	end if;
-	end process;
-	
-	EN_IN_REG<=EN_IN_REG_tmp;
-	EN_OUT<=EN_OUT_tmp;
-	VOUT<=VOUT_tmp;
-
-end behavioural;
-
diff --git a/VHDL/VHDL_FIR/src/full_FIR.vhd b/VHDL/VHDL_FIR/src/full_FIR.vhd
deleted file mode 100644
index d727359..0000000
--- a/VHDL/VHDL_FIR/src/full_FIR.vhd
+++ /dev/null
@@ -1,55 +0,0 @@
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-
-library work;
-use work.pkg.all;
-entity full_FIR is
-port	(
-           DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
-		   DOUT: out signed(7 downto 0);
-		   CLK, RST_n, VIN: in std_logic;
-		   VOUT: out std_logic
-		   );
-end entity;
-
-architecture struct of full_FIR is
-
-component my_fir is
-	port ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst: std_logic;
-		   EN_OUT, EN_IN_REG: std_logic
-		);
-end component;
-
-component control is
-	port ( VIN, clk,reg_rst: in std_logic;
-			VOUT, EN_OUT, EN_IN_REG: out std_logic );
-end component;
-
-signal EN_OUT_tmp, EN_IN_REG_tmp: std_logic;
-
-begin
-FIR: my_fir  port map (
-	DIN=>DIN,
-	DOUT=>DOUT,
-	b=>b,
-	CLK=>CLK,
-	reg_rst=>RST_n,
-	EN_OUT=>EN_OUT_tmp,
-	EN_IN_REG=>EN_IN_REG_tmp);
-		
-	
-controllo: control port map(
-	VIN =>VIN,
-	VOUT =>VOUT,
-	clk=>CLK,
-	EN_OUT=> EN_OUT_tmp,
-	EN_IN_REG=> EN_IN_REG_tmp,
-	reg_rst =>RST_n );
-	
-
-end struct;
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/src/my_fir.vhd b/VHDL/VHDL_FIR/src/my_fir.vhd
deleted file mode 100644
index a0e8afc..0000000
--- a/VHDL/VHDL_FIR/src/my_fir.vhd
+++ /dev/null
@@ -1,113 +0,0 @@
-
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-
-library work;
-use work.pkg.all;
-
-entity my_fir is
-	port ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst: std_logic;
-		   EN_OUT, EN_IN_REG: std_logic
-		);
-end entity;
-
-architecture behavioural of my_fir is
-
-	type reg8_type is array(0 to 8) of signed(8 downto 0);
-	type internal_type is array(0 to 8) of signed(7 downto 0);
-	type sum_type is array (0 to 7) of signed(8 downto 0);
-	--type sum_tmp_type is array (0 to 7) of signed(7 downto 0);
-	type mult_type is array (0 to 8) of signed (15 downto 0);
-	signal x_mult_long: mult_type;
-	signal x_int : internal_type;
-	signal x_mult, x_multed : reg8_type;
-	signal x_sum: sum_type;
-	--signal x_sum_tmp: sum_tmp_type;
-	signal DOUT_tmp : signed(7 downto 0);
-	
-
-	
-begin
-	
-	--Combinatorial logic
-	
-	--Moltiplicazioni
-	
-	prodotti: for I in 0 to 8 generate
-	begin
-		x_mult_long(I)<=x_int(I) * b(I);
-	end generate prodotti;
-	
-	scarto_mult: for I in 0 to 8 generate
-	begin
-		x_mult(I)<=x_mult_long(I)(15 downto 7);
-	end generate;
-	
-	--Somme
-		
-	x_sum(0)<=x_multed(1)+x_multed(0);
-		
-	somme: for I in 1 to 7 generate
-	begin
-		x_sum(I)<=x_sum(I-1)+x_multed(I+1);
-	end generate;
-	
-
-	shifting: process(clk)		--Shift register 8x8
-	begin
-	if (reg_rst='0')then
-	    x_int(1 to 8)<= (others=>"00000000") ;
-		elsif(EN_IN_REG='1')  then
-			if (clk'event and clk='1') then
-				x_int(1 to 8)<= x_int(0 to 7);
-			else
-			x_int(1 to 8)<=x_int(1 to 8);
-			end if;
-	end if;
-	end process;
-	
-	
-	mult_saving: process(clk)
-	begin
-	if (reg_rst='0')then
-		x_multed(0 to 8)<= (others=>"000000000");
-		elsif(EN_IN_REG='1') then
-			if (clk'event and clk='1') then
-				x_multed(0 to 8)<= x_mult(0 to 8);
-			else
-		        x_multed(0 to 8)<=x_multed(0 to 8);
-	        end if;
-	end if;		
-	end process;
-
-	loading: process(clk)
-	begin
-	if (reg_rst='0') then
-		x_int(0)<= (others=>'0');
-	elsif (clk'event and clk='1') then
-			x_int(0)<=DIN;
-	else
-			x_int(0)<=x_int(0);
-	end if;
-	end process;
-	
-	saving: process(clk)
-	begin
-	if (reg_rst='0') then
-		DOUT_tmp<= (others=>'0');
-		elsif (EN_OUT = '1') then
-			if (clk'event and clk='1') then
-				DOUT_tmp<=x_sum(7)(7 downto 0);
-			else
-			DOUT_tmp<=DOUT_tmp;
-		    end if;
-	end if;
-	end process;
-	
-	DOUT<=DOUT_tmp;
-
-end behavioural;
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/src/pkg.vhd b/VHDL/VHDL_FIR/src/pkg.vhd
deleted file mode 100644
index 3ebd4a5..0000000
--- a/VHDL/VHDL_FIR/src/pkg.vhd
+++ /dev/null
@@ -1,12 +0,0 @@
-
-library ieee;
-use ieee.numeric_std.all;
-
-
-
-package pkg is
-  type array8 is array (natural range <>) of signed(7 downto 0);
-end package;
-
-package body pkg is
-end package body;
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/src/reg8.vhd b/VHDL/VHDL_FIR/src/reg8.vhd
deleted file mode 100644
index 1568195..0000000
--- a/VHDL/VHDL_FIR/src/reg8.vhd
+++ /dev/null
@@ -1,30 +0,0 @@
-
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-
-entity reg8 is
-	port (  D : in signed(7 downto 0);
-			Q : out signed(7 downto 0);
-			clk: in std_logic;
-			rst: in std_logic
-		);
-end entity;
-
-architecture behavioural of reg8 is
-	
-	sample: process(clk)
-	begin
-		if (clk'event and clk='1') then
-			if (rst='1')then
-				Q<= (others=>'0');
-			else
-				Q<=D;
-			end if;
-		end if;
-	end process;
-
-end behavioural;
-	
-	
-	
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/src/testbench_datapath.vhd b/VHDL/VHDL_FIR/src/testbench_datapath.vhd
deleted file mode 100644
index c6f51d9..0000000
--- a/VHDL/VHDL_FIR/src/testbench_datapath.vhd
+++ /dev/null
@@ -1,154 +0,0 @@
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-library work;
-use work.pkg.all;
-
-entity testbench_datapath is 
-end entity ; 
-
-architecture cpk of testbench_datapath is 
-component my_fir is
-port  ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--Coefficienti
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst:in std_logic;
-		   EN_OUT: in std_logic;
-		   EN_IN_REG:in std_logic
-		);
-end component;
-
-component coeffs is
-port(b:  OUT array8(0 to 8));
-end component;
-
-signal DIN_test: signed(7 downto 0); 
-signal b_test: array8(8 downto 0);	--Coefficienti
-signal DOUT_test: signed(7 downto 0);
-signal CLK_test, reg_rst_test: std_logic;
-signal EN_OUT_test: std_logic;
-signal EN_IN_REG_test: std_logic;
-	
-begin
-
-coefficienti: coeffs port map (
-	b(0)=>b_test(0), b(1)=>b_test(1), b(2)=>b_test(2), b(3)=>b_test(3), b(4)=>b_test(4), b(5)=>b_test(5), b(6)=>b_test(6), b(7)=>b_test(7), b(8)=>b_test(8)
-);
-
-FIR : my_fir port map (
-DIN => DIN_test,
-b => b_test,
-DOUT => DOUT_test,
-reg_rst=> reg_rst_test,
-EN_OUT=> EN_OUT_test,
-EN_IN_REG=> EN_IN_REG_test, 
-CLK=> CLK_test);
-clock_gen : process
-		begin
-			CLK_test<='0';
-			wait for 0.5 ns;
-			CLK_test<='1';
-			
-			wait for 0.5 ns;
-	end process;
-stimuli: process 
-begin 
---idle con reg_rst attivo
---b_test<="100000000";
-reg_rst_test<='1';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait for 1 ns ;
---idle con reg_rst disattivo
---b_test<="00000010";
-reg_rst_test<='0';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait for 1 ns;
---shifting 
-	--primo dato in ingresso
-	
-	reg_rst_test<='0';
-	DIN_test<="00001000";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0'; 
-	wait for 1 ns;
-	--secondo dato in ingresso
-	
-	reg_rst_test<='0';
-	DIN_test<="00000010";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- wait
-    --b_test<="000100000";
-	reg_rst_test<='0';
-	DIN_test<="00000011";
-	EN_IN_REG_test<='0';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- ritorno nello shifting
-	--terzo dato in ingresso
-	--b_test<="001000000";
-	reg_rst_test<='0';
-	DIN_test<="00000011";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- regime 
---b_test<="010000000";
-reg_rst_test<='0';
-DIN_test<="00000011";
-EN_IN_REG_test<='1';
-EN_OUT_test<='1';
-wait for 1 ns;
---idle con reg_rst attivo
---b_test<="011111111";
-reg_rst_test<='1';
-DIN_test<="00000000";
-EN_IN_REG_test<='1';
-EN_OUT_test<='1';
-wait for 10 ns;
-reg_rst_test<='0';
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(39,8);
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(103,8);
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(127,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(103,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(39,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(-40,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(-104,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(-128,8);
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(-104,8);
-wait;
-
-end process;
-end cpk;
\ No newline at end of file
diff --git a/VHDL/VHDL_FIR/tb/testbench_datapath.vhd b/VHDL/VHDL_FIR/tb/testbench_datapath.vhd
deleted file mode 100644
index 9439a53..0000000
--- a/VHDL/VHDL_FIR/tb/testbench_datapath.vhd
+++ /dev/null
@@ -1,105 +0,0 @@
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-library work;
-use work.pkg.all;
-
-entity testbench_datapath is 
-end entity ; 
-
-architecture cpk of testbench_datapath is 
-component my_fir is
-port  ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--Coefficienti
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst:in std_logic;
-		   EN_OUT: in std_logic;
-		   EN_IN_REG:in std_logic
-		);
-end component;
-signal DIN_test: signed(7 downto 0); 
-signal b_test: array8(8 downto 0);	--Coefficienti
-signal DOUT_test: signed(7 downto 0);
-signal CLK_test, reg_rst_test: std_logic;
-signal EN_OUT_test: std_logic;
-signal EN_IN_REG_test: std_logic;
-	
-begin
-FIR : my_fir port map (
-DIN => DIN_test,
-b => b_test,
-DOUT => DOUT_test,
-reg_rst=> reg_rst_test,
-EN_OUT=> EN_OUT_test,
-EN_IN_REG=> EN_IN_REG_test, 
-CLK=> CLK_test);
-clock_gen : process
-		begin
-			CLK_test<='0';
-			wait for 2 ns;
-			CLK_test<='1';
-			
-			wait for 2 ns;
-	end process;
-stimuli: process 
-begin 
---idle con reg_rst attivo
-b_test<="100000000";
-reg_rst_test<='1';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait for 1 ns ;
---idle con reg_rst disattivo
-b_test<="00000010";
-reg_rst_test<='0';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait for 1 ns;
---shifting 
-	--primo dato in ingresso
-	b_test<="000000100";
-	reg_rst_test<='0';
-	DIN_test<="00001000";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0'; 
-	wait for 1 ns;
-	--secondo dato in ingresso
-	b_test<="000010000";
-	reg_rst_test<='0';
-	DIN_test<="00000010";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- wait
-    b_test<="000100000";
-	reg_rst_test<='0';
-	DIN_test<="00000011";
-	EN_IN_REG_test<='0';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- ritorno nello shifting
-	--terzo dato in ingresso
-	b_test<="001000000";
-	reg_rst_test<='0';
-	DIN_test<="00000011";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- regime 
-b_test<="010000000";
-reg_rst_test<='0';
-DIN_test<="00000011";
-EN_IN_REG_test<='1';
-EN_OUT_test<='1';
-wait for 1 ns;
---idle con reg_rst attivo
-b_test<="011111111";
-reg_rst_test<='1';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait;
-end process;
-end cpk;
\ No newline at end of file
diff --git a/VHDL/src/control.vhd b/VHDL/src/control.vhd
index 5df0054..c4a6657 100644
--- a/VHDL/src/control.vhd
+++ b/VHDL/src/control.vhd
@@ -10,7 +10,7 @@ end entity;
 
 architecture behavioural of control is
 
-	signal EN_IN_REG_tmp, EN_OUT_tmp, VOUT_tmp  : std_logic;
+	signal EN_IN_REG_tmp, VOUT_tmp  : std_logic;
 
 begin
 
@@ -24,31 +24,18 @@ begin
 	--	EN_IN_REG_tmp<=EN_IN_REG_tmp;
 	end if;
 	end process;
-	
-	second_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		EN_OUT_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		EN_OUT_tmp<=EN_IN_REG_tmp;
-	--else
-	--	EN_OUT_tmp<=EN_OUT_tmp;
-	end if;
-	end process;
 
-	third_reg: process(clk)
+	second_reg: process(clk)
 	begin
 	if (reg_rst='0') then
 		VOUT_tmp<= '0';
 	elsif (clk'event and clk='1') then
-		VOUT_tmp<=EN_OUT_tmp;
-	--else
-	--	VOUT_tmp<=VOUT_tmp;
+		VOUT_tmp<=EN_IN_REG_tmp;
 	end if;
 	end process;
 	
 	EN_IN_REG<=EN_IN_REG_tmp;
-	EN_OUT<=EN_OUT_tmp;
+	EN_OUT<=EN_IN_REG_tmp;
 	VOUT<=VOUT_tmp;
 
 end behavioural;
diff --git a/VHDL/src/my_fir.vhd b/VHDL/src/my_fir.vhd
index acbb6a4..3252065 100644
--- a/VHDL/src/my_fir.vhd
+++ b/VHDL/src/my_fir.vhd
@@ -24,7 +24,7 @@ architecture behavioural of my_fir is
 	type mult_type is array (0 to 8) of signed (15 downto 0);
 	signal x_mult_long: mult_type;
 	signal x_int : internal_type;
-	signal x_mult, x_multed : reg8_type;
+	signal x_mult : reg8_type;
 	signal x_sum: sum_type;
 	--signal x_sum_tmp: sum_tmp_type;
 	signal DOUT_tmp : signed(7 downto 0);
@@ -49,11 +49,11 @@ begin
 	
 	--Somme
 		
-	x_sum(0)<=x_multed(1)+x_multed(0);
+	x_sum(0)<=x_mult(1)+x_mult(0);
 		
 	somme: for I in 1 to 7 generate
 	begin
-		x_sum(I)<=x_sum(I-1)+x_multed(I+1);
+		x_sum(I)<=x_sum(I-1)+x_mult(I+1);
 	end generate;
 	
 
@@ -69,20 +69,7 @@ begin
 			end if;
 	end if;
 	end process;
-	
-	
-	mult_saving: process(clk)
-	begin
-	if (reg_rst='0')then
-		x_multed(0 to 8)<= (others=>"000000000");
-		elsif (clk'event and clk='1') then
-			if (EN_IN_REG='1') then
-				x_multed(0 to 8)<= x_mult(0 to 8);
-			else
-		        x_multed(0 to 8)<=x_multed(0 to 8);
-	        end if;
-	end if;		
-	end process;
+
 
 	loading: process(clk)
 	begin
diff --git a/VHDL/src_alb/FIR_FILTER.vhd b/VHDL/src_alb/FIR_FILTER.vhd
deleted file mode 100644
index 9e8cf19..0000000
--- a/VHDL/src_alb/FIR_FILTER.vhd
+++ /dev/null
@@ -1,136 +0,0 @@
-LIBRARY IEEE;
-USE IEEE.STD_LOGIC_1164.ALL;
-USE IEEE.NUMERIC_STD.ALL;
-
-ENTITY IIR_FILTER IS
-		PORT (	VIN, CLOCK, RST_n	: IN STD_LOGIC;
-				VOUT				: OUT STD_LOGIC;
-				DIN      			: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
-				DOUT	      		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0));
-END ENTITY IIR_FILTER;
-
-ARCHITECTURE BEHAVIORAL OF IIR_FILTER IS
-	COMPONENT REGN_EN_FP IS
-		GENERIC ( N : INTEGER:=24); --dimensione generica
-		PORT (	R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
-					ENABLE, CLOCK, RESETN : IN STD_LOGIC;
-					Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
-	END COMPONENT REGN_EN_FP;
-
-
-	TYPE STATE_MACHINE IS (IDLE, FIRST_DATA_RECEIVED, SECOND_DATA_RECEIVED, THIRD_DATA_RECEIVED, PROCESS_ONE_DATA, ENDING_PROCESS_DATA, END_PROCESS_DATA,SPURIUS_DATA_RECEIVED);
-	SIGNAL Y_PR, Y_NX: STATE_MACHINE;
-	
-	--REGISTER SIGNALS
-	SIGNAL EN_INPUT_REG, EN_OUTPUT 	: STD_LOGIC;
-	SIGNAL DOUT_i, DIN_i      		: STD_LOGIC_VECTOR (10 DOWNTO 0));
-BEGIN
--------------------------------------------DATAPATH-----------------------------------------------------
-	REG_DIN: REGN_EN_FP 	GENERIC MAP(11)
-								PORT MAP (DIN, EN_DIN_REG, CLOCK, RST_n, DIN_i);
-								
-								
-	REG_DOUT: REGN_EN_FP 	GENERIC MAP(11)
-								PORT MAP (DOUT_i, EN_DOUT_REG, CLOCK, RST_n, DOUT);
-	
--------------------------------------------------------------------------------------------------------------
------------------------------------------FINITE--STATE--MACHINE----------------------------------------------
--------------------------------------------------------------------------------------------------------------
-	--STATE UPDATE
-	PROCESS (CLOCK,RST_n )
-	BEGIN
-	IF RST_n='0' THEN
-		Y_PR<=IDLE;
-	ELSIF (CLOCK'EVENT AND CLOCK='1') THEN   
-				Y_PR<=Y_NX;
-		END IF;
-	END PROCESS;
-	--STATE TABLE
-	PROCESS ( Y_PR, VIN)
-	BEGIN
-		CASE Y_PR IS 
-			WHEN IDLE 					=>	IF VIN='1' THEN
-													Y_NX<=FIRST_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=IDLE;
-												END IF;
-							
-			WHEN FIRST_DATA_RECEIVED	=> IF VIN='1' THEN
-												Y_NX<=SECOND_DATA_RECEIVED;
-											ELSE 
-												Y_NX<=PROCESS_ONE_DATA;
-											END IF;
-			
-			WHEN SECOND_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=THIRD_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=ENDING_PROCESS_DATA;
-												END IF;
-			
-			WHEN THIRD_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=THIRD_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=ENDING_PROCESS_DATA;
-												END IF;
-												
-			WHEN ENDING_PROCESS_DATA	=> IF VIN='1' THEN
-													Y_NX<=SPURIUS_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=END_PROCESS_DATA;
-												END IF;
-			
-			WHEN END_PROCESS_DATA		=> IF VIN='1' THEN
-													Y_NX<=FIRST_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=IDLE;
-												END IF;
-			
-			WHEN PROCESS_ONE_DATA		=> IF VIN='1' THEN
-													Y_NX<=SPURIUS_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=END_PROCESS_DATA;
-												END IF;	
-			
-			WHEN SPURIUS_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=SECOND_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=PROCESS_ONE_DATA;
-												END IF;	
-												
-			WHEN OTHERS => Y_NX<=IDLE;				
-		END CASE;
-	END PROCESS; 
-   --OUTPUT GENERATION
-	PROCESS (Y_PR)
-	BEGIN
-	EN_OUTPUT <='0';
-	EN_INPUT_REG <='0';
-	VOUT <='0';
-	CASE Y_PR IS 
-			WHEN IDLE 					=>	EN_INPUT_REG <= '0';--DO NOTHING
-							
-			WHEN FIRST_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-			
-			WHEN SECOND_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-											EN_OUTPUT <= '1';
-											
-			
-			WHEN THIRD_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-											EN_OUTPUT <= '1';
-											VOUT <= '1';
-												
-			WHEN ENDING_PROCESS_DATA	=> EN_OUTPUT <= '1';
-											VOUT <= '1';
-			
-			WHEN END_PROCESS_DATA		=> VOUT <= '1';
-			
-			WHEN PROCESS_ONE_DATA		=> EN_OUTPUT <= '1';
-											
-											
-			WHEN SPURIUS_DATA_RECEIVED  => EN_INPUT_REG <= '1';
-											VOUT <= '1';
-									
-		END CASE;
-	END PROCESS; 	
-
-END BEHAVIORAL;
\ No newline at end of file
diff --git a/VHDL/src_alb/REGN.vhd b/VHDL/src_alb/REGN.vhd
deleted file mode 100644
index d2b6989..0000000
--- a/VHDL/src_alb/REGN.vhd
+++ /dev/null
@@ -1,24 +0,0 @@
-LIBRARY IEEE;
-USE IEEE.STD_LOGIC_1164.ALL;
-USE IEEE.NUMERIC_STD.ALL;
-
-ENTITY REGN_EN_FP IS
-	GENERIC ( N : INTEGER:=8); --dimensione generica
-	PORT (	R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
-			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
-			Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
-END REGN_EN_FP;
-
-ARCHITECTURE BEHAVIOR OF REGN_EN_FP IS
-BEGIN
-	PROCESS (CLOCK, RESETN)
-	BEGIN
-		IF (RESETN = '0') THEN
-			Q <= (OTHERS => '0');
-		ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
-			IF ENABLE='1' THEN
-				Q <= R;
-			END IF;
-		END IF;
-	END PROCESS;
-END BEHAVIOR;
diff --git a/VHDL/src_alb/STATE_MACHINE.vhd b/VHDL/src_alb/STATE_MACHINE.vhd
deleted file mode 100644
index 9dc778c..0000000
--- a/VHDL/src_alb/STATE_MACHINE.vhd
+++ /dev/null
@@ -1,116 +0,0 @@
-LIBRARY IEEE;
-USE IEEE.STD_LOGIC_1164.ALL;
-USE IEEE.NUMERIC_STD.ALL;
-
-ENTITY FILTER_STATE_MACHINE IS
-		PORT (	VIN, CLOCK, RST_n				: IN STD_LOGIC;
-				VOUT,EN_INPUT_REG,EN_OUTPUT		: OUT STD_LOGIC;
-				);
-END ENTITY FILTER_STATE_MACHINE;
-
-ARCHITECTURE BEHAVIORAL OF FILTER_STATE_MACHINE IS
-	TYPE STATE_MACHINE IS (IDLE, FIRST_DATA_RECEIVED, SECOND_DATA_RECEIVED, THIRD_DATA_RECEIVED, PROCESS_ONE_DATA, ENDING_PROCESS_DATA, END_PROCESS_DATA,SPURIUS_DATA_RECEIVED);
-	SIGNAL Y_PR, Y_NX: STATE_MACHINE;
-
-BEGIN
--------------------------------------------------------------------------------------------------------------
------------------------------------------FINITE--STATE--MACHINE----------------------------------------------
--------------------------------------------------------------------------------------------------------------
-	--STATE UPDATE
-	PROCESS (CLOCK,RST_n )
-	BEGIN
-	IF RST_n='0' THEN
-		Y_PR<=IDLE;
-	ELSIF (CLOCK'EVENT AND CLOCK='1') THEN   
-				Y_PR<=Y_NX;
-		END IF;
-	END PROCESS;
-	--STATE TABLE
-	PROCESS ( Y_PR, VIN)
-	BEGIN
-		CASE Y_PR IS 
-			WHEN IDLE 					=>	IF VIN='1' THEN
-													Y_NX<=FIRST_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=IDLE;
-												END IF;
-							
-			WHEN FIRST_DATA_RECEIVED	=> IF VIN='1' THEN
-												Y_NX<=SECOND_DATA_RECEIVED;
-											ELSE 
-												Y_NX<=PROCESS_ONE_DATA;
-											END IF;
-			
-			WHEN SECOND_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=THIRD_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=ENDING_PROCESS_DATA;
-												END IF;
-			
-			WHEN THIRD_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=THIRD_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=ENDING_PROCESS_DATA;
-												END IF;
-												
-			WHEN ENDING_PROCESS_DATA	=> IF VIN='1' THEN
-													Y_NX<=SPURIUS_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=END_PROCESS_DATA;
-												END IF;
-			
-			WHEN END_PROCESS_DATA		=> IF VIN='1' THEN
-													Y_NX<=FIRST_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=IDLE;
-												END IF;
-			
-			WHEN PROCESS_ONE_DATA		=> IF VIN='1' THEN
-													Y_NX<=SPURIUS_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=END_PROCESS_DATA;
-												END IF;	
-			
-			WHEN SPURIUS_DATA_RECEIVED	=> IF VIN='1' THEN
-													Y_NX<=SECOND_DATA_RECEIVED;
-												ELSE 
-													Y_NX<=PROCESS_ONE_DATA;
-												END IF;	
-												
-			WHEN OTHERS => Y_NX<=IDLE;				
-		END CASE;
-	END PROCESS; 
-   --OUTPUT GENERATION
-	PROCESS (Y_PR)
-	BEGIN
-	EN_OUTPUT <='0';
-	EN_INPUT_REG <='0';
-	VOUT <='0';
-	CASE Y_PR IS 
-			WHEN IDLE 					=>	EN_INPUT_REG <= '0';--DO NOTHING
-							
-			WHEN FIRST_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-			
-			WHEN SECOND_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-											EN_OUTPUT <= '1';
-											
-			
-			WHEN THIRD_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
-											EN_OUTPUT <= '1';
-											VOUT <= '1';
-												
-			WHEN ENDING_PROCESS_DATA	=> EN_OUTPUT <= '1';
-											VOUT <= '1';
-			
-			WHEN END_PROCESS_DATA		=> VOUT <= '1';
-			
-			WHEN PROCESS_ONE_DATA		=> EN_OUTPUT <= '1';
-											
-											
-			WHEN SPURIUS_DATA_RECEIVED  => EN_INPUT_REG <= '1';
-											VOUT <= '1';
-									
-		END CASE;
-	END PROCESS; 	
-
-END BEHAVIORAL;
\ No newline at end of file
diff --git a/VHDL/src_alb/coeffs.vhd b/VHDL/src_alb/coeffs.vhd
deleted file mode 100644
index 263e554..0000000
--- a/VHDL/src_alb/coeffs.vhd
+++ /dev/null
@@ -1,25 +0,0 @@
-LIBRARY IEEE;
-USE ieee.std_logic_1164.all;
-USE ieee.numeric_std.all;
-
-library work;
-use work.pkg.all;
-
-entity coeffs is
-port(	b:  OUT array8(0 to 8));
-end coeffs;
- 
--- Coefficienti {-1, -2, 6, 34, 51, 34, 6, -2, -1}
-
-architecture behavioural of coeffs is
-begin 
-b(0)<= to_signed(-1,8);
-b(1)<= to_signed(-2,8);
-b(2)<= to_signed(6,8);
-b(3)<= to_signed(34,8);
-b(4)<= to_signed(51,8);
-b(5)<= to_signed(34,8);
-b(6)<= to_signed(6,8);
-b(7)<= to_signed(-2,8);
-b(8)<= to_signed(-1,8); 
-end behavioural;
\ No newline at end of file
diff --git a/VHDL/src_alb/control.vhd b/VHDL/src_alb/control.vhd
deleted file mode 100644
index 979b92b..0000000
--- a/VHDL/src_alb/control.vhd
+++ /dev/null
@@ -1,55 +0,0 @@
-
-library ieee;
-use ieee.std_logic_1164.all;
-
-entity control is
-
-	port ( VIN, clk,reg_rst: in std_logic;
-			VOUT, EN_OUT, EN_IN_REG: out std_logic );
-end entity;
-
-architecture behavioural of control is
-
-	signal EN_IN_REG_tmp, EN_OUT_tmp, VOUT_tmp  : std_logic;
-
-begin
-
-	first_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		EN_IN_REG_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		EN_IN_REG_tmp<=VIN;
-	else
-		EN_IN_REG_tmp<=EN_IN_REG_tmp;
-	end if;
-	end process;
-	
-	second_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		EN_OUT_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		EN_OUT_tmp<=EN_IN_REG_tmp;
-	else
-		EN_OUT_tmp<=EN_OUT_tmp;
-	end if;
-	end process;
-
-	third_reg: process(clk)
-	begin
-	if (reg_rst='0') then
-		VOUT_tmp<= '0';
-	elsif (clk'event and clk='1') then
-		VOUT_tmp<=EN_OUT_tmp;
-	else
-		VOUT_tmp<=VOUT_tmp;
-	end if;
-	end process;
-	
-	EN_IN_REG<=EN_IN_REG_tmp;
-	EN_OUT<=EN_OUT_tmp;
-	VOUT<=VOUT_tmp;
-
-end behavioural;
-
diff --git a/VHDL/src_alb/full_FIR.vhd b/VHDL/src_alb/full_FIR.vhd
deleted file mode 100644
index d727359..0000000
--- a/VHDL/src_alb/full_FIR.vhd
+++ /dev/null
@@ -1,55 +0,0 @@
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-
-library work;
-use work.pkg.all;
-entity full_FIR is
-port	(
-           DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
-		   DOUT: out signed(7 downto 0);
-		   CLK, RST_n, VIN: in std_logic;
-		   VOUT: out std_logic
-		   );
-end entity;
-
-architecture struct of full_FIR is
-
-component my_fir is
-	port ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst: std_logic;
-		   EN_OUT, EN_IN_REG: std_logic
-		);
-end component;
-
-component control is
-	port ( VIN, clk,reg_rst: in std_logic;
-			VOUT, EN_OUT, EN_IN_REG: out std_logic );
-end component;
-
-signal EN_OUT_tmp, EN_IN_REG_tmp: std_logic;
-
-begin
-FIR: my_fir  port map (
-	DIN=>DIN,
-	DOUT=>DOUT,
-	b=>b,
-	CLK=>CLK,
-	reg_rst=>RST_n,
-	EN_OUT=>EN_OUT_tmp,
-	EN_IN_REG=>EN_IN_REG_tmp);
-		
-	
-controllo: control port map(
-	VIN =>VIN,
-	VOUT =>VOUT,
-	clk=>CLK,
-	EN_OUT=> EN_OUT_tmp,
-	EN_IN_REG=> EN_IN_REG_tmp,
-	reg_rst =>RST_n );
-	
-
-end struct;
\ No newline at end of file
diff --git a/VHDL/src_alb/my_fir.vhd b/VHDL/src_alb/my_fir.vhd
deleted file mode 100644
index a0e8afc..0000000
--- a/VHDL/src_alb/my_fir.vhd
+++ /dev/null
@@ -1,113 +0,0 @@
-
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-
-library work;
-use work.pkg.all;
-
-entity my_fir is
-	port ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--9 Coefficienti da 8 bit
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst: std_logic;
-		   EN_OUT, EN_IN_REG: std_logic
-		);
-end entity;
-
-architecture behavioural of my_fir is
-
-	type reg8_type is array(0 to 8) of signed(8 downto 0);
-	type internal_type is array(0 to 8) of signed(7 downto 0);
-	type sum_type is array (0 to 7) of signed(8 downto 0);
-	--type sum_tmp_type is array (0 to 7) of signed(7 downto 0);
-	type mult_type is array (0 to 8) of signed (15 downto 0);
-	signal x_mult_long: mult_type;
-	signal x_int : internal_type;
-	signal x_mult, x_multed : reg8_type;
-	signal x_sum: sum_type;
-	--signal x_sum_tmp: sum_tmp_type;
-	signal DOUT_tmp : signed(7 downto 0);
-	
-
-	
-begin
-	
-	--Combinatorial logic
-	
-	--Moltiplicazioni
-	
-	prodotti: for I in 0 to 8 generate
-	begin
-		x_mult_long(I)<=x_int(I) * b(I);
-	end generate prodotti;
-	
-	scarto_mult: for I in 0 to 8 generate
-	begin
-		x_mult(I)<=x_mult_long(I)(15 downto 7);
-	end generate;
-	
-	--Somme
-		
-	x_sum(0)<=x_multed(1)+x_multed(0);
-		
-	somme: for I in 1 to 7 generate
-	begin
-		x_sum(I)<=x_sum(I-1)+x_multed(I+1);
-	end generate;
-	
-
-	shifting: process(clk)		--Shift register 8x8
-	begin
-	if (reg_rst='0')then
-	    x_int(1 to 8)<= (others=>"00000000") ;
-		elsif(EN_IN_REG='1')  then
-			if (clk'event and clk='1') then
-				x_int(1 to 8)<= x_int(0 to 7);
-			else
-			x_int(1 to 8)<=x_int(1 to 8);
-			end if;
-	end if;
-	end process;
-	
-	
-	mult_saving: process(clk)
-	begin
-	if (reg_rst='0')then
-		x_multed(0 to 8)<= (others=>"000000000");
-		elsif(EN_IN_REG='1') then
-			if (clk'event and clk='1') then
-				x_multed(0 to 8)<= x_mult(0 to 8);
-			else
-		        x_multed(0 to 8)<=x_multed(0 to 8);
-	        end if;
-	end if;		
-	end process;
-
-	loading: process(clk)
-	begin
-	if (reg_rst='0') then
-		x_int(0)<= (others=>'0');
-	elsif (clk'event and clk='1') then
-			x_int(0)<=DIN;
-	else
-			x_int(0)<=x_int(0);
-	end if;
-	end process;
-	
-	saving: process(clk)
-	begin
-	if (reg_rst='0') then
-		DOUT_tmp<= (others=>'0');
-		elsif (EN_OUT = '1') then
-			if (clk'event and clk='1') then
-				DOUT_tmp<=x_sum(7)(7 downto 0);
-			else
-			DOUT_tmp<=DOUT_tmp;
-		    end if;
-	end if;
-	end process;
-	
-	DOUT<=DOUT_tmp;
-
-end behavioural;
\ No newline at end of file
diff --git a/VHDL/src_alb/pkg.vhd b/VHDL/src_alb/pkg.vhd
deleted file mode 100644
index 3ebd4a5..0000000
--- a/VHDL/src_alb/pkg.vhd
+++ /dev/null
@@ -1,12 +0,0 @@
-
-library ieee;
-use ieee.numeric_std.all;
-
-
-
-package pkg is
-  type array8 is array (natural range <>) of signed(7 downto 0);
-end package;
-
-package body pkg is
-end package body;
\ No newline at end of file
diff --git a/VHDL/src_alb/reg8.vhd b/VHDL/src_alb/reg8.vhd
deleted file mode 100644
index 1568195..0000000
--- a/VHDL/src_alb/reg8.vhd
+++ /dev/null
@@ -1,30 +0,0 @@
-
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-
-entity reg8 is
-	port (  D : in signed(7 downto 0);
-			Q : out signed(7 downto 0);
-			clk: in std_logic;
-			rst: in std_logic
-		);
-end entity;
-
-architecture behavioural of reg8 is
-	
-	sample: process(clk)
-	begin
-		if (clk'event and clk='1') then
-			if (rst='1')then
-				Q<= (others=>'0');
-			else
-				Q<=D;
-			end if;
-		end if;
-	end process;
-
-end behavioural;
-	
-	
-	
\ No newline at end of file
diff --git a/VHDL/src_alb/testbench_datapath.vhd b/VHDL/src_alb/testbench_datapath.vhd
deleted file mode 100644
index c6f51d9..0000000
--- a/VHDL/src_alb/testbench_datapath.vhd
+++ /dev/null
@@ -1,154 +0,0 @@
-library ieee;
-use ieee.std_logic_1164.all;
-use ieee.numeric_std.all;
-library work;
-use work.pkg.all;
-
-entity testbench_datapath is 
-end entity ; 
-
-architecture cpk of testbench_datapath is 
-component my_fir is
-port  ( DIN: in signed(7 downto 0); 
-		   b: in array8(8 downto 0);	--Coefficienti
-		   DOUT: out signed(7 downto 0);
-		   CLK, reg_rst:in std_logic;
-		   EN_OUT: in std_logic;
-		   EN_IN_REG:in std_logic
-		);
-end component;
-
-component coeffs is
-port(b:  OUT array8(0 to 8));
-end component;
-
-signal DIN_test: signed(7 downto 0); 
-signal b_test: array8(8 downto 0);	--Coefficienti
-signal DOUT_test: signed(7 downto 0);
-signal CLK_test, reg_rst_test: std_logic;
-signal EN_OUT_test: std_logic;
-signal EN_IN_REG_test: std_logic;
-	
-begin
-
-coefficienti: coeffs port map (
-	b(0)=>b_test(0), b(1)=>b_test(1), b(2)=>b_test(2), b(3)=>b_test(3), b(4)=>b_test(4), b(5)=>b_test(5), b(6)=>b_test(6), b(7)=>b_test(7), b(8)=>b_test(8)
-);
-
-FIR : my_fir port map (
-DIN => DIN_test,
-b => b_test,
-DOUT => DOUT_test,
-reg_rst=> reg_rst_test,
-EN_OUT=> EN_OUT_test,
-EN_IN_REG=> EN_IN_REG_test, 
-CLK=> CLK_test);
-clock_gen : process
-		begin
-			CLK_test<='0';
-			wait for 0.5 ns;
-			CLK_test<='1';
-			
-			wait for 0.5 ns;
-	end process;
-stimuli: process 
-begin 
---idle con reg_rst attivo
---b_test<="100000000";
-reg_rst_test<='1';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait for 1 ns ;
---idle con reg_rst disattivo
---b_test<="00000010";
-reg_rst_test<='0';
-DIN_test<="00000000";
-EN_IN_REG_test<='0';
-EN_OUT_test<='0';
-wait for 1 ns;
---shifting 
-	--primo dato in ingresso
-	
-	reg_rst_test<='0';
-	DIN_test<="00001000";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0'; 
-	wait for 1 ns;
-	--secondo dato in ingresso
-	
-	reg_rst_test<='0';
-	DIN_test<="00000010";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- wait
-    --b_test<="000100000";
-	reg_rst_test<='0';
-	DIN_test<="00000011";
-	EN_IN_REG_test<='0';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- ritorno nello shifting
-	--terzo dato in ingresso
-	--b_test<="001000000";
-	reg_rst_test<='0';
-	DIN_test<="00000011";
-	EN_IN_REG_test<='1';
-	EN_OUT_test<='0';
-	wait for 1 ns;
--- regime 
---b_test<="010000000";
-reg_rst_test<='0';
-DIN_test<="00000011";
-EN_IN_REG_test<='1';
-EN_OUT_test<='1';
-wait for 1 ns;
---idle con reg_rst attivo
---b_test<="011111111";
-reg_rst_test<='1';
-DIN_test<="00000000";
-EN_IN_REG_test<='1';
-EN_OUT_test<='1';
-wait for 10 ns;
-reg_rst_test<='0';
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(39,8);
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(103,8);
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(127,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(103,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(39,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(-40,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(-104,8);
-wait for 1 ns;
-DIN_test<=to_signed(-1,8);
-wait for 1 ns;
-DIN_test<=to_signed(-128,8);
-wait for 1 ns;
-DIN_test<=to_signed(0,8);
-wait for 1 ns;
-DIN_test<=to_signed(-104,8);
-wait;
-
-end process;
-end cpk;
\ No newline at end of file
