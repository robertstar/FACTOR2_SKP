----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2021 12:14:47 PM
-- Design Name: 
-- Module Name: skp_tx_tb - Behavioral
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


entity skp_tx_tb is
end skp_tx_tb;

architecture Behavioral of skp_tx_tb is


    signal clk_125Mhz    : std_logic := '0';
    
    signal SKP_SERIAL_RX : std_logic := '0';
    signal SKP_SERIAL_TX : std_logic;
    signal SKP_SERIAL_RE : std_logic;
    signal SKP_SERIAL_DE : std_logic;
    
    constant clk_period : time := 8 ns;
    
    signal tx_en    : std_logic := '0';
    signal tx_data  : std_logic_vector (7 downto 0) := (others => '0');
    signal rx_data  : std_logic_vector (7 downto 0) := (others => '0');
    signal rx       : std_logic;
    signal rx_busy  : std_logic;
    signal rx_error : std_logic;
    signal tx       : std_logic;
    signal tx_busy  : std_logic;
    
    signal SKP25700_RD_DATA    : std_logic_vector(7 downto 0);
    signal SKP25700_BUSY       : std_logic;
    signal SKP25700_DONE       : std_logic;
    signal SKP25700_RD_EN      : std_logic := '0';
    signal SKP25700_RD_ADDR    : std_logic_vector(4 downto 0):= (others => '0');
    
    signal parity_eo           : std_logic := '0';

    ---------------------------------------------------------------------------------------
    component skp_rs485
    generic(
        CLK_FREQ            : integer; 
        SKP_ADDR            : integer;
        SPEED               : integer;
        TX_PKT              : integer                           -- tx packet per second
    ); 
    port (
        CLK                 : in  STD_LOGIC;
        RST                 : in  STD_LOGIC;
        SERIAL_RX           : in  STD_LOGIC;
        SERIAL_TX           : out STD_LOGIC;
        SERIAL_RE           : out STD_LOGIC;
        SERIAL_DE           : out STD_LOGIC;
        
        SKP25700_RD_EN      : in  std_logic;
        SKP25700_RD_ADDR    : in  std_logic_vector(4 downto 0);
        SKP25700_RD_DATA    : out std_logic_vector(7 downto 0);
        SKP25700_BUSY       : out std_logic := '0';
        SKP25700_DONE       : out std_logic := '0'
    );
    end component;


    ---------------------------------------------------------------------------------------
    component uart
      GENERIC(
        clk_freq        :  INTEGER;                                    --frequency of system clock in Hertz
        baud_rate       :  INTEGER;                                    --data link baud rate in bits/second
        os_rate         :  INTEGER;                                    --oversampling rate to find center of receive bits (in samples per baud period)
        d_width         :  INTEGER;                                    --data bus width
        parity          :  INTEGER                                     --0 for no parity, 1 for parity
        --parity_eo       :  STD_LOGIC);                                 --'0' for even, '1' for odd parity
      );
      PORT(
        clk             :  IN   STD_LOGIC;                             --system clock
        reset_n         :  IN   STD_LOGIC;                             --ascynchronous reset
        tx_ena          :  IN   STD_LOGIC;                             --initiate transmission
        tx_data         :  IN   STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
        rx              :  IN   STD_LOGIC;                             --receive pin
        rx_busy         :  OUT  STD_LOGIC;                             --data reception in progress
        rx_error        :  OUT  STD_LOGIC;                             --start, parity, or stop bit error detected
        rx_data         :  OUT  STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data received
        tx_busy         :  OUT  STD_LOGIC;                             --transmission in progress
        tx              :  OUT  STD_LOGIC;
        parity_eo       :  IN   STD_LOGIC);  
    end component;



    
begin


    clock_process :process
	begin
		clk_125Mhz <= '0';
		wait for clk_period/2;
		clk_125Mhz <= '1';
		wait for clk_period/2;
	end process;


    -------------------------------------------------------------------------------------
--    uart_inst: uart
--    generic map(
--        clk_freq    => 125_000_000, --frequency of system clock in Hertz
--        baud_rate   => 57_600,      --data link baud rate in bits/second
--        os_rate     => 16,          --oversampling rate to find center of receive bits (in samples per baud period)
--        d_width     => 8,           --data bus width
--        parity      => 0,           --0 for no parity, 1 for parity
--        parity_eo   => '0'
--    )
--    port map(    
--        clk         => clk_125Mhz,                 --system clock
--        reset_n     => '1',                        --ascynchronous reset
--        tx_ena      => tx_en,                      --initiate transmission
--        tx_data     => tx_data,                    --data to transmit
--        rx          => rx,                         --receive pin
--        rx_busy     => rx_busy,                    --data reception in progress
--        rx_error    => rx_error,                   --start, parity, or stop bit error detected
--        rx_data     => rx_data,                    --data received
--        tx_busy     => tx_busy,                    --transmission in progress
--        tx          => tx
--    );
    
    uart_inst: uart
    generic map(
        clk_freq    => 125_000_000,         --frequency of system clock in Hertz
        baud_rate   => 57_600,              --data link baud rate in bits/second
        os_rate     => 16,                  --oversampling rate to find center of receive bits (in samples per baud period)
        d_width     => 8,                   --data bus width
        parity      => 1                    --0 for no parity, 1 for parity
        --parity_eo   => parity_eo          --'0' for even, '1' for odd parity
    )
    port map(    
        clk         => clk_125Mhz,                 --system clock
        reset_n     => '1',                 --ascynchronous reset
        
        parity_eo   => parity_eo,
        
        tx_ena      => tx_en,               --initiate transmission
        tx_data     => tx_data,             --data to transmit
        tx          => tx,
        tx_busy     => tx_busy,             --transmission in progress
        
        rx_data     => rx_data,             --data received
        rx          => rx,           --receive pin
        rx_busy     => rx_busy,             --data reception in progress
        rx_error    => rx_error               --start, parity, or stop bit error detected   
    );
    
    
    
    --rx <= tx;
    SKP_SERIAL_RX <= tx;

    ---------------------------------------------------------------------------------------
    skp_rs485_inst: skp_rs485
    generic map(
        CLK_FREQ            => 125000000,
        SKP_ADDR            => 52,
        SPEED               => 57600,
        TX_PKT              => 50        -- tx packet per second
    )
    port map(    
        CLK                 => clk_125Mhz,
        RST                 => '0',
        SERIAL_RX           => SKP_SERIAL_RX,
        SERIAL_TX           => SKP_SERIAL_TX,
        SERIAL_RE           => SKP_SERIAL_RE,
        SERIAL_DE           => SKP_SERIAL_DE,
        
        SKP25700_RD_EN      => SKP25700_RD_EN,
        SKP25700_RD_ADDR    => SKP25700_RD_ADDR,
        SKP25700_RD_DATA    => SKP25700_RD_DATA,
        SKP25700_BUSY       => SKP25700_BUSY,
        SKP25700_DONE       => SKP25700_DONE
    );


    stim_proc: process
    begin
        wait for 80 ns;
