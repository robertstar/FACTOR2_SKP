----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2021 11:46:25 AM
-- Design Name: 
-- Module Name: tx_pkt_gen_25700 - Behavioral
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


entity tx_pkt_25700 is
Port ( 
        CLK                     : in STD_LOGIC;
        
        DEV_IP                  : in STD_LOGIC_VECTOR (31 downto 0);
        DEV_MAC                 : in STD_LOGIC_VECTOR (47 downto 0);
        
        DST_IP                  : in std_logic_vector (31 downto 0);
        DST_MAC                 : in std_logic_vector (47 downto 0);
        
        envelope                : in  STD_LOGIC;
        trigger                 : out  STD_LOGIC := '0';
        
        ADC_DONE                : in  STD_LOGIC;
        ADC_DATA                : in  STD_LOGIC_VECTOR (1359 downto 0);
        
        APO_COMM                : in  STD_LOGIC_VECTOR (143 downto 0);  
        APO_DONE                : in  STD_LOGIC;
        
        MEM_SKP_25700_RD_EN     : out std_logic := '0';
        MEM_SKP_25700_RD_ADDR   : out std_logic_vector(4 downto 0) := (others => '0');
        MEM_SKP_25700_RD_DATA   : in  std_logic_vector(7 downto 0);
        MEM_SKP_25700_BUSY      : in  std_logic;
        MEM_SKP_25700_DONE      : in  std_logic;
        
        FIFO_25700_WR_EN        : out STD_LOGIC := '0';
        FIFO_25700_WR_DATA      : out STD_LOGIC_VECTOR (9 downto 0) := (others => '0');

        sel_dbg                 : out std_logic_vector(7 downto 0) := (others => '0')
);
end tx_pkt_25700;


