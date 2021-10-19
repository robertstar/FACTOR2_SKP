----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2021 09:41:43 AM
-- Design Name: 
-- Module Name: skp_rs485 - Behavioral
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


entity skp_rs485 is
generic(
        CLK_FREQ                : integer; 
        --SKP_ADDR                : integer;
        SPEED                   : integer;
        TX_PKT                  : integer -- tx packet per second
    );
Port ( 
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
        MEM_SKP_25700_BUSY      : out std_logic := '0';
        MEM_SKP_25700_DONE      : out std_logic := '0';
        
        MEM_SKP_26100_RD_EN     : in  std_logic;
        MEM_SKP_26100_RD_ADDR   : in  std_logic_vector(4 downto 0);
        MEM_SKP_26100_RD_DATA   : out std_logic_vector(7 downto 0);
        MEM_SKP_26100_BUSY      : out std_logic := '0';
        MEM_SKP_26100_DONE      : out std_logic := '0'
    );
end skp_rs485;

architecture Behavioral of skp_rs485 is

    --------------------------------------------------------------------------------------------------------
    --type   tx_state_t       is (IDLE, TX_0, DELAY);
    --signal tx_st            : tx_state_t := IDLE;
    signal tx_st            : std_logic_vector(3 downto 0)  := (others => '0');
    
    signal TX_BUSY          : std_logic;
    signal TX_EN            : std_logic := '0';
    signal tx_cnt           : std_logic_vector(31 downto 0) := (others => '0');
    signal RX_DATA          : std_logic_vector(7 downto 0);
    signal RX_DONE          : std_logic;
    signal write_st         : std_logic_vector(3 downto 0)  := (others => '0');
    
    signal ram1_wr_en       : std_logic := '0';
    signal ram1_wr_addr     : std_logic_vector(4 downto 0)  := (others => '0');
    signal ram1_wr_data     : std_logic_vector(7 downto 0)  := (others => '0');
    
    signal ram1_rd_en       : std_logic := '0';
    signal ram1_rd_addr     : std_logic_vector(4 downto 0)  := (others => '0');
    signal ram1_dout        : std_logic_vector(7 downto 0);
    
    signal ram2_wr_en       : std_logic := '0';
    signal ram2_wr_addr     : std_logic_vector(4 downto 0)  := (others => '0');
    signal ram2_wr_data     : std_logic_vector(7 downto 0)  := (others => '0');
    
    signal ram3_wr_en       : std_logic := '0';
    signal ram3_wr_addr     : std_logic_vector(4 downto 0)  := (others => '0');
    signal ram3_wr_data     : std_logic_vector(7 downto 0)  := (others => '0');
    
    signal sync             : std_logic_vector(31 downto 0) := (others => '0');
    signal ram1_wr_cnt      : std_logic_vector(7 downto 0)  := (others => '0');
    
    signal set_done1        : std_logic := '0';
    signal clr_done1        : std_logic := '0';
    signal set_done1_t      : std_logic := '0';
    signal clr_done1_t      : std_logic := '0';
    
    signal set_done2        : std_logic := '0';
    signal clr_done2        : std_logic := '0';
    signal set_done2_t      : std_logic := '0';
    signal clr_done2_t      : std_logic := '0';

    signal write_st2        : std_logic_vector(3 downto 0)  := (others => '0');
    
    signal RX_BUSY          : std_logic;
    signal RX_ERR           : std_logic;
    --signal tx_busy2         : std_logic;
    --signal tx2              : std_logic;
    
    signal TX_DATA          : std_logic_vector(7 downto 0)  := (others => '0');
    signal rx_busy_t        : std_logic_vector(1 downto 0) := (others => '0');
    
    signal parity_eo        : std_logic := '0';
    signal skp_timeout      : std_logic_vector(31 downto 0)  := (others => '0');


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
--    component ila_3 
--    port (
--        clk             :in  std_logic;
--        probe0          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--        probe1          : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--        probe2          : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--        probe3          : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--        probe4          : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--        probe5          : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--        probe6          : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
--    );
--    end component;
    