--        dac_wr   <= '1';
--        work_st  <= X"31";
--        envelope <= '0';
--        dac_addr <= "0000000000";

        l_acc : for i in 0 to 18 loop
                    
                    case i is
                        when 0 => 
                            tx_data <= X"52";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns;
                            
                         when 1 => 
                            tx_data <= X"24";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns;   
                         
                         when 2 => 
                            tx_data <= X"13";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns;  
                            
                         when 3 => 
                            tx_data <= X"00";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns;   
                            
                            
                         when 4 => 
                            tx_data <= X"1D";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns;   
                            
                         when 18 => 
                            tx_data <= X"78";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns; 

                        when others => 
                            tx_data <= X"00";
                            tx_en   <= '1';
                            wait for 8 ns;
                            tx_en   <= '0';
                            wait until tx_busy = '0';
                            wait for 8 ns;
 
                    end case;
        end loop l_acc;


        wait for 8 ns;
--        SKP25700_RD_EN   <= '1';
        
        
--        wait until SKP25700_BUSY = '0';
--        wait for 8 ns;
--        wait until SKP25700_DONE = '1';
--        wait for 8 ns;
        

        l_acc2 : for i in 0 to 19 loop
            case i is
                when 0 => 
                    SKP25700_RD_EN   <= '1';
                    SKP25700_RD_ADDR <= "00000";
                    wait for 8 ns;
                    
                when 19 => 
                    SKP25700_RD_EN   <= '0';
                    SKP25700_RD_ADDR <= "00000";
                    wait for 8 ns;
                
                when others => 
                    SKP25700_RD_ADDR <= SKP25700_RD_ADDR + 1;
                    wait for 8 ns;
            end case;
        end loop l_acc2;
        
--        tx_data <= X"A7";
--        tx_en   <= '1';
--        wait for 8 ns;
--        tx_en   <= '0';
--        wait until tx_busy = '0';
--        wait for 8 ns;


--        tx_data <= X"55";
--        tx_en   <= '1';
--        wait for 8 ns;
--        tx_en   <= '0';
--        wait until tx_busy = '0';
--        wait for 8 ns;

        
        
    
--         in_s1    <= "1000000000"; 
--         in_s1_dcount <= X"010";
--         wait for 20 ns;
--         
--         in_s1    <= "1001010100"; 
--         in_s1_dcount <= X"039";
--         wait for 20 ns;
--         
--         in_s1    <= "1011010110"; 
--         in_s1_dcount <= X"040";
--         wait for 20 ns;
        
--         in_s1    <= "1101010101"; 
--         in_s1_dcount <= X"042";
--         wait for 20 ns;
--         
--         in_s1    <= "1010010011"; 
--         in_s1_dcount <= X"035";
--         wait for 20 ns;
--         
--         in_s1    <= "1001110110"; 
--         in_s1_dcount <= X"010";
--         wait for 20 ns;
        
--         in_s1    <= "1011010110"; 
--         in_s1_dcount <= X"001";
--         wait for 20 ns;
--         
--         in_s1    <= "1001110011"; 
--         in_s1_dcount <= X"000";
--         wait for 20 ns;
        
--         in_s1    <= "1011110011"; 
--         in_s1_dcount <= X"000";
--         wait for 20 ns;
    
    
        --input <= "000"; wait for 10 ns; assert output = "00" report "0+0+0 failed";
        --input <= "001"; wait for 10 ns; assert output = "01" report "0+0+1 failed";
        --input <= "010"; wait for 10 ns; assert output = "01" report "0+1+0 failed";
        --input <= "100"; wait for 10 ns; assert output = "01" report "1+0+0 failed";
        --input <= "011"; wait for 10 ns; assert output = "10" report "0+1+1 failed";
        --input <= "110"; wait for 10 ns; assert output = "10" report "1+1+0 failed";
        --input <= "111"; wait for 10 ns; assert output = "11" report "1+1+1 failed";

-- 	wait for 200 ns;
-- 	--reset_n <= '0';
-- 	wait for 200 ns;
	--reset_n <= '1';
	--wait for 200 ns;
	--up_down <= '1';
	wait for 600000 ns;
        report "testbench finished";
        wait;
    end process;


end Behavioral;
