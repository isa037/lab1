library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
--library work;
--use work.pkg.all;
library std;
use std.textio.all;

entity tb_input_data_maker is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT    : out std_logic_vector(7 downto 0);
	b0,b1,b2,b3,b4,b5,b6,b7,b8		: out std_logic_vector (7 downto 0);
    END_SIM : out std_logic);
end tb_input_data_maker;

architecture beh of tb_input_data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  

begin  -- beh
-- Coefficienti {-1, -2, 6, 34, 51, 34, 6, -2, -1}
	b0<= std_logic_vector(to_signed(-1,8));
	b1<= std_logic_vector(to_signed(-2,8));
	b2<= std_logic_vector(to_signed(6,8));
	b3<= std_logic_vector(to_signed(34,8));
	b4<= std_logic_vector(to_signed(51,8));
	b5<= std_logic_vector(to_signed(34,8));
	b6<= std_logic_vector(to_signed(6,8));
	b7<= std_logic_vector(to_signed(-2,8));
	b8<= std_logic_vector(to_signed(-1,8)); 
	
  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "../../C/samples.txt";
    variable line_in : line;
    variable x : integer;
	variable counter : INTEGER;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT <= (others => '0') after tco;      
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
	  counter:=0;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
	  if (counter = 10 or counter=20 or counter=21 or counter=22) then 
		VOUT <= '0' after tco;
	  else
		  if not endfile(fp_in) then
			readline(fp_in, line_in);
			read(line_in, x);
			DOUT <= conv_std_logic_vector(x, 8) after tco;
			VOUT <= '1' after tco;
			sEndSim <= '0' after tco;
		  else
			VOUT <= '0' after tco;        
			sEndSim <= '1' after tco;
		  end if;
	  end if;
	  counter :=counter+1;
    end if;
  end process;

  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;
  

  END_SIM <= END_SIM_i(10);  

end beh;
