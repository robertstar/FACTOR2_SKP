----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2021 12:21:51 PM
-- Design Name: 
-- Module Name: dfs_rs485 - Behavioral
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


entity dfs_rs485 is
generic(
        CLK_FREQ                : integer; 
        SPEED                   : integer
    );
Port ( 
        CLK                     : in  std_logic;
        RST                     : in  std_logic;
        
        SERIAL_RX               : in  std_logic;
        SERIAL_TX               : out std_logic;
        SERIAL_RE               : out std_logic;
        SERIAL_DE               : out std_logic;
        
        --Receive request packet
        PKT_26010_DONE          : in  std_logic;
        PKT_26100_DONE          : in  std_logic;
        
        FIFO_DFS_WR_CLK         : in  std_logic; 
        FIFO_DFS_WR_EN          : in  std_logic;
        FIFO_DFS_WR_DATA        : in  std_logic_vector(7 downto 0);
        
        MEM_DFS_26010_RD_EN     : in  std_logic;
        MEM_DFS_26010_RD_ADDR   : in  std_logic_vector(7 downto 0);
        MEM_DFS_26010_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_DFS_26010_BUSY      : out std_logic := '0';
        MEM_DFS_26010_DONE      : out std_logic := '0';
        
        MEM_DFS_26100_RD_EN     : in  std_logic;
        MEM_DFS_26100_RD_ADDR   : in  std_logic_vector(7 downto 0);
        MEM_DFS_26100_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_DFS_26100_BUSY      : out std_logic := '0';
        MEM_DFS_26100_DONE      : out std_logic := '0'
    );
end dfs_rs485;

