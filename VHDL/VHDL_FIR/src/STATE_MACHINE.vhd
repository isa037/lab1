LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FILTER_STATE_MACHINE IS
		PORT (	VIN, CLOCK, RST_n				: IN STD_LOGIC;
				VOUT,EN_INPUT_REG,EN_OUTPUT		: OUT STD_LOGIC;
				);
END ENTITY FILTER_STATE_MACHINE;

ARCHITECTURE BEHAVIORAL OF FILTER_STATE_MACHINE IS
	TYPE STATE_MACHINE IS (IDLE, FIRST_DATA_RECEIVED, SECOND_DATA_RECEIVED, THIRD_DATA_RECEIVED, PROCESS_ONE_DATA, ENDING_PROCESS_DATA, END_PROCESS_DATA,SPURIUS_DATA_RECEIVED);
	SIGNAL Y_PR, Y_NX: STATE_MACHINE;

BEGIN
-------------------------------------------------------------------------------------------------------------
-----------------------------------------FINITE--STATE--MACHINE----------------------------------------------
-------------------------------------------------------------------------------------------------------------
	--STATE UPDATE
	PROCESS (CLOCK,RST_n )
	BEGIN
	IF RST_n='0' THEN
		Y_PR<=IDLE;
	ELSIF (CLOCK'EVENT AND CLOCK='1') THEN   
				Y_PR<=Y_NX;
		END IF;
	END PROCESS;
	--STATE TABLE
	PROCESS ( Y_PR, VIN)
	BEGIN
		CASE Y_PR IS 
			WHEN IDLE 					=>	IF VIN='1' THEN
													Y_NX<=FIRST_DATA_RECEIVED;
												ELSE 
													Y_NX<=IDLE;
												END IF;
							
			WHEN FIRST_DATA_RECEIVED	=> IF VIN='1' THEN
												Y_NX<=SECOND_DATA_RECEIVED;
											ELSE 
												Y_NX<=PROCESS_ONE_DATA;
											END IF;
			
			WHEN SECOND_DATA_RECEIVED	=> IF VIN='1' THEN
													Y_NX<=THIRD_DATA_RECEIVED;
												ELSE 
													Y_NX<=ENDING_PROCESS_DATA;
												END IF;
			
			WHEN THIRD_DATA_RECEIVED	=> IF VIN='1' THEN
													Y_NX<=THIRD_DATA_RECEIVED;
												ELSE 
													Y_NX<=ENDING_PROCESS_DATA;
												END IF;
												
			WHEN ENDING_PROCESS_DATA	=> IF VIN='1' THEN
													Y_NX<=SPURIUS_DATA_RECEIVED;
												ELSE 
													Y_NX<=END_PROCESS_DATA;
												END IF;
			
			WHEN END_PROCESS_DATA		=> IF VIN='1' THEN
													Y_NX<=FIRST_DATA_RECEIVED;
												ELSE 
													Y_NX<=IDLE;
												END IF;
			
			WHEN PROCESS_ONE_DATA		=> IF VIN='1' THEN
													Y_NX<=SPURIUS_DATA_RECEIVED;
												ELSE 
													Y_NX<=END_PROCESS_DATA;
												END IF;	
			
			WHEN SPURIUS_DATA_RECEIVED	=> IF VIN='1' THEN
													Y_NX<=SECOND_DATA_RECEIVED;
												ELSE 
													Y_NX<=PROCESS_ONE_DATA;
												END IF;	
												
			WHEN OTHERS => Y_NX<=IDLE;				
		END CASE;
	END PROCESS; 
   --OUTPUT GENERATION
	PROCESS (Y_PR)
	BEGIN
	EN_OUTPUT <='0';
	EN_INPUT_REG <='0';
	VOUT <='0';
	CASE Y_PR IS 
			WHEN IDLE 					=>	EN_INPUT_REG <= '0';--DO NOTHING
							
			WHEN FIRST_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
			
			WHEN SECOND_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
											EN_OUTPUT <= '1';
											
			
			WHEN THIRD_DATA_RECEIVED	=> EN_INPUT_REG <= '1';
											EN_OUTPUT <= '1';
											VOUT <= '1';
												
			WHEN ENDING_PROCESS_DATA	=> EN_OUTPUT <= '1';
											VOUT <= '1';
			
			WHEN END_PROCESS_DATA		=> VOUT <= '1';
			
			WHEN PROCESS_ONE_DATA		=> EN_OUTPUT <= '1';
											
											
			WHEN SPURIUS_DATA_RECEIVED  => EN_INPUT_REG <= '1';
											VOUT <= '1';
									
		END CASE;
	END PROCESS; 	

END BEHAVIORAL;