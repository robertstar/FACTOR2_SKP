------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 04/14/2021 11:02:17 AM
---- Design Name: 
---- Module Name: arbiter - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.math_real.all;


--entity arbiter is
--    Port ( clk          : in STD_LOGIC;
--           s1_din       : in STD_LOGIC_VECTOR (9 downto 0);
--           s1_dcount    : in STD_LOGIC_VECTOR (11 downto 0);
--           s1_rd        : out STD_LOGIC;
           
--           s2_din       : in STD_LOGIC_VECTOR (9 downto 0);
--           s2_dcount    : in STD_LOGIC_VECTOR (11 downto 0);
--           s2_rd        : out STD_LOGIC;
           
--           y_dout       : out STD_LOGIC_VECTOR (9 downto 0)
--           );
--end arbiter;

--architecture Behavioral of arbiter is

--    type   arb_state_t      is (IDLE, ST_S1, ST_S2, ST_IGP);
--    signal arb_state        : arb_state_t := IDLE;
--    signal next_arb_state   : arb_state_t := IDLE;
--    signal set_arb_state    : std_logic := '0';
    
--    signal s1_rd_t          : std_logic := '0';
--    signal s2_rd_t          : std_logic := '0';
--    signal y_dout_t         : STD_LOGIC_VECTOR (9 downto 0) := (others => '0'); 
    
--    type   count_mode_type  is (RST, INCR, HOLD);
--    signal arb_count_mode   : count_mode_type := RST;  
--    signal arb_count        : unsigned (4 downto 0) := to_unsigned(0, 5);  
    
--    signal s1_cnt           : unsigned (11 downto 0) := to_unsigned(0, 12);
--    signal s2_cnt           : unsigned (11 downto 0) := to_unsigned(0, 12);
      
--begin

--    ---------------------------------------------------------------------------------------
--    --assign
--    s1_rd   <= s1_rd_t;
--    s2_rd   <= s2_rd_t;
--    y_dout  <= y_dout_t;
    

--    ---------------------------------------------------------------------------------------
----    arb_combinatorial : process (
----        s1_din, s1_dcount,
----        s2_din, s2_dcount,
        
----        -- control signals
----        next_arb_state, set_arb_state, arb_count_mode, arb_count,
----        s1_cnt, s2_cnt
----        --s1_rd_t, s2_rd_t, y_dout_t
 
----    )begin
----        -- Set signal defaults
----        next_arb_state  <= IDLE;
------        arb_count_mode  <= HOLD;
----        set_arb_state   <= '0';
------        s1_rd_t         <= '0';
------        s2_rd_t         <= '0';
------        y_dout_t        <= (others => '0'); 

----        s1_cnt <= unsigned(s1_dcount);
----        s2_cnt <= unsigned(s2_dcount);
        
----        -- ARB FSM
----        case arb_state is
----            when IDLE =>
----                arb_count_mode  <= RST;
----                s1_rd_t         <= '0';
----                s2_rd_t         <= '0';
----                y_dout_t        <= (others => '0'); 
                
----                if    ( to_integer(s1_cnt) >= 64  ) then
----                    s1_rd_t        <= '1';
----                    set_arb_state  <= '1';
----                    next_arb_state <= ST_S1;
----                elsif ( to_integer(s2_cnt) >= 1444  ) then --50 + 1390 + 4
----                    s2_rd_t        <= '1';
----                    set_arb_state  <= '1';
----                    next_arb_state <= ST_S2;
----                end if;
            
----            when ST_S1 => 
----                y_dout_t <=s1_din;
----                if( (s1_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s1_cnt) = 0) ) then 
----                    set_arb_state  <= '1';
----                    next_arb_state <= ST_IGP;
----                end if;
            
----            when ST_S2 =>
----                y_dout_t <=s2_din;
----                if( (s2_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s2_cnt) = 0) ) then 
----                    set_arb_state  <= '1';
----                    next_arb_state <= ST_IGP;
----                end if; 
            
