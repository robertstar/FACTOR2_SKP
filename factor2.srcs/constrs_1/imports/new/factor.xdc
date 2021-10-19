set_property CFGBVS VCCO                        [current_design]
set_property CONFIG_VOLTAGE 3.3                 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4    [current_design]

set_property PACKAGE_PIN H21                    [get_ports sys_clk]
set_property IOSTANDARD  LVCMOS33               [get_ports sys_clk]

set_property PACKAGE_PIN V16                    [get_ports sys_led]
set_property IOSTANDARD  LVCMOS33               [get_ports sys_led]

set_property PACKAGE_PIN V14                    [get_ports led_HL4]
set_property IOSTANDARD  LVCMOS33               [get_ports led_HL4]


set_property PACKAGE_PIN T2                     [get_ports PHY_MDC]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_MDC]

set_property PACKAGE_PIN R2                     [get_ports PHY_MDIO]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_MDIO]



set_property PACKAGE_PIN U1                     [get_ports PHY_RESET_N]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RESET_N]

set_property PACKAGE_PIN P6                     [get_ports PHY_COMA]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_COMA]

set_property PACKAGE_PIN P4                     [get_ports PHY_TX_DISABLE]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TX_DISABLE]

set_property PACKAGE_PIN N2                     [get_ports PHY_GTXC]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_GTXC]
set_property SLEW FAST                          [get_ports PHY_GTXC]

set_property PACKAGE_PIN M5                     [get_ports PHY_RXC]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXC]

set_property PACKAGE_PIN N6                     [get_ports PHY_RXER]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXER]

set_property PACKAGE_PIN M6                     [get_ports PHY_RXDV]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXDV]

set_property PACKAGE_PIN N7                     [get_ports {PHY_RXD[0]}]
set_property PACKAGE_PIN K5                     [get_ports {PHY_RXD[1]}]
set_property PACKAGE_PIN L5                     [get_ports {PHY_RXD[2]}]
set_property PACKAGE_PIN L4                     [get_ports {PHY_RXD[3]}]
set_property PACKAGE_PIN M4                     [get_ports {PHY_RXD[4]}]
set_property PACKAGE_PIN L7                     [get_ports {PHY_RXD[5]}]
set_property PACKAGE_PIN M7                     [get_ports {PHY_RXD[6]}]
set_property PACKAGE_PIN J3                     [get_ports {PHY_RXD[7]}]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXD*]



set_property PACKAGE_PIN N3                     [get_ports PHY_TXC]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXC]

set_property PACKAGE_PIN L2                     [get_ports PHY_TXEN]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXEN]
set_property SLEW FAST                          [get_ports PHY_TXEN]

set_property PACKAGE_PIN M2                     [get_ports PHY_TXER]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXER]

set_property PACKAGE_PIN H1                     [get_ports {PHY_TXD[0]}]
set_property PACKAGE_PIN H2                     [get_ports {PHY_TXD[1]}]
set_property PACKAGE_PIN M1                     [get_ports {PHY_TXD[2]}]
set_property PACKAGE_PIN N1                     [get_ports {PHY_TXD[3]}]
set_property PACKAGE_PIN K2                     [get_ports {PHY_TXD[4]}]
set_property PACKAGE_PIN L3                     [get_ports {PHY_TXD[5]}]
set_property PACKAGE_PIN J1                     [get_ports {PHY_TXD[6]}]
set_property PACKAGE_PIN K1                     [get_ports {PHY_TXD[7]}]
set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXD*]
set_property SLEW FAST                          [get_ports PHY_TXD*]

#ADC
set_property PACKAGE_PIN W23                    [get_ports adc_rst]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_rst]

set_property PACKAGE_PIN Y22                    [get_ports adc_conv]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_conv]
set_property SLEW FAST                          [get_ports adc_conv]

set_property PACKAGE_PIN Y23                    [get_ports adc_rd12]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_rd12]
set_property SLEW FAST                          [get_ports adc_rd12]

set_property PACKAGE_PIN J14                    [get_ports adc_rd34]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_rd34]
set_property SLEW FAST                          [get_ports adc_rd34]

