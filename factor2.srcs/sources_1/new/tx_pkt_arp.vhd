----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2021 09:27:00 AM
-- Design Name: 
-- Module Name: tx_arp - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use work.arp_types.all;

entity tx_pkt_arp is port 
(
    tx_clk              : in  std_logic;
    
    dev_mac             : in  std_logic_vector (47 downto 0);
    dev_ip              : in  std_logic_vector (31 downto 0);
    
    -- control signals
    arp_request_ok      : in std_logic;
    arp_request_ip      : in std_logic_vector (31 downto 0);
    arp_request_mac     : in std_logic_vector (47 downto 0);

    arp_fifo_wr_clk     : out std_logic;
    arp_fifo_wr_en      : out std_logic;
    arp_fifo_wr_data    : out std_logic_vector (9 downto 0)
);
end tx_pkt_arp;

    -- TX signals
    --arp_tx_clk          : out std_logic;
    --arp_tx_wr           : out std_logic;
    --arp_tx_data         : out std_logic_vector (7 downto 0);
    --gmii_tx_en          : out std_logic;
    --gmii_tx_err         : out std_logic;

architecture Behavioral of tx_pkt_arp is

    type count_mode_t   is (RST, INCR, HOLD);
    type set_clr_t      is (SET, CLR, HOLD);
    type tx_state_t     is (IDLE, SEND);
    type tx_mode_t      is (REPLY, REQUEST);

    -- state variables
    signal tx_state         : tx_state_t := IDLE;
    signal tx_count         : unsigned (7 downto 0) := to_unsigned(0, 8);
    signal send_I_have_reg  : std_logic := '0';
    signal tx_mode          : tx_mode_t;  -- what sort of tx to make

    -- busses
    signal next_tx_state    : tx_state_t;
    signal tx_mode_val      : tx_mode_t;
    signal target_ip        : std_logic_vector (31 downto 0) := (others => '0');
    signal target_mac       : std_logic_vector (47 downto 0) := (others => '0');
    
    -- tx control signals
    signal set_tx_state     : std_logic :='0';
    signal tx_count_mode    : count_mode_t;
    signal set_send_I_have  : set_clr_t;
    signal set_tx_mode      : std_logic :='0';
    signal set_target       : std_logic :='0';
  
--    signal fcs_rst          : std_logic := '1';
--    signal fcs_en           : std_logic := '0';
    signal fcs_din          : std_logic_vector(7 downto 0)  := (others => '0'); 
--    signal fcs_crc          : std_logic_vector(31 downto 0) := (others => '0');
--    signal fcs_crcnext      : std_logic_vector(31 downto 0) := (others => '0'); 
    
--    signal fcs_t1           : std_logic_vector(7 downto 0)  := (others => '0');
--    signal fcs_t2           : std_logic_vector(7 downto 0)  := (others => '0');
--    signal fcs_t3           : std_logic_vector(7 downto 0)  := (others => '0'); 
--    signal fcs_t4           : std_logic_vector(7 downto 0)  := (others => '0'); 



    signal fcs_en       : std_logic := '0';
    signal fcs_rst      : std_logic := '1';
    signal fcs_crc      : std_logic_vector(31 downto 0)  := x"00_00_00_00";
    signal fcs_crcnext  : std_logic_vector(31 downto 0)  := x"00_00_00_00";
    
    signal fcs_t2       : std_logic_vector(7 downto 0)  := x"00";
    signal fcs_t3       : std_logic_vector(7 downto 0)  := x"00";
    signal fcs_t4       : std_logic_vector(7 downto 0)  := x"00";
    
    
    --signal arp_tx_clk       : std_logic;
    --signal arp_tx_wr        : std_logic;
    signal arp_tx_data      : std_logic_vector (7 downto 0) := (others => '0');
    signal gmii_tx_en       : std_logic :='0';
    signal gmii_tx_err      : std_logic :='0';
    
  component crc
        port(
            Clk:            in std_logic;
            Reset:          in std_logic;
            Enable:         in std_logic;
            Data_in:        in std_logic_vector(7 downto 0);
            Crc:            out std_logic_vector(31 downto 0);
            CrcNext:        out std_logic_vector(31 downto 0)
        );
    end component;
    