----            when ST_IGP => 
----                s1_rd_t  <='0';
----                s2_rd_t  <='0';
----                y_dout_t <=(others => '0'); 
----                if (to_integer(arb_count) = 15) then              
----                      arb_count_mode <= RST;
----                      next_arb_state <= IDLE;
----                      set_arb_state  <= '1';
----                else
----                      arb_count_mode <= INCR;
----                end if;
                
----            when others => NULL;
----        end case;
    
    
----    end process arb_combinatorial;
    
    
    
    
--    ---------------------------------------------------------------------------------------
--    arb_sequential : process (clk)
--    begin
--      if rising_edge(clk) then
        
----        if (set_arb_state = '1') then
----            arb_state <= next_arb_state;
----        else
----            arb_state <= arb_state;
----        end if;
        
--        case arb_count_mode is
--            when RST     => arb_count <= to_unsigned(0, 5);
--            when INCR    => arb_count <= arb_count + 1;
--            when HOLD    => arb_count <= arb_count;
--            when others  => NULL;
--        end case;


--       --ARB FSM
--        case arb_state is
--            when IDLE =>
--                arb_count_mode  <= RST;
--                s1_rd_t         <= '0';
--                s2_rd_t         <= '0';
--                y_dout_t        <= (others => '0'); 
                
--                if    ( to_integer(s1_cnt) >= 64  ) then
--                    s1_rd_t     <= '1';
--                    arb_state   <= ST_S1;
--                elsif ( to_integer(s2_cnt) >= 1444  ) then --50 + 1390 + 4
--                    s2_rd_t     <= '1';
--                    arb_state   <= ST_S2;
--                end if;
            
--            when ST_S1 => 
--                y_dout_t <=s1_din;
--                if( (s1_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s1_cnt) = 0) ) then 
--                    arb_state   <= ST_IGP;
--                end if;
            
--            when ST_S2 =>
--                y_dout_t <=s2_din;
--                if( (s2_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s2_cnt) = 0) ) then 
--                    arb_state   <= ST_IGP;
--                end if; 
            
--            when ST_IGP => 
--                s1_rd_t  <='0';
--                s2_rd_t  <='0';
--                y_dout_t <=(others => '0'); 
--                if (to_integer(arb_count) = 15) then              
--                      arb_count_mode <= RST;
--                      arb_state <= IDLE;
--                else
--                      arb_count_mode <= INCR;
--                end if;
                
--            when others => NULL;
--        end case;
        
        
            
--      end if;
--    end process arb_sequential;


--end Behavioral;















library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity arbiter is
    Port ( 
           clk          : in STD_LOGIC;
           s1_din       : in STD_LOGIC_VECTOR (9 downto 0);
           s1_dcount    : in STD_LOGIC_VECTOR (11 downto 0);
           s1_rd        : out STD_LOGIC;
           
           s2_din       : in STD_LOGIC_VECTOR (9 downto 0);
           s2_dcount    : in STD_LOGIC_VECTOR (11 downto 0);
           s2_rd        : out STD_LOGIC;
           
           s3_din       : in STD_LOGIC_VECTOR (9 downto 0);
           s3_dcount    : in STD_LOGIC_VECTOR (11 downto 0);
           s3_rd        : out STD_LOGIC;
           
           s4_din       : in STD_LOGIC_VECTOR (9 downto 0);
           s4_dcount    : in STD_LOGIC_VECTOR (11 downto 0);
           s4_rd        : out STD_LOGIC;
           
           y_dout       : out STD_LOGIC_VECTOR (9 downto 0)
           );
end arbiter;