set_property PACKAGE_PIN J15                    [get_ports {adc_cs[0]}]
set_property PACKAGE_PIN K16                    [get_ports {adc_cs[1]}]
set_property PACKAGE_PIN K17                    [get_ports {adc_cs[2]}]
set_property PACKAGE_PIN M14                    [get_ports {adc_cs[3]}]
set_property PACKAGE_PIN V23                    [get_ports {adc_cs[4]}]
set_property PACKAGE_PIN AC24                   [get_ports {adc_cs[5]}]
set_property PACKAGE_PIN AB24                   [get_ports {adc_cs[6]}]
set_property PACKAGE_PIN AA23                   [get_ports {adc_cs[7]}]
set_property IOSTANDARD LVCMOS33                [get_ports adc_cs*]
set_property SLEW FAST                          [get_ports adc_cs*]

set_property PACKAGE_PIN M17                    [get_ports {adc_bus_1[0]}]
set_property PACKAGE_PIN M15                    [get_ports {adc_bus_1[1]}]
set_property PACKAGE_PIN L14                    [get_ports {adc_bus_1[2]}]
set_property PACKAGE_PIN L15                    [get_ports {adc_bus_1[3]}]
set_property PACKAGE_PIN M16                    [get_ports {adc_bus_1[4]}]
set_property PACKAGE_PIN H19                    [get_ports {adc_bus_1[5]}]
set_property PACKAGE_PIN G21                    [get_ports {adc_bus_1[6]}]
set_property PACKAGE_PIN E23                    [get_ports {adc_bus_1[7]}]
set_property PACKAGE_PIN D25                    [get_ports {adc_bus_1[8]}]
set_property PACKAGE_PIN E26                    [get_ports {adc_bus_1[9]}]
set_property PACKAGE_PIN G22                    [get_ports {adc_bus_1[10]}]
set_property PACKAGE_PIN H24                    [get_ports {adc_bus_1[11]}]
set_property PACKAGE_PIN J24                    [get_ports {adc_bus_1[12]}]
set_property PACKAGE_PIN K23                    [get_ports {adc_bus_1[13]}]
set_property PACKAGE_PIN U26                    [get_ports {adc_bus_1[14]}]
set_property PACKAGE_PIN V26                    [get_ports {adc_bus_1[15]}]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_bus_1*]

set_property PACKAGE_PIN K20                    [get_ports {adc_bus_2[0]}]
set_property PACKAGE_PIN K22                    [get_ports {adc_bus_2[1]}]
set_property PACKAGE_PIN T20                    [get_ports {adc_bus_2[2]}]
set_property PACKAGE_PIN T15                    [get_ports {adc_bus_2[3]}]
set_property PACKAGE_PIN T18                    [get_ports {adc_bus_2[4]}]
set_property PACKAGE_PIN U19                    [get_ports {adc_bus_2[5]}]
set_property PACKAGE_PIN V18                    [get_ports {adc_bus_2[6]}]
set_property PACKAGE_PIN Y20                    [get_ports {adc_bus_2[7]}]
set_property PACKAGE_PIN AA22                   [get_ports {adc_bus_2[8]}]
set_property PACKAGE_PIN AA24                   [get_ports {adc_bus_2[9]}]
set_property PACKAGE_PIN V24                    [get_ports {adc_bus_2[10]}]
set_property PACKAGE_PIN W20                    [get_ports {adc_bus_2[11]}]
set_property PACKAGE_PIN AC26                   [get_ports {adc_bus_2[12]}]
set_property PACKAGE_PIN AB26                   [get_ports {adc_bus_2[13]}]
set_property PACKAGE_PIN Y25                    [get_ports {adc_bus_2[14]}]
set_property PACKAGE_PIN W25                    [get_ports {adc_bus_2[15]}]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_bus_2*]

