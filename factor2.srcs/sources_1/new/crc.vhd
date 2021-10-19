----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2021 01:08:16 PM
-- Design Name: 
-- Module Name: crc - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity crc is
    Port ( Clk      : in STD_LOGIC;
           Reset    : in STD_LOGIC;
           Data_in  : in STD_LOGIC_VECTOR (7 downto 0);
           Enable   : in STD_LOGIC;
           Crc      : out STD_LOGIC_VECTOR (31 downto 0);
           CrcNext  : out STD_LOGIC_VECTOR (31 downto 0));
end crc;

architecture Behavioral of crc is
    signal crc_t        : std_logic_vector(31 downto 0) := (others => '0'); 
    signal crc_next_t   : std_logic_vector(31 downto 0) := (others => '0'); 
    signal Data         : std_logic_vector(0 to 7)      := (others => '0'); 
begin

    --CRC
    crc_calc : process(Clk, Reset, Enable)
    begin
        if (Reset = '1') then
            crc_t <= X"FFFFFFFF";
        elsif (Clk'event and Clk = '1' and Enable = '1') then
            crc_t <= crc_next_t;
        else
            null;
        end if;
    end process crc_calc;
    
    --assign
    Crc     <= crc_t;
    CrcNext <= crc_next_t;
    Data    <= Data_in;
    crc_next_t(0)  <= crc_t(24) xor crc_t(30) xor Data(0) xor Data(6);
    crc_next_t(1)  <= crc_t(24) xor crc_t(25) xor crc_t(30) xor crc_t(31) xor Data(0) xor Data(1) xor Data(6) xor Data(7);
    crc_next_t(2)  <= crc_t(24) xor crc_t(25) xor crc_t(26) xor crc_t(30) xor crc_t(31) xor Data(0) xor Data(1) xor Data(2) xor Data(6) xor Data(7);
    crc_next_t(3)  <= crc_t(25) xor crc_t(26) xor crc_t(27) xor crc_t(31) xor Data(1) xor Data(2) xor Data(3) xor Data(7);
    crc_next_t(4)  <= crc_t(24) xor crc_t(26) xor crc_t(27) xor crc_t(28) xor crc_t(30) xor Data(0) xor Data(2) xor Data(3) xor Data(4) xor Data(6);
    crc_next_t(5)  <= crc_t(24) xor crc_t(25) xor crc_t(27) xor crc_t(28) xor crc_t(29) xor crc_t(30) xor crc_t(31) xor Data(0) xor Data(1) xor Data(3) xor Data(4) xor Data(5) xor Data(6) xor Data(7);
    crc_next_t(6)  <= crc_t(25) xor crc_t(26) xor crc_t(28) xor crc_t(29) xor crc_t(30) xor crc_t(31) xor Data(1) xor Data(2) xor Data(4) xor Data(5) xor Data(6) xor Data(7);
    crc_next_t(7)  <= crc_t(24) xor crc_t(26) xor crc_t(27) xor crc_t(29) xor crc_t(31) xor Data(0) xor Data(2) xor Data(3) xor Data(5) xor Data(7);
    crc_next_t(8)  <= crc_t(0) xor crc_t(24) xor crc_t(25) xor crc_t(27) xor crc_t(28) xor Data(0) xor Data(1) xor Data(3) xor Data(4);
    crc_next_t(9)  <= crc_t(1) xor crc_t(25) xor crc_t(26) xor crc_t(28) xor crc_t(29) xor Data(1) xor Data(2) xor Data(4) xor Data(5);
    crc_next_t(10) <= crc_t(2) xor crc_t(24) xor crc_t(26) xor crc_t(27) xor crc_t(29) xor Data(0) xor Data(2) xor Data(3) xor Data(5);
    crc_next_t(11) <= crc_t(3) xor crc_t(24) xor crc_t(25) xor crc_t(27) xor crc_t(28) xor Data(0) xor Data(1) xor Data(3) xor Data(4);
    crc_next_t(12) <= crc_t(4) xor crc_t(24) xor crc_t(25) xor crc_t(26) xor crc_t(28) xor crc_t(29) xor crc_t(30) xor Data(0) xor Data(1) xor Data(2) xor Data(4) xor Data(5) xor Data(6);
    crc_next_t(13) <= crc_t(5) xor crc_t(25) xor crc_t(26) xor crc_t(27) xor crc_t(29) xor crc_t(30) xor crc_t(31) xor Data(1) xor Data(2) xor Data(3) xor Data(5) xor Data(6) xor Data(7);
    crc_next_t(14) <= crc_t(6) xor crc_t(26) xor crc_t(27) xor crc_t(28) xor crc_t(30) xor crc_t(31) xor Data(2) xor Data(3) xor Data(4) xor Data(6) xor Data(7);
    crc_next_t(15) <= crc_t(7) xor crc_t(27) xor crc_t(28) xor crc_t(29) xor crc_t(31) xor Data(3) xor Data(4) xor Data(5) xor Data(7);
    crc_next_t(16) <= crc_t(8) xor crc_t(24) xor crc_t(28) xor crc_t(29) xor Data(0) xor Data(4) xor Data(5);
    crc_next_t(17) <= crc_t(9) xor crc_t(25) xor crc_t(29) xor crc_t(30) xor Data(1) xor Data(5) xor Data(6);
    crc_next_t(18) <= crc_t(10) xor crc_t(26) xor crc_t(30) xor crc_t(31) xor Data(2) xor Data(6) xor Data(7);
    crc_next_t(19) <= crc_t(11) xor crc_t(27) xor crc_t(31) xor Data(3) xor Data(7);
    crc_next_t(20) <= crc_t(12) xor crc_t(28) xor Data(4);
    crc_next_t(21) <= crc_t(13) xor crc_t(29) xor Data(5);
    crc_next_t(22) <= crc_t(14) xor crc_t(24) xor Data(0);
    crc_next_t(23) <= crc_t(15) xor crc_t(24) xor crc_t(25) xor crc_t(30) xor Data(0) xor Data(1) xor Data(6);
    crc_next_t(24) <= crc_t(16) xor crc_t(25) xor crc_t(26) xor crc_t(31) xor Data(1) xor Data(2) xor Data(7);
    crc_next_t(25) <= crc_t(17) xor crc_t(26) xor crc_t(27) xor Data(2) xor Data(3);
    crc_next_t(26) <= crc_t(18) xor crc_t(24) xor crc_t(27) xor crc_t(28) xor crc_t(30) xor Data(0) xor Data(3) xor Data(4) xor Data(6);
    crc_next_t(27) <= crc_t(19) xor crc_t(25) xor crc_t(28) xor crc_t(29) xor crc_t(31) xor Data(1) xor Data(4) xor Data(5) xor Data(7);
    crc_next_t(28) <= crc_t(20) xor crc_t(26) xor crc_t(29) xor crc_t(30) xor Data(2) xor Data(5) xor Data(6);
    crc_next_t(29) <= crc_t(21) xor crc_t(27) xor crc_t(30) xor crc_t(31) xor Data(3) xor Data(6) xor Data(7);
    crc_next_t(30) <= crc_t(22) xor crc_t(28) xor crc_t(31) xor Data(4) xor Data(7);
    crc_next_t(31) <= crc_t(23) xor crc_t(29) xor Data(5);

end Behavioral;