begin

fcs: crc 
port map(    
    Clk     => tx_clk,        
    Reset   => fcs_rst,
    Enable  => fcs_en,
    Data_in => fcs_din,
    Crc     => fcs_crc,
    CrcNext => fcs_crcnext
); 


  --assign
  arp_fifo_wr_data <= gmii_tx_en & gmii_tx_err & arp_tx_data;
  arp_fifo_wr_clk  <= tx_clk;
  arp_tx_data      <= fcs_din;
 
  
  tx_combinatorial : process (arp_request_ok, send_I_have_reg) begin 
        
        if (arp_request_ok = '1') then
            set_send_I_have <= SET;
            target_mac <= arp_request_mac;
            target_ip  <= arp_request_ip;
        end if;
        
        if (send_I_have_reg = '1') then
--          tx_mode_val     <= REPLY;
--          set_tx_mode     <= '1';
--          set_target      <= '1';
          set_send_I_have <= CLR;
--          next_tx_state   <= SEND;
--          set_tx_state    <= '1';
        end if;
        
  end process; 
  
  
  
  tx_sequential : process (tx_clk)
    begin
        if rising_edge(tx_clk) then


            -- input request latching
            case set_send_I_have is
              when SET =>
                send_I_have_reg <= '1';
                tx_state        <= SEND;
              when CLR =>
                send_I_have_reg <= '0';
              when HOLD =>
                send_I_have_reg <= send_I_have_reg;
            end case;
            
            
            -- tx_count processing
            case tx_count_mode is
              when RST =>
                tx_count <= x"00";
              when INCR =>
                tx_count <= tx_count + 1;
              when HOLD =>
                tx_count <= tx_count;
            end case;


            -- TX FSM
            case tx_state is
              when IDLE =>
                tx_count_mode <= RST;
                gmii_tx_en    <= '0';
                arp_fifo_wr_en<= '0';
                fcs_en        <= '0';  	--Disable module FCS
                fcs_rst       <= '1'; 	--Reset value FCS 

              when SEND =>
                case tx_count is
                when x"00" => gmii_tx_en    <= '1';
                              arp_fifo_wr_en<= '1';
                              fcs_din       <= x"55";     
                              tx_count_mode <= INCR;
                              
                when x"01" => fcs_din <= x"55";  
                when x"02" => fcs_din <= x"55";  
                when x"03" => fcs_din <= x"55";  
                when x"04" => fcs_din <= x"55";  
                when x"05" => fcs_din <= x"55";  
                when x"06" => fcs_din <= x"55";  
                when x"07" => fcs_din <= x"D5";  
                when x"08" => fcs_din <= target_mac (47 downto 40);         --data_out <= x"ff"; 
                              fcs_en  <= '1';  	--Enable module FCS
                              fcs_rst <= '0'; 	--Set value FCS 
                
                when x"09" => fcs_din <= target_mac (39 downto 32);         --data_out <= x"ff";
                when x"0a" => fcs_din <= target_mac (31 downto 24);         --data_out <= x"ff";
                when x"0b" => fcs_din <= target_mac (23 downto 16);         --data_out <= x"ff";
                when x"0c" => fcs_din <= target_mac (15 downto 8);          --data_out <= x"ff";
                when x"0d" => fcs_din <= target_mac (7 downto 0);           --data_out <= x"ff";
                when x"0e" => fcs_din <= dev_mac (47 downto 40);            -- src = our mac
                when x"0f" => fcs_din <= dev_mac (39 downto 32);
                when x"10" => fcs_din <= dev_mac (31 downto 24);
                when x"11" => fcs_din <= dev_mac (23 downto 16);
                when x"12" => fcs_din <= dev_mac (15 downto 8);
                when x"13" => fcs_din <= dev_mac (7 downto 0);
                when x"14" => fcs_din <= x"08";                             -- pkt type = 0806 : ARP
                when x"15" => fcs_din <= x"06";
                when x"16" => fcs_din <= x"00";                             -- HW type = 0001 : eth
                when x"17" => fcs_din <= x"01";
                when x"18" => fcs_din <= x"08";                             -- protocol = 0800 : ip
                when x"19" => fcs_din <= x"00";
                when x"1a" => fcs_din <= x"06";                             -- HW size = 06
                when x"1b" => fcs_din <= x"04";                             -- prot size = 04
                when x"1c" => fcs_din <= x"00";                             -- opcode =             
                when x"1d" => fcs_din <= x"02";                             -- 02 : REPLY 
                when x"1e" => fcs_din <= dev_mac (47 downto 40);       -- sender mac
                when x"1f" => fcs_din <= dev_mac (39 downto 32);
                when x"20" => fcs_din <= dev_mac (31 downto 24);
                when x"21" => fcs_din <= dev_mac (23 downto 16);
                when x"22" => fcs_din <= dev_mac (15 downto 8);
                when x"23" => fcs_din <= dev_mac (7 downto 0);
                when x"24" => fcs_din <= dev_ip  (31 downto 24);   -- sender ip
                when x"25" => fcs_din <= dev_ip  (23 downto 16);
                when x"26" => fcs_din <= dev_ip  (15 downto 8);
                when x"27" => fcs_din <= dev_ip  (7 downto 0);
                when x"28" => fcs_din <= target_mac (47 downto 40);       -- target mac
                when x"29" => fcs_din <= target_mac (39 downto 32);                    
                when x"2a" => fcs_din <= target_mac (31 downto 24);                    
                when x"2b" => fcs_din <= target_mac (23 downto 16);                    
                when x"2c" => fcs_din <= target_mac (15 downto 8);                     
                when x"2d" => fcs_din <= target_mac (7 downto 0);                      
                when x"2e" => fcs_din <= target_ip (31 downto 24);        -- target ip
                when x"2f" => fcs_din <= target_ip (23 downto 16);
                when x"30" => fcs_din <= target_ip (15 downto 8);
                when x"31" => fcs_din <= target_ip (7 downto 0);
                when x"43" => fcs_din <= x"00";     --end trailer ARP
                when x"44" => fcs_din <= not fcs_crcnext(24) & not fcs_crcnext(25) & not fcs_crcnext(26) & not fcs_crcnext(27) & not fcs_crcnext(28) & not fcs_crcnext(29) & not fcs_crcnext(30) & not fcs_crcnext(31) ;
                              fcs_t2  <= not fcs_crcnext(16) & not fcs_crcnext(17) & not fcs_crcnext(18) & not fcs_crcnext(19) & not fcs_crcnext(20) & not fcs_crcnext(21) & not fcs_crcnext(22) & not fcs_crcnext(23) ;
                              fcs_t3  <= not fcs_crcnext(8) &  not fcs_crcnext(9) &  not fcs_crcnext(10) & not fcs_crcnext(11) & not fcs_crcnext(12) & not fcs_crcnext(13) & not fcs_crcnext(14) & not fcs_crcnext(15) ;
                              fcs_t4  <= not fcs_crcnext(0) &  not fcs_crcnext(1) &  not fcs_crcnext(2) &  not fcs_crcnext(3) &  not fcs_crcnext(4) &  not fcs_crcnext(5) &  not fcs_crcnext(6) &  not fcs_crcnext(7) ;
                              fcs_en  <='0';        --Disable module FCS
                              fcs_rst <='1';        --Reset value FCS 
                when x"45" => fcs_din <= fcs_t2;    --FCS 2byte
                when x"46" => fcs_din <= fcs_t3;    --FCS 3byte
                when x"47" => fcs_din <= fcs_t4;    --FCS 4byte
                when x"48" => fcs_din <= x"00";
                              gmii_tx_en    <= '0';
                              tx_state      <= IDLE;
                              --set_tx_state  <= '1';              
                              
                when others => fcs_din <= x"00"; --Trailer ARP
                end case;
            end case;


        end if;
    end process;

