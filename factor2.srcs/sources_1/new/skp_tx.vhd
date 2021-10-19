----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2021 01:46:52 PM
-- Design Name: 
-- Module Name: skp_tx - Behavioral
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


entity skp_tx is
generic(
        CLK_FREQ    : integer; 
        SKP_ADDR    : integer;
        SPEED       : integer
    );
Port ( 
        CLK         : in  STD_LOGIC;
        RST         : in  STD_LOGIC;
        WR_EN       : in  STD_LOGIC;
        TXD         : out STD_LOGIC := '1';
        TX_BUSY     : out STD_LOGIC := '0'
    );
end skp_tx;


architecture Behavioral of skp_tx is
    
    
    ---------------------------------------------------------------------------------------
    type   tx_state_t       is (IDLE, SEND);
    signal tx_st            : tx_state_t := IDLE;
    signal data_x52         : std_logic_vector(72 downto 0) := b"1111_0_01001010_110_00100100_010_01100000_010_00000000_010_11001010_010_11101100_0_1111";
    signal data_x51         : std_logic_vector(72 downto 0) := b"1111_0_10001010_110_00100100_010_01100000_010_00000000_010_11001010_010_11001110_0_1111";
    
    signal uart_data_addr   : std_logic_vector(7 downto 0)  := (others => '0');
    signal uart_shift       : std_logic_vector(72 downto 0) := (others => '0');
    
    signal uart_clk         : std_logic := '0';
    
    signal set_wr           : std_logic := '0';
    signal get_wr           : std_logic := '0';
    
    signal txcnt16          : INTEGER RANGE 0 TO 15 := 0; 
    
    ---------------------------------------------------------------------------------------
    component baud_rate
    generic(
        CLK_FREQ    : integer; 
        SPEED       : integer
    ); 
    port (
        clk         : in std_logic; 
        rst         : in std_logic; 
        bclk        : out std_logic
    );
    end component;
    
begin

    ---------------------------------------------------------------------------------------
    --Assign 
    TX_BUSY  <= '1' when (tx_st = SEND) else '0';
    
    
    --------------------------------------------------------------------------------------------------------
    baud_gen_inst: baud_rate
    generic map(
        CLK_FREQ    => CLK_FREQ,
        SPEED       => SPEED
    )
    port map(    
        clk         => CLK,
        rst         => RST,
        bclk        => uart_clk
    ); 
    
    
    --------------------------------------------------------------------------------------------------------------------
    tx_comb: process (WR_EN, get_wr) begin 
        if (WR_EN = '1') then
            set_wr <= '1';
        end if;
        
        if (get_wr = '1') then
            set_wr <= '0';
        end if;   
    end process tx_comb; 
    
    
    ---------------------------------------------------------------------------------------
    tx_sequential : process (uart_clk)
    begin
        if rising_edge(uart_clk) then

            IF txcnt16 = 15 THEN 
				txcnt16 <= 0; 
				
				if(set_wr = '1') then
                    get_wr <= '1';
                else
                    get_wr <= '0';
                end if;
				
				case tx_st is
                    when IDLE   =>
                        if (get_wr = '1') then
                            tx_st <= SEND;
                            case SKP_ADDR is
                                when 51     => uart_shift <= data_x51;
                                when 52     => uart_shift <= data_x52;
                                when others => uart_shift <= data_x52;
                            end case;
                            uart_data_addr <= "00000000";
                        end if;
    
                    when SEND   =>
                        if(uart_data_addr /= X"49") then
                            uart_data_addr          <= uart_data_addr + 1;
                            TXD                     <= uart_shift(72);
                            uart_shift(72 DOWNTO 1) <= uart_shift(71 DOWNTO 0); 
                        else
                            TXD            <= '1';
                            tx_st          <= IDLE;
                            uart_data_addr <= "00000000";
                        end if;
                    
                    when others => null;
                end case;
			ELSE 
				txcnt16 <= txcnt16 + 1; 
			END IF; 
			     
        end if;        
    end process tx_sequential;

end Behavioral;
