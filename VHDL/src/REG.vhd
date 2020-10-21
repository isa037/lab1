LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY REGN_EN_FP IS
	GENERIC ( N : INTEGER:=8);
	PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			ENABLE, CLOCK, RESETN : IN STD_LOGIC;
			Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END REGN_EN_FP;

ARCHITECTURE BEHAVIOR OF REGN_EN_FP IS
BEGIN
	PROCESS (CLOCK, RESETN)
	BEGIN
		IF (RESETN = '0') THEN   -- RST ASINCRONO ATTIVO BASSO
			Q <= (OTHERS => '0');
		ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
			IF ENABLE='1' THEN
				Q <= R;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIOR;