architecture Behavioral of dfs_rs485 is

    --------------------------------------------------------------------------------------------------------
    signal tx_st                : std_logic_vector(3 downto 0)  := (others => '0');
    signal wr_st                : std_logic_vector(3 downto 0)  := (others => '0');
    
    signal RX_BUSY              : std_logic := '0';
    signal RX_ERR               : std_logic := '0';
    signal TX_DATA              : std_logic_vector(7 downto 0)  := (others => '0');
    signal TX_BUSY              : std_logic := '0';
    signal TX_EN                : std_logic := '0';
    signal tx_cnt               : std_logic_vector(31 downto 0) := (others => '0');
    signal RX_DATA              : std_logic_vector(7 downto 0)  := (others => '0');
    signal RX_DONE              : std_logic := '0';

    signal FIFO_DFS_WR_FULL     : std_logic := '0';
    signal FIFO_DFS_RD_EN       : std_logic := '0';
    signal FIFO_DFS_RD_DATA     : std_logic_vector(7 downto 0)  := (others => '0');
    signal FIFO_DFS_RD_EMPTY    : std_logic := '0';
    signal FIFO_DFS_RD_COUNT    : std_logic_vector(9 downto 0)  := (others => '0');
    
    signal fifo_rd_cnt          : unsigned (9 downto 0) := to_unsigned(0, 10);
    signal rx_busy_t            : std_logic_vector(1 downto 0)  := (others => '0');
    signal dfs_timeout_eop      : std_logic_vector(31 downto 0) := (others => '0');
    signal dfs_timeout_500ms    : std_logic_vector(31 downto 0) := (others => '0');
    
    --TEMP RAM
    signal ram1_wr_en           : std_logic := '0';
    signal ram1_wr_addr         : std_logic_vector(7 downto 0)  := (others => '0');
    signal ram1_wr_data         : std_logic_vector(7 downto 0)  := (others => '0');
    signal ram1_rd_en           : std_logic := '0';
    signal ram1_rd_addr         : std_logic_vector(7 downto 0)  := (others => '0');
    signal ram1_dout            : std_logic_vector(7 downto 0);
    
    --RAM 26010
    signal ram2_wr_en           : std_logic := '0';
    signal ram2_wr_addr         : std_logic_vector(7 downto 0)  := (others => '0');
    signal ram2_wr_data         : std_logic_vector(7 downto 0)  := (others => '0');
    
    --RAM26100
    signal ram3_wr_en           : std_logic := '0';
    signal ram3_wr_addr         : std_logic_vector(7 downto 0)  := (others => '0');
    signal ram3_wr_data         : std_logic_vector(7 downto 0)  := (others => '0');

    signal write_st             : std_logic_vector(3 downto 0)  := (others => '0');
    signal write_st2            : std_logic_vector(3 downto 0)  := (others => '0');
    
    signal EOP                  : std_logic := '0';
    signal ram1_wr_cnt          : std_logic_vector(7 downto 0);
    signal ram1_wr_bytes        : std_logic_vector(7 downto 0);
    
    signal set_done1            : std_logic := '0';
    signal clr_done1            : std_logic := '0';
    signal set_done1_t          : std_logic := '0';
    signal clr_done1_t          : std_logic := '0';
    
    signal set_done2            : std_logic := '0';
    signal clr_done2            : std_logic := '0';
    signal set_done2_t          : std_logic := '0';
    signal clr_done2_t          : std_logic := '0';
    
    signal set_26010_t          : std_logic := '0';
    signal clr_26010_t          : std_logic := '0';
    
    signal set_26100_t          : std_logic := '0';
    signal clr_26100_t          : std_logic := '0';
    
    signal MEM_DFS_26010_DONE_t : std_logic := '0';
    signal MEM_DFS_26100_DONE_t : std_logic := '0';
    
    
    signal wr_26010_en           : std_logic := '0';
    signal wr_26100_en           : std_logic := '0';
    
    ---------------------------------------------------------------------------------------
    component uart
      GENERIC(
        clk_freq        :  INTEGER;                                    --frequency of system clock in Hertz
        baud_rate       :  INTEGER;                                    --data link baud rate in bits/second
        os_rate         :  INTEGER;                                    --oversampling rate to find center of receive bits (in samples per baud period)
        d_width         :  INTEGER;                                    --data bus width
        parity          :  INTEGER                                     --0 for no parity, 1 for parity                          
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
        parity_eo       :  IN   STD_LOGIC);                            --'0' for even, '1' for odd parity
    end component;
    
    --------------------------------------------------------------------------------------------------------
    component single_port_ram
    generic(
        RAM_DATA_WIDTH  : integer; 
        RAM_DATA_LENGTH : integer;
        RAM_ADDR_WIDTH  : integer
    ); 
    port (
        RAM_WR_CLOCK    : in std_logic;                     -- Write clock 
        RAM_WR_EN       : in std_logic;                     -- Write enable 
        RAM_WR_ADDR     : in std_logic_vector(RAM_ADDR_WIDTH - 1 downto 0);  -- Address to write RAM
        RAM_WR_DATA     : in std_logic_vector(RAM_DATA_WIDTH - 1 downto 0);  -- Data to write into RAM

        RAM_RD_EN       : in std_logic;                     -- Write enable 
        RAM_RD_ADDR     : in std_logic_vector(RAM_ADDR_WIDTH - 1 downto 0);  -- Address to read RAM
        RAM_RD_DATA     : out std_logic_vector(RAM_DATA_WIDTH - 1 downto 0)  -- Data output of RAM
        );
    end component;
    
    --------------------------------------------------------------------------------------------------------
    component fifo_1k
    port (
        wr_clk          : IN STD_LOGIC;
        wr_en           : IN STD_LOGIC;
        din             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        full            : OUT STD_LOGIC;
        
        rd_clk          : IN STD_LOGIC;
        rd_en           : IN STD_LOGIC;
        dout            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        empty           : OUT STD_LOGIC;
        rd_data_count   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
    end component;
    
--    ---------------------------------------------------------------------------------------
--    component ila_4 
--    port (
--        clk             : in  std_logic;
--        probe0          : in  std_logic_vector (3  DOWNTO 0);
--        probe1          : in  std_logic_vector (0  DOWNTO 0);
--        probe2          : in  std_logic_vector (0  DOWNTO 0);  
--        probe3          : in  std_logic_vector (7  DOWNTO 0);
--        probe4          : in  std_logic_vector (7  DOWNTO 0);
--        probe5          : in  std_logic_vector (0  DOWNTO 0);
--        probe6          : in  std_logic_vector (0  DOWNTO 0);
--        probe7          : in  std_logic_vector (7  DOWNTO 0);
--        probe8          : in  std_logic_vector (3  DOWNTO 0);
--        probe9          : in  std_logic_vector (0  DOWNTO 0);
--        probe10         : in  std_logic_vector (7  DOWNTO 0);
--        probe11         : in  std_logic_vector (7  DOWNTO 0);
        
--        probe12         : in  std_logic_vector (1  DOWNTO 0);
--        probe13         : in  std_logic_vector (0  DOWNTO 0); 
--        probe14         : in  std_logic_vector (7  DOWNTO 0);
--        probe15         : in  std_logic_vector (7  DOWNTO 0);
        
--        probe16         : in  std_logic_vector (0  DOWNTO 0);
--        probe17         : in  std_logic_vector (0  DOWNTO 0); 
--        probe18         : in  std_logic_vector (0  DOWNTO 0);
--        probe19         : in  std_logic_vector (7  DOWNTO 0);  
--        probe20         : in  std_logic_vector (7  DOWNTO 0);
--        probe21         : in  std_logic_vector (0  DOWNTO 0); 
--        probe22         : in  std_logic_vector (0  DOWNTO 0);
--        probe23         : in  std_logic_vector (0  DOWNTO 0);
--        probe24         : in  std_logic_vector (0  DOWNTO 0);        
--        probe25         : in  std_logic_vector (31  DOWNTO 0)                       
--    );
--    end component;

begin

    --------------------------------------------------------------------------------------------------------
    --Assign 
    SERIAL_RE           <= '1' when (TX_BUSY = '1') else '0'; 
    SERIAL_DE           <= '1' when (TX_BUSY = '1') else '0'; 
    fifo_rd_cnt         <= unsigned(FIFO_DFS_RD_COUNT);
    MEM_DFS_26010_BUSY  <= '1' when (ram2_wr_en = '1') else '0';
    MEM_DFS_26100_BUSY  <= '1' when (ram3_wr_en = '1') else '0';


    
    
    -------------------------------------------------------------------------------------
    uart_inst: uart
    generic map(
        clk_freq    => CLK_FREQ,            --frequency of system clock in Hertz
        baud_rate   => SPEED,               --data link baud rate in bits/second
        os_rate     => 16,                  --oversampling rate to find center of receive bits (in samples per baud period)
        d_width     => 8,                   --data bus width
        parity      => 0                    --0 for no parity, 1 for parity  
    )
    port map(    
        clk         => CLK,                 --system clock
        reset_n     => '1',                 --ascynchronous reset
        
        parity_eo   => '0',                 --'0' for even, '1' for odd parity
        
        tx_ena      => TX_EN,               --initiate transmission
        tx_data     => TX_DATA,             --data to transmit
        tx          => SERIAL_TX,
        tx_busy     => TX_BUSY,             --transmission in progress
        
        rx_data     => RX_DATA,             --data received
        rx          => SERIAL_RX,           --receive pin
        rx_busy     => RX_BUSY,             --data reception in progress
        rx_error    => RX_ERR               --start, parity, or stop bit error detected   
    );
    
    -------------------------------------------------------------------------------------
    tx_fifo: fifo_1k
    port map( 
        wr_clk          => FIFO_DFS_WR_CLK,
        wr_en           => FIFO_DFS_WR_EN,
        din             => FIFO_DFS_WR_DATA,
        full            => FIFO_DFS_WR_FULL,
        
        rd_clk          => CLK,
        rd_en           => FIFO_DFS_RD_EN,
        dout            => FIFO_DFS_RD_DATA,
        empty           => FIFO_DFS_RD_EMPTY,
        rd_data_count   => FIFO_DFS_RD_COUNT
    );
    
    
    ---------------------------------------------------------------------------------------
--    dbg26100: ila_4
--    port map(    
--        clk                     => CLK,    
--        probe0                  => tx_st,            
--        probe1(0)               => TX_EN,   
--        probe2(0)               => TX_BUSY,
--        probe3(0)               => FIFO_DFS_RD_EN,
--        probe4                  => FIFO_DFS_RD_DATA,
--        probe5(0)               => FIFO_DFS_RD_EMPTY,
--        probe6                  => FIFO_DFS_RD_COUNT
--    );
    
--    dbg26100: ila_4
--    port map(    
--        clk                     => CLK,    
--        probe0                  => write_st,            --4     
--        probe1(0)               => EOP,                 --1
        
--        probe2(0)               => ram1_rd_en,          --1
--        probe3                  => ram1_rd_addr,        --8
--        probe4                  => ram1_dout,           --8
        
--        probe5(0)               => MEM_DFS_26010_RD_EN, --1
--        probe6(0)               => MEM_DFS_26100_RD_EN, --1
        
--        probe7                  => ram1_wr_bytes,       --8
--        probe8                  => write_st2,           --4
        
--        probe9(0)               => ram2_wr_en,          --1
--        probe10                 => ram2_wr_data,        --8
--        probe11                 => ram2_wr_addr,        --8
        
--        probe12                 => rx_busy_t,           --2
--        probe13(0)              => ram1_wr_en,          --1
--        probe14                 => ram1_wr_data,        --8
--        probe15                 => ram1_wr_addr,        --8
        
--        probe16(0)              => MEM_DFS_26010_DONE_t,--1
--        probe17(0)              => MEM_DFS_26100_DONE_t,--1
        
--        probe18(0)              => ram3_wr_en,          --1
--        probe19                 => ram3_wr_data,        --8
--        probe20                 => ram3_wr_addr,        --8
        
--        probe21(0)              => wr_26010_en,         --1
--        probe22(0)              => wr_26100_en,         --1
        
--        probe23(0)              => clr_26010_t,         --1
--        probe24(0)              => clr_26100_t,         --1
        
--        probe25                 => dfs_timeout_eop      --32    
--    );
    
    --------------------------------------------------------------------------------------------------------
    --RAM1 TEMP
    mem1_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 256,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 8
    )
    port map(    
        RAM_WR_CLOCK    => CLK,
        RAM_WR_EN       => ram1_wr_en,
        RAM_WR_ADDR     => ram1_wr_addr,
        RAM_WR_DATA     => ram1_wr_data,
        
        RAM_RD_EN       => ram1_rd_en,
        RAM_RD_ADDR     => ram1_rd_addr,
        RAM_RD_DATA     => ram1_dout
    ); 
    
    --------------------------------------------------------------------------------------------------------
    --RAM 26010
    mem2_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 256,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 8
    )
    port map(    
        RAM_WR_CLOCK    => CLK,
        RAM_WR_EN       => ram2_wr_en,
        RAM_WR_ADDR     => ram2_wr_addr,
        RAM_WR_DATA     => ram2_wr_data,
        RAM_RD_EN       => MEM_DFS_26010_RD_EN,
        RAM_RD_ADDR     => MEM_DFS_26010_RD_ADDR,
        RAM_RD_DATA     => MEM_DFS_26010_RD_DATA
    ); 
    
    --------------------------------------------------------------------------------------------------------
    --RAM 26100
    mem3_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 256,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 8
    )
    port map(    
        RAM_WR_CLOCK    => CLK,
        RAM_WR_EN       => ram3_wr_en,
        RAM_WR_ADDR     => ram3_wr_addr,
        RAM_WR_DATA     => ram3_wr_data,
        RAM_RD_EN       => MEM_DFS_26100_RD_EN,
        RAM_RD_ADDR     => MEM_DFS_26100_RD_ADDR,
        RAM_RD_DATA     => MEM_DFS_26100_RD_DATA
    ); 
    

    --------------------------------------------------------------------------------------------------------------------
    done_comb: process (    
                            PKT_26010_DONE, PKT_26100_DONE,
                            clr_26010_t, clr_26100_t,
                            dfs_timeout_eop,
                            ram2_wr_en, ram2_wr_addr, 
                            ram3_wr_en, ram3_wr_addr, 
                            MEM_DFS_26010_RD_EN,
                            MEM_DFS_26100_RD_EN, 
                            set_done1, clr_done1, 
                            set_done2, clr_done2
        ) begin 
        
        
        --------------------------------------------------------------------------------------------------
        if(PKT_26010_DONE = '1') then set_26010_t <= '1'; end if;
        if(clr_26010_t    = '1') then set_26010_t <= '0'; end if;
        
        if(PKT_26100_DONE = '1') then set_26100_t <= '1'; end if;
        if(clr_26100_t    = '1') then set_26100_t <= '0'; end if;
        
        --------------------------------------------------------------------------------------------------
        if( to_integer(unsigned(dfs_timeout_eop))  = 300000 )  then
        --if( dfs_timeout_eop  = X"07_A1_20" )  then
            EOP <= '1';
        else
            EOP <= '0';
        end if;
        
        --------------------------------------------------------------------------------------------------
        --26010
        if (ram2_wr_en = '1' and to_integer(unsigned(ram2_wr_addr)) = 255)      then set_done1_t <= '1'; end if;
        if (set_done1 = '1')                                                    then set_done1_t <= '0'; end if; 
        if (clr_done1 = '1')                                                    then clr_done1_t <= '0'; end if;  
        if (MEM_DFS_26010_RD_EN = '1')                                          then clr_done1_t <= '1'; end if; 
        
        --------------------------------------------------------------------------------------------------
        --26100
        if (ram3_wr_en = '1' and to_integer(unsigned(ram3_wr_addr)) = 255)      then set_done2_t <= '1'; end if;
        if (set_done2 = '1')                                                    then set_done2_t <= '0'; end if; 
        if (clr_done2 = '1')                                                    then clr_done2_t <= '0'; end if;  
        if (MEM_DFS_26100_RD_EN = '1')                                          then clr_done2_t <= '1'; end if; 

    end process done_comb; 
    
    
    
    --------------------------------------------------------------------------------------------------------
    rx_sequential : process (CLK)
    begin
        if rising_edge (CLK) then
        
            ---------------------------------------------------
            --sync rx data
            rx_busy_t <= rx_busy_t(0) & RX_BUSY;
