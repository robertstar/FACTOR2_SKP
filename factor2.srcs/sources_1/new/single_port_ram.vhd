----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2021 08:41:36 AM
-- Design Name: 
-- Module Name: single_port_ram - Behavioral
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

entity single_port_ram is
generic(
        RAM_DATA_WIDTH  : integer; 
        RAM_DATA_LENGTH : integer;
        RAM_ADDR_WIDTH  : integer
    );
port( 
        RAM_WR_CLOCK    : in std_logic;                                         -- Write clock 
        RAM_WR_EN       : in std_logic;                                         -- Write enable 
        RAM_WR_ADDR     : in std_logic_vector(RAM_ADDR_WIDTH  - 1 downto 0);    -- Address to write RAM
        RAM_WR_DATA     : in std_logic_vector(RAM_DATA_WIDTH  - 1 downto 0);    -- Data to write into RAM

        RAM_RD_EN       : in std_logic;                                         -- Write enable 
        RAM_RD_ADDR     : in std_logic_vector(RAM_ADDR_WIDTH  - 1 downto 0);    -- Address to read RAM
        RAM_RD_DATA     : out std_logic_vector(RAM_DATA_WIDTH - 1 downto 0)     -- Data output of RAM
        );
end single_port_ram;

architecture Behavioral of single_port_ram is
    
    type RAM_ARRAY is array (0 to RAM_DATA_LENGTH - 1 ) of std_logic_vector (RAM_DATA_WIDTH - 1 downto 0);
    -- initial values in the RAM
    signal RAM: RAM_ARRAY :=(
        others => "00000000"
    );
    
begin

    process(RAM_WR_CLOCK)
    begin
        if(rising_edge(RAM_WR_CLOCK)) then
            if(RAM_WR_EN = '1') then
                RAM(to_integer(unsigned(RAM_WR_ADDR))) <= RAM_WR_DATA;
            end if;
        end if;
    end process;
    
    --Assign
    RAM_RD_DATA <= RAM(to_integer(unsigned(RAM_RD_ADDR))) when (RAM_RD_EN = '1') else X"00";

end Behavioral;
