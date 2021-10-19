----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 11:59:29 AM
-- Design Name: 
-- Module Name: ad9850 - Behavioral
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

entity ad9850 is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           apo_comm_en  : in  STD_LOGIC;
           freq         : in  STD_LOGIC_VECTOR (31 downto 0);
           
           dds_d0       : out STD_LOGIC := '1';
           dds_d1       : out STD_LOGIC := '1';
           dds_d2       : out STD_LOGIC := '0';
           dds_rst      : out STD_LOGIC := '0';
           dds_mclk     : out STD_LOGIC := '0';
           dds_sclk     : out STD_LOGIC := '0';
           dds_upd      : out STD_LOGIC := '0';
           dds_sdata    : out STD_LOGIC := '0');
                   
end ad9850;

architecture Behavioral of ad9850 is
    constant max_count  : natural   := 125;
    signal sclk_t       : std_logic :='0';
    signal mclk_t       : std_logic :='0';
    signal clkw         : std_logic :='0';
    signal dds_st       : integer range 0 to 15 := 0;
    signal set_apo      : std_logic := '0';
    signal get_apo      : std_logic := '0';
    signal dds_word     : std_logic_vector(39 downto 0) := (others => '0');
    signal delay_cnt    : integer range 0 to 10 := 0;
    signal bit_no       : integer range 0 to 39 := 0;
    
begin

    --Assign 
    dds_mclk <= mclk_t;
    dds_sclk <= clkw;
    dds_d0   <= '1';
    dds_d1   <= '1';
    dds_d2   <= '0';
    
    
    ----------------------------------------------------------------------------------------------------------------------
    --CLOCK DIV 5
    clock_div4 : process(clk)
        variable count : natural range 0 to 5;
    begin
        if rising_edge(clk) then
            
            case count is           
                when 4 => 
                    count := 0; mclk_t <= not mclk_t; 
                when others => 
                    count := count + 1;
            end case;
        end if;
    end process clock_div4;
    
    
    ----------------------------------------------------------------------------------------------------------------------
    --CLOCK DIV 125
    clock_div : process(clk)
        variable count : natural range 0 to max_count;
    begin
        if rising_edge(clk) then
            case count is           
                when 62 => 
                    count := 0; sclk_t <= not sclk_t; 
                when others => 
                    count := count + 1;
            end case;
        end if;
    end process clock_div;

    
    --------------------------------------------------------------------------------------------------------------------
    apo_comb: process (apo_comm_en, get_apo) begin 
        if (apo_comm_en = '1') then
            set_apo <= '1';
        end if;
        
        if (get_apo = '1') then
            set_apo <= '0';
        end if;   
    end process apo_comb; 
    
    
    ----------------------------------------------------------------------------------------------------------------------
    --DDS
    dds : process(sclk_t)
    begin
        if rising_edge(sclk_t) then
        
            if(set_apo = '1') then
                get_apo  <= '1';
                dds_word <= X"00" & freq;
            else
                get_apo <= '0';
            end if;
        
        
            case dds_st is
                when 0 =>
                    if(get_apo = '1') then
                        dds_st  <= dds_st + 1;
                        dds_rst <= '0';
                        dds_upd <= '0';
                        clkw    <= '0';
                        bit_no  <= 0;
                    end if;
                
                when 1 =>    
                    dds_rst <= '1';
                    if(delay_cnt <= 10) then
                        delay_cnt <= delay_cnt + 1;
                    else
                        delay_cnt <= 0;
                        dds_st    <= dds_st + 1;
                    end if;
                    
                when 2 =>
                    dds_rst <= '0';
                    dds_st  <= dds_st + 1;
                    
                when 3 =>
                    clkw   <= '1';
                    dds_st <= dds_st + 1;
                    
                when 4 =>
                    clkw   <= '0';
                    dds_st <= dds_st + 1;
               
                when 5 =>
                    dds_upd <= '1';
                    if(delay_cnt <= 10) then
                        delay_cnt <= delay_cnt + 1;
                    else
                        delay_cnt <= 0;
                        dds_st    <= dds_st + 1;
                    end if;
                
                when 6 =>
                    dds_upd <= '0';
                    dds_st  <= dds_st + 1;
                    
                when 7 =>
                    dds_sdata <= dds_word(bit_no);
                    dds_st    <= dds_st + 1;
                
                when 8 =>
                    clkw   <= '1';
                    dds_st <= dds_st + 1;
                    
                when 9 =>
                    clkw <= '0';
                    if(bit_no < 39) then
                        dds_st <= 7;
                        bit_no <= bit_no + 1;
                    else
                        dds_st <= 10;
                        bit_no <= 0;
                    end if;
                
                when 10 =>
                    dds_upd  <= '1';
                    if(delay_cnt<=10) then
                        delay_cnt <= delay_cnt + 1;
                    else
                        dds_st <= dds_st + 1;
                        delay_cnt <= 0;
                    end if;
                    
                when 11 =>
                    dds_upd <= '0';
                    dds_st  <= 0;
                    
                when others => null;
            end case;
        end if;
    end process dds;

end Behavioral;