set_property PACKAGE_PIN L17                    [get_ports {adc_bus_3[0]}]
set_property PACKAGE_PIN L18                    [get_ports {adc_bus_3[1]}]
set_property PACKAGE_PIN J18                    [get_ports {adc_bus_3[2]}]
set_property PACKAGE_PIN H18                    [get_ports {adc_bus_3[3]}]
set_property PACKAGE_PIN J19                    [get_ports {adc_bus_3[4]}]
set_property PACKAGE_PIN G20                    [get_ports {adc_bus_3[5]}]
set_property PACKAGE_PIN F22                    [get_ports {adc_bus_3[6]}]
set_property PACKAGE_PIN F23                    [get_ports {adc_bus_3[7]}]
set_property PACKAGE_PIN E25                    [get_ports {adc_bus_3[8]}]
set_property PACKAGE_PIN F24                    [get_ports {adc_bus_3[9]}]
set_property PACKAGE_PIN G24                    [get_ports {adc_bus_3[10]}]
set_property PACKAGE_PIN H23                    [get_ports {adc_bus_3[11]}]
set_property PACKAGE_PIN J23                    [get_ports {adc_bus_3[12]}]
set_property PACKAGE_PIN H22                    [get_ports {adc_bus_3[13]}]
set_property PACKAGE_PIN U25                    [get_ports {adc_bus_3[14]}]
set_property PACKAGE_PIN W26                    [get_ports {adc_bus_3[15]}]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_bus_3*]

set_property PACKAGE_PIN J20                    [get_ports {adc_bus_4[0]}]
set_property PACKAGE_PIN K21                    [get_ports {adc_bus_4[1]}]
set_property PACKAGE_PIN U20                    [get_ports {adc_bus_4[2]}]
set_property PACKAGE_PIN T14                    [get_ports {adc_bus_4[3]}]
set_property PACKAGE_PIN T17                    [get_ports {adc_bus_4[4]}]
set_property PACKAGE_PIN T19                    [get_ports {adc_bus_4[5]}]
set_property PACKAGE_PIN W18                    [get_ports {adc_bus_4[6]}]
set_property PACKAGE_PIN W19                    [get_ports {adc_bus_4[7]}]
set_property PACKAGE_PIN Y21                    [get_ports {adc_bus_4[8]}]
set_property PACKAGE_PIN W21                    [get_ports {adc_bus_4[9]}]
set_property PACKAGE_PIN W24                    [get_ports {adc_bus_4[10]}]
set_property PACKAGE_PIN U24                    [get_ports {adc_bus_4[11]}]
set_property PACKAGE_PIN V19                    [get_ports {adc_bus_4[12]}]
set_property PACKAGE_PIN AB25                   [get_ports {adc_bus_4[13]}]
set_property PACKAGE_PIN AA25                   [get_ports {adc_bus_4[14]}]
set_property PACKAGE_PIN Y26                    [get_ports {adc_bus_4[15]}]
set_property IOSTANDARD  LVCMOS33               [get_ports adc_bus_4*]

        
set_property PACKAGE_PIN U22                    [get_ports rk_o]
set_property IOSTANDARD  LVCMOS33               [get_ports rk_o]

set_property PACKAGE_PIN V22                    [get_ports ru_o]
set_property IOSTANDARD  LVCMOS33               [get_ports ru_o]

############################################################################
# DAC pins                                                                 #
############################################################################
set_property PACKAGE_PIN G6                     [get_ports dac_sync]
set_property IOSTANDARD  LVCMOS33               [get_ports dac_sync]

set_property PACKAGE_PIN H9                     [get_ports dac_sclk]
set_property IOSTANDARD  LVCMOS33               [get_ports dac_sclk]

set_property PACKAGE_PIN G9                     [get_ports dac_sdata]
set_property IOSTANDARD  LVCMOS33               [get_ports dac_sdata]

############################################################################
# DDS pins                                                                 #
############################################################################
set_property PACKAGE_PIN J5                     [get_ports dds_rst]
set_property IOSTANDARD  LVCMOS33               [get_ports dds_rst]

set_property PACKAGE_PIN F5                     [get_ports dds_mclk]
set_property IOSTANDARD  LVCMOS33               [get_ports dds_mclk]

set_property PACKAGE_PIN J6                     [get_ports dds_sclk]
set_property IOSTANDARD  LVCMOS33               [get_ports dds_sclk]