architecture Behavioral of tx_pkt_25700 is

    constant  IP4_VHL   : std_logic_vector(7 downto 0)  := x"45";
    constant  IP4_DSCP  : std_logic_vector(7 downto 0)  := x"00";
    constant  IP4_TL    : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(1418, 16)); -- 20 + 8 + 1390
    constant  IPv4_FL   : std_logic_vector(15 downto 0) := x"40_00";
    constant  IP4_TTL   : std_logic_vector(7 downto 0)  := x"40";
    constant  IP4_TYPE  : std_logic_vector(7 downto 0)  := x"11";
    constant  IP4_DST_IP: std_logic_vector(31 downto 0) := x"C0_A8_04_01";
    constant  UDP_SP    : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(25700, 16));
    constant  UDP_DP    : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(25700, 16));
    constant  UDP_LEN   : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(1398, 16));  --8 + 1390
    constant  UDP_CRC   : std_logic_vector(15 downto 0) := x"00_00";
    
    type t_State is (IDLE, SYNC, TRIG, WRITE_HDR, WAIT_DATA, WRITE_DATA, WRITE_FCS, END_TX);
    signal State        : t_State;
    
    signal sync1        : std_logic := '0';
    signal sync2        : std_logic := '0';
    
    signal din          : std_logic_vector(7 downto 0)  := x"00";
    
    signal pkt_cnt      : std_logic_vector (31 downto 0) := x"00_00_00_00";
    signal IPv4_ID      : std_logic_vector (15 downto 0) := x"00_00";
    signal sel          : integer range 0 to 255 := 0;
    
    signal wait_cnt     : integer range 0 to 255 := 0;
    signal pkt_d        : std_logic_vector (7 downto 0) := x"00";
    
    signal fcs_en       : std_logic := '0';
    signal fcs_rst      : std_logic := '1';
    signal fcs_crc      : std_logic_vector(31 downto 0)  := x"00_00_00_00";
    signal fcs_crcnext  : std_logic_vector(31 downto 0)  := x"00_00_00_00";
    
    signal IP4_CRC      : std_logic_vector(31 downto 0)  := x"00_00_00_00";
    
    signal fcs_t2       : std_logic_vector(7 downto 0)  := x"00";
    signal fcs_t3       : std_logic_vector(7 downto 0)  := x"00";
    signal fcs_t4       : std_logic_vector(7 downto 0)  := x"00";
    
    signal tx_en        : std_logic := '0';
    signal adc_data_t   : std_logic_vector (1359 downto 0) := std_logic_vector(to_unsigned(0, 1360));
    
    
    signal y1           : unsigned(15 downto 0) := unsigned(IP4_VHL & IP4_DSCP);
    signal y2           : unsigned(15 downto 0) := unsigned(IP4_TL);
    signal y3           : unsigned(15 downto 0) := unsigned(IPv4_FL);
    signal y4           : unsigned(15 downto 0) := unsigned(IP4_TTL & IP4_TYPE);
    signal y5           : unsigned(15 downto 0) := unsigned(IP4_DST_IP(31 downto 16));
    signal y6           : unsigned(15 downto 0) := unsigned(IP4_DST_IP(15 downto 0));
    signal y7           : unsigned(15 downto 0) := unsigned(DEV_IP    (31 downto 16));
    signal y8           : unsigned(15 downto 0) := unsigned(DEV_IP    (15 downto 0));
    signal y9           : unsigned(15 downto 0) := to_unsigned(0, 16);
    signal ip4_crc_t1   : unsigned(31 downto 0) := to_unsigned(0, 32);
    signal ip4_crc_t2   : unsigned(16 downto 0) := to_unsigned(0, 17);
    
    signal dst_mac_t    : std_logic_vector(47 downto 0)  := x"00_00_00_00_00_00";
    signal index        : integer range 0 to 1359 := 0;
    signal cnt_get_pkt  : std_logic_vector (31 downto 0) := x"00_00_00_00";
    signal set_apo      : std_logic := '0';
    signal get_apo      : std_logic := '0';
    signal work_st      : std_logic_vector (7 downto 0) := x"00";
    
    signal get_time_t   : std_logic_vector (31 downto 0) := x"00_00_00_00";
    signal SKP25700_RD_ADDR_t : std_logic_vector(4 downto 0) := b"00000";
    signal skp_timeot   : std_logic_vector(7 downto 0) := X"00";
    
    signal sel_u_t      : unsigned (7 downto 0) := to_unsigned(0, 8);
    
    --Metastability
    signal envelope1_t  : std_logic := '0';
    signal envelope2_t  : std_logic := '0';
    signal envelope3_t  : std_logic := '0';
    signal envelope4_t  : std_logic_vector(1 downto 0)  := b"00";
    
    signal env_st       : std_logic_vector(1 downto 0)  := b"00";
    signal env_timer    : std_logic_vector(15 downto 0) := x"00_00";
    signal trigger_t    : std_logic := '0';
    
    component crc
        port (
            Clk         :in   std_logic;
            Reset       :in   std_logic;
            Data_in     :in   std_logic_vector (7 downto 0);
            Enable      :in   std_logic;
            Crc         :out  std_logic_vector (31 downto 0);
            CrcNext     :out  std_logic_vector (31 downto 0)
        );
    end component;
    
--    ---------------------------------------------------------------------------------------
--    component ila_5 
--    port (
--        clk             : in  std_logic;
--        probe0          : in  std_logic_vector (0  DOWNTO 0);
--        probe1          : in  std_logic_vector (0  DOWNTO 0);
--        probe2          : in  std_logic_vector (0  DOWNTO 0);  
--        probe3          : in  std_logic_vector (0  DOWNTO 0);
--        probe4          : in  std_logic_vector (1  DOWNTO 0);
--        probe5          : in  std_logic_vector (1  DOWNTO 0);
--        probe6          : in  std_logic_vector (15 DOWNTO 0);
--        probe7          : in  std_logic_vector (7  DOWNTO 0);
--        probe8          : in  std_logic_vector (0  DOWNTO 0)                        
--    );
--    end component;
       
begin

    crc_inst: crc
    port map(    
        Clk         => CLK,        
        Reset       => fcs_rst,        
        Data_in     => din,       
        Enable      => fcs_en,    
        Crc         => fcs_crc,
        CrcNext     => fcs_crcnext
    ); 
    
