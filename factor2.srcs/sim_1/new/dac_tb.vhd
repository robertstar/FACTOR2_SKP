----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 08:34:21 AM
-- Design Name: 
-- Module Name: dac_tb - Behavioral
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

entity dac_tb is
end dac_tb;

architecture behavior of dac_tb is
    
    COMPONENT dac
    PORT(
            clk          : in  STD_LOGIC;
            
            varu_wr_clk  : in  STD_LOGIC;
            varu_wr_en   : in  STD_LOGIC;
            varu_wr_data : in  STD_LOGIC_VECTOR (7 downto 0);
            varu_wr_addr : in  STD_LOGIC_VECTOR (9 downto 0); 
            
            state        : in  STD_LOGIC_VECTOR (7 downto 0);
            envelope     : in  STD_LOGIC;
            p_varu_cnt   : in  STD_LOGIC_VECTOR (31 downto 0);
            
            dac_sync     : out STD_LOGIC;
            dac_sclk     : out STD_LOGIC;
            dac_sdata    : out STD_LOGIC
    );
    END COMPONENT;

    --Inputs 
    signal   varu_wr_clk     : std_logic := '0'; 
    constant varu_clk_period : time := 8 ns;
    
    signal   clk12M8         : std_logic := '0'; 
    constant clk12M8_period  : time := 78 ns;
    
    --DAC
    signal dac_wr            : std_logic :='0';
    signal dac_din           : std_logic_vector (7 downto 0) := (others => '0');
    signal dac_addr          : std_logic_vector (9 downto 0) := (others => '0');
    signal work_st           : std_logic_vector (7 downto 0) := (others => '0');
    signal p_varu_cnt        : std_logic_vector (31 downto 0):= (others => '0');
    
    signal envelope          : std_logic := '0'; 
    
    signal dac_sync          : std_logic := '0'; 
    signal dac_sclk          : std_logic := '0'; 
    signal dac_sdata         : std_logic := '0'; 
    
    signal i                 : integer range 0 to 1024 := 0;
    signal i2                : unsigned(7 downto 0) := X"A7";--to_unsigned(0, 8);

begin
    
    dac_inst: dac
    port map(   
        clk                 => clk12M8,
        
        varu_wr_clk         => varu_wr_clk,
        varu_wr_en          => dac_wr,
        varu_wr_data        => dac_din,
        varu_wr_addr        => dac_addr,
        
        state               => work_st,
        envelope            => envelope,
        p_varu_cnt          => p_varu_cnt,
        
        dac_sync            => dac_sync,
        dac_sclk            => dac_sclk,
        dac_sdata           => dac_sdata
    );



    clock_process :process
	begin
		varu_wr_clk <= '0';
		wait for varu_clk_period/2;
		varu_wr_clk <= '1';
		wait for varu_clk_period/2;
	end process;
	
	clk12M8_process :process
	begin
		clk12M8 <= '0';
		wait for clk12M8_period/2;
		clk12M8 <= '1';
		wait for clk12M8_period/2;
	end process;
	

    stim_proc: process
    begin
        wait for 80 ns;
        dac_wr   <= '1';
        work_st  <= X"31";
        envelope <= '0';
        dac_addr <= "0000000000";

        l_acc : for i in 0 to 1023 loop
                    
                    case i is
                        when 0      => dac_din <= X"A7"; --dac_addr <= dac_addr +1;
                        when 1      => dac_din <= X"A8"; dac_addr <= dac_addr +1;
                        when 2      => dac_din <= X"A9"; dac_addr <= dac_addr +1;
                        
                        when 1021   => dac_din <= X"B1"; dac_addr <= dac_addr +1;
                        when 1022   => dac_din <= X"C3"; dac_addr <= dac_addr +1;
                        when 1023   => dac_din <= X"D6"; dac_addr <= dac_addr +1;
                        
                        when others => dac_din <= X"00"; dac_addr <= dac_addr +1;
                    end case;
                    
                    --dac_din <= std_logic_vector(i2);
                    --i2 <= i2 -1;
                    --dac_addr <= dac_addr +1;
                    wait for 8 ns;
        end loop l_acc;
        dac_wr <= '0';
        
        wait for 8 ns;
        envelope <= '1';
        wait for 8 ns;
        envelope <= '0';
        
        
    
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
end;