begin

    --------------------------------------------------------------------------------------------------------
    --Assign 
    SERIAL_RE  <= '1' when (TX_BUSY = '1') else '0'; 
    SERIAL_DE  <= '1' when (TX_BUSY = '1') else '0'; 

    -------------------------------------------------------------------------------------
    uart_inst: uart
    generic map(
        clk_freq    => CLK_FREQ,            --frequency of system clock in Hertz
        baud_rate   => SPEED,               --data link baud rate in bits/second
        os_rate     => 16,                  --oversampling rate to find center of receive bits (in samples per baud period)
        d_width     => 8,                   --data bus width
        parity      => 1                    --0 for no parity, 1 for parity  
    )
    port map(    
        clk         => CLK,                 --system clock
        reset_n     => '1',                 --ascynchronous reset
        
        parity_eo   => parity_eo,           --'0' for even, '1' for odd parity
        
        tx_ena      => TX_EN,               --initiate transmission
        tx_data     => TX_DATA,             --data to transmit
        tx          => SERIAL_TX,
        tx_busy     => TX_BUSY,             --transmission in progress
        
        rx_data     => RX_DATA,             --data received
        rx          => SERIAL_RX,           --receive pin
        rx_busy     => RX_BUSY,             --data reception in progress
        rx_error    => RX_ERR               --start, parity, or stop bit error detected   
    );
    
    --------------------------------------------------------------------------------------------------------
    --RAM TEMP
    mem1_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 32,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 5
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
    --RAM 25700
    mem2_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 32,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 5
    )
    port map(    
        RAM_WR_CLOCK    => CLK,
        RAM_WR_EN       => ram2_wr_en,
        RAM_WR_ADDR     => ram2_wr_addr,
        RAM_WR_DATA     => ram2_wr_data,
        RAM_RD_EN       => MEM_SKP_25700_RD_EN,
        RAM_RD_ADDR     => MEM_SKP_25700_RD_ADDR,
        RAM_RD_DATA     => MEM_SKP_25700_RD_DATA
    ); 
    
    --------------------------------------------------------------------------------------------------------
    --RAM 26100
    mem3_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 32,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 5
    )
    port map(    
        RAM_WR_CLOCK    => CLK,
        RAM_WR_EN       => ram3_wr_en,
        RAM_WR_ADDR     => ram3_wr_addr,
        RAM_WR_DATA     => ram3_wr_data,
        RAM_RD_EN       => MEM_SKP_26100_RD_EN,
        RAM_RD_ADDR     => MEM_SKP_26100_RD_ADDR,
        RAM_RD_DATA     => MEM_SKP_26100_RD_DATA
    ); 
    
    --------------------------------------------------------------------------------------------------------
    --Assign
    MEM_SKP_25700_BUSY <= '1' when (ram2_wr_en = '1') else '0';
    MEM_SKP_26100_BUSY <= '1' when (ram3_wr_en = '1') else '0';

     --------------------------------------------------------------------------------------------------------------------
    done_comb: process (    ram2_wr_addr,
                            ram3_wr_addr, 
                            MEM_SKP_25700_RD_EN,
                            MEM_SKP_26100_RD_EN, 
                            set_done1, clr_done1, 
                            set_done2, clr_done2
        ) begin 
        
        --25700
        if (ram2_wr_addr = X"12")       then set_done1_t <= '1'; end if;
        if (set_done1 = '1')            then set_done1_t <= '0'; end if; 
        if (clr_done1 = '1')            then clr_done1_t <= '0'; end if;  
        if (MEM_SKP_25700_RD_EN = '1')  then clr_done1_t <= '1'; end if; 
        
        --26100
        if (ram3_wr_addr = X"12")       then set_done2_t <= '1'; end if;
        if (set_done2 = '1')            then set_done2_t <= '0'; end if; 
        if (clr_done2 = '1')            then clr_done2_t <= '0'; end if;  
        if (MEM_SKP_26100_RD_EN = '1')  then clr_done2_t <= '1'; end if; 

    end process done_comb; 
    
   
    --------------------------------------------------------------------------------------------------------
    rx_sequential : process (CLK)
    begin
        if rising_edge(CLK) then
            
            --27500
            if(set_done1_t = '1') then set_done1 <= '1'; MEM_SKP_25700_DONE <= '1'; else set_done1 <= '0'; end if;
            if(clr_done1_t = '1') then clr_done1 <= '1'; MEM_SKP_25700_DONE <= '0'; else clr_done1 <= '0'; end if;
            
            --26100
            if(set_done2_t = '1') then set_done2 <= '1'; MEM_SKP_26100_DONE <= '1'; else set_done2 <= '0'; end if;
            if(clr_done2_t = '1') then clr_done2 <= '1'; MEM_SKP_26100_DONE <= '0'; else clr_done2 <= '0'; end if;
            
            --sync rx data
            rx_busy_t <= rx_busy_t(0) & RX_BUSY;
            
            case write_st is
            
                --SYNC
                when b"0000" =>
                    ram1_wr_en <= '0';
                    if( rx_busy_t = b"10" ) then
                        skp_timeout <= X"00_00_00_00"; --Clear timeout
                        rx_busy_t <= "00";
                        sync <= sync(23 downto 0) & RX_DATA;
                        case SKP_ADDR is
                            when '0' => 
                                if( sync(23 downto 0) & RX_DATA = X"51_24_13_00" ) then
                                    ram1_wr_en   <= '1';
                                    ram1_wr_data <= X"51";
                                    ram1_wr_addr <= "00000";
                                    sync         <= X"00_00_00_00";
                                    ram1_wr_cnt  <= ram1_wr_cnt + 1;
                                    write_st     <= b"0010";
                                end if;
                            when '1' => 
                                if( sync(23 downto 0) & RX_DATA = X"52_24_13_00" ) then
                                    ram1_wr_en   <= '1';
                                    ram1_wr_data <= X"52";
                                    ram1_wr_addr <= "00000";
                                    sync         <= X"00_00_00_00";
                                    ram1_wr_cnt  <= ram1_wr_cnt + 1;
                                    write_st     <= b"0010";
                                end if;
                            when others => 
                                if( sync(23 downto 0) & RX_DATA = X"51_24_13_00" ) then
                                    ram1_wr_en   <= '1';
                                    ram1_wr_data <= X"51";
                                    ram1_wr_addr <= "00000";
                                    sync         <= X"00_00_00_00";
                                    ram1_wr_cnt  <= ram1_wr_cnt + 1;
                                    write_st     <= b"0010";
                                end if;
                        end case;
                    else
                        if(skp_timeout >= X"07_73_59_40") then -- One second timeout
                            ram1_wr_cnt <= X"00";
                            write_st    <= b"0001";
                        else
                            skp_timeout <= skp_timeout +1;
                        end if;    
                    end if;
                
                --CLEAR RAM1 TIMEOUT    
                when b"0001" =>    
                    case ram1_wr_cnt is
                            when X"00" =>
                                ram1_wr_en   <= '1';
                                ram1_wr_data <= X"00";
                                ram1_wr_addr <= b"00000";
                                ram1_wr_cnt  <= ram1_wr_cnt + 1;
                    
                            when X"13" =>
                                ram1_wr_en   <= '0';
                                ram1_wr_data <= X"00";
                                ram1_wr_cnt  <= X"00";
                                ram1_wr_addr <= b"00000"; 
                                write_st     <= b"0111";        --Read from RAM1 and Write to RAM2
                                skp_timeout  <= X"00_00_00_00"; --Clear timeout
                            
                            when others =>
                                ram1_wr_data <= X"00";
                                ram1_wr_addr <= ram1_wr_addr + 1;  
                                ram1_wr_cnt  <= ram1_wr_cnt + 1;
                        end case;      
                    
                when b"0010" =>
                    ram1_wr_data <= X"24";  
                    ram1_wr_addr <= ram1_wr_addr + 1;      
                    ram1_wr_cnt  <= ram1_wr_cnt + 1;
                    write_st     <= write_st + 1;
                    
                when b"0011" =>
                    ram1_wr_data <= X"13";    
                    ram1_wr_addr <= ram1_wr_addr + 1;      
                    ram1_wr_cnt  <= ram1_wr_cnt + 1;
                    write_st     <= write_st + 1;
                    
                when b"0100" =>
                    ram1_wr_data <= X"00";  
                    ram1_wr_addr <= ram1_wr_addr + 1;        
                    ram1_wr_cnt  <= ram1_wr_cnt + 1;
                    write_st     <= write_st + 1;    
                    
                when b"0101" =>
                    ram1_wr_en <= '0';
                    if( rx_busy_t = b"10" ) then 
                        rx_busy_t <= "00";
                        case ram1_wr_cnt is
                            when X"12" =>
                                ram1_wr_en   <= '1';
                                ram1_wr_data <= RX_DATA;
                                ram1_wr_cnt  <= X"00";
                                ram1_wr_addr <= ram1_wr_addr + 1; 
                                write_st     <= write_st + 1;  --test read ram
                            
                            when others =>
                                ram1_wr_en   <= '1';
                                ram1_wr_data <= RX_DATA;
                                ram1_wr_addr <= ram1_wr_addr + 1;  
                                ram1_wr_cnt  <= ram1_wr_cnt + 1;
                        end case;  
                    end if;

                when b"0110" =>
                    ram1_wr_en   <= '0';
                    ram1_wr_data <= X"00";
                    ram1_wr_addr <= "00000"; 
                    write_st     <= write_st + 1;
                         
                when b"0111" => --Read from RAM1 and write to RAM2 and RAM3
                    case write_st2 is
                        when b"0000" => --Check RD RAM2
                            if(MEM_SKP_25700_RD_EN = '0' and MEM_SKP_26100_RD_EN = '0') then
                                ram1_rd_en   <= '1';
                                ram1_rd_addr <= b"00000";
                                ram2_wr_en   <= '1'; --RAM 25700
                                ram3_wr_en   <= '1'; --RAM 26100
                                write_st2    <= write_st2 + 1;
                            end if;
                            
                        when b"0001" =>
                            case ram1_rd_addr is
                                when b"00000" =>
                                    ram1_rd_addr <= ram1_rd_addr + 1;
                                    
                                    ram2_wr_addr <= b"00000";
                                    ram2_wr_data <= ram1_dout;
                                    
                                    ram3_wr_addr <= b"00000";
                                    ram3_wr_data <= ram1_dout;
                                    
                                    
                                when b"10011" =>
                                    ram1_rd_en   <= '0';
                                    ram1_rd_addr <= b"00000";
                                    
                                    ram2_wr_en   <= '0';
                                    ram2_wr_addr <= b"00000";
                                    ram2_wr_data <= X"00";
                                    
                                    ram3_wr_en   <= '0';
                                    ram3_wr_addr <= b"00000";
                                    ram3_wr_data <= X"00";
                                    
                                    write_st     <= b"0000"; -- idle
                                    write_st2    <= b"0000";
                                    
                                when others   => 
                                    ram1_rd_addr <= ram1_rd_addr + 1;
                                    ram2_wr_addr <= ram2_wr_addr + 1;
                                    ram3_wr_addr <= ram3_wr_addr + 1;
                                    ram2_wr_data <= ram1_dout;
                                    ram3_wr_data <= ram1_dout;
                            end case;
                        when others => null;
                    end case;
                  
                when others => null;
            end case;
        end if;
    end process rx_sequential;
    
    
    
    --------------------------------------------------------------------------------------------------------
    tx_sequential : process (CLK)
    begin
        if rising_edge(CLK) then
            case tx_st is
                when b"0000" =>
                    if(TX_BUSY = '0') then
                        parity_eo <= '0';       --'0' for even, '1' for odd parity
                        TX_EN     <= '1';
                        case SKP_ADDR is
                            when '0'    => TX_DATA <= X"51";
                            when '1'    => TX_DATA <= X"52";
                            when others => TX_DATA <= X"51";
                        end case;
                        tx_st     <= tx_st + 1;
                        tx_cnt    <= X"00_00_00_00";
                     end if;
 
                when b"0001" =>
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= tx_st + 1;
                    end if;
                
                when b"0010" =>
                    if(TX_BUSY = '0') then
                        TX_EN   <= '1';
                        TX_DATA <= X"24";
                        tx_st   <= tx_st + 1;  
                    end if; 
                    
                when b"0011" =>
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= tx_st + 1;
                    end if;
                
                when b"0100" =>
                    if(TX_BUSY = '0') then
                        TX_EN   <= '1';
                        TX_DATA <= X"06";
                        tx_st   <= tx_st + 1;     
                    end if;
                    
                when b"0101" =>
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= tx_st + 1;
                    end if;
                
                when b"0110" =>
                    if(TX_BUSY = '0') then
                        TX_EN   <= '1';
                        TX_DATA <= X"00";
                        tx_st   <= tx_st + 1;   
                    end if; 
                    
                when b"0111" =>
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= tx_st + 1;
                    end if;
                
                when b"1000" => --CRC16
                    if(TX_BUSY = '0') then
                        TX_EN   <= '1';
                        TX_DATA <= X"53";
                        tx_st   <= tx_st + 1;      
                    end if;
                    
                when b"1001" =>
                    TX_EN <= '0';
                    if(TX_BUSY = '0') then
                        tx_st <= tx_st + 1;
                    end if;
                
                when b"1010" => --CRC16
                    if(TX_BUSY = '0') then
                        parity_eo <= '1';       --'0' for even, '1' for odd parity
                        TX_EN   <= '1';
                        case SKP_ADDR is
                            when '0'    => TX_DATA <= X"73";
                            when '1'    => TX_DATA <= X"37";
                            when others => TX_DATA <= X"73";
                        end case;
                        tx_st   <= tx_st + 1;  
                    end if;    
                    
                when b"1011" =>
                    TX_EN     <= '0';
                    parity_eo <= '0';       --'0' for even, '1' for odd parity
                    
                    if(tx_cnt < (CLK_FREQ / TX_PKT) ) then     --50 packet per second
                        tx_cnt <= tx_cnt + 1;
                    else
                        tx_cnt <= X"00_00_00_00";
                        tx_st  <= b"0000";
                    end if;
                
                when others => null; 
            end case;
        end if;
    end process tx_sequential;

end Behavioral;


--------------------------------------------------------------------------------------------------------
--    skp_dbg: ila_3
--    port map(    
--        clk              => CLK,    
--        probe0           => write_st,            
--        probe1(0)        => ram1_wr_en,   
--        probe2           => ram1_wr_addr,
--        probe3           => ram1_wr_data,
--        probe4(0)        => ram1_rd_en,
--        probe5           => ram1_rd_addr,
--        probe6           => ram1_dout
--    );