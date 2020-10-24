library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity tb_output_data_checker is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
	END_SIM : in std_logic;
    DIN0, DIN1, DIN2   : in std_logic_vector(7 downto 0));
end tb_output_data_checker;

architecture beh of tb_output_data_checker is
	SIGNAL CORRECT_VALUE    :  std_logic_vector(7 downto 0);

begin  -- beh

 process (CLK, RST_n, END_SIM)--tb process
	--Open results output file  --------------------------------------
    file res_fp : text open WRITE_MODE is "./results.csv";
    variable line_out : line;    
	-------------------------------------------------------------------
	--Open file of input values and file of correct output values
	file inputValues_fp : text open READ_MODE is "../../C/samples.txt";
	file correctOutputValues_fp : text open READ_MODE is "../../C/resultsc.txt";
    variable line_in : line;  
	variable input0, input1, input2 , correctOutputValue0, correctOutputValue1, correctOutputValue2 , filterOutput0, filterOutput1, filterOutput2 : integer;
	variable signal_error: integer :=0;
	-------------------------------------------------------------------
	variable write_first_line_in_csv : std_logic := '0';
	   

 begin  -- process
	if write_first_line_in_csv = '0' then 
		write(line_out, string'("INPUT0, INPUT1, INPUT2, OUTPUT0, OUTPUT1, OUTPUT2, EXPECTED OUTPUT0, EXPECTED OUTPUT1, EXPECTED OUTPUT2, TEST RESULT0, TEST RESULT1, TEST RESULT3"));
      	writeline(res_fp, line_out);
		write_first_line_in_csv := '1';
	end if;

		
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (VIN = '1') then
		
		--Write INPUT value readed from file
		if not endfile(inputValues_fp) then
			readline(inputValues_fp, line_in);
			read(line_in, input0);
			if not endfile(inputValues_fp) then
				readline(inputValues_fp, line_in);
				read(line_in, input1);
			else
				input1:=0;
			end if;
			if not endfile(inputValues_fp) then
				readline(inputValues_fp, line_in);
				read(line_in, input2);
			else
				input2:=0;
			end if;
        end if;
		write(line_out, input0);
		write(line_out, string'(","));
		write(line_out, input1);
		write(line_out, string'(","));
		write(line_out, input2);
		write(line_out, string'(","));
		--Write OUTPUT value obtained by tested circuit
		filterOutput0 := conv_integer(signed(DIN0));
		filterOutput1 := conv_integer(signed(DIN1));
		filterOutput2 := conv_integer(signed(DIN2));
        write(line_out, filterOutput0);
		write(line_out, string'(","));
        write(line_out, filterOutput1);
		write(line_out, string'(","));
        write(line_out, filterOutput2);
		write(line_out, string'(","));
		--Write EXPECTED OUTPUT value readed from file
        if not endfile(correctOutputValues_fp) then
			readline(correctOutputValues_fp, line_in);
			read(line_in, correctOutputValue0);
			if not endfile(correctOutputValues_fp) then
				readline(correctOutputValues_fp, line_in);
				read(line_in, correctOutputValue1);
			else
				correctOutputValue1:=0;
			end if;
			if not endfile(correctOutputValues_fp) then
				readline(correctOutputValues_fp, line_in);
				read(line_in, correctOutputValue2);
			else
				correctOutputValue2:=0;
			end if;
        end if;
		write(line_out, correctOutputValue0);
		write(line_out, string'(","));
		write(line_out, correctOutputValue1);
		write(line_out, string'(","));
		write(line_out, correctOutputValue2);
		write(line_out, string'(","));       
		--Test result an write TEST RESULT
		if (correctOutputValue0 /= filterOutput0 or correctOutputValue1 /= filterOutput1 or correctOutputValue2 /= filterOutput2) then
          write(line_out, string'("Error"));
		  signal_error:=1;
        else
          write(line_out, string'("OK"));
		end if;
		writeline(res_fp, line_out);
      end if;
    end if;

	if END_SIM = '1' THEN
		if signal_error=0 then
			write(line_out, string'("SIMULATION ENDED SUCCESSFULLY"));
			writeline(res_fp, line_out);
		else
			write(line_out, string'("ERROR, WRONG RESULT PRODUCED"));
			writeline(res_fp, line_out);
		end if;			
	end if;
  end process;
end beh;
