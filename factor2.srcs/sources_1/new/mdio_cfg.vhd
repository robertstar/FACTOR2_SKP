----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2021 07:58:15 AM
-- Design Name: 
-- Module Name: mdio_cfg - Behavioral
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

entity mdio_cfg is
Port ( 
        clk         : in STD_LOGIC;
        mdc         : out STD_LOGIC;
        mdio        : inout STD_LOGIC;
        done        : out STD_LOGIC;
        eth_rst_n   : out STD_LOGIC
);
end mdio_cfg;

architecture Behavioral of mdio_cfg is
    type t_State is (ST_IDLE, ST_READING, ST_WRITING);
    signal State : t_State;
    
    type  t2_State is (ST_0, ST_1, ST_2, ST_3, ST_4, ST_5, ST_6, ST_7, ST_8, ST_9, ST_10, ST_11, ST_12, ST_13, ST_14, ST_15, ST_16, ST_17, ST_18, ST_19);
    signal State_cfg    : t2_State;
    
    constant max_count  : natural := 100;
    signal phy_clk      : std_logic := '0';
    
    signal init_ok      : std_logic := '0';
    
    signal addr         : std_logic_vector(4 downto 0)  := (others => '0'); 
    --signal addr : integer range 0 to 63 := 0;
    
    signal rd_request   : std_logic := '0';
    signal wr_request   : std_logic := '0';
    signal ready        : std_logic := '0';
    signal wr_data      : std_logic_vector(15 downto 0) := (others => '0'); 
    signal rd_data      : std_logic_vector(15 downto 0) := (others => '0');  
    
    signal wr_bits      : std_logic_vector(63 downto 0) := X"FFFFFFFF" & b"010100000" & addr & b"10" & wr_data; 
    signal rd_bits      : std_logic_vector(63 downto 0) := X"FFFFFFFF" & b"011000000" & addr & "XX"  & X"FFFF"; 
    
    signal mdio_high_z  : std_logic := '0';
    signal bit_no       : integer range 0 to 63   := 0;
    signal PHY_DELAY    : integer range 0 to 9999 := 0;
    
    signal PHY_REG0     : std_logic_vector(15 downto 0) := (others => '0'); 
    signal PHY_REG22    : std_logic_vector(15 downto 0) := (others => '0'); 
    signal PHY_REG27    : std_logic_vector(15 downto 0) := (others => '0');
    
    signal rst_n        : std_logic := '1';
    signal sel          : integer range 0 to 255 := 0;
    signal rst_st       : integer range 0 to 5   := 0;
    
