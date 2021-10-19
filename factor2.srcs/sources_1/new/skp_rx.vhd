----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2021 02:51:04 PM
-- Design Name: 
-- Module Name: skp_rx - Behavioral
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


entity skp_rx is
generic(
        CLK_FREQ    : integer; 
        SPEED       : integer
    );
Port ( 
        CLK             : in  STD_LOGIC;
        RST             : in  STD_LOGIC;
        SERIAL_RX       : in  STD_LOGIC;
        SERIAL_RE       : in  STD_LOGIC;
        RX_DATA         : out STD_LOGIC_VECTOR (7 downto 0) := X"00";
        RX_DONE         : out STD_LOGIC := '0' 
    );
end skp_rx;

architecture Behavioral of skp_rx is

    type uart_rx_states is ( 
        rx_idle,
        rx_start_data_low,
        rx_start_data_high,
        rx_start_data_delay,
        rx_receive           
    );            
    signal uart_rx_state    : uart_rx_states := rx_idle;
    signal uart_clk         : std_logic := '0';
    signal uart_rx_data_sr  : std_logic_vector(1 downto 0) := (others => '1');
    signal uart_period_rx   : INTEGER RANGE 0 TO 150000 := 0; 
    signal bit_rx_nn        : std_logic_vector(2 downto 0) := (others => '0');
    signal rx_data_t        : std_logic_vector (7 downto 0) := X"00";

    ---------------------------------------------------------------------------------------
--    component baud_rate
--    generic(
--        CLK_FREQ    : integer; 
--        SPEED       : integer
--    ); 
--    port (
--        clk         : in std_logic; 
--        rst         : in std_logic; 
--        bclk        : out std_logic
--    );
--    end component;

begin


--    --------------------------------------------------------------------------------------------------------
--    baud_gen_inst: baud_rate
--    generic map(
--        CLK_FREQ    => CLK_FREQ,
--        SPEED       => SPEED
--    )
--    port map(    
--        clk         => CLK,
--        rst         => RST,
--        bclk        => uart_clk
--    ); 
    
    
--    --------------------------------------------------------------------------------------------------------
--    rxd_synchronise : process(CLK)
--    begin
--        if rising_edge(CLK) then
--            if RST = '1' then
--                uart_rx_data_sr <= (others => '1');
--            else
--                if uart_clk = '1' then
--                    uart_rx_data_sr(0) <= SERIAL_RX;
--                    uart_rx_data_sr(1) <= uart_rx_data_sr(0);
--                end if;
--            end if;
--        end if;
--    end process rxd_synchronise;
    
    
    ---------------------------------------------------------------------------------------
    rx_sequential : process (CLK)
    begin
        if rising_edge(CLK) then
            
            if(SERIAL_RE = '0') then
            
                case uart_rx_state is
                    
                    when rx_idle =>
                        RX_DONE <= '0';
                        if(SERIAL_RX = '1') then
                           uart_period_rx <= uart_period_rx + 1; 
                           if uart_period_rx = (CLK_FREQ / SPEED) then   
                                uart_rx_state  <= rx_start_data_low;
                                uart_period_rx <= 0;
                           end if;
                        end if;
                    
                    when rx_start_data_low =>
                        if uart_period_rx /= (CLK_FREQ / SPEED) then   
                            uart_period_rx <= uart_period_rx + 1;
                        else
                            uart_period_rx <= 0;	 
                            uart_rx_state <= rx_start_data_high;
                        end if;
                    
                    when rx_start_data_high =>
                        if SERIAL_RX = '0' then
                            uart_period_rx <= uart_period_rx + 1;
                            if uart_period_rx = (CLK_FREQ / SPEED) then
                                uart_rx_state <= rx_start_data_delay;
                                uart_period_rx <= 0;
                            end if;
                        end if;
                    
                    when rx_start_data_delay =>
                        if uart_period_rx /= (CLK_FREQ / SPEED)  then
                            uart_period_rx <= uart_period_rx + 1;
                        else
                            uart_period_rx <= 0;
                            uart_rx_state <= rx_receive;
                        end if;
                    
                    when rx_receive => 
                        if uart_period_rx /= (CLK_FREQ / SPEED) then
                           uart_period_rx <= uart_period_rx + 1;
                        else
                            uart_period_rx <= 0;
                            if(bit_rx_nn /= X"07") then
                                bit_rx_nn <= bit_rx_nn + 1;
                            else 
                                bit_rx_nn     <= "000";
                                uart_rx_state <= rx_idle;
                                RX_DONE       <= '1';
                            end if;
                            rx_data_t(7)          <= SERIAL_RX;
                            rx_data_t(6 downto 0) <= rx_data_t(7 downto 1);  
                        end if;
            
                    when others => null;     
                end case;
            else
                RX_DONE         <= '0';
                uart_period_rx  <= 0;
                bit_rx_nn       <= "000";
                uart_rx_state   <= rx_idle;
                rx_data_t       <= X"00";
            end if;
			     
        end if;        
    end process rx_sequential;
    
    --Assign 
    RX_DATA <= rx_data_t;


end Behavioral;
