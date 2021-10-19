----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 08:36:32 AM
-- Design Name: 
-- Module Name: adc_module_tb - Behavioral
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

entity adc_module_tb is
end adc_module_tb;

architecture behavior of adc_module_tb is
    
    COMPONENT adc_module
    PORT(
 
           clk          : in STD_LOGIC;
    
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
           adc_data     : out STD_LOGIC_VECTOR (1359 downto 0)

    );
    END COMPONENT;

--Inputs 
signal clock            : std_logic := '0';

signal in_s1            : std_logic_vector(9 downto  0) := (others => '0');     
signal in_s1_dcount     : std_logic_vector(11 downto 0) := (others => '0');    
signal s1_rd            : std_logic;

signal in_s2            : std_logic_vector(9 downto  0) := (others => '0');     
signal in_s2_dcount     : std_logic_vector(11 downto 0) := (others => '0');    
signal s2_rd            : std_logic;

signal y_dout           : std_logic_vector(9 downto 0);
signal st_dbg           : std_logic_vector(3 downto 0);


signal adc_bus_1        : std_logic_vector(15 downto  0) := (others => '0'); 
signal adc_bus_2        : std_logic_vector(15 downto  0) := (others => '0'); 
signal adc_bus_3        : std_logic_vector(15 downto  0) := (others => '0'); 
signal adc_bus_4        : std_logic_vector(15 downto  0) := (others => '0'); 

signal adc_rst          : std_logic;
signal adc_conv         : std_logic;
signal adc_rd12         : std_logic;
signal adc_rd34         : std_logic;
signal adc_cs           : std_logic_vector(7 downto  0);
signal adc_done         : std_logic;
signal adc_data         : std_logic_vector(1359 downto 0);

    
constant clock_period   : time := 20 ns;

begin
    
    adc_module_inst: adc_module 
    port map 
    (
        clk          => clock,

        adc_bus_1    => adc_bus_1,
        adc_bus_2    => adc_bus_2,
        adc_bus_3    => adc_bus_3,
        adc_bus_4    => adc_bus_4,

        adc_rst      => adc_rst,
        adc_conv     => adc_conv,
        
        adc_rd12     => adc_rd12,
        adc_rd34     => adc_rd34,
        adc_cs       => adc_cs,

        adc_done     => adc_done,
        adc_data     => adc_data
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
	   wait for 500000 ns;
       report "testbench finished";
       wait;
    end process;
end;

