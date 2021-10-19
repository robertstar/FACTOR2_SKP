----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2021 11:00:51 AM
-- Design Name: 
-- Module Name: ad9850_par - Behavioral
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
use ieee.std_logic_arith.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ad9850_par is 
  port(  
        reset     : in    std_logic; 
        clk       : in    std_logic; 
        
        apo_comm_en  : in  std_logic;
        freq         : in  std_logic_vector (31 downto 0);
         
        --con_word1 : in    std_logic_vector(7 downto 0);--freq_b[31..24] 
        --con_word2 : in    std_logic_vector(7 downto 0);--freq_b[23..16] 
        --con_word3 : in    std_logic_vector(7 downto 0);--freq_b[15..8] 
        --con_word4 : in    std_logic_vector(7 downto 0);--freq_b[7..0] 
 
        --dds_mclk  : out   std_logic := '0';
        dds_reset : out   std_logic := '0';
        dds_updata: out   std_logic := '0';
        dds_clk   : out   std_logic := '0';
        dds_pdata : out   std_logic_vector(7 downto 0) := (others => '0')
      ); 
end ad9850_par; 
 
architecture behave of ad9850_par is 
    
    signal state        : integer range 0 to 8; 
    signal mclk_t       : std_logic :='0';
    signal set_apo      : std_logic := '0';
    signal get_apo      : std_logic := '0';
    
begin 
 
    --Assign 
    --dds_mclk <= mclk_t;
 
    ----------------------------------------------------------------------------------------------------------------------
    --CLOCK DIV 5
--    clock_div4 : process(clk)
--        variable count : natural range 0 to 5;
--    begin
--        if rising_edge(clk) then
            
--            case count is           
--                when 4 => 
--                    count := 0; mclk_t <= not mclk_t; 
--                when others => 
--                    count := count + 1;
--            end case;
--        end if;
--    end process clock_div4;
 
 
    --------------------------------------------------------------------------------------------------------------------
    apo_comb: process (apo_comm_en, get_apo) begin 
        if (apo_comm_en = '1') then
            set_apo <= '1';
        end if;
        
        if (get_apo = '1') then
            set_apo <= '0';
        end if;   
    end process apo_comb; 
 
 
process(reset,clk) 
  variable m: integer range 0 to 8191; 
  variable k: integer range 0 to 4; 
  variable yy:integer range 0 to 8191; 
begin 
  if (clk'event and clk='1') then 
    if reset='0' then 
       dds_updata<='0'; 
       dds_clk<='0'; 
       yy:=0; 
       dds_pdata<="00000000"; 
       dds_reset<='0'; 
       m:=0; 
       k:=0; 
       state<=0; 
    else 
    
        if(set_apo = '1') then
            get_apo  <= '1';
            --dds_word <= X"00" & freq;
        else
            get_apo <= '0';
        end if;
        
    
        case state is 
            when 0 =>
                if(get_apo = '1') then
                    state<=1;    
                end if;
                
            when 1 =>
                k:=0; 
                if yy=8190 then 
                   yy:=0;  
                   dds_reset<='0'; 
                   state<=2; 
                else 
                   dds_reset<='1'; 
                   yy:=yy+1; 
                   state<=1; 
                end if; 
                
            when 2 => 
                case k is 
                  when 0 =>
                    dds_pdata<="00101000"; 
                    state<=3; 
                  when 1 =>
                    dds_pdata<=freq(31 downto 24);--con_word1; 
                    state<=3; 
                  when 2 =>
                    dds_pdata<=freq(23 downto 16);--con_word2; 
                    state<=3; 
                  when 3=>
                    dds_pdata<=freq(15 downto 8);--con_word3; 
                    state<=3; 
                  when 4 =>
                    dds_pdata<=freq(7 downto 0);--con_word4; 
                    state<=3; 
                  when others=> null;
                end case; 
                
            when 3 =>
                dds_clk<='0'; 
                if m=800 then 
                  m:=0; 
                  state<=4; 
                else 
                  m:=m+1; 
                end if; 
                
            when 4 =>
                dds_clk<='1'; 
                if m=800 then 
                  m:=0; 
                  state<=5; 
                else 
                  m:=m+1; 
                end if; 
                
            when 5 =>
                dds_clk<='0'; 
                if m=10 then 
                  m:=0; 
                  state<=6; 
                else 
                  m:=m+1; 
                end if; 
                
            when 6 =>
                if k=4 then 
                    k:=0; 
                    state<=7; 
                else 
                    k:=k+1; 
                    state<=2; 
                end if; 
                   
           when 7 =>
                dds_updata<='1'; 
                if m=8190 then 
                  m:=0; 
                  state<=8;  
                else 
                  m:=m+1; 
                end if; 
                    
            when 8 =>
                dds_updata<='0'; 
                state<=0; 
                
            when others => null;   
              
     end case; 
 end if; 
 end if; 
end process; 


end behave; 
 