--            if( rx_busy_t(1) = '1' and rx_busy_t(0) = '0' ) then  --Receive byte
--                rx_busy_t         <= b"00";
--                dfs_timeout_eop   <= X"00_00_00_00";
--                dfs_timeout_500ms <= X"00_00_00_00";
--            end if;    
            
            ---------------------------------------------------
            --Timeout counter for EOP
--            if( to_integer(unsigned(dfs_timeout_eop))  < 1000000 ) then
--            --if( dfs_timeout_eop  < X"07_A1_20" ) then
--                dfs_timeout_eop <= dfs_timeout_eop + 1;
--            end if;
            
            ---------------------------------------------------
            --Timeout 500 ms counter for not response DFS
            --if( to_integer(unsigned(dfs_timeout_500ms))  < 62500000) then
--            if( dfs_timeout_500ms < X"03_B9_AC_A0" ) then
--                dfs_timeout_500ms <= dfs_timeout_500ms + 1;
--            end if;
            
            ---------------------------------------------------
            --Flag's for write
            if(set_26010_t = '1') then wr_26010_en <= '1'; clr_26010_t <= '1'; else clr_26010_t <= '0'; end if;
            if(set_26100_t = '1') then wr_26100_en <= '1'; clr_26100_t <= '1'; else clr_26100_t <= '0'; end if;
            
            ---------------------------------------------------
            --26010
            if(set_done1_t = '1') then set_done1 <= '1'; MEM_DFS_26010_DONE <= '1'; MEM_DFS_26010_DONE_t <= '1'; else set_done1 <= '0'; end if;
            if(clr_done1_t = '1') then clr_done1 <= '1'; MEM_DFS_26010_DONE <= '0'; MEM_DFS_26010_DONE_t <= '0'; else clr_done1 <= '0'; end if;
            
            ---------------------------------------------------
            --26100
            if(set_done2_t = '1') then set_done2 <= '1'; MEM_DFS_26100_DONE <= '1'; MEM_DFS_26100_DONE_t <= '1'; else set_done2 <= '0'; end if;
            if(clr_done2_t = '1') then clr_done2 <= '1'; MEM_DFS_26100_DONE <= '0'; MEM_DFS_26100_DONE_t <= '0'; else clr_done2 <= '0'; end if;
            
            
            --TIMEOUT 500 ms
            --if(  (to_integer(unsigned(dfs_timeout_500ms))  = 62500000) and (to_integer(unsigned(write_st)) = 0) and (to_integer(unsigned(write_st)) = 1)   ) then 
            --if( (dfs_timeout_500ms = X"03_B9_AC_A0") and (to_integer(unsigned(write_st)) = 0) and (to_integer(unsigned(write_st)) = 1)   ) then 
                --TIMEOUT
                --write_st<= b"0100";
            --end if;
            
            
            ---------------------------------------------------
            --FSM Write to Ram1
            case write_st is
                when b"0000" =>
                    if( rx_busy_t(1) = '1' and rx_busy_t(0) = '0' ) then  --Receive byte
                        rx_busy_t         <= b"00";
                        dfs_timeout_eop   <= X"00_00_00_00";
                        dfs_timeout_500ms <= X"00_00_00_00";
                        ram1_wr_en        <= '1';
                        ram1_wr_data      <= RX_DATA;
                        ram1_wr_addr      <= X"00";  
                        ram1_wr_cnt       <= ram1_wr_cnt + 1;
                        write_st          <= write_st + 1;
                    else
                        ram1_wr_en <= '0';
                        --Timeout counter for EOP
                        if( to_integer(unsigned(dfs_timeout_eop))  < 300000 ) then
                            dfs_timeout_eop <= dfs_timeout_eop + 1;
                        end if;
                        --Timeout 500 ms counter for not response DFS
                        if( to_integer(unsigned(dfs_timeout_500ms))  < 62500000) then
                            dfs_timeout_500ms <= dfs_timeout_500ms + 1;
                        end if;   
                        if( EOP = '1' and to_integer(unsigned(ram1_wr_cnt)) /= 0 ) then
                            ram1_wr_bytes <= ram1_wr_cnt;
                            write_st      <= b"0010";
                        else
                            --TIMEOUT 500 ms
                            if(to_integer(unsigned(dfs_timeout_500ms))  = 62500000) then
                                write_st<= b"0100";
                            end if;
                        end if;
                    end if;
                
                when b"0001" =>   
                    if( rx_busy_t(1) = '1' and rx_busy_t(0) = '0' ) then  --Receive byte
                        rx_busy_t         <= b"00";
                        dfs_timeout_eop   <= X"00_00_00_00";
                        dfs_timeout_500ms <= X"00_00_00_00";
                        ram1_wr_en        <= '1';
                        ram1_wr_data      <= RX_DATA;
                        ram1_wr_addr      <= ram1_wr_addr + 1; 
                        ram1_wr_cnt       <= ram1_wr_cnt + 1;
                    else
                        ram1_wr_en <= '0';
                        --Timeout counter for EOP
                        if( to_integer(unsigned(dfs_timeout_eop))  < 300000 ) then
                            dfs_timeout_eop <= dfs_timeout_eop + 1;
                        end if;
                        --Timeout 500 ms counter for not response DFS
                        if( to_integer(unsigned(dfs_timeout_500ms))  < 62500000) then
                            dfs_timeout_500ms <= dfs_timeout_500ms + 1;
                        end if;  
                        if( EOP = '1' and to_integer(unsigned(ram1_wr_cnt)) /= 0 ) then
                            ram1_wr_bytes <= ram1_wr_cnt;
                            write_st      <= write_st + 1;
                        else
                            --TIMEOUT 500 ms
                            if(to_integer(unsigned(dfs_timeout_500ms))  = 62500000) then
                                write_st<= b"0100";
                            end if;
                        end if;
                    end if; 

                when b"0010" => 
                    ram1_wr_en        <= '0';
                    ram1_wr_data      <= X"00";
                    ram1_wr_addr      <= X"00";
                    ram1_wr_cnt       <= X"00";
                    dfs_timeout_eop   <= X"00_00_00_00";
