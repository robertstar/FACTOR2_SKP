----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2021 07:28:25 AM
-- Design Name: 
-- Module Name: factor2 - Behavioral
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


entity factor2 is
Port ( 
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
            PHY_TXD          : out STD_LOGIC_VECTOR (7 downto 0));
end factor2;

architecture Behavioral of factor2 is

    constant max_count              : natural := 50000000;
    
    signal clk_125Mhz               : std_logic;
    SIGNAL clk_25Mhz                : std_logic;
    signal clk_12M8                 : std_logic;
    signal clk_10Mhz                : std_logic;
    signal phy_done                 : std_logic;

    signal adc_done                 : std_logic := '0';
    signal adc_data                 : STD_LOGIC_VECTOR (1359 downto 0);
    
    signal r_led                    : std_logic := '0';
    signal r_led2                   : std_logic := '0';
    
    signal tx_en                    : std_logic := '0';

    
    signal gclk                     : std_logic :='0';
    signal arp_ok                   : std_logic := '0';
    
    signal cnt_dbg_st               : std_logic_vector(3 downto 0);
    signal rx_count_dbg             : std_logic_vector(15 downto 0);
    
    signal rx_dv2_dbg               : std_logic;
    signal rx_err2_dbg              : std_logic;
    signal rx_data2_dbg             : std_logic_vector(7 downto 0);
    signal rx_tlast2_dbg            : std_logic;
    
    
    signal arp_fifo_wr_clk          : std_logic;
    signal arp_fifo_wr_en           : std_logic;
    signal arp_fifo_wr_data         : std_logic_vector (9 downto 0);
    
    signal arp_fifo_dout            : std_logic_vector (9 downto 0);
    signal arp_fifo_rd_dcount       : std_logic_vector (11 downto 0);
    signal arp_fifo_rd_en           : std_logic;
    
    signal arb_dout                 : std_logic_vector (9 downto 0);
    
    signal s_adc_rst                : std_logic :='0';
    signal s_adc_conv               : std_logic :='0';
    signal s_adc_rd12               : std_logic :='0';
    signal s_adc_rd34               : std_logic :='0';
    signal s_adc_cs                 : std_logic_vector (7 downto 0) := (others => '0');
    
    signal work_st                  : std_logic_vector (7 downto 0) := (others => '0');
    signal p_varu_cnt               : std_logic_vector (31 downto 0):= (others => '0');
    signal reset_n                  : std_logic :='1';
    

    signal MEM_SKP_25700_RD_EN      : std_logic :='0';
    signal MEM_SKP_25700_RD_ADDR    : std_logic_vector(4 downto 0) := (others => '0');
    signal MEM_SKP_25700_RD_DATA    : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_SKP_25700_BUSY       : std_logic :='0';
    signal MEM_SKP_25700_DONE       : std_logic :='0';
    
    signal MEM_SKP_26100_RD_EN      : std_logic :='0';
    signal MEM_SKP_26100_RD_ADDR    : std_logic_vector(4 downto 0) := (others => '0');
    signal MEM_SKP_26100_RD_DATA    : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_SKP_26100_BUSY       : std_logic :='0';
    signal MEM_SKP_26100_DONE       : std_logic :='0';
    
    signal MEM_DFS_26010_RD_EN      : std_logic :='0';
    signal MEM_DFS_26010_RD_ADDR    : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_DFS_26010_RD_DATA    : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_DFS_26010_BUSY       : std_logic :='0';
    signal MEM_DFS_26010_DONE       : std_logic :='0';
    
    signal MEM_DFS_26100_RD_EN      : std_logic :='0';
    signal MEM_DFS_26100_RD_ADDR    : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_DFS_26100_RD_DATA    : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_DFS_26100_BUSY       : std_logic :='0';
    signal MEM_DFS_26100_DONE       : std_logic :='0';
    
    signal sel_dbg                  : std_logic_vector(7 downto 0);
    
    signal FIFO_26010_WR_DATA       : std_logic_vector(9 downto 0) := (others => '0');
    signal FIFO_26010_WR_EN         : std_logic := '0';
    signal FIFO_26010_RD_DATA       : std_logic_vector (9 downto 0);
    signal FIFO_26010_RD_DCOUNT     : std_logic_vector (11 downto 0);
    signal FIFO_26010_RD_EN         : std_logic;
    
    signal FIFO_26100_WR_DATA       : std_logic_vector(9 downto 0) := (others => '0');
    signal FIFO_26100_WR_EN         : std_logic := '0';
    signal FIFO_26100_RD_DATA       : std_logic_vector (9 downto 0);
    signal FIFO_26100_RD_DCOUNT     : std_logic_vector (11 downto 0);
    signal FIFO_26100_RD_EN         : std_logic;
    
    signal FIFO_25700_WR_DATA       : std_logic_vector(9 downto 0) := (others => '0');
    signal FIFO_25700_WR_EN         : std_logic := '0';
    signal FIFO_25700_RD_DATA       : std_logic_vector (9 downto 0);
    signal FIFO_25700_RD_DCOUNT     : std_logic_vector (11 downto 0);
    signal FIFO_25700_RD_EN         : std_logic;
        
    signal PKT_APO_CLR              : std_logic := '0';
    signal PKT_APO_DONE             : std_logic := '0';
    signal PKT_APO_COMM             : std_logic_vector(143 downto 0);  
    
    signal PKT_VARU_RAM_WR_CLK      : std_logic := '0';
    signal PKT_VARU_RAM_WR_EN       : std_logic := '0';
    signal PKT_VARU_RAM_WR_ADDR     : std_logic_vector (9 downto 0) := (others => '0');
    signal PKT_VARU_RAM_WR_DATA     : std_logic_vector (7 downto 0) := (others => '0');
    
    signal PKT_DFS_FIFO_WR_CLK      : std_logic := '0';
    signal PKT_DFS_FIFO_WR_EN       : std_logic := '0';
    signal PKT_DFS_FIFO_WR_DATA     : std_logic_vector(7 downto 0);
    
    signal PKT_ARP_IP               : std_logic_vector (31 downto 0):= (others => '0');
    signal PKT_ARP_MAC              : std_logic_vector (47 downto 0):= (others => '0');
    signal PKT_ARP_CLR              : std_logic := '0';
    signal PKT_ARP_DONE             : std_logic := '0';
    
    signal PKT_26010_CLR            : std_logic := '0';
    signal PKT_26010_DONE           : std_logic := '0';
    
    signal PKT_26100_CLR            : std_logic := '0';
    signal PKT_26100_DONE           : std_logic := '0';
    
    signal set_arp_done             : std_logic := '0';
    signal clr_arp_done             : std_logic := '0';
    signal set_arp_done_t           : std_logic := '0';
    signal clr_arp_done_t           : std_logic := '0';
    
    signal set_apo_done             : std_logic := '0';
    signal clr_apo_done             : std_logic := '0';
    signal set_apo_done_t           : std_logic := '0';
    signal clr_apo_done_t           : std_logic := '0';
    
    signal trigger                  : std_logic := '0';
    
    
    ---------------------------------------------------------------------------------------
    component pll
    port (
        clk_in1                 : in  std_logic;
        clk_out1                : out std_logic;
        clk_out2                : out std_logic;
        clk_out3                : out std_logic;
        clk_out4                : out std_logic
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component mdio_cfg
    port (
        clk                     : in    std_logic;
        mdc                     : out   std_logic;
        mdio                    : inout std_logic;
        done                    : out   std_logic;
        eth_rst_n               : out   std_logic
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component dac
    port (
        clk                     : in  STD_LOGIC;
        
        varu_wr_clk             : in  STD_LOGIC;
        varu_wr_en              : in  STD_LOGIC;
        varu_wr_data            : in  STD_LOGIC_VECTOR (7 downto 0);
        varu_wr_addr            : in  STD_LOGIC_VECTOR (9 downto 0); 
           
        state                   : in  STD_LOGIC_VECTOR (7 downto 0);
        envelope                : in  STD_LOGIC;
        p_varu_cnt              : in  STD_LOGIC_VECTOR (31 downto 0);
        
        dac_sync                : out STD_LOGIC;
        dac_sclk                : out STD_LOGIC;
        dac_sdata               : out STD_LOGIC
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component ad9850_par
    port(  
        reset                   : in  std_logic; 
        clk                     : in  std_logic; 
        apo_comm_en             : in  std_logic;
        freq                    : in  std_logic_vector (31 downto 0);
        dds_reset               : out std_logic; 
        dds_updata              : out std_logic; 
        dds_clk                 : out std_logic; 
        dds_pdata               : out std_logic_vector(7 downto 0) 
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component adc_module 
    port (
        clk                     : in STD_LOGIC;
        test_ch1                : in STD_LOGIC;
        adc_bus_1               : in STD_LOGIC_VECTOR (15 downto 0);
        adc_bus_2               : in STD_LOGIC_VECTOR (15 downto 0);
        adc_bus_3               : in STD_LOGIC_VECTOR (15 downto 0);
        adc_bus_4               : in STD_LOGIC_VECTOR (15 downto 0);
        adc_rst                 : out STD_LOGIC;
        adc_conv                : out STD_LOGIC; 
        adc_rd12                : out STD_LOGIC;
        adc_rd34                : out STD_LOGIC;
        adc_cs                  : out STD_LOGIC_VECTOR (7 downto 0);
        adc_done                : out STD_LOGIC;
        adc_data                : out STD_LOGIC_VECTOR (1359 downto 0)
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component skp_rs485
    generic(
        CLK_FREQ                : integer; 
        --SKP_ADDR                : integer;
        SPEED                   : integer;
        TX_PKT                  : integer -- tx packet per second
    ); 
    port (
        CLK                     : in  STD_LOGIC;
        RST                     : in  STD_LOGIC;
        
        SKP_ADDR                : in  STD_LOGIC; -- '0' - 51; '1' - 52
        
        SERIAL_RX               : in  STD_LOGIC;
        SERIAL_TX               : out STD_LOGIC;
        SERIAL_RE               : out STD_LOGIC;
        SERIAL_DE               : out STD_LOGIC;
        
        MEM_SKP_25700_RD_EN     : in  std_logic;
        MEM_SKP_25700_RD_ADDR   : in  std_logic_vector(4 downto 0);
        MEM_SKP_25700_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_SKP_25700_BUSY      : out std_logic;
        MEM_SKP_25700_DONE      : out std_logic;
        
        MEM_SKP_26100_RD_EN     : in  std_logic;
        MEM_SKP_26100_RD_ADDR   : in  std_logic_vector(4 downto 0);
        MEM_SKP_26100_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_SKP_26100_BUSY      : out std_logic;
        MEM_SKP_26100_DONE      : out std_logic
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component dfs_rs485
    generic(
        CLK_FREQ                : integer; 
        SPEED                   : integer
    ); 
    port (
        CLK                     : in  STD_LOGIC;
        RST                     : in  STD_LOGIC;
        
        SERIAL_RX               : in  STD_LOGIC;
        SERIAL_TX               : out STD_LOGIC;
        SERIAL_RE               : out STD_LOGIC;
        SERIAL_DE               : out STD_LOGIC;
        
        --Receive request packet 26100 
        PKT_26010_DONE          : in  std_logic;
        PKT_26100_DONE          : in  std_logic;
        
        --Write data from ETH to FIFO
        FIFO_DFS_WR_CLK         : in  std_logic; 
        FIFO_DFS_WR_EN          : in  std_logic;
        FIFO_DFS_WR_DATA        : in  std_logic_vector(7 downto 0);
        
        MEM_DFS_26010_RD_EN     : in  std_logic;
        MEM_DFS_26010_RD_ADDR   : in  std_logic_vector(7 downto 0);
        MEM_DFS_26010_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_DFS_26010_BUSY      : out std_logic;
        MEM_DFS_26010_DONE      : out std_logic;
        
        MEM_DFS_26100_RD_EN     : in  std_logic;
        MEM_DFS_26100_RD_ADDR   : in  std_logic_vector(7 downto 0);
        MEM_DFS_26100_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_DFS_26100_BUSY      : out std_logic;
        MEM_DFS_26100_DONE      : out std_logic
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component tx_pkt_25700
    port (
        CLK                     : in STD_LOGIC;
        
        DEV_IP                  : in STD_LOGIC_VECTOR (31 downto 0);
        DEV_MAC                 : in STD_LOGIC_VECTOR (47 downto 0);
        
        DST_IP                  : in std_logic_vector (31 downto 0);
        DST_MAC                 : in std_logic_vector (47 downto 0);
        
        envelope                : in  STD_LOGIC;
        trigger                 : out STD_LOGIC;
        
        ADC_DONE                : in  STD_LOGIC;
        ADC_DATA                : in  STD_LOGIC_VECTOR (1359 downto 0);
        
        APO_COMM                : in  STD_LOGIC_VECTOR (143 downto 0);  
        APO_DONE                : in  STD_LOGIC;
        
        MEM_SKP_25700_RD_EN     : out std_logic;
        MEM_SKP_25700_RD_ADDR   : out std_logic_vector(4 downto 0);
        MEM_SKP_25700_RD_DATA   : in  std_logic_vector(7 downto 0);
        MEM_SKP_25700_BUSY      : in  std_logic;
        MEM_SKP_25700_DONE      : in  std_logic;
        
        FIFO_25700_WR_DATA      : out STD_LOGIC_VECTOR (9 downto 0);
        FIFO_25700_WR_EN        : out STD_LOGIC;
        
        sel_dbg                 : out std_logic_vector(7 downto 0)
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component tx_pkt_26100
    port (
        CLK                     : in STD_LOGIC;
        
        DEV_IP                  : in STD_LOGIC_VECTOR (31 downto 0);
        DEV_MAC                 : in STD_LOGIC_VECTOR (47 downto 0);
        
        DST_IP                  : in std_logic_vector (31 downto 0);
        DST_MAC                 : in std_logic_vector (47 downto 0);
        
        --Receive request packet 26100 
        PKT_26100_CLR           : out std_logic;
        PKT_26100_DONE          : in  std_logic;
        
        --Read SKP DATA from MEM
        MEM_SKP_26100_RD_EN     : out std_logic;
        MEM_SKP_26100_RD_ADDR   : out std_logic_vector(4 downto 0);
        MEM_SKP_26100_RD_DATA   : in  std_logic_vector(7 downto 0);
        MEM_SKP_26100_BUSY      : in  std_logic;
        MEM_SKP_26100_DONE      : in  std_logic;
        
        --Read DFS DATA from MEM
        MEM_DFS_26100_RD_EN     : out std_logic;
        MEM_DFS_26100_RD_ADDR   : out std_logic_vector(7 downto 0);
        MEM_DFS_26100_RD_DATA   : in  std_logic_vector(7 downto 0);
        MEM_DFS_26100_BUSY      : in  std_logic;
        MEM_DFS_26100_DONE      : in  std_logic;

        FIFO_26100_WR_DATA      : out STD_LOGIC_VECTOR (9 downto 0);
        FIFO_26100_WR_EN        : out STD_LOGIC
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component tx_pkt_26010
    port (
        CLK                     : in STD_LOGIC;
        
        DEV_IP                  : in STD_LOGIC_VECTOR (31 downto 0);
        DEV_MAC                 : in STD_LOGIC_VECTOR (47 downto 0);
        
        DST_IP                  : in std_logic_vector (31 downto 0);
        DST_MAC                 : in std_logic_vector (47 downto 0);
        
        --Receive request packet 26010 
        PKT_26010_CLR           : out std_logic := '0';
        PKT_26010_DONE          : in  std_logic;
        
        --Read DFS DATA from MEM
        MEM_DFS_26010_RD_EN     : out std_logic := '0';
        MEM_DFS_26010_RD_ADDR   : out std_logic_vector(7 downto 0) := (others => '0');
        MEM_DFS_26010_RD_DATA   : in  std_logic_vector(7 downto 0);
        MEM_DFS_26010_BUSY      : in  std_logic;
        MEM_DFS_26010_DONE      : in  std_logic;

        --Write TX packet to FIFO 
        FIFO_26010_WR_EN        : out STD_LOGIC := '0';
        FIFO_26010_WR_DATA      : out STD_LOGIC_VECTOR (9 downto 0) := (others => '0') 
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component rx_packets
    port (
        rx_clk                  : in std_logic;
        rx_dv                   : in std_logic;
        rx_err                  : in std_logic;
        rx_data                 : in std_logic_vector (7 downto 0);
        dev_mac                 : in std_logic_vector (47 downto 0);
        dev_ip 	                : in std_logic_vector (31 downto 0);
  
        PKT_APO_CLR             : in STD_LOGIC;
        PKT_APO_DONE            : out STD_LOGIC;
        PKT_APO_COMM            : out std_logic_vector(143 downto 0);

        PKT_VARU_RAM_WR_CLK     : out std_logic;
        PKT_VARU_RAM_WR_EN      : out std_logic;
        PKT_VARU_RAM_WR_ADDR    : out std_logic_vector(9  downto 0);
        PKT_VARU_RAM_WR_DATA    : out std_logic_vector(7  downto 0);
        
        PKT_DFS_FIFO_WR_CLK     : out std_logic;
        PKT_DFS_FIFO_WR_EN      : out std_logic ;
        PKT_DFS_FIFO_WR_DATA    : out std_logic_vector(7  downto 0);
        
        PKT_ARP_IP              : out STD_LOGIC_VECTOR (31 downto 0);
        PKT_ARP_MAC             : out STD_LOGIC_VECTOR (47 downto 0);
        PKT_ARP_CLR             : in STD_LOGIC;
        PKT_ARP_DONE            : out STD_LOGIC;
        
        PKT_26010_CLR           : in STD_LOGIC;
        PKT_26010_DONE          : out STD_LOGIC;
        
        PKT_26100_CLR           : in STD_LOGIC;
        PKT_26100_DONE          : out STD_LOGIC
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component tx_pkt_arp
    port (
        tx_clk                  : in  std_logic;
        dev_mac                 : in  std_logic_vector (47 downto 0);
        dev_ip                  : in  std_logic_vector (31 downto 0);
        arp_request_ok          : in  std_logic;
        arp_request_ip          : in  std_logic_vector (31 downto 0);
        arp_request_mac         : in  std_logic_vector (47 downto 0);
        arp_fifo_wr_clk         : out std_logic;
        arp_fifo_wr_en          : out std_logic;
        arp_fifo_wr_data        : out std_logic_vector (9 downto 0)
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component fifo_4k 
    port (
        wr_clk                  : IN  STD_LOGIC;
        rd_clk                  : IN  STD_LOGIC;
        din                     : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        wr_en                   : IN  STD_LOGIC;
        rd_en                   : IN  STD_LOGIC;
        dout                    : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        full                    : OUT STD_LOGIC;
        empty                   : OUT STD_LOGIC;
        rd_data_count           : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
    end component;
    
    ---------------------------------------------------------------------------------------
    component arbiter 
    port ( 
        clk                     : in STD_LOGIC;
            
        s1_din                  : in STD_LOGIC_VECTOR (9 downto 0);
        s1_dcount               : in STD_LOGIC_VECTOR (11 downto 0);
        s1_rd                   : out STD_LOGIC;
        
        s2_din                  : in STD_LOGIC_VECTOR (9 downto 0);
        s2_dcount               : in STD_LOGIC_VECTOR (11 downto 0);
        s2_rd                   : out STD_LOGIC;
        
        s3_din                  : in STD_LOGIC_VECTOR (9 downto 0);
        s3_dcount               : in STD_LOGIC_VECTOR (11 downto 0);
        s3_rd                   : out STD_LOGIC;
        
        s4_din                  : in STD_LOGIC_VECTOR (9 downto 0);
        s4_dcount               : in STD_LOGIC_VECTOR (11 downto 0);
        s4_rd                   : out STD_LOGIC;
        
        y_dout                  : out STD_LOGIC_VECTOR (9 downto 0)
    );
    end component;
    
--    ---------------------------------------------------------------------------------------
--    component ila_0 
--    port (
--        clk                     : in  std_logic;
--        probe0                  : in  std_logic_vector (0  DOWNTO 0);
--        probe1                  : in  std_logic_vector (0  DOWNTO 0);
--        probe2                  : in  std_logic_vector (7  DOWNTO 0);  
--        probe3                  : in  std_logic_vector (0  DOWNTO 0);
--        probe4                  : in  std_logic_vector (0  DOWNTO 0);
--        probe5                  : in  std_logic_vector (11 DOWNTO 0);
--        probe6                  : in  std_logic_vector (0 DOWNTO 0);      
--        probe7                  : in  std_logic_vector (11 DOWNTO 0);
--        probe8                  : in  std_logic_vector (0  DOWNTO 0); 
--        probe9                  : in  std_logic_vector (4  DOWNTO 0);
--        probe10                 : in  std_logic_vector (7  DOWNTO 0);
--        probe11                 : in  std_logic_vector (0  DOWNTO 0);
--        probe12                 : in  std_logic_vector (0  DOWNTO 0);
--        probe13                 : in  std_logic_vector (7  DOWNTO 0)
--    );
--    end component;
    
--    ---------------------------------------------------------------------------------------
--    component ila_3
--    port (
--        clk                     : in  std_logic;
--        probe0                  : in  std_logic_vector (0  DOWNTO 0);
--        probe1                  : in  std_logic_vector (0  DOWNTO 0);
--        probe2                  : in  std_logic_vector (0  DOWNTO 0);  
--        probe3                  : in  std_logic_vector (7  DOWNTO 0)
--    );
--    end component;
    
    ---------------------------------------------------------------------------------------
--    component ila_1 
--    port (
--        clk                 :in  std_logic;
--        probe0              :in  std_logic_vector (0  DOWNTO 0);
--        probe1              :in  std_logic_vector (7  DOWNTO 0);
--        probe2              :in  std_logic_vector (9  DOWNTO 0);  
--        probe3              :in  std_logic_vector (0  DOWNTO 0) 
--    );
--    end component;
    

begin

    ---------------------------------------------------------------------------------------
    pll_inst: pll
    port map(    
        clk_in1                 => sys_clk,        
        clk_out1                => clk_125Mhz,        
        clk_out2                => clk_25Mhz,       
        clk_out3                => clk_12M8,
        clk_out4                => clk_10Mhz      
    ); 
    
    ---------------------------------------------------------------------------------------
    mdio: mdio_cfg
    port map(    
        clk                     => clk_10Mhz,        
        mdc                     => PHY_MDC,        
        mdio                    => PHY_MDIO,       
        done                    => phy_done,
        eth_rst_n               => reset_n --PHY_RESET_N     
    ); 
    
    ---------------------------------------------------------------------------------------
    adc: adc_module 
    port map( 
        clk                     => clk_125Mhz,
        test_ch1                => PKT_APO_COMM(9),  -- '0' - Disable; '1' - Enable
        adc_bus_1               => adc_bus_1,
        adc_bus_2               => adc_bus_2,
        adc_bus_3               => adc_bus_3,
        adc_bus_4               => adc_bus_4,
        adc_rst                 => s_adc_rst,
        adc_conv                => s_adc_conv,
        adc_rd12                => s_adc_rd12,
        adc_rd34                => s_adc_rd34,
        adc_cs                  => s_adc_cs,
        adc_done                => adc_done,
        adc_data                => adc_data
    );
    
    ---------------------------------------------------------------------------------------
    tx_25700: tx_pkt_25700
    port map(    
        CLK                     => clk_125Mhz,
        
        DEV_IP                  => x"C0_A8_04_02",  
        DEV_MAC                 => x"1A_CF_FC_1D_67_03",
        
        DST_IP                  => PKT_ARP_IP,
        DST_MAC                 => PKT_ARP_MAC,
        
        envelope                => envelope,
        trigger                 => trigger,
        
        ADC_DONE                => adc_done,
        ADC_DATA                => adc_data,
        
        APO_COMM                => PKT_APO_COMM,  
        APO_DONE                => PKT_APO_DONE,
        
        MEM_SKP_25700_RD_EN     => MEM_SKP_25700_RD_EN,
        MEM_SKP_25700_RD_ADDR   => MEM_SKP_25700_RD_ADDR,
        MEM_SKP_25700_RD_DATA   => MEM_SKP_25700_RD_DATA,
        MEM_SKP_25700_BUSY      => MEM_SKP_25700_BUSY,
        MEM_SKP_25700_DONE      => MEM_SKP_25700_DONE,
        
        FIFO_25700_WR_EN        => FIFO_25700_WR_EN,
        FIFO_25700_WR_DATA      => FIFO_25700_WR_DATA,

        sel_dbg                 => sel_dbg 
    ); 
    
    ---------------------------------------------------------------------------------------
    tx_26100: tx_pkt_26100
    port map(  
        CLK                     => clk_125Mhz,
        
        DEV_IP                  => x"C0_A8_04_02", 
        DEV_MAC                 => x"1A_CF_FC_1D_67_03",
        
        DST_IP                  => PKT_ARP_IP,
        DST_MAC                 => PKT_ARP_MAC,
        
        --Receive request packet 26100 
        PKT_26100_CLR           => PKT_26100_CLR,
        PKT_26100_DONE          => PKT_26100_DONE,
        
        --Read SKP DATA from MEM
        MEM_SKP_26100_RD_EN     => MEM_SKP_26100_RD_EN,
        MEM_SKP_26100_RD_ADDR   => MEM_SKP_26100_RD_ADDR,
        MEM_SKP_26100_RD_DATA   => MEM_SKP_26100_RD_DATA,
        MEM_SKP_26100_BUSY      => MEM_SKP_26100_BUSY,
        MEM_SKP_26100_DONE      => MEM_SKP_26100_DONE,
        
        --Read DFS DATA from MEM
        MEM_DFS_26100_RD_EN     => MEM_DFS_26100_RD_EN,
        MEM_DFS_26100_RD_ADDR   => MEM_DFS_26100_RD_ADDR,
        MEM_DFS_26100_RD_DATA   => MEM_DFS_26100_RD_DATA,
        MEM_DFS_26100_BUSY      => MEM_DFS_26100_BUSY,
        MEM_DFS_26100_DONE      => MEM_DFS_26100_DONE,
        
        --Write TX packet to FIFO 
        FIFO_26100_WR_EN        => FIFO_26100_WR_EN,
        FIFO_26100_WR_DATA      => FIFO_26100_WR_DATA
    ); 
    
    ---------------------------------------------------------------------------------------
    tx_26010: tx_pkt_26010
    port map( 
        CLK                     => clk_125Mhz,
        
        DEV_IP                  => x"C0_A8_04_02", 
        DEV_MAC                 => x"1A_CF_FC_1D_67_03",
        
        DST_IP                  => PKT_ARP_IP,
        DST_MAC                 => PKT_ARP_MAC,
        
        --Receive request packet 26100 
        PKT_26010_CLR           => PKT_26010_CLR,
        PKT_26010_DONE          => PKT_26010_DONE,
        
        --Read DFS DATA from MEM
        MEM_DFS_26010_RD_EN     => MEM_DFS_26010_RD_EN,
        MEM_DFS_26010_RD_ADDR   => MEM_DFS_26010_RD_ADDR,
        MEM_DFS_26010_RD_DATA   => MEM_DFS_26010_RD_DATA,
        MEM_DFS_26010_BUSY      => MEM_DFS_26010_BUSY,
        MEM_DFS_26010_DONE      => MEM_DFS_26010_DONE,

        --Write TX packet to FIFO 
        FIFO_26010_WR_EN        => FIFO_26010_WR_EN,
        FIFO_26010_WR_DATA      => FIFO_26010_WR_DATA
    ); 
    
    ---------------------------------------------------------------------------------------
    fifo_pkt25700: fifo_4k 
    port map(  
        wr_clk                  => clk_125Mhz,
        wr_en                   => FIFO_25700_WR_EN,
        din                     => FIFO_25700_WR_DATA,
        
        rd_clk                  => gclk,
        rd_en                   => FIFO_25700_RD_EN,
        rd_data_count           => FIFO_25700_RD_DCOUNT,
        dout                    => FIFO_25700_RD_DATA
    ); 
    
    ---------------------------------------------------------------------------------------
    fifo_pkt26100: fifo_4k 
    port map(  
        wr_clk                  => clk_125Mhz,
        wr_en                   => FIFO_26100_WR_EN,
        din                     => FIFO_26100_WR_DATA,
        
        rd_clk                  => gclk,
        rd_en                   => FIFO_26100_RD_EN,
        rd_data_count           => FIFO_26100_RD_DCOUNT,
        dout                    => FIFO_26100_RD_DATA
    ); 
    
    ---------------------------------------------------------------------------------------
    fifo_pkt26010: fifo_4k 
    port map(  
        wr_clk                  => clk_125Mhz,
        wr_en                   => FIFO_26010_WR_EN,
        din                     => FIFO_26010_WR_DATA,
        
        rd_clk                  => gclk,
        rd_en                   => FIFO_26010_RD_EN,
        rd_data_count           => FIFO_26010_RD_DCOUNT,
        dout                    => FIFO_26010_RD_DATA
    ); 
    
    ---------------------------------------------------------------------------------------
    rx_pkt: rx_packets 
    port map(    
        rx_clk                  => PHY_RXC, 
        rx_dv                   => PHY_RXDV,   
        rx_err                  => PHY_RXER,
        rx_data                 => PHY_RXD,
        
        dev_ip                  => x"C0_A8_04_02",        
        dev_mac                 => x"1A_CF_FC_1D_67_03", 
        
        PKT_APO_CLR             => PKT_APO_CLR,
        PKT_APO_DONE            => PKT_APO_DONE,
        PKT_APO_COMM            => PKT_APO_COMM,
        
        PKT_VARU_RAM_WR_CLK     => PKT_VARU_RAM_WR_CLK,
        PKT_VARU_RAM_WR_EN      => PKT_VARU_RAM_WR_EN,
        PKT_VARU_RAM_WR_ADDR    => PKT_VARU_RAM_WR_ADDR,
        PKT_VARU_RAM_WR_DATA    => PKT_VARU_RAM_WR_DATA,
        
        PKT_DFS_FIFO_WR_CLK     => PKT_DFS_FIFO_WR_CLK,
        PKT_DFS_FIFO_WR_EN      => PKT_DFS_FIFO_WR_EN,
        PKT_DFS_FIFO_WR_DATA    => PKT_DFS_FIFO_WR_DATA,
        
        PKT_ARP_IP              => PKT_ARP_IP,
        PKT_ARP_MAC             => PKT_ARP_MAC,
        PKT_ARP_CLR             => PKT_ARP_CLR,
        PKT_ARP_DONE            => PKT_ARP_DONE,
        
        PKT_26010_CLR           => PKT_26010_CLR,
        PKT_26010_DONE          => PKT_26010_DONE,
        
        PKT_26100_CLR           => PKT_26100_CLR,
        PKT_26100_DONE          => PKT_26100_DONE     
    ); 

    ---------------------------------------------------------------------------------------
    tx_arp: tx_pkt_arp 
    port map(  
        tx_clk                  => clk_125Mhz,
        dev_mac                 => x"1A_CF_FC_1D_67_03", 
        dev_ip                  => x"C0_A8_04_02", 
         
        arp_request_ok          => PKT_ARP_DONE,
        arp_request_ip          => PKT_ARP_IP,
        arp_request_mac         => PKT_ARP_MAC,
        
        arp_fifo_wr_clk         => arp_fifo_wr_clk,
        arp_fifo_wr_en          => arp_fifo_wr_en,
        arp_fifo_wr_data        => arp_fifo_wr_data
    );
    
    ---------------------------------------------------------------------------------------
    fifo_arp: fifo_4k 
    port map(  
        wr_clk                  => arp_fifo_wr_clk,
        wr_en                   => arp_fifo_wr_en,
        din                     => arp_fifo_wr_data,
        rd_clk                  => gclk,
        rd_en                   => arp_fifo_rd_en,
        rd_data_count           => arp_fifo_rd_dcount,
        dout                    => arp_fifo_dout
    ); 
    
    ---------------------------------------------------------------------------------------
    arb_inst: arbiter 
    port map( 
        clk                     => gclk,
        
        --TX packet arp
        s1_din                  => arp_fifo_dout,
        s1_dcount               => arp_fifo_rd_dcount,
        s1_rd                   => arp_fifo_rd_en,
        
        --TX packet 25700
        s2_din                  => FIFO_25700_RD_DATA,
        s2_dcount               => FIFO_25700_RD_DCOUNT,
        s2_rd                   => FIFO_25700_RD_EN,
        
        --TX packet 26100
        s3_din                  => FIFO_26100_RD_DATA,
        s3_dcount               => FIFO_26100_RD_DCOUNT,
        s3_rd                   => FIFO_26100_RD_EN,
        
        --TX packet 26010
        s4_din                  => FIFO_26010_RD_DATA,
        s4_dcount               => FIFO_26010_RD_DCOUNT,
        s4_rd                   => FIFO_26010_RD_EN,
        
        --out
        y_dout                  => arb_dout
    ); 
    
    ---------------------------------------------------------------------------------------
    dac_inst: dac
    port map(   
        clk                     => clk_12M8,
        
        varu_wr_clk             => PKT_VARU_RAM_WR_CLK,
        varu_wr_en              => PKT_VARU_RAM_WR_EN,
        varu_wr_data            => PKT_VARU_RAM_WR_DATA,
        varu_wr_addr            => PKT_VARU_RAM_WR_ADDR,
        
        state                   => PKT_APO_COMM(7 downto 0),     --work_st,
        envelope                => trigger,                      --PKT_APO_DONE, --envelope,
        p_varu_cnt              => PKT_APO_COMM(143 downto 112), --p_varu_cnt,
        
        dac_sync                => dac_sync,
        dac_sclk                => dac_sclk,
        dac_sdata               => dac_sdata
    );
    
    ---------------------------------------------------------------------------------------
    dds: ad9850_par
    port map( 
        clk                     => clk_125Mhz,  
        reset                   => reset_n,
        apo_comm_en             => PKT_APO_DONE,
        freq                    => PKT_APO_COMM(111 downto 80), --X"00_00_86_38",--
        dds_reset               => dds_rst,
        dds_updata              => dds_upd,
        dds_clk                 => dds_sclk,
        dds_pdata               => dds_pdata
    );
    
    ---------------------------------------------------------------------------------------
    skp: skp_rs485
    generic map(
        CLK_FREQ                => 125000000,
        --SKP_ADDR                => 52,
        SPEED                   => 57600,
        TX_PKT                  => 50        -- tx packet per second
    )
    port map(    
        CLK                     => clk_125Mhz,
        RST                     => '0',
        
        SKP_ADDR                => PKT_APO_COMM(8),  -- '0' - 51; '1' - 52
        
        SERIAL_RX               => SKP_SERIAL_RX,
        SERIAL_TX               => SKP_SERIAL_TX,
        SERIAL_RE               => SKP_SERIAL_RE,
        SERIAL_DE               => SKP_SERIAL_DE,
      
        MEM_SKP_25700_RD_EN     => MEM_SKP_25700_RD_EN,
        MEM_SKP_25700_RD_ADDR   => MEM_SKP_25700_RD_ADDR,
        MEM_SKP_25700_RD_DATA   => MEM_SKP_25700_RD_DATA,
        MEM_SKP_25700_BUSY      => MEM_SKP_25700_BUSY,
        MEM_SKP_25700_DONE      => MEM_SKP_25700_DONE,
        
        MEM_SKP_26100_RD_EN     => MEM_SKP_26100_RD_EN,
        MEM_SKP_26100_RD_ADDR   => MEM_SKP_26100_RD_ADDR,
        MEM_SKP_26100_RD_DATA   => MEM_SKP_26100_RD_DATA,
        MEM_SKP_26100_BUSY      => MEM_SKP_26100_BUSY,
        MEM_SKP_26100_DONE      => MEM_SKP_26100_DONE
    );
    
    ---------------------------------------------------------------------------------------
    dfs: dfs_rs485
    generic map(
        CLK_FREQ                => 125000000,
        SPEED                   => 9600
    ) 
    port map(    
        CLK                     => clk_125Mhz,
        RST                     => '0',

        SERIAL_RX               => DFS_SERIAL_RX,
        SERIAL_TX               => DFS_SERIAL_TX,
        SERIAL_RE               => DFS_SERIAL_RE,
        SERIAL_DE               => DFS_SERIAL_DE,
            
        PKT_26010_DONE          => PKT_26010_DONE,
        PKT_26100_DONE          => PKT_26100_DONE,

        --Write data from ETH to FIFO
        FIFO_DFS_WR_CLK         => PKT_DFS_FIFO_WR_CLK,
        FIFO_DFS_WR_EN          => PKT_DFS_FIFO_WR_EN,
        FIFO_DFS_WR_DATA        => PKT_DFS_FIFO_WR_DATA,
        
        MEM_DFS_26010_RD_EN     => MEM_DFS_26010_RD_EN,
        MEM_DFS_26010_RD_ADDR   => MEM_DFS_26010_RD_ADDR,
        MEM_DFS_26010_RD_DATA   => MEM_DFS_26010_RD_DATA,
        MEM_DFS_26010_BUSY      => MEM_DFS_26010_BUSY,
        MEM_DFS_26010_DONE      => MEM_DFS_26010_DONE,
        
        MEM_DFS_26100_RD_EN     => MEM_DFS_26100_RD_EN,
        MEM_DFS_26100_RD_ADDR   => MEM_DFS_26100_RD_ADDR,
        MEM_DFS_26100_RD_DATA   => MEM_DFS_26100_RD_DATA,
        MEM_DFS_26100_BUSY      => MEM_DFS_26100_BUSY,
        MEM_DFS_26100_DONE      => MEM_DFS_26100_DONE
    );

--    ---------------------------------------------------------------------------------------
--    dbg26100: ila_3
--    port map(    
--        clk                     => PKT_DFS_FIFO_WR_CLK,    
--        probe0(0)               => PKT_DFS_FIFO_WR_EN,            
--        probe1(0)               => PKT_26100_CLR,   
--        probe2(0)               => PKT_26100_DONE,
--        probe3                  => PKT_DFS_FIFO_WR_DATA
--    );
    
    
    ---------------------------------------------------------------------------------------
--    ila0_inst: ila_0
--    port map(    
--        clk                     => gclk,        
--        probe0(0)               => arb_dout(9),            
--        probe1(0)               => arb_dout(8),   
--        probe2                  => arb_dout(7 downto 0),
--        probe3(0)               => arp_ok,
--        probe4(0)               => arp_fifo_rd_en,
--        probe5                  => arp_fifo_rd_dcount,
--        probe6(0)               => FIFO_25700_RD_EN,
--        probe7                  => FIFO_25700_RD_DCOUNT,
        
--        --MEM
--        probe8(0)               => MEM_SKP_25700_RD_EN,
--        probe9                  => MEM_SKP_25700_RD_ADDR,
--        probe10                 => MEM_SKP_25700_RD_DATA,
--        probe11(0)              => MEM_SKP_25700_BUSY,
--        probe12(0)              => MEM_SKP_25700_DONE,
        
--        probe13                 => sel_dbg
--    );




    ------------------------------------------------------------------------------------------------------------------------
    done_comb: process (PKT_ARP_DONE, PKT_APO_DONE, set_arp_done, clr_arp_done, set_apo_done, clr_apo_done ) begin 
 
        if(PKT_ARP_DONE = '1') then set_arp_done_t <= '1'; elsif (PKT_ARP_DONE = '0') then clr_arp_done_t <= '1'; end if; 
        if(set_arp_done = '1') then set_arp_done_t <= '0'; end if; 
        if(clr_arp_done = '1') then clr_arp_done_t <= '0'; end if;  
        
        if(PKT_APO_DONE = '1') then set_apo_done_t <= '1'; elsif (PKT_APO_DONE = '0') then clr_apo_done_t <= '1'; end if; 
        if(set_apo_done = '1') then set_apo_done_t <= '0'; end if; 
        if(clr_apo_done = '1') then clr_apo_done_t <= '0'; end if;

    end process done_comb; 

    
    ------------------------------------------------------------------------------------------------------------------------
    done_sequential : process (clk_125Mhz)
    begin
        if rising_edge(clk_125Mhz) then
            if(set_arp_done_t = '1') then set_arp_done <= '1'; PKT_ARP_CLR <= '1'; else set_arp_done <= '0'; end if;
            if(clr_arp_done_t = '1') then clr_arp_done <= '1'; PKT_ARP_CLR <= '0'; else clr_arp_done <= '0'; end if;
            
            if(set_apo_done_t = '1') then set_apo_done <= '1'; PKT_APO_CLR <= '1'; else set_apo_done <= '0'; end if;
            if(clr_apo_done_t = '1') then clr_apo_done <= '1'; PKT_APO_CLR <= '0'; else clr_apo_done <= '0'; end if;
        end if;
    end process done_sequential;
    
    
    --------------------------------------------------------------------------------------------------------
    --Assign 
    sys_led         <= r_led;   
    led_HL4         <= phy_done and arp_ok;
    gclk            <= not clk_125Mhz;
    
    dds_mclk        <= clk_25Mhz;

    adc_rst         <= s_adc_rst;
    adc_conv        <= s_adc_conv;
    adc_rd12        <= s_adc_rd12;
    adc_rd34        <= s_adc_rd34;
    adc_cs          <= s_adc_cs;
    
    rk_o            <= '1' when (PKT_APO_COMM(7 downto 0) = X"31") else '0'; -- 0x31 WORK
    ru_o            <= '1' when (PKT_APO_COMM(47) = '1')           else '0'; 

    PHY_RESET_N     <= reset_n;
    PHY_TX_DISABLE  <= '0';
    PHY_COMA        <= '0';
    PHY_GTXC        <= gclk;
    PHY_TXEN        <= arb_dout(9);
    PHY_TXER        <= arb_dout(8);
    PHY_TXD         <= arb_dout(7 downto 0);
    
end Behavioral;
