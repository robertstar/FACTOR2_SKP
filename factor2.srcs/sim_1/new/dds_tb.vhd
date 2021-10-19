----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 08:34:21 AM
-- Design Name: 
-- Module Name: dds_tb - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity dds_tb is
end dds_tb;

architecture behavior of dds_tb is
    
--    component ad9850
--    port (
--        clk          : in  STD_LOGIC;
--        rst          : in  STD_LOGIC;
--        apo_comm_en  : in  STD_LOGIC;
--        freq         : in  STD_LOGIC_VECTOR (31 downto 0);
        
--        dds_rst      : out STD_LOGIC;
--        dds_mclk     : out STD_LOGIC;
--        dds_sclk     : out STD_LOGIC;
--        dds_upd      : out STD_LOGIC;
--        dds_sdata    : out STD_LOGIC
--    );
--    end component;


component ad9850_par
    port(  
        reset       : in  std_logic; 
        clk         : in  std_logic; 
        
        apo_comm_en : in  std_logic;
        freq        : in  std_logic_vector (31 downto 0);

        dds_mclk    : out std_logic := '0';
        dds_reset   : out std_logic; 
        dds_updata  : out std_logic; 
        dds_clk     : out std_logic; 
        dds_pdata   : out std_logic_vector(7 downto 0) 
    );
    end component;


--Inputs 
signal   clock           : std_logic := '0'; 
constant clock_period    : time := 20 ns;

--DAC
signal rx_apo_comm_en    : std_logic :='0';
signal freq              : std_logic_vector (31 downto 0) := X"00_00_86_38";  --32'h00008638;


signal reset             : std_logic := '0'; 
signal dds_rst           : std_logic := '0'; 
signal dds_mclk          : std_logic := '0'; 
signal dds_sclk          : std_logic := '0'; 
signal dds_upd           : std_logic := '0'; 
signal dds_sdata         : std_logic := '0'; 
signal dds_pdata         : std_logic_vector (7 downto 0);

begin
    
--    dds: ad9850
--    port map(   
--        clk                 => clock,
--        rst                 => '0',
        
--        apo_comm_en         => rx_apo_comm_en,
--        freq                => freq,
        
--        dds_rst             => dds_rst,
--        dds_mclk            => dds_mclk,
--        dds_sclk            => dds_sclk,
--        dds_upd             => dds_upd,
--        dds_sdata           => dds_sdata
--    );


    dds: ad9850_par
    port map(   
        reset       => reset,
        clk         => clock,
        
        apo_comm_en => rx_apo_comm_en,
        freq        => freq,

        dds_mclk    => dds_mclk,
        dds_reset   => dds_rst,
        dds_updata  => dds_upd,
        dds_clk     => dds_sclk,
        dds_pdata   => dds_pdata
    );



    clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;
	

    stim_proc: process
    begin
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



    reset <= '0';
    wait for 60 ns;
    reset <= '1';
    wait for 60 ns;
    reset <= '0';

 	wait for 200 ns;
 	rx_apo_comm_en <= '0';
 	wait for 20 ns;
	rx_apo_comm_en <= '1';
	wait for 20 ns;
	rx_apo_comm_en <= '0';
	
	wait for 5000000 ns;
        report "testbench finished";
        wait;
    end process;
end;