--                    dfs_timeout_500ms <= X"00_00_00_00";
                    write_st          <= write_st + 1;
                
                when b"0011" =>  --Read from RAM1 and write to RAM2 and RAM3
                    dfs_timeout_eop   <= X"00_00_00_00";
--                    dfs_timeout_500ms <= X"00_00_00_00";
                    case write_st2 is
                        when b"0000" => 
                            --Check flag's of rx packet's
                            --Check RD RAM2
                            if(MEM_DFS_26010_RD_EN = '0' and MEM_DFS_26100_RD_EN = '0') then
                                ram1_rd_en   <= '1';
                                ram1_rd_addr <= X"00";
                                if(wr_26010_en = '1') then ram2_wr_en <= '1'; else ram2_wr_en <= '0'; end if;
                                if(wr_26100_en = '1') then ram3_wr_en <= '1'; else ram3_wr_en <= '0'; end if;
                                write_st2    <= write_st2 + 1;
                            end if;
                        
                        when b"0001" =>   
                            if (ram1_rd_addr + 1 = ram1_wr_bytes) then
                                ram2_wr_data <= ram1_dout; ram2_wr_addr <= ram2_wr_addr + 1;
                                ram3_wr_data <= ram1_dout; ram3_wr_addr <= ram3_wr_addr + 1;
                                write_st2    <= write_st2 + 1;
                            else
                                case ram1_rd_addr is
                                    when X"00"  =>
                                        ram1_rd_addr <= ram1_rd_addr + 1;
                                        ram2_wr_addr <= X"00";
                                        ram2_wr_data <= ram1_dout;
                                        ram3_wr_addr <= X"00";
                                        ram3_wr_data <= ram1_dout;
                                        
                                    when others =>
                                        ram1_rd_addr <= ram1_rd_addr + 1;
                                        ram2_wr_data <= ram1_dout; ram2_wr_addr <= ram2_wr_addr + 1;
                                        ram3_wr_data <= ram1_dout; ram3_wr_addr <= ram3_wr_addr + 1;
                                end case;  
                            end if;
                        
                        when b"0010" => 
                            if ( to_integer(unsigned(ram2_wr_addr) )  < 255) then
                                ram2_wr_data <= X"00";
                                ram3_wr_data <= X"00";
                                ram2_wr_addr <= ram2_wr_addr + 1;
                                ram3_wr_addr <= ram3_wr_addr + 1;
                            else
                                ram1_rd_en   <= '0';
                                ram1_rd_addr <= X"00";
                                
                                ram2_wr_en   <= '0';
                                ram2_wr_addr <= X"00";
                                ram2_wr_data <= X"00";
                                
                                ram3_wr_en   <= '0';
                                ram3_wr_addr <= X"00";
                                ram3_wr_data <= X"00";

                                if(wr_26010_en = '1') then wr_26010_en <= '0'; end if;
                                if(wr_26100_en = '1') then wr_26100_en <= '0'; end if;
                                
                                write_st     <= b"0000"; -- idle
                                write_st2    <= b"0000";
                            end if;

                        when others  => null;          
                    end case;
        
                when b"0100" => --TIMEOUT 500 ms NOT RESPONSE !
                    dfs_timeout_eop   <= X"00_00_00_00";
                    dfs_timeout_500ms <= X"00_00_00_00";
                    case write_st2 is
                        when b"0000" => 
                            if(wr_26010_en = '1') then ram2_wr_en <= '1'; else ram2_wr_en <= '0'; end if;
                            if(wr_26100_en = '1') then ram3_wr_en <= '1'; else ram3_wr_en <= '0'; end if;
                            write_st2 <= write_st2 + 1;
                    
                        when b"0001" =>
                            ram2_wr_addr <= X"00";
                            ram3_wr_addr <= X"00";
                            ram2_wr_data <= X"00";
                            ram3_wr_data <= X"00";
                            write_st2    <= write_st2 + 1;
                            
                        when b"0010" =>    
                            if ( to_integer(unsigned(ram2_wr_addr) )  < 255) then
                                ram2_wr_data <= X"00";
                                ram3_wr_data <= X"00";
                                ram2_wr_addr <= ram2_wr_addr + 1;
                                ram3_wr_addr <= ram3_wr_addr + 1;
                            else
                                ram2_wr_en   <= '0';
                                ram2_wr_addr <= X"00";
                                ram2_wr_data <= X"00";
                                
                                ram3_wr_en   <= '0';
                                ram3_wr_addr <= X"00";
                                ram3_wr_data <= X"00";

                                if(wr_26010_en = '1') then wr_26010_en <= '0'; end if;
                                if(wr_26100_en = '1') then wr_26100_en <= '0'; end if;
                                
                                write_st     <= b"0000"; -- idle
                                write_st2    <= b"0000";
                            end if;
                        
                        when others  => null; 
                    end case;
                    
                when others => 
                    dfs_timeout_eop <= X"00_00_00_00";
                    
            end case;
        end if;
    end process rx_sequential;
    
    
    
    
    
    
    --------------------------------------------------------------------------------------------------------
    --Read data from FIFO and transmit to DFS
    tx_sequential : process (CLK)
    begin
        if rising_edge(CLK) then
            case tx_st is
                
                --IDLE State
                when b"0000" =>
                    TX_EN           <= '0';
                    FIFO_DFS_RD_EN  <= '0';
                    if( (to_integer(fifo_rd_cnt) > 0) and (TX_BUSY /= '1') ) then
                        FIFO_DFS_RD_EN <= '1';
                        tx_st <= tx_st + 1;
                    end if;
                
                --Latency 1 clk for read from FIFO
                when b"0001" =>
                    tx_st <= tx_st + 1;
                
                when b"0010" => --2
                    FIFO_DFS_RD_EN <= '0';
                    if(TX_BUSY = '0') then
                        TX_EN   <= '1';
                        TX_DATA <= FIFO_DFS_RD_DATA;
                        tx_st   <= tx_st + 1;
                    end if;
                
                when b"0011" => --3 
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= tx_st + 1;
                    end if;

                when b"0100" => --4 
                    if(TX_BUSY = '0') then
                        if(to_integer(fifo_rd_cnt) > 0) then
                            FIFO_DFS_RD_EN  <= '1';
                            TX_EN           <= '1';
                            TX_DATA         <= FIFO_DFS_RD_DATA;
                            tx_st           <= tx_st + 1;
                        else
                           tx_st <= b"0110";  
                        end if; 
                    end if; 
                    
                when b"0101" => --5
                    FIFO_DFS_RD_EN  <= '0';     
                    TX_EN           <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= b"0100";
                    end if;    

                when b"0110" => --end byte
                    if(TX_BUSY = '0') then
                        TX_EN   <= '1';
                        TX_DATA <= FIFO_DFS_RD_DATA;
                        tx_st   <= tx_st + 1;
                    end if;  
                    
                when b"0111" =>    
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= b"0000";
                    end if;   

                when others => null; 
            end case;
        end if;
    end process tx_sequential;