set_property PACKAGE_PIN L8                     [get_ports dds_upd]
set_property IOSTANDARD  LVCMOS33               [get_ports dds_upd]

set_property PACKAGE_PIN K8                    [get_ports {dds_pdata[0]}]
set_property PACKAGE_PIN J4                    [get_ports {dds_pdata[1]}]
set_property PACKAGE_PIN H4                    [get_ports {dds_pdata[2]}]
set_property PACKAGE_PIN K7                    [get_ports {dds_pdata[3]}]
set_property PACKAGE_PIN K6                    [get_ports {dds_pdata[4]}]
set_property PACKAGE_PIN G4                    [get_ports {dds_pdata[5]}]
set_property PACKAGE_PIN F4                    [get_ports {dds_pdata[6]}]
set_property PACKAGE_PIN G5                    [get_ports {dds_pdata[7]}]
set_property IOSTANDARD LVCMOS33               [get_ports dds_pdata*]
set_property SLEW FAST                         [get_ports dds_pdata*]


############################################################################
# SKP pins                                                                 #
############################################################################
set_property PACKAGE_PIN D3                     [get_ports SKP_SERIAL_RX]
set_property IOSTANDARD  LVCMOS33               [get_ports SKP_SERIAL_RX]

set_property PACKAGE_PIN C3                     [get_ports SKP_SERIAL_RE]
set_property IOSTANDARD  LVCMOS33               [get_ports SKP_SERIAL_RE]

set_property PACKAGE_PIN F3                     [get_ports SKP_SERIAL_DE]
set_property IOSTANDARD  LVCMOS33               [get_ports SKP_SERIAL_DE]

set_property PACKAGE_PIN E3                     [get_ports SKP_SERIAL_TX]
set_property IOSTANDARD  LVCMOS33               [get_ports SKP_SERIAL_TX]


############################################################################
# DFS pins                                                                 #
############################################################################
set_property PACKAGE_PIN E5                     [get_ports DFS_SERIAL_RX]
set_property IOSTANDARD  LVCMOS33               [get_ports DFS_SERIAL_RX]

set_property PACKAGE_PIN D5                     [get_ports DFS_SERIAL_RE]
set_property IOSTANDARD  LVCMOS33               [get_ports DFS_SERIAL_RE]

set_property PACKAGE_PIN D4                     [get_ports DFS_SERIAL_DE]
set_property IOSTANDARD  LVCMOS33               [get_ports DFS_SERIAL_DE]

set_property PACKAGE_PIN C4                     [get_ports DFS_SERIAL_TX]
set_property IOSTANDARD  LVCMOS33               [get_ports DFS_SERIAL_TX]


############################################################################
# Envelope pins                                                            #
############################################################################
#set_property PACKAGE_PIN B2                     [get_ports envelope]
#set_property IOSTANDARD  LVCMOS33               [get_ports envelope]

set_property PACKAGE_PIN C2                     [get_ports envelope]
set_property IOSTANDARD  LVCMOS33               [get_ports envelope]



#[Place 30-574] Poor placement for routing between an IO pin and BUFG. If this sub optimal condition is acceptable for this design, you may use the CLOCK_DEDICATED_ROUTE constraint in the .xdc file to demote this message to a WARNING. However, the use of this override is highly discouraged. These examples can be used directly in the .xdc file to override this clock rule.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PHY_RXC_IBUF]
#PHY_RXC_IBUF_inst (IBUF.O) is locked to IOB_X1Y87
#and PHY_RXC_IBUF_BUFG_inst (BUFG.I) is provisionally placed by clockplacer on BUFGCTRL_X0Y1



#create_clock -period 8.000      -name ts_PHY_RXC    [get_ports PHY_RXC]
#create_clock -period 8.000      -name ts_PHY_GTXC   [get_ports PHY_GTXC]
#create_clock -period 5000.000   -name ts_conv_o     [get_ports conv_o]
#create_clock -period 6.250      -name ts_clk_adc_o  [get_ports sclk_adc_o]

