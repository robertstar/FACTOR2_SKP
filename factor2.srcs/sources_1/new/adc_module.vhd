----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 10:19:56 AM
-- Design Name: 
-- Module Name: adc_module - Behavioral
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


entity adc_module is
Port ( 
        clk          : in STD_LOGIC;
        
        test_ch1     : in STD_LOGIC;
        
        adc_bus_1    : in STD_LOGIC_VECTOR (15 downto 0);
        adc_bus_2    : in STD_LOGIC_VECTOR (15 downto 0);
        adc_bus_3    : in STD_LOGIC_VECTOR (15 downto 0);
        adc_bus_4    : in STD_LOGIC_VECTOR (15 downto 0);
        
        adc_rst      : out STD_LOGIC;
        adc_conv     : out STD_LOGIC;
        
        adc_rd12     : out STD_LOGIC;
        adc_rd34     : out STD_LOGIC;
        adc_cs       : out STD_LOGIC_VECTOR (7 downto 0);
        
        adc_done     : out STD_LOGIC;
        adc_data     : out STD_LOGIC_VECTOR (1359 downto 0) := (others => '0')
);
end adc_module;

architecture Behavioral of adc_module is

    signal cs_o         : std_logic_vector(7 downto 0)  := b"11_11_11_11";
    signal adc_clk_o    : std_logic := '1'; 
    signal adc_rst_o    : std_logic := '0';
    signal adc_fd_o     : std_logic := '0'; 
    signal adc_ok       : std_logic := '0'; 
    
    signal   fd_tim     : integer range 0 to 1023 := 0;
    constant offset     : integer := 211;
    
    signal sorting      : std_logic := '0'; 
    
    --type ram is array(84 downto 0) of std_logic_vector(15 downto 0);
    --signal ram1 : ram := (others => (others => '0'));
 
    signal i_addr       : unsigned (4 downto 0) := to_unsigned(0, 5);

--    type t_sin_table is array(0 to 31) of integer range 0 to 255;
--    constant C_SIN_TABLE  : t_sin_table := (128,  153,  177,  200,  219,  235,  247,  254,  255,  254,  247,  235,  219,  200,  177,  153,
--                                            128,  103,   79,   56,   37,   21,    9,    2,    0,    2,    9,   21,   37,   56,   79,  103);
                                            
--    type t_sin_table is array(0 to 31) of integer range -128 to 127;
--    constant C_SIN_TABLE  : t_sin_table := (-128, -104, -80, -58, -38, -22, -11, -3, -1, -3, -11, -22, -38, -58, -80, -104, 
--                                            -128, 103, 79, 57, 37, 21, 10, 2, 0, 2, 10, 21, 37, 57, 79, 103);

--    type t_sin_table is array(0 to 31) of integer range -32768 to 32767;
--    constant C_SIN_TABLE  : t_sin_table := (-32768, -26376, -20229, -14564, -9598, -5523, -2495, -631, -1, -631, -2495, -5523, -9598, -14564, -20229, -26376,
--                                            -32768,  26375,  20228,  14563,  9597,  5522,  2494,  630,  0,  630,  2494,  5522,  9597,  14563,  20228,  26375);
                                            
    type t_sin_table2 is array(0 to 31) of integer range 0 to 65535;
    constant C_SIN_TABLE2  : t_sin_table2 := (32768, 39160, 45307, 50972, 55938, 60013, 63041, 64905, 65535, 64905, 63041, 60013, 55938, 50972, 45307, 39160, 
                                              32768, 26375, 20228, 14563,  9597,  5522,  2494,   630,     0,   630,  2494,  5522,  9597, 14563, 20228, 26375);
                                            
    
    
    signal test_s1       : signed (15 downto 0) := to_signed(0, 16);                                        
                                  
    