end Behavioral;





--  tx_combinatorial : process 
--  (
--    -- input signals
--    tx_clk,
--    arp_request_ok,
--    dev_mac, 
--    dev_ip, 
--    --reset,
    
--    -- state variables
--    tx_state, 
--    tx_count, 
--    --who_has_target,
--    send_I_have_reg, 
--    --send_who_has_reg, 
--    tx_mode, 


--    -- busses
--    next_tx_state, 
--    tx_mode_val, 

--    -- control signals
--    tx_count_mode, 
--    set_send_I_have, 
--    set_tx_mode, 
--    set_target
--)begin

--    -- set bus defaults
--    next_tx_state  <= IDLE;
--    tx_mode_val    <= REPLY;

--    -- set signal defaults
--    set_tx_state        <= '0';
----     tx_count_mode       <= HOLD;
----     fcs_din             <= x"00";
--    arp_tx_data         <= fcs_din;
----     gmii_tx_en          <= '0';
----     gmii_tx_err         <= '0';
----     arp_fifo_wr_en      <= '0';
--    set_send_I_have     <= HOLD;
--    set_tx_mode         <= '0';
--    set_target          <= '0';
    
--    --arp_fifo_wr_en      <= '0';

--    -- process requests in regardless of FSM state
    
----     if(tx_clk 'event and tx_clk = '1') then 
----         arp_fifo_wr_clk <= '1';
----     end if;
    
--    if arp_request_ok = '1' then
--        set_send_I_have <= SET;
--    end if;
    
--    -- TX FSM
--    case tx_state is
--      when IDLE =>
--        tx_count_mode <= RST;
--        gmii_tx_en    <= '0';
--        arp_fifo_wr_en<= '0';
--        fcs_en        <= '0';  	--Disable module FCS
--	    fcs_rst       <= '1'; 	--Reset value FCS 
        
--        if send_I_have_reg = '1' then
--          tx_mode_val     <= REPLY;
--          set_tx_mode     <= '1';
--          set_target      <= '1';
--          set_send_I_have <= CLR;
--          next_tx_state   <= SEND;
--          set_tx_state    <= '1';
--        end if;
        
--      when SEND =>
--        case tx_count is
--        when x"00" => gmii_tx_en    <= '1';
--                      arp_fifo_wr_en<= '1';
--                      fcs_din       <= x"55";     
--                      tx_count_mode <= INCR;
                      
--        when x"01" => fcs_din <= x"55";  
--        when x"02" => fcs_din <= x"55";  
--        when x"03" => fcs_din <= x"55";  
--        when x"04" => fcs_din <= x"55";  
--        when x"05" => fcs_din <= x"55";  
--        when x"06" => fcs_din <= x"55";  
--        when x"07" => fcs_din <= x"D5";  
--        when x"08" => fcs_din <= target_mac (47 downto 40);         --data_out <= x"ff"; 
--                      fcs_en  <= '1';  	--Enable module FCS
--	                  fcs_rst <= '0'; 	--Set value FCS 
        
--        when x"09" => fcs_din <= target_mac (39 downto 32);         --data_out <= x"ff";
--        when x"0a" => fcs_din <= target_mac (31 downto 24);         --data_out <= x"ff";
--        when x"0b" => fcs_din <= target_mac (23 downto 16);         --data_out <= x"ff";
--        when x"0c" => fcs_din <= target_mac (15 downto 8);          --data_out <= x"ff";
--        when x"0d" => fcs_din <= target_mac (7 downto 0);           --data_out <= x"ff";
--        when x"0e" => fcs_din <= dev_mac (47 downto 40);            -- src = our mac
--        when x"0f" => fcs_din <= dev_mac (39 downto 32);
--        when x"10" => fcs_din <= dev_mac (31 downto 24);
--        when x"11" => fcs_din <= dev_mac (23 downto 16);
--        when x"12" => fcs_din <= dev_mac (15 downto 8);
--        when x"13" => fcs_din <= dev_mac (7 downto 0);
--        when x"14" => fcs_din <= x"08";                             -- pkt type = 0806 : ARP
--        when x"15" => fcs_din <= x"06";
--        when x"16" => fcs_din <= x"00";                             -- HW type = 0001 : eth
--        when x"17" => fcs_din <= x"01";
--        when x"18" => fcs_din <= x"08";                             -- protocol = 0800 : ip
--        when x"19" => fcs_din <= x"00";
--        when x"1a" => fcs_din <= x"06";                             -- HW size = 06
--        when x"1b" => fcs_din <= x"04";                             -- prot size = 04
--        when x"1c" => fcs_din <= x"00";                             -- opcode =             
--        when x"1d" => fcs_din <= x"02";                             -- 02 : REPLY 
--        when x"1e" => fcs_din <= dev_mac (47 downto 40);       -- sender mac
--        when x"1f" => fcs_din <= dev_mac (39 downto 32);
--        when x"20" => fcs_din <= dev_mac (31 downto 24);
--        when x"21" => fcs_din <= dev_mac (23 downto 16);
--        when x"22" => fcs_din <= dev_mac (15 downto 8);
--        when x"23" => fcs_din <= dev_mac (7 downto 0);
--        when x"24" => fcs_din <= dev_ip  (31 downto 24);   -- sender ip
--        when x"25" => fcs_din <= dev_ip  (23 downto 16);
--        when x"26" => fcs_din <= dev_ip  (15 downto 8);
--        when x"27" => fcs_din <= dev_ip  (7 downto 0);
--        when x"28" => fcs_din <= target_mac (47 downto 40);       -- target mac
--        when x"29" => fcs_din <= target_mac (39 downto 32);                    
--        when x"2a" => fcs_din <= target_mac (31 downto 24);                    
--        when x"2b" => fcs_din <= target_mac (23 downto 16);                    
--        when x"2c" => fcs_din <= target_mac (15 downto 8);                     
--        when x"2d" => fcs_din <= target_mac (7 downto 0);                      
--        when x"2e" => fcs_din <= target_ip (31 downto 24);        -- target ip
--        when x"2f" => fcs_din <= target_ip (23 downto 16);
--        when x"30" => fcs_din <= target_ip (15 downto 8);
--        when x"31" => fcs_din <= target_ip (7 downto 0);
--        when x"43" => fcs_din <= x"00";     --end trailer ARP
--        when x"44" => fcs_din <= not fcs_crcnext(24) & not fcs_crcnext(25) & not fcs_crcnext(26) & not fcs_crcnext(27) & not fcs_crcnext(28) & not fcs_crcnext(29) & not fcs_crcnext(30) & not fcs_crcnext(31) ;
--                      fcs_t2  <= not fcs_crcnext(16) & not fcs_crcnext(17) & not fcs_crcnext(18) & not fcs_crcnext(19) & not fcs_crcnext(20) & not fcs_crcnext(21) & not fcs_crcnext(22) & not fcs_crcnext(23) ;
--                      fcs_t3  <= not fcs_crcnext(8) &  not fcs_crcnext(9) &  not fcs_crcnext(10) & not fcs_crcnext(11) & not fcs_crcnext(12) & not fcs_crcnext(13) & not fcs_crcnext(14) & not fcs_crcnext(15) ;
--                      fcs_t4  <= not fcs_crcnext(0) &  not fcs_crcnext(1) &  not fcs_crcnext(2) &  not fcs_crcnext(3) &  not fcs_crcnext(4) &  not fcs_crcnext(5) &  not fcs_crcnext(6) &  not fcs_crcnext(7) ;
--                      fcs_en  <='0';        --Disable module FCS
--                      fcs_rst <='1';        --Reset value FCS 
--        when x"45" => fcs_din <= fcs_t2;    --FCS 2byte
--        when x"46" => fcs_din <= fcs_t3;    --FCS 3byte
--        when x"47" => fcs_din <= fcs_t4;    --FCS 4byte
--        when x"48" => fcs_din <= x"00";
--                      gmii_tx_en    <= '0';
--                      next_tx_state <= IDLE;
--                      set_tx_state  <= '1';              
                      
--        when others => fcs_din <= x"00"; --Trailer ARP
--        end case;
--    end case;
--  end process;

