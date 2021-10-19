----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2021 08:20:35 AM
-- Design Name: 
-- Module Name: baud_rate - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

 
entity baud_rate is 
generic(
        CLK_FREQ    : integer; 
        SPEED       : integer
    );
port (
        clk         : in std_logic; 
        rst         : in std_logic; 
        bclk        : out std_logic := '0'
    ); 
end baud_rate; 

 
architecture baud_rate of baud_rate is 
	signal baud_clk        : std_logic := '0'; 
	signal fre_div_factor  : integer range 0 to 50000 := CLK_FREQ/16/SPEED; 
	 
	begin 
	PROCESS (clk, rst) 
		VARIABLE baud_cnt: INTEGER RANGE 0 TO 10415; 
		BEGIN 
		IF rst = '1' THEN 
			baud_cnt := 0; 
			baud_clk <= '0'; 
		ELSIF clk'EVENT AND clk = '1' THEN 
			
--			case baud_sel is  
--				when "00" => fre_div_factor <= 50000000/16/300; 
--				when "01" => fre_div_factor <= 50000000/16/2400; 
--				when "10" => fre_div_factor <= 50000000/16/9600; 
--				when "11" => fre_div_factor <= 50000000/16/115200; 
--			end case; 
		 
		    IF baud_cnt = fre_div_factor-1 THEN 
				baud_cnt := 0; 
			ELSE 
				baud_cnt := baud_cnt + 1; 
			END IF; 
			IF baud_cnt = 0 THEN     
				baud_clk <= '0';        
			ELSIF baud_cnt = fre_div_factor/2 THEN  
				baud_clk <= '1'; 
			END IF; 
		END IF; 
		bclk <= baud_clk; 
		END PROCESS; 
end baud_rate;
