
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg8 is
	port (  D : in signed(7 downto 0);
			Q : out signed(7 downto 0);
			clk: in std_logic;
			rst: in std_logic
		);
end entity;

architecture behavioural of reg8 is
	begin
	sample: process(clk)
	begin
		if (clk'event and clk='1') then
			if (rst='1')then
				Q<= (others=>'0');
			else
				Q<=D;
			end if;
		end if;
	end process;

end behavioural;
	
	
	