begin

    ----------------------------------------------------------------------------------------------------------------------
    --CLOCK DIV 100
    clock_div : process(clk)
        variable count : natural range 0 to max_count;
    begin
        if rising_edge(clk) then
            if count < max_count/2 then
                count := count + 1;
                phy_clk <= '1';
            elsif count < max_count then
                phy_clk <= '0';
                count := count + 1;
            else
                phy_clk <= '1';
                count := 0;
            end if;
    
        end if;
    end process clock_div;
    
    
    ----------------------------------------------------------------------------------------------------------------------
    --PHY Reset process
    phy_rst : process(clk)
        variable phy_cnt : natural range 0 to 5000000; --0.5 seconds
    begin
        if rising_edge(clk) then
            case rst_st is
                when 0 =>
                    if(phy_cnt >= 2500000) then
                        phy_cnt := 0;
                        rst_n <= '0';
                        rst_st <= rst_st + 1;
                    else
                        phy_cnt := phy_cnt +1;
                        rst_n <= '1';
                    end if;
                    
                when 1 =>
                    if(phy_cnt >= 2500000) then
                        phy_cnt := 0;
                        rst_n <= '1';
                        rst_st <= rst_st + 1;
                    else
                        phy_cnt := phy_cnt +1;
                    end if;
                    
                when 2 => --IDLE
                    rst_n <= '1';
                    
                when others => null;
            end case;    
        end if;
    end process phy_rst;
    
    
    ----------------------------------------------------------------------------------------------------------------------
    --PHY_MDIO
    phy_mdio : process(phy_clk)
    begin
        if falling_edge(phy_clk) then
            case State is
                when ST_IDLE    =>
                    mdio_high_z <= '0';
                    bit_no      <= 63; 
                    if (rd_request = '1') then
                        State <= ST_READING;
                    elsif (wr_request = '1') then 
                        State <= ST_WRITING;
                    end if;
      
                when ST_READING =>
                    rd_data <= rd_data(14 downto 0) & mdio;
                    bit_no  <= bit_no - 1;
                    if (bit_no = 18) then
                        mdio_high_z <= '1';
                    end if;
                    
                    if (bit_no = 1) then
                        State <= ST_IDLE;
                    end if;

                when ST_WRITING =>
                    bit_no  <= bit_no - 1;
                    if (bit_no = 0) then
                        State <= ST_IDLE;
                    end if;
                
                when others => null;
            end case;
        end if;
    end process phy_mdio;
    
    
    ----------------------------------------------------------------------------------------------------------------------
    --PHY_CFG
    phy_cfg : process(phy_clk)
    begin
        if rising_edge(phy_clk) then
            case State_cfg is
                when ST_0 =>
                    if (ready = '1' and rst_st = 2) then
                        State_cfg <= ST_1;
                    end if;
                
                --WRITE to REG 20: TX Enable    
                when ST_1 =>
                    addr       <= std_logic_vector(to_unsigned(20, addr'length));
                    wr_data    <= X"0C71";
                    wr_request <= '1';
                    State_cfg  <= ST_2;
                
                --End Write    
                when ST_2 =>
                    wr_request <= '0';
                    if (ready = '1') then
                        --Config fiber interface
                        State_cfg <= ST_3; 
                        
                        --Config cupper interface
                        --State_cfg <= ST_2; --IDLE
                        --init_ok   <= '1';
                    end if;
                
                --READ REG 27    
                when ST_3 =>
                    addr       <= std_logic_vector(to_unsigned(27, addr'length));
                    rd_request <= '1';
                    State_cfg  <= ST_4; 
                    
                --End Read   
                when ST_4 =>   
                    rd_request <= '0';
                    if (ready = '1') then
                        PHY_REG27 <= rd_data;
                        State_cfg <= ST_5;
                    end if;
                
                --WRITE to REG 27    
                when ST_5 => 
                    addr       <= std_logic_vector(to_unsigned(27, addr'length));
                    wr_data    <= PHY_REG27(15 downto 4) & b"0111";
                    wr_request <= '1';
                    State_cfg  <= ST_6;
                
                --End Write   
                when ST_6 =>   
                    wr_request <= '0';
                    if (ready = '1') then
                        State_cfg <= ST_7;
                    end if;
                
                --READ REG 0
                when ST_7 => 
                    addr       <= std_logic_vector(to_unsigned(0, addr'length));
                    rd_request <= '1';
                    State_cfg <= ST_8;
                    
                --End Read   
                when ST_8 =>   
                    rd_request <= '0';
                    if (ready = '1') then
                        PHY_REG0  <= rd_data;
                        State_cfg <= ST_9;
                    end if;
                    
                --WRITE to REG 0
                when ST_9 => 
                    addr       <= std_logic_vector(to_unsigned(0, addr'length));
                    wr_data    <= '1' & PHY_REG0(14 downto 0); --Soft Reset
                    wr_request <= '1';
                    State_cfg  <= ST_10;
                    
                --End Write
                when ST_10 =>   
                    wr_request <= '0';
                    if (ready = '1') then
                        PHY_DELAY  <= PHY_DELAY + 1;
                        if (PHY_DELAY = 9999) then
                            PHY_DELAY <= 0;
                            State_cfg <= ST_11;
                        end if;
                    end if;
                
                --READ REG 22    
                when ST_11 => 
                    addr       <= std_logic_vector(to_unsigned(22, addr'length));
                    rd_request <= '1';
                    State_cfg <= ST_12; 
                    
                --End Read   
                when ST_12 =>   
                    rd_request <= '0';
                    if (ready = '1') then
                        PHY_REG22 <= rd_data;
                        State_cfg <= ST_13;
                    end if;   
                    
                --WRITE to REG 22
                when ST_13 => 
                    addr       <= std_logic_vector(to_unsigned(22, addr'length));
                    wr_data    <= PHY_REG22(15 downto 8) & b"00000001"; --Change to PAGE 1
                    wr_request <= '1';
                    State_cfg  <= ST_14; 
                    
                --End Write   
                when ST_14 =>   
                    wr_request <= '0';
                    if (ready = '1') then
                        State_cfg <= ST_15;
                    end if;  
                    
                --READ REG 0
                when ST_15 => 
                    addr       <= std_logic_vector(to_unsigned(0, addr'length));
                    rd_request <= '1';
                    State_cfg <= ST_16;
                    
                --End Read   
                when ST_16 =>   
                    rd_request <= '0';
                    if (ready = '1') then
                        PHY_REG0  <= rd_data;
                        State_cfg <= ST_17;
                    end if;
                    
                --WRITE to REG 0
                when ST_17 => 
                    addr       <= std_logic_vector(to_unsigned(0, addr'length));
                    wr_data    <= '1' & PHY_REG0(14 downto 0); --Soft Reset
                    wr_request <= '1';
                    State_cfg  <= ST_18;
                    
                --End Write
                when ST_18 =>   
                    wr_request <= '0';
                    if (ready = '1') then
                        PHY_DELAY  <= PHY_DELAY + 1;
                        if (PHY_DELAY = 9999) then
                            PHY_DELAY <= 0;
                            State_cfg <= ST_19;
                        end if;
                    end if;
                
                --IDLE2    
                when ST_19 => 
                    init_ok   <= '1';   
                    State_cfg <= ST_19;    
                
                when others => null;
                    
            end case;
        end if;
    end process phy_cfg;
    
    
---------------------------------------------------------------------------------------------------------------------- 
--assign   
mdc         <= phy_clk;
mdio        <= 'Z' when (mdio_high_z = '1') else rd_bits(bit_no) when (State = ST_READING) else wr_bits(bit_no);  
ready       <= '1' when (State = ST_IDLE) else '0';
done        <= init_ok;
eth_rst_n   <= rst_n;

end Behavioral;