#create_clock -period 8.000      -name ts_clk125     [get_nets clk_125Mhz]
#create_clock -period 6.250      -name ts_clk160     [get_nets clk_160Mhz]



#QMTECH_Artix-7_XC7A100T_Wukong_Board
#set_property CFGBVS VCCO                        [current_design]
#set_property CONFIG_VOLTAGE 3.3                 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4    [current_design]

#set_property PACKAGE_PIN M22                    [get_ports sys_clk]
#set_property IOSTANDARD  LVCMOS33               [get_ports sys_clk]

#set_property PACKAGE_PIN J6                     [get_ports sys_led]
#set_property IOSTANDARD  LVCMOS33               [get_ports sys_led]

#set_property PACKAGE_PIN H6                     [get_ports led_HL4]
#set_property IOSTANDARD  LVCMOS33               [get_ports led_HL4]


#set_property PACKAGE_PIN H4                     [get_ports PHY_MDC]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_MDC]

#set_property PACKAGE_PIN F4                     [get_ports PHY_MDIO]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_MDIO]



#set_property PACKAGE_PIN H7                     [get_ports PHY_RESET_N]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RESET_N]

#set_property PACKAGE_PIN A4                     [get_ports PHY_COMA]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_COMA]

#set_property PACKAGE_PIN A5                     [get_ports PHY_TX_DISABLE]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TX_DISABLE]

#set_property PACKAGE_PIN U1                     [get_ports PHY_GTXC]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_GTXC]
#set_property SLEW FAST                          [get_ports PHY_GTXC]

#set_property PACKAGE_PIN P4                     [get_ports PHY_RXC]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXC]

#set_property PACKAGE_PIN U5                     [get_ports PHY_RXER]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXER]

#set_property PACKAGE_PIN L3                     [get_ports PHY_RXDV]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXDV]

#set_property PACKAGE_PIN M4                     [get_ports {PHY_RXD[0]}]
#set_property PACKAGE_PIN N3                     [get_ports {PHY_RXD[1]}]
#set_property PACKAGE_PIN N4                     [get_ports {PHY_RXD[2]}]
#set_property PACKAGE_PIN P3                     [get_ports {PHY_RXD[3]}]
#set_property PACKAGE_PIN R3                     [get_ports {PHY_RXD[4]}]
#set_property PACKAGE_PIN T3                     [get_ports {PHY_RXD[5]}]
#set_property PACKAGE_PIN T4                     [get_ports {PHY_RXD[6]}]
#set_property PACKAGE_PIN T5                     [get_ports {PHY_RXD[7]}]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_RXD*]



#set_property PACKAGE_PIN M2                     [get_ports PHY_TXC]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXC]

#set_property PACKAGE_PIN T2                     [get_ports PHY_TXEN]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXEN]
#set_property SLEW FAST                          [get_ports PHY_TXEN]

#set_property PACKAGE_PIN J1                     [get_ports PHY_TXER]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXER]

#set_property PACKAGE_PIN R2                     [get_ports {PHY_TXD[0]}]
#set_property PACKAGE_PIN P1                     [get_ports {PHY_TXD[1]}]
#set_property PACKAGE_PIN N2                     [get_ports {PHY_TXD[2]}]
#set_property PACKAGE_PIN N1                     [get_ports {PHY_TXD[3]}]
#set_property PACKAGE_PIN M1                     [get_ports {PHY_TXD[4]}]
#set_property PACKAGE_PIN L2                     [get_ports {PHY_TXD[5]}]
#set_property PACKAGE_PIN K2                     [get_ports {PHY_TXD[6]}]
#set_property PACKAGE_PIN K1                     [get_ports {PHY_TXD[7]}]
#set_property IOSTANDARD  LVCMOS33               [get_ports PHY_TXD*]
#set_property SLEW FAST                          [get_ports PHY_TXD*]


#[Place 30-876] Port 'sys_clk'  is assigned to PACKAGE_PIN 'M22'  which can only be used as the N side of a differential clock input. 
#Please use the following constraint(s) to pass this DRC check:
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {pll_inst/inst/clk_in1_pll}]