end Behavioral;






--WORK CODE
--                when b"0011" =>  --Read from RAM1 and write to RAM2 and RAM3
--                    case write_st2 is
--                        when b"0000" => --Check RD RAM2
                        
--                            --set_26010_t
                        
                        
--                            if(MEM_DFS_26010_RD_EN = '0' and MEM_DFS_26100_RD_EN = '0') then
--                                ram1_rd_en   <= '1';
--                                ram1_rd_addr <= X"00";
--                                ram2_wr_en   <= '1'; --RAM 26010
--                                ram3_wr_en   <= '1'; --RAM 26100
--                                write_st2    <= write_st2 + 1;
--                            end if;
                        
--                        when b"0001" =>   
--                            if (ram1_rd_addr + 1 = ram1_wr_bytes) then
--                                ram2_wr_data <= ram1_dout;
--                                ram3_wr_data <= ram1_dout;
--                                ram2_wr_addr <= ram2_wr_addr + 1;
--                                ram3_wr_addr <= ram3_wr_addr + 1;
--                                write_st2    <= write_st2 + 1;
--                            else
--                                case ram1_rd_addr is
--                                    when X"00"  =>
--                                        ram1_rd_addr <= ram1_rd_addr + 1;
--                                        ram2_wr_addr <= X"00";
--                                        ram2_wr_data <= ram1_dout;
--                                        ram3_wr_addr <= X"00";
--                                        ram3_wr_data <= ram1_dout;
                                        