--    dbg25700: ila_5
--    port map(    
--        clk         => CLK,    
--        probe0(0)   => envelope,    --1     
--        probe1(0)   => envelope1_t, --1
--        probe2(0)   => envelope2_t, --1
--        probe3(0)   => envelope3_t, --1
--        probe4      => envelope4_t, --2
--        probe5      => env_st,      --2
--        probe6      => env_timer,   --16
--        probe7      => work_st,     --8
--        probe8(0)   => trigger_t    --1
--        );


    --------------------------------------------------------------------------------------------------------------------
    apo_comb: process (APO_DONE, get_apo) begin 
        if (APO_DONE = '1') then
            set_apo <= '1';
        end if;
        
        if (get_apo = '1') then
            set_apo <= '0';
        end if;   
    end process apo_comb; 
    
    --Assign 
    --sel_u_t <= to_unsigned(sel, 8);
    --sel_dbg <= std_logic_vector( sel_u_t );
    sel_dbg <= std_logic_vector( to_unsigned(sel, 8) );
    
    --------------------------------------------------------------------------------------------------------------------
    --SEND UDP PACKET
    send_udp : process(CLK)
    begin
        if rising_edge(CLK) then
         
            --sync adc fd clock
            sync1 <= ADC_DONE;
            sync2 <= sync1;
            
            --sync envelope and metastability
            envelope1_t <= envelope;
            envelope2_t <= envelope1_t;
            envelope3_t <= envelope2_t;
            
            
            --sync APO command
            if(set_apo = '1') then
                get_apo     <= '1';
                work_st     <= apo_comm(7  DOWNTO 0);
                cnt_get_pkt <= apo_comm(79 downto 48);
            else
                get_apo <= '0';
            end if;
            
            --FSM
            case State is
            
                when IDLE =>
                    case work_st is
                        when X"31" =>   --Work
                            if(cnt_get_pkt /= 0) then
                                State <= TRIG;
                            end if;
                        when X"32" =>   --Control
                            if(cnt_get_pkt /= 0) then
                                State <= SYNC;
                            end if;
                        when X"33" => State <= IDLE; --Reset
                        when X"34" =>   --Stop
                        when others => null;
                    end case;  
                
                when TRIG =>
                    case env_st is
                        when b"00" =>
                            envelope4_t <=  envelope4_t(0) & envelope3_t;
                            if(envelope4_t = b"10") then
                                envelope4_t <= b"11";  
                                env_st <= env_st + 1;
                            end if;
                                            
                        when b"01" =>
                            if( to_integer(unsigned(env_timer)) < 62500 ) then --500us
                                env_timer <= env_timer + 1;
                            else 
                                env_timer <= X"00_00";
                                env_st <= env_st + 1;
                            end if;
                        
                        when b"10" =>
                            envelope4_t <=  envelope4_t(0) & envelope3_t;
                            if(envelope4_t = b"01") then
                                envelope4_t <= b"00";  
                                trigger     <= '1'; --to oscilloscope
                                trigger_t   <= '1';
                                env_st      <= b"00";
                                State       <= SYNC;
                            end if;
                            
                        --when b"11" => --IDLE
                            --env_st <= env_st;
                        when others => null;
                    end case;
   
                when SYNC =>
                    if (sync1 = '1' and sync2 = '0') then
                        sel <= 0;
                        adc_data_t <= adc_data;
                        get_time_t <= get_time_t + 1;
                        if(DST_IP = IP4_DST_IP) then
                            dst_mac_t <= DST_MAC;
                        elsif (DST_IP = X"00_00_00_00") then
                            dst_mac_t <= X"FF_FF_FF_FF_FF_FF";
                        end if;
                        State <= WRITE_HDR;
                    end if;    
                
                when WRITE_HDR =>
                    case sel is
                        --Ethenet preambule
                        when 0 => din <= x"55"; pkt_cnt <=pkt_cnt + 1; IPv4_ID <=IPv4_ID + 1; wait_cnt <=0; pkt_d <= x"00"; tx_en <= '1'; FIFO_25700_WR_EN <= '1'; sel <=sel+1;
                        when 1 => din <= x"55"; sel <=sel+1;
                        when 2 => din <= x"55"; sel <=sel+1;
                        when 3 => din <= x"55"; sel <=sel+1;
                        when 4 => din <= x"55"; sel <=sel+1;
                        when 5 => din <= x"55"; sel <=sel+1;
                        when 6 => din <= x"55"; sel <=sel+1;
                        when 7 => din <= x"D5"; sel <=sel+1;
                        
                        --Ethenet header    
                        when 8 => din     <= dst_mac_t(47 downto 40); 
                                  sel     <=sel+1; 
                                  fcs_en  <='1';  	          --Enable module FCS
                                  fcs_rst <='0'; 	          --Set value FCS 
                                    
                        when 9 =>  din <= dst_mac_t(39 downto 32); sel <=sel+1;
                        when 10 => din <= dst_mac_t(31 downto 24); sel <=sel+1;
                        when 11 => din <= dst_mac_t(23 downto 16); sel <=sel+1;
                        when 12 => din <= dst_mac_t(15 downto 8);  sel <=sel+1;
                        when 13 => din <= dst_mac_t(7  downto 0);  sel <=sel+1;
                        
                        --SRC MAC
                        when 14 => din <= DEV_MAC(47 downto 40); sel <=sel+1;   
                        when 15 => din <= DEV_MAC(39 downto 32); sel <=sel+1; 
                        when 16 => din <= DEV_MAC(31 downto 24); sel <=sel+1; 
                        when 17 => din <= DEV_MAC(23 downto 16); sel <=sel+1; 
                        when 18 => din <= DEV_MAC(15 downto 8);  sel <=sel+1; 
                        when 19 => din <= DEV_MAC(7  downto 0);  sel <=sel+1; 
                        
                        --TYPE
                        when 20 => din <= x"08"; sel <=sel+1; 
                        when 21 => din <= x"00"; sel <=sel+1; y9 <= unsigned(IPv4_ID);  
                        
                        --IPv4 header
                        when 22 => din <=IP4_VHL; 
                                   sel <=sel+1;
                                   ip4_crc_t1 <= (resize(y1,32)) + (resize(y2,32)) + (resize(y3,32)) + (resize(y4,32)) + (resize(y5,32)) + (resize(y6,32)) + (resize(y7,32)) + (resize(y8,32)) + (resize(y9,32));
                        when 23 => din <=IP4_DSCP;
                                   sel <=sel+1; 
                                   ip4_crc_t2 <= "0" & ip4_crc_t1(31 downto 16) + ip4_crc_t1(15 downto 0);
                        when 24 => din <=IP4_TL(15 downto 8);       sel <=sel+1;   
                        when 25 => din <=IP4_TL(7 downto 0);        sel <=sel+1; 
                        when 26 => din <=IPv4_ID(15 downto 8);      sel <=sel+1; 
                        when 27 => din <=IPv4_ID(7 downto 0);       sel <=sel+1; 
                        when 28 => din <=IPv4_FL(15 downto 8);      sel <=sel+1;   
                        when 29 => din <=IPv4_FL(7 downto 0);       sel <=sel+1; 
                        when 30 => din <=IP4_TTL;                   sel <=sel+1; 
                        when 31 => din <=IP4_TYPE;                  sel <=sel+1;   
                        when 32 => din <= not std_logic_vector(ip4_crc_t2(15 downto 8)); 
                                   sel <=sel+1;                   
                        when 33 => 
                            if(IP4_CRC(16) = '1') then  --overflow carry 
                                din <= not std_logic_vector(ip4_crc_t2(7 downto 0)) - '1';
                            else
                                din <= not std_logic_vector(ip4_crc_t2(7 downto 0)); 
                            end if;
                            sel <=sel+1;
                            
                        when 34 => din <=DEV_IP(31 downto 24);      sel <=sel+1; 
                        when 35 => din <=DEV_IP(23 downto 16);      sel <=sel+1; 
                        when 36 => din <=DEV_IP(15 downto 8);       sel <=sel+1; 
                        when 37 => din <=DEV_IP(7 downto 0);        sel <=sel+1; 
                        when 38 => din <=IP4_DST_IP(31 downto 24);  sel <=sel+1; 
                        when 39 => din <=IP4_DST_IP(23 downto 16);  sel <=sel+1; 
                        when 40 => din <=IP4_DST_IP(15 downto 8);   sel <=sel+1; 
                        when 41 => din <=IP4_DST_IP(7 downto 0);    sel <=sel+1; 
                        
                        --UDP header
                        when 42 => din <=UDP_SP(15 downto 8);       sel <=sel+1;
                        when 43 => din <=UDP_SP(7 downto 0);        sel <=sel+1;
                        
                        when 44 => din <=UDP_DP(15 downto 8);       sel <=sel+1;
                        when 45 => din <=UDP_DP(7 downto 0);        sel <=sel+1;
                        
                        when 46 => din <=UDP_LEN(15 downto 8);      sel <=sel+1;
                        when 47 => din <=UDP_LEN(7 downto 0);       sel <=sel+1;
                        
                        when 48 => din <=UDP_CRC(15 downto 8);      sel <=sel+1;
                        when 49 => din <=UDP_CRC(7 downto 0);       sel <=sel+1;
                        
                        --Timer 5 us
                        when 50 => din <=get_time_t(7 downto 0);    sel <=sel+1;
                        when 51 => din <=get_time_t(15 downto 8);   sel <=sel+1;
                        when 52 => din <=get_time_t(23 downto 16);  sel <=sel+1;
                        when 53 => din <=get_time_t(31 downto 24);  sel <=sel+1;
                        
                        --Timer 5 us
                        when 54 => din <=pkt_cnt(7 downto 0);       sel <=sel+1;
                        when 55 => din <=pkt_cnt(15 downto 8);      sel <=sel+1;
                        when 56 => din <=pkt_cnt(23 downto 16);     sel <=sel+1;
                        when 57 => din <=pkt_cnt(31 downto 24);     sel <=sel+1;
                        
                        --SKP 19 bytes
                        when 58 =>
                            FIFO_25700_WR_EN <= '0';
                            fcs_en     <= '0';
                            if( MEM_SKP_25700_BUSY = '0' ) then --and SKP25700_DONE = '1'
                                MEM_SKP_25700_RD_EN <= '1';
                                SKP25700_RD_ADDR_t  <= b"00000";
                                sel                 <= sel+1;
                            else
                                if(skp_timeot = X"64") then
                                    sel             <= sel+1;
                                else
                                    skp_timeot <= skp_timeot + 1;
                                end if;
                            end if;
                            
                        when 59 =>  
                            FIFO_25700_WR_EN <= '1';
                            fcs_en     <= '1';
                            if(skp_timeot = X"64") then
                                din <= x"EE";
                            else
                                din                <= MEM_SKP_25700_RD_DATA; 
                                SKP25700_RD_ADDR_t <= SKP25700_RD_ADDR_t + 1;
                            end if;
                            sel <= sel+1;  
                        
                        when 80 => 
                            if(skp_timeot = X"64") then
                                din        <= x"EE";
                                skp_timeot <= X"00";
                            else
                                SKP25700_RD_ADDR_t <= SKP25700_RD_ADDR_t + 1;
                                din                <= MEM_SKP_25700_RD_DATA; 
                            end if;
                            sel   <=0; 
                            State <= WRITE_DATA;
                      
                        when others => 
                            if(skp_timeot = X"64") then
                                din <= x"EE";
                                sel <= sel+1;
                            else
                                SKP25700_RD_ADDR_t <= SKP25700_RD_ADDR_t + 1;
                                din                <= MEM_SKP_25700_RD_DATA;
                                sel                <= sel+1;
                            end if;
                                
                    end case;
                
                when WAIT_DATA =>
                    index       <=  0; 
                    FIFO_25700_WR_EN  <= '0';
                    fcs_en      <= '0';
                    if (sync1 = '1' and sync2 = '0') then
                        sel        <= 0;
                        get_time_t <= get_time_t + 1;
                        adc_data_t <= adc_data;
                        State      <= WRITE_DATA;
                    end if;
                
                when WRITE_DATA =>
                    case sel is
                        when 0 =>
                            MEM_SKP_25700_RD_EN <= '0';
                            SKP25700_RD_ADDR_t  <= b"00000";

                            FIFO_25700_WR_EN  <= '1';
                            fcs_en      <= '1';
                            din         <= adc_data_t(index+7 downto index);     
                            sel         <= sel+1;  
                            wait_cnt    <= wait_cnt+1; 
                            index       <= index+8;

                        when 169 =>
                            din      <= adc_data_t(index+7 downto index); 
                            sel <=0;
                            if(wait_cnt>=8) then
                                State <= WRITE_FCS;
                            else
                                State <= WAIT_DATA;
                            end if;
                        
                        when others =>
                            din      <= adc_data_t(index+7 downto index);     
                            sel      <= sel+1;
                            index    <= index+8;
                    end case;
                
                when WRITE_FCS =>
                    case sel is
                        when 0 =>
                            din     <= not fcs_crcnext(24) & not fcs_crcnext(25) & not fcs_crcnext(26) & not fcs_crcnext(27) & not fcs_crcnext(28) & not fcs_crcnext(29) & not fcs_crcnext(30) & not fcs_crcnext(31) ;
                            fcs_t2  <= not fcs_crcnext(16) & not fcs_crcnext(17) & not fcs_crcnext(18) & not fcs_crcnext(19) & not fcs_crcnext(20) & not fcs_crcnext(21) & not fcs_crcnext(22) & not fcs_crcnext(23) ;
                            fcs_t3  <= not fcs_crcnext(8) &  not fcs_crcnext(9) &  not fcs_crcnext(10) & not fcs_crcnext(11) & not fcs_crcnext(12) & not fcs_crcnext(13) & not fcs_crcnext(14) & not fcs_crcnext(15) ;
                            fcs_t4  <= not fcs_crcnext(0) &  not fcs_crcnext(1) &  not fcs_crcnext(2) &  not fcs_crcnext(3) &  not fcs_crcnext(4) &  not fcs_crcnext(5) &  not fcs_crcnext(6) &  not fcs_crcnext(7) ;
                            fcs_en  <= '0'; --Disable module FCS
                            fcs_rst <= '1'; --Reset value FCS 
                            sel     <= sel+1;
                            
                        when 1 => din<=fcs_t2; sel <=sel+1;
                        when 2 => din<=fcs_t3; sel <=sel+1;
                        when 3 => din<=fcs_t4; sel <=sel+1;
                        when 4 => din<=x"00";  
                                  sel <=0; 
                                  tx_en <= '0'; 
                                  State <= END_TX;
                                  
                        when others => null; 
                    end case;
                
                when END_TX =>
                    index      <=  0; 
                    FIFO_25700_WR_EN <= '0';
                    if( (cnt_get_pkt>0) and work_st /= X"33"  and work_st /= X"34") then
                        cnt_get_pkt <= cnt_get_pkt - 1;
                        State <= SYNC;
                    else
                        pkt_cnt   <= X"00_00_00_00";
                        State     <= IDLE;
                        trigger   <= '0'; --to oscilloscope
                        trigger_t <= '0';
                        env_st    <= b"00";
                    end if;

                when others => null;
            end case;
        end if;
    end process send_udp;
    
    
    --assign
    FIFO_25700_WR_DATA(7 downto 0) <= din;
    FIFO_25700_WR_DATA(8)          <= '0';
    FIFO_25700_WR_DATA(9)          <= tx_en;
    MEM_SKP_25700_RD_ADDR          <= SKP25700_RD_ADDR_t;

end Behavioral;