begin

    --assign
    ---------------------------------------------------------------------------------------
    adc_cs   <= cs_o;
    adc_conv <= adc_fd_o;
    adc_rst  <= adc_rst_o;
    adc_rd12 <= adc_clk_o;
    adc_rd34 <= adc_clk_o;
    adc_done <= adc_ok;
    test_s1  <= to_signed(C_SIN_TABLE2(to_integer(i_addr)),16);

    ---------------------------------------------------------------------------------------
    adc_proto : process (clk)
    begin
      if rising_edge(clk) then
        case fd_tim is
        
            when 0          =>  adc_fd_o <= '1'; 
                                fd_tim <= fd_tim + 1;
                                
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
            when offset     =>  adc_clk_o <= '0'; 
                                cs_o      <= b"0111_0111"; -- ADC Module 1 and 5
                                fd_tim    <= fd_tim + 1;
                             
            when offset+8   =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        case test_ch1 is
                                            when '0' => adc_data(15 downto 0) <= adc_bus_3;--ch0;
                                            when '1' => adc_data(15 downto 0) <= std_logic_vector( not test_s1(15) & test_s1(14 downto 0));
                                            when others => null;
                                        end case;
                                        adc_data(111 downto 96)     <= adc_bus_4;--ch6;
                                        adc_data(607 downto 592)    <= adc_bus_1;--ch37;
                                        adc_data(703 downto 688)    <= adc_bus_2;--ch43;
                                        i_addr <= i_addr +1; 
                                    when '1' =>
                                        adc_data(1183 downto 1168)  <= adc_bus_3;--ch73;
                                        adc_data(1279 downto 1264)  <= adc_bus_4;--ch79;
                                        adc_data(15 downto 0)       <= adc_bus_1;--ch0;
                                        adc_data(111 downto 96)     <= adc_bus_2;--ch6;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;  
                                             
            when offset+10  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+18  =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(31 downto 16)      <= adc_bus_3;--ch1;
                                        adc_data(127 downto 112)    <= adc_bus_4;--ch7;
                                        adc_data(623 downto 608)    <= adc_bus_1;--ch38;
                                        adc_data(719 downto 704)    <= adc_bus_2;--ch44;
                                    when '1' =>
                                        adc_data(1199 downto 1184)  <= adc_bus_3;--ch74;
                                        adc_data(1295 downto 1280)  <= adc_bus_4;--ch80;
                                        adc_data(31 downto 16)      <= adc_bus_1;--ch1;
                                        adc_data(127 downto 112)    <= adc_bus_2;--ch7;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;  
                                
            when offset+20  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+28  =>  adc_clk_o <= '1'; 
                                case sorting is
                                    when '0' =>
                                        adc_data(47 downto 32)      <= adc_bus_3;--ch3;
                                        adc_data(143 downto 128)    <= adc_bus_4;--ch9;
                                        adc_data(639 downto 624)    <= adc_bus_1;--ch39;
                                        adc_data(735 downto 720)    <= adc_bus_2;--ch45;
                                    when '1' =>
                                        adc_data(1215 downto 1200)  <= adc_bus_3;--ch75;
                                        adc_data(1311 downto 1296)  <= adc_bus_4;--ch81;
                                        adc_data(47 downto 32)      <= adc_bus_1;--ch2;
                                        adc_data(143 downto 128)    <= adc_bus_2;--ch8;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;  
                               
            when offset+30  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+38  =>  adc_clk_o <= '1'; 
                                case sorting is
                                    when '0' =>
                                        adc_data(63 downto 48)      <= adc_bus_3;--ch4;
                                        adc_data(159 downto 144)    <= adc_bus_4;--ch10;
                                        adc_data(655 downto 640)    <= adc_bus_1;--ch40;
                                        adc_data(751 downto 736)    <= adc_bus_2;--ch46;
                                    when '1' =>
                                        adc_data(1231 downto 1216)  <= adc_bus_3;--ch76;
                                        adc_data(1327 downto 1312)  <= adc_bus_4;--ch82;
                                        adc_data(63 downto 48)      <= adc_bus_1;--ch3;
                                        adc_data(159 downto 144)    <= adc_bus_2;--ch9;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;  
                               
            when offset+40  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+48  =>  adc_clk_o <= '1'; 
                                case sorting is
                                    when '0' =>
                                        adc_data(79 downto 64)      <= adc_bus_3;--ch5;
                                        adc_data(175 downto 160)    <= adc_bus_4;--ch11;
                                        adc_data(671 downto 656)    <= adc_bus_1;--ch41;
                                        adc_data(767 downto 752)    <= adc_bus_2;--ch47;
                                    when '1' =>
                                        adc_data(1247 downto 1232)  <= adc_bus_3;--ch77;
                                        adc_data(1343 downto 1328)  <= adc_bus_4;--ch83;
                                        adc_data(79 downto 64)      <= adc_bus_1;--ch4;
                                        adc_data(175 downto 160)    <= adc_bus_2;--ch10;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                               
            when offset+50  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+58  =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(95 downto 80)      <= adc_bus_3;--ch6;
                                        adc_data(191 downto 176)    <= adc_bus_4;--ch12;
                                        adc_data(687 downto 672)    <= adc_bus_1;--ch42;
                                        adc_data(783 downto 768)    <= adc_bus_2;--ch48;
                                    when '1' =>
                                        adc_data(1263 downto 1248)  <= adc_bus_3;--ch78;
                                        adc_data(1359 downto 1344)  <= adc_bus_4;--ch84;
                                        adc_data(95 downto 80)      <= adc_bus_1;--ch5;
                                        adc_data(191 downto 176)    <= adc_bus_2;--ch11;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1; 
                                
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                   
            when offset+60  =>  adc_clk_o <= '0'; 
                                cs_o <= b"1011_1011"; --ADC Module 2 and 6
                                fd_tim <= fd_tim + 1;
               
            when offset+68  =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(207 downto 192)    <= adc_bus_3;--ch12;
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(799 downto 784)    <= adc_bus_1;--ch49;
                                        adc_data(895 downto 880)    <= adc_bus_2;--ch55;
                                    when '1' =>
                                        adc_data(1167 downto 1152)  <= adc_bus_3;--ch72;
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(207 downto 192)    <= adc_bus_1;--ch12;
                                        adc_data(303 downto 288)    <= adc_bus_2;--ch18;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+70  =>  adc_clk_o <= '0'; 
                                fd_tim <= fd_tim + 1;
                                
            when offset+78  =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(815 downto 800)    <= adc_bus_1;--ch50;
                                        adc_data(911 downto 896)    <= adc_bus_2;--ch56;
                                    when '1' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(223 downto 208)    <= adc_bus_1;--ch13;
                                        adc_data(287 downto 272)    <= adc_bus_2;--ch17;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+80  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+88  =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(831 downto 816)    <= adc_bus_1;--ch51;
                                        adc_data(927 downto 912)    <= adc_bus_2;--ch57;
                                    when '1' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(239 downto 224)    <= adc_bus_1;--ch14;
                                        adc_data(335 downto 320)    <= adc_bus_2;--ch20;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+90  =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+98  =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(847 downto 832)    <= adc_bus_1;--ch52;
                                        adc_data(943 downto 928)    <= adc_bus_2;--ch58;
                                    when '1' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(255 downto 240)    <= adc_bus_1;--ch15;
                                        adc_data(351 downto 336)    <= adc_bus_2;--ch21;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+100 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+108 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(863 downto 848)    <= adc_bus_1;--ch53;
                                        adc_data(959 downto 944)    <= adc_bus_2;--ch59;
                                    when '1' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(271 downto 256)    <= adc_bus_1;--ch16;
                                        adc_data(367 downto 352)    <= adc_bus_2;--ch22;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+110 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+118 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(879 downto 864)    <= adc_bus_1;--ch54;
                                        adc_data(975 downto 960)    <= adc_bus_2;--ch60;
                                    when '1' =>
                                        --NOT USE                   <= adc_bus_3
                                        --NOT USE                   <= adc_bus_4
                                        adc_data(287 downto 272)    <= adc_bus_1;--ch17;
                                        adc_data(383 downto 368)    <= adc_bus_2;--ch23;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                    
            when offset+120 =>  adc_clk_o <= '0'; 
                                cs_o <= b"1101_1101";  --ADC Module 3 and 7
                                fd_tim <= fd_tim + 1;
            
            when offset+128 =>  adc_clk_o <= '1'; 
                                case sorting is
                                    when '0' =>
                                        adc_data(223 downto 208)    <= adc_bus_3;--ch13;
                                        adc_data(319 downto 304)    <= adc_bus_4;--ch19;
                                        adc_data(991 downto 976)    <= adc_bus_1;--ch61;
                                        adc_data(1087 downto 1072)  <= adc_bus_2;--ch67;
                                    when '1' =>
                                        adc_data(783 downto 768)    <= adc_bus_3;--ch48;
                                        adc_data(879 downto 864)    <= adc_bus_4;--ch54;
                                        adc_data(399 downto 384)    <= adc_bus_1;--ch24;
                                        adc_data(495 downto 480)    <= adc_bus_2;--ch30;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+130 =>  adc_clk_o <= '0'; 
                                fd_tim <= fd_tim + 1;
                                
            when offset+138 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(239 downto 224)    <= adc_bus_3;--ch14;
                                        adc_data(335 downto 320)    <= adc_bus_4;--ch20;
                                        adc_data(1007 downto 992)   <= adc_bus_1;--ch62;
                                        adc_data(1103 downto 1088)  <= adc_bus_2;--ch68;
                                    when '1' =>
                                        adc_data(799 downto 784)    <= adc_bus_3;--ch49;
                                        adc_data(895 downto 880)    <= adc_bus_4;--ch55;
                                        adc_data(415 downto 400)    <= adc_bus_1;--ch25;
                                        adc_data(511 downto 496)    <= adc_bus_2;--ch31;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+140 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+148 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(255 downto 240)    <= adc_bus_3;--ch15;
                                        adc_data(351 downto 336)    <= adc_bus_4;--ch21;
                                        adc_data(1023 downto 1008)  <= adc_bus_1;--ch63;
                                        adc_data(1119 downto 1104)  <= adc_bus_2;--ch69;
                                    when '1' =>
                                        adc_data(815 downto 800)    <= adc_bus_3;--ch50;
                                        adc_data(911 downto 896)    <= adc_bus_4;--ch56;
                                        adc_data(431 downto 416)    <= adc_bus_1;--ch26;
                                        adc_data(527 downto 512)    <= adc_bus_2;--ch32;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+150 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+158 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(271 downto 256)    <= adc_bus_3;--ch16;
                                        adc_data(367 downto 352)    <= adc_bus_4;--ch22;
                                        adc_data(1039 downto 1024)  <= adc_bus_1;--ch64;
                                        adc_data(1135 downto 1120)  <= adc_bus_2;--ch70;
                                    when '1' =>
                                        adc_data(831 downto 816)    <= adc_bus_3;--ch51;
                                        adc_data(927 downto 912)    <= adc_bus_4;--ch57;
                                        adc_data(447 downto 432)    <= adc_bus_1;--ch27;
                                        adc_data(543 downto 528)    <= adc_bus_2;--ch33;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+160 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+168 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(287 downto 272)    <= adc_bus_3;--ch17;
                                        adc_data(383 downto 368)    <= adc_bus_4;--ch23;
                                        adc_data(1055 downto 1040)  <= adc_bus_1;--ch65;
                                        adc_data(1151 downto 1136)  <= adc_bus_2;--ch71;
                                    when '1' =>
                                        adc_data(847 downto 832)    <= adc_bus_3;--ch52;
                                        adc_data(943 downto 928)    <= adc_bus_4;--ch58;
                                        adc_data(463 downto 448)    <= adc_bus_1;--ch28;
                                        adc_data(559 downto 544)    <= adc_bus_2;--ch34;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+170 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+178 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(303 downto 288)    <= adc_bus_3;--ch18;
                                        adc_data(399 downto 384)    <= adc_bus_4;--ch24;
                                        adc_data(1071 downto 1056)  <= adc_bus_1;--ch66;
                                        adc_data(1167 downto 1152)  <= adc_bus_2;--ch72;
                                    when '1' =>
                                        adc_data(863 downto 848)    <= adc_bus_3;--ch53;
                                        adc_data(959 downto 944)    <= adc_bus_4;--ch59;
                                        adc_data(479 downto 464)    <= adc_bus_1;--ch29;
                                        adc_data(575 downto 560)    <= adc_bus_2;--ch35;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
            
            
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                    
            when offset+180 =>  adc_clk_o <= '0'; 
                                cs_o <= b"1110_1110";  --ADC Module 4 and 8
                                fd_tim <= fd_tim + 1;
            
            when offset+188 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(415 downto 400)    <= adc_bus_3;--ch25;
                                        adc_data(511 downto 496)    <= adc_bus_4;--ch31;
                                        adc_data(1183 downto 1168)  <= adc_bus_1;--ch73;
                                        adc_data(1279 downto 1264)  <= adc_bus_2;--ch79;
                                    when '1' =>
                                        adc_data(975 downto 960)    <= adc_bus_3;--ch60;
                                        adc_data(1071 downto 1056)  <= adc_bus_4;--ch66;
                                        adc_data(591 downto 576)    <= adc_bus_1;--ch36;
                                        adc_data(687 downto 672)    <= adc_bus_2;--ch42;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+190 =>  adc_clk_o <= '0'; 
                                fd_tim <= fd_tim + 1;
                                
            when offset+198 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(431 downto 416)    <= adc_bus_3;--ch26;
                                        adc_data(527 downto 512)    <= adc_bus_4;--ch32;
                                        adc_data(1199 downto 1184)  <= adc_bus_1;--ch74;
                                        adc_data(1295 downto 1280)  <= adc_bus_2;--ch80;
                                    when '1' =>
                                        adc_data(991 downto 976)    <= adc_bus_3;--ch61;
                                        adc_data(1087 downto 1072)  <= adc_bus_4;--ch67;
                                        adc_data(607 downto 592)    <= adc_bus_1;--ch37;
                                        adc_data(703 downto 688)    <= adc_bus_2;--ch43;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+200 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+208 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(447 downto 432)    <= adc_bus_3;--ch27;
                                        adc_data(543 downto 528)    <= adc_bus_4;--ch33;
                                        adc_data(1215 downto 1200)  <= adc_bus_1;--ch75;
                                        adc_data(1311 downto 1296)  <= adc_bus_2;--ch81;
                                    when '1' =>
                                        adc_data(1007 downto 992)   <= adc_bus_3;--ch62;
                                        adc_data(1103 downto 1088)  <= adc_bus_4;--ch68;
                                        adc_data(623 downto 608)    <= adc_bus_1;--ch38;
                                        adc_data(719 downto 704)    <= adc_bus_2;--ch44;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+210 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+218 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(463 downto 448)    <= adc_bus_3;--ch28;
                                        adc_data(559 downto 544)    <= adc_bus_4;--ch34;
                                        adc_data(1231 downto 1216)  <= adc_bus_1;--ch76;
                                        adc_data(1327 downto 1312)  <= adc_bus_2;--ch82;
                                    when '1' =>
                                        adc_data(1023 downto 1008)  <= adc_bus_3;--ch63;
                                        adc_data(1119 downto 1104)  <= adc_bus_4;--ch69;
                                        adc_data(639 downto 624)    <= adc_bus_1;--ch39;
                                        adc_data(735 downto 720)    <= adc_bus_2;--ch45;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+220 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+228 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(479 downto 464)    <= adc_bus_3;--ch29;
                                        adc_data(575 downto 560)    <= adc_bus_4;--ch35;
                                        adc_data(1247 downto 1232)  <= adc_bus_1;--ch77;
                                        adc_data(1343 downto 1328)  <= adc_bus_2;--ch83;
                                    when '1' =>
                                        adc_data(1039 downto 1024)  <= adc_bus_3;--ch64;
                                        adc_data(1135 downto 1120)  <= adc_bus_4;--ch70;
                                        adc_data(655 downto 640)    <= adc_bus_1;--ch40;
                                        adc_data(751 downto 736)    <= adc_bus_2;--ch46;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
                                
            when offset+230 =>  adc_clk_o <= '0';
                                fd_tim <= fd_tim + 1;
                                
            when offset+238 =>  adc_clk_o <= '1';
                                case sorting is
                                    when '0' =>
                                        adc_data(495 downto 480)    <= adc_bus_3;--ch30;
                                        adc_data(591 downto 576)    <= adc_bus_4;--ch36;
                                        adc_data(1263 downto 1248)  <= adc_bus_1;--ch78;
                                        adc_data(1359 downto 1344)  <= adc_bus_2;--ch84;
                                    when '1' =>
                                        adc_data(1055 downto 1040)  <= adc_bus_3;--ch65;
                                        adc_data(1151 downto 1136)  <= adc_bus_4;--ch71;
                                        adc_data(671 downto 656)    <= adc_bus_1;--ch41;
                                        adc_data(751 downto 736)    <= adc_bus_2;--ch46;
                                    when others => null;
                                end case;
                                fd_tim <= fd_tim + 1;
            
            
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            when offset+250 =>  adc_ok    <= '1';
                                fd_tim    <= fd_tim + 1;
                                
            when offset+251 =>  adc_ok <= '0'; 
                                adc_fd_o <= '0';
                                cs_o <= b"1111_1111"; 
                                fd_tim <= fd_tim + 1; 
                                
            when 624        =>  fd_tim <= 0;
            
            when others     =>  fd_tim <= fd_tim + 1;
            
        end case;

      end if;
    end process adc_proto;
end Behavioral;