--                                    when others =>
--                                        ram1_rd_addr <= ram1_rd_addr + 1;
--                                        ram2_wr_addr <= ram2_wr_addr + 1;
--                                        ram3_wr_addr <= ram3_wr_addr + 1;
--                                        ram2_wr_data <= ram1_dout;
--                                        ram3_wr_data <= ram1_dout;
--                                end case;  
--                            end if;
                        
--                        when b"0010" => 
--                            if ( to_integer(unsigned(ram2_wr_addr) )  < 255) then
--                                ram2_wr_data <= X"00";
--                                ram3_wr_data <= X"00";
--                                ram2_wr_addr <= ram2_wr_addr + 1;
--                                ram3_wr_addr <= ram3_wr_addr + 1;
--                            else
--                                ram1_rd_en   <= '0';
--                                ram1_rd_addr <= X"00";
                                
--                                ram2_wr_en   <= '0';
--                                ram2_wr_addr <= X"00";
--                                ram2_wr_data <= X"00";
                                
--                                ram3_wr_en   <= '0';
--                                ram3_wr_addr <= X"00";
--                                ram3_wr_data <= X"00";
                                
--                                write_st     <= b"0000"; -- idle
--                                write_st2    <= b"0000";
--                            end if;
                                    
--                        when others  => null;          
--                    end case;
        
--                when others => null;
                
--            end case;
--        end if;
--    end process rx_sequential;





