----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 10:13:22 AM
-- Design Name: 
-- Module Name: dac - Behavioral
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

entity dac is
    Port ( clk          : in  STD_LOGIC;
    
           varu_wr_clk  : in  STD_LOGIC;
           varu_wr_en   : in  STD_LOGIC;
           varu_wr_data : in  STD_LOGIC_VECTOR (7 downto 0);
           varu_wr_addr : in  STD_LOGIC_VECTOR (9 downto 0); 
           
           state        : in  STD_LOGIC_VECTOR (7 downto 0);
           envelope     : in  STD_LOGIC;
           p_varu_cnt   : in  STD_LOGIC_VECTOR (31 downto 0);
           
           dac_sync     : out STD_LOGIC := '1';
           dac_sclk     : out STD_LOGIC := '0';
           dac_sdata    : out STD_LOGIC := '0');
end dac;

architecture Behavioral of dac is

    signal   clk_64Mhz          : std_logic :='0';
    signal   clk_6M4            : std_logic :='0';
    constant max_count          : natural   := 10;
    
    signal   wr_bits            : std_logic_vector(15 downto 0) := b"00_00" & X"FF" & b"0000"; 
    signal   sel                : integer range 0 to 31 := 31;
    signal   dac_fd             : std_logic :='0';
    
    signal   dac_sync_t         : std_logic :='1';
    --signal   dac_st             : std_logic_vector(1 downto 0) := b"00";
    --signal   dac_st2            : integer range 0 to 8 := 0; 
    
    signal   set_envelope       : std_logic :='0';
    signal   envelope_t         : std_logic :='0';
    
    signal   dac_div_cnt        : std_logic_vector(31 downto 0) := x"00_00_00_00";
    signal   dac_byte_cnt       : std_logic_vector(9  downto 0) := b"0000000000";
    
    signal   ram_varu_rd_addr   : std_logic_vector(9  downto 0) := b"0000000000";
    signal   ram_varu_rd_en     : std_logic :='0';
    signal   ram_varu_dout      : std_logic_vector(7  downto 0) := X"00";
    
    signal   dac_st2            : unsigned (1 downto 0) := to_unsigned(0, 2);
    
    
    --------------------------------------------------------------------------------------- 
    component single_port_ram
    generic(
        RAM_DATA_WIDTH  : integer; 
        RAM_DATA_LENGTH : integer;
        RAM_ADDR_WIDTH  : integer
    ); 
    port (
        RAM_WR_CLOCK    : in std_logic;                     -- Write clock 
        RAM_WR_EN       : in std_logic;                     -- Write enable 
        RAM_WR_ADDR     : in std_logic_vector(9 downto 0);  -- Address to write RAM
        RAM_WR_DATA     : in std_logic_vector(7 downto 0);  -- Data to write into RAM

        RAM_RD_EN       : in std_logic;                     -- Write enable 
        RAM_RD_ADDR     : in std_logic_vector(9 downto 0);  -- Address to read RAM
        RAM_RD_DATA     : out std_logic_vector(7 downto 0)  -- Data output of RAM
        );
    end component;
    
    
    ---------------------------------------------------------------------------------------
--    component ila_2 
--    port (
--        clk                 :in  std_logic;
--        probe0              :in  std_logic_vector (0  DOWNTO 0); --clk
--        probe1              :in  std_logic_vector (7  DOWNTO 0); --state
--        probe2              :in  std_logic_vector (1  DOWNTO 0); --dac_st 
--        probe3              :in  std_logic_vector (0  DOWNTO 0); --rd_en
--        probe4              :in  std_logic_vector (9  DOWNTO 0); --rd_addr
--        probe5              :in  std_logic_vector (9  DOWNTO 0); --byte_cnt
--        probe6              :in  std_logic_vector (7  DOWNTO 0);  --rd_data
        
--        probe7              :in  std_logic_vector (0  DOWNTO 0); 
--        probe8              :in  std_logic_vector (0  DOWNTO 0); 
--        probe9              :in  std_logic_vector (0  DOWNTO 0) 
--    );
--    end component;
                
begin

    --------------------------------------------------------------------------------------------------------
    --Assign 
    dac_sclk <= clk_6M4;
    
    
    --------------------------------------------------------------------------------------------------------
    mem_varu_inst: single_port_ram
    generic map(
        RAM_DATA_LENGTH => 1024,
        RAM_DATA_WIDTH  => 8,
        RAM_ADDR_WIDTH  => 10
    )
    port map(    
        RAM_WR_CLOCK    => varu_wr_clk,
        RAM_WR_EN       => varu_wr_en,
        RAM_WR_ADDR     => varu_wr_addr,
        RAM_WR_DATA     => varu_wr_data,
        
        RAM_RD_EN       => ram_varu_rd_en,
        RAM_RD_ADDR     => ram_varu_rd_addr,
        RAM_RD_DATA     => ram_varu_dout
    ); 
    
    --------------------------------------------------------------------------------------------------------