architecture Behavioral of arbiter is

    type   arb_state_t      is (IDLE, ST_S1, ST_S2, ST_S3, ST_S4, ST_IGP);
    signal arb_state        : arb_state_t := IDLE;
    signal next_arb_state   : arb_state_t := IDLE;
    signal set_arb_state    : std_logic := '0';
    
    signal s1_rd_t          : std_logic := '0';
    signal s2_rd_t          : std_logic := '0';
    signal s3_rd_t          : std_logic := '0';
    signal s4_rd_t          : std_logic := '0';
    signal y_dout_t         : STD_LOGIC_VECTOR (9 downto 0) := (others => '0'); 
    
    type   count_mode_type  is (RST, INCR, HOLD);
    signal arb_count_mode   : count_mode_type := RST;  
    signal arb_count        : unsigned (4 downto 0) := to_unsigned(0, 5);  
    
    signal s1_cnt           : unsigned (11 downto 0) := to_unsigned(0, 12);
    signal s2_cnt           : unsigned (11 downto 0) := to_unsigned(0, 12);
    signal s3_cnt           : unsigned (11 downto 0) := to_unsigned(0, 12);
    signal s4_cnt           : unsigned (11 downto 0) := to_unsigned(0, 12);
      
begin

    ---------------------------------------------------------------------------------------
    --assign
    s1_rd   <= s1_rd_t;
    s2_rd   <= s2_rd_t;
    s3_rd   <= s3_rd_t;
    s4_rd   <= s4_rd_t;
    y_dout  <= y_dout_t;
    
    s1_cnt <= unsigned(s1_dcount);
    s2_cnt <= unsigned(s2_dcount);
    s3_cnt <= unsigned(s3_dcount);
    s4_cnt <= unsigned(s4_dcount);
    
    ---------------------------------------------------------------------------------------
    arb_sequential : process (clk)
    begin
      if rising_edge(clk) then
        

        -- ARB FSM
        case arb_state is
            when IDLE =>
                --arb_count_mode  <= RST;
                s1_rd_t         <= '0';
                s2_rd_t         <= '0';
                s3_rd_t         <= '0';
                s4_rd_t         <= '0';
                y_dout_t        <= (others => '0'); 
                
                --ARP
                if    ( to_integer(s1_cnt) >= 72  ) then
                    s1_rd_t   <= '1';
                    arb_state <= ST_S1;
                
                --25700    
                elsif ( to_integer(s2_cnt) >= 1444  ) then --50 + 1390 + 4
                    s2_rd_t   <= '1';
                    arb_state <= ST_S2;
                
                --26100
                elsif ( to_integer(s3_cnt) >= 168  ) then --50 + 1390 + 4
                    s3_rd_t   <= '1';
                    arb_state <= ST_S3;  
                
                --26010    
                elsif ( to_integer(s4_cnt) >= 168  ) then --50 + 1390 + 4
                    s4_rd_t   <= '1';
                    arb_state <= ST_S4;  
                       
                end if;
            
            
            
            when ST_S1 => 
                y_dout_t <=s1_din;
                if( (s1_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s1_cnt) = 0) ) then 
                    arb_state <= ST_IGP;
                end if;
            
            when ST_S2 =>
                y_dout_t <=s2_din;
                if( (s2_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s2_cnt) = 0) ) then 
                    arb_state <= ST_IGP;
                end if; 
                
            when ST_S3 =>
                y_dout_t <=s3_din;
                if( (s3_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s3_cnt) = 0) ) then 
                    arb_state <= ST_IGP;
                end if;     
                
            when ST_S4 =>
                y_dout_t <=s4_din;
                if( (s4_din(9) = '0'  and  y_dout_t(9) ='1') or (to_integer(s4_cnt) = 0) ) then 
                    arb_state <= ST_IGP;
                end if;     
            
            when ST_IGP => 
                s1_rd_t  <='0';
                s2_rd_t  <='0';
                s3_rd_t  <='0';
                s4_rd_t  <='0';
                y_dout_t <=(others => '0'); 
                
                if (to_integer(arb_count) = 15) then              
                      arb_state <= IDLE;
                      arb_count <= to_unsigned(0, 5);
                else
                      arb_count <= arb_count + 1;
                end if;
                
            when others => NULL;
        end case;    
 
      end if;
    end process arb_sequential;


end Behavioral;

