----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 18:26:49
-- Design Name: 
-- Module Name: factor_tb - Behavioral
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

entity factor_tb is
end factor_tb;

architecture Behavioral of factor_tb is

    constant clk_period     : time := 17 ns;
    signal   clk_60Mhz      : std_logic := '0';
    
    signal HL1              : std_logic := '0';
    signal HL4              : std_logic := '0';
    
    signal PHY_MDC          : std_logic := '0';
    signal PHY_MDIO         : std_logic := '0';
    
    signal adc_bus_1        : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
    signal adc_bus_2        : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
    signal adc_bus_3        : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
    signal adc_bus_4        : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
    signal adc_rst          : STD_LOGIC := '0';
    signal adc_conv         : STD_LOGIC := '0';
    signal adc_rd12         : STD_LOGIC := '0';
    signal adc_rd34         : STD_LOGIC := '0';
    signal adc_cs           : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    
    --Control
    signal rk_o             : STD_LOGIC;
    signal ru_o             : STD_LOGIC;
    
    --DAC
    signal dac_sync         : STD_LOGIC;
    signal dac_sclk         : STD_LOGIC;
    signal dac_sdata        : STD_LOGIC;
   
    --DDS
    signal dds_rst          : STD_LOGIC;
    signal dds_mclk         : STD_LOGIC;
    signal dds_sclk         : STD_LOGIC;
    signal dds_upd          : STD_LOGIC;
    signal dds_pdata        : STD_LOGIC_VECTOR (7 downto 0);
    
    --TRIGGER
    signal envelope         : STD_LOGIC;
    
    --SKP
    signal SKP_SERIAL_RX    : STD_LOGIC;
    signal SKP_SERIAL_TX    : STD_LOGIC;
    signal SKP_SERIAL_RE    : STD_LOGIC;
    signal SKP_SERIAL_DE    : STD_LOGIC;
    
    --DFS
    signal DFS_SERIAL_RX    : STD_LOGIC;
    signal DFS_SERIAL_TX    : STD_LOGIC;
    signal DFS_SERIAL_RE    : STD_LOGIC;
    signal DFS_SERIAL_DE    : STD_LOGIC;
    
    
    --ETHERNET
    signal PHY_TX_DISABLE   : STD_LOGIC;
    signal PHY_COMA         : STD_LOGIC;
    signal PHY_RESET_N      : STD_LOGIC;
    signal PHY_GTXC         : STD_LOGIC;
    signal PHY_RXC          : STD_LOGIC;
    signal PHY_RXER         : STD_LOGIC;
    signal PHY_RXDV         : STD_LOGIC;
    signal PHY_RXD          : STD_LOGIC_VECTOR (7 downto 0);
    signal PHY_TXC          : STD_LOGIC;
    signal PHY_TXEN         : STD_LOGIC;
    signal PHY_TXER         : STD_LOGIC;
    signal PHY_TXD          : STD_LOGIC_VECTOR (7 downto 0);

    ---------------------------------------------------------------------------------------
    component factor2
    port (
            sys_clk          : in STD_LOGIC;
            sys_led          : out STD_LOGIC;
            led_HL4          : out STD_LOGIC;
            
            --MDIO
            PHY_MDC          : out STD_LOGIC;
            PHY_MDIO         : inout STD_LOGIC;
            
            --ADC
            adc_bus_1        : in STD_LOGIC_VECTOR (15 downto 0);
            adc_bus_2        : in STD_LOGIC_VECTOR (15 downto 0);
            adc_bus_3        : in STD_LOGIC_VECTOR (15 downto 0);
            adc_bus_4        : in STD_LOGIC_VECTOR (15 downto 0);
            adc_rst          : out STD_LOGIC;
            adc_conv         : out STD_LOGIC;
            adc_rd12         : out STD_LOGIC;
            adc_rd34         : out STD_LOGIC;
            adc_cs           : out STD_LOGIC_VECTOR (7 downto 0);
            
            --Control
            rk_o             : out STD_LOGIC;
            ru_o             : out STD_LOGIC;
            
            --DAC
            dac_sync         : out STD_LOGIC;
            dac_sclk         : out STD_LOGIC;
            dac_sdata        : out STD_LOGIC;
           
            --DDS
            dds_rst          : out STD_LOGIC;
            dds_mclk         : out STD_LOGIC;
            dds_sclk         : out STD_LOGIC;
            dds_upd          : out STD_LOGIC;
            dds_pdata        : out STD_LOGIC_VECTOR (7 downto 0);
            
            --TRIGGER
            envelope         : in STD_LOGIC;
            
            --SKP
            SKP_SERIAL_RX    : in  STD_LOGIC;
            SKP_SERIAL_TX    : out STD_LOGIC;
            SKP_SERIAL_RE    : out STD_LOGIC;
            SKP_SERIAL_DE    : out STD_LOGIC;
            
            --DFS
            DFS_SERIAL_RX    : in  STD_LOGIC;
            DFS_SERIAL_TX    : out STD_LOGIC;
            DFS_SERIAL_RE    : out STD_LOGIC;
            DFS_SERIAL_DE    : out STD_LOGIC;
            
            
            --ETHERNET
            PHY_TX_DISABLE   : out STD_LOGIC;
            PHY_COMA         : out STD_LOGIC;
            PHY_RESET_N      : out STD_LOGIC;
            PHY_GTXC         : out STD_LOGIC;
            PHY_RXC          : in STD_LOGIC;
            PHY_RXER         : in STD_LOGIC;
            PHY_RXDV         : in STD_LOGIC;
            PHY_RXD          : in STD_LOGIC_VECTOR (7 downto 0);
            PHY_TXC          : in STD_LOGIC;
            PHY_TXEN         : out STD_LOGIC;
            PHY_TXER         : out STD_LOGIC;
            PHY_TXD          : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;

begin

    clock_process :process
	begin
		clk_60Mhz <= '0';
		wait for clk_period/2;
		clk_60Mhz <= '1';
		wait for clk_period/2;
	end process;


    ---------------------------------------------------------------------------------------
    factor2_inst: factor2
    port map(    
        sys_clk          => clk_60Mhz,
        
        sys_led          => HL1,
        led_HL4          => HL4,
        
        --MDIO
        PHY_MDC          => PHY_MDC,
        PHY_MDIO         => PHY_MDIO,
        
        --ADC
        adc_bus_1        => adc_bus_1,
        adc_bus_2        => adc_bus_2,
        adc_bus_3        => adc_bus_3,
        adc_bus_4        => adc_bus_4,
        adc_rst          => adc_rst,
        adc_conv         => adc_conv,
        adc_rd12         => adc_rd12,
        adc_rd34         => adc_rd34,
        adc_cs           => adc_cs,
        
        --Control
        rk_o             => rk_o,
        ru_o             => ru_o,
        
        --DAC
        dac_sync         => dac_sync,
        dac_sclk         => dac_sclk,
        dac_sdata        => dac_sdata,
        
        --DDS
        dds_rst          => dds_rst,
        dds_mclk         => dds_mclk,
        dds_sclk         => dds_sclk,
        dds_upd          => dds_upd,
        dds_pdata        => dds_pdata,
        
        --TRIGGER
        envelope         => envelope,
        
        --SKP
        SKP_SERIAL_RX    => SKP_SERIAL_RX,
        SKP_SERIAL_TX    => SKP_SERIAL_TX,
        SKP_SERIAL_RE    => SKP_SERIAL_RE,
        SKP_SERIAL_DE    => SKP_SERIAL_DE,
        
        --DFS
        DFS_SERIAL_RX    => DFS_SERIAL_RX,
        DFS_SERIAL_TX    => DFS_SERIAL_TX,
        DFS_SERIAL_RE    => DFS_SERIAL_RE,
        DFS_SERIAL_DE    => DFS_SERIAL_DE,
        
        
        --ETHERNET
        PHY_TX_DISABLE   => PHY_TX_DISABLE,
        PHY_COMA         => PHY_COMA,
        PHY_RESET_N      => PHY_RESET_N,
        PHY_GTXC         => PHY_GTXC,
        PHY_RXC          => PHY_RXC,
        PHY_RXER         => PHY_RXER,
        PHY_RXDV         => PHY_RXDV,
        PHY_RXD          => PHY_RXD,
        PHY_TXC          => PHY_TXC,
        PHY_TXEN         => PHY_TXEN,
        PHY_TXER         => PHY_TXER,
        PHY_TXD          => PHY_TXD
    );


end Behavioral;