--    dac_dbg2: ila_2
--    port map(    
--        clk                 => clk,    
--        probe0(0)           => dac_fd,            
--        probe1              => state,   
--        probe2              => std_logic_vector(dac_st2),
--        probe3(0)           => ram_varu_rd_en,
--        probe4              => ram_varu_rd_addr,
--        probe5              => dac_byte_cnt,
--        probe6              => ram_varu_dout,
--        probe7(0)           => envelope,
--        probe8(0)           => set_envelope,
--        probe9(0)           => envelope_t
--    );
    
    --------------------------------------------------------------------------------------------------------
    --CLOCK DIV 2
    clock_div : process(clk)
        variable count : natural range 0 to max_count;
    begin
        if rising_edge(clk) then
            --Create clock from 12.821 Mhz
            clk_6M4 <= not clk_6M4;
        end if;
    end process clock_div;
    
    
    --------------------------------------------------------------------------------------------------------
    dac_comb: process (envelope, envelope_t) begin 
--        if (envelope = '1') then
--            set_envelope <= '1';
--        end if;
        
--        if (envelope_t = '1') then
--            set_envelope <= '0';
--        end if;  


        if (envelope = '1') then
            set_envelope <= '1';
        elsif (envelope_t = '1') then
            set_envelope <= '0';
        end if;

        
         
    end process; 
    
    
    --------------------------------------------------------------------------------------------------------
    --DAC write serial data
    dac_wr_bits : process(clk_6M4)
    begin
        if rising_edge(clk_6M4) then
            case sel is
                when 0 =>
                    sel<= 31;
            
                when 16 to 31 =>
                    dac_sync  <= '0';  
                    dac_fd    <= '1';
                    dac_sdata <= wr_bits(sel - 16);
                    sel       <= sel - 1;
                      
                when others =>
                    dac_sync  <= '1';
                    dac_fd    <= '0';
                    dac_sdata <= '0';
                    sel       <= sel - 1;  
            end case;
        end if;
    end process dac_wr_bits;
    
    
    --------------------------------------------------------------------------------------------------------
    --DAC control state FSM
    dac_ctrl : process(dac_fd)
    begin
        if falling_edge(dac_fd) then


            if(set_envelope = '1') then
                envelope_t   <= '1';
            else
                envelope_t   <= '0';
            end if;


            case state is
                when X"31" =>
                    
                    case to_integer(dac_st2) is

                        --------------------------------------------------------------------------------------------------------
                        --Wait Envelope
                        when 0 =>
                            if(envelope_t = '1') then
                                dac_byte_cnt <= b"0000000000";
                                dac_st2      <= to_unsigned(1, 2); 
                            --else
                                --wr_bits      <= b"00_00" & X"FF" & b"0000"; 
                                --envelope_t   <= '0'; 
                            end if;    
                            
                            
                            --if(set_envelope = '1') then
                                --envelope_t   <= '1';
                            --else
                                --wr_bits      <= b"00_00" & X"FF" & b"0000"; 
                                --envelope_t   <= '0';
                            --end if;
                            
                        --------------------------------------------------------------------------------------------------------
                        --Wait VARU Period    
                        when 1 =>
                            if(dac_div_cnt < p_varu_cnt) then
                                dac_div_cnt <= dac_div_cnt + 1;
                            else 
                                dac_div_cnt <= X"00_00_00_00";
                                case dac_byte_cnt is
                                    when b"0000000000" => 
                                        --dac_div_cnt      <= X"00_00_00_00";
                                        ram_varu_rd_addr <= b"0000000000";
                                        ram_varu_rd_en   <= '1';
                                        wr_bits          <= b"00_00" & ram_varu_dout & b"0000";    
                                        dac_byte_cnt     <= dac_byte_cnt+1;
                                    
                                    when b"1111111111" =>
                                        wr_bits          <= b"00_00" & ram_varu_dout & b"0000";   
                                        ram_varu_rd_addr <= ram_varu_rd_addr+1;
                                        dac_st2          <= to_unsigned(2, 2);  
                                     
                                    when others =>
                                        wr_bits          <= b"00_00" & ram_varu_dout & b"0000";  
                                        ram_varu_rd_addr <= ram_varu_rd_addr+1;
                                        dac_byte_cnt     <= dac_byte_cnt+1;
                                end case;
                            end if;
                            
                        --------------------------------------------------------------------------------------------------------
                        when 2 =>
                            dac_div_cnt      <= X"00_00_00_00";
                            dac_byte_cnt     <= b"0000000000";
                            ram_varu_rd_addr <= b"0000000000";
                            ram_varu_rd_en   <= '0';
                            if(envelope /= '1') then
                                dac_st2 <= to_unsigned(0, 2);  
                            end if;
                            
                        when others => null;
                        
                    end case;
                    
                --------------------------------------------------------------------------------------------------------
                when others => 
                    wr_bits <= b"00_00" & X"FF" & b"0000";  
            end case;  
        end if;
    end process dac_ctrl;

end Behavioral;
