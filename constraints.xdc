## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project


## Clock signal
    set_property PACKAGE_PIN W5 [get_ports clock]
        set_property IOSTANDARD LVCMOS33 [get_ports clock]
        create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clock]


## Switches ***** Currently used for H-Bridge speed and control *****
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
#set_property PACKAGE_PIN T3 [get_ports {sw[9]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
#set_property PACKAGE_PIN R3 [get_ports {sw[11]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
#set_property PACKAGE_PIN T1 [get_ports {sw[14]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
#set_property PACKAGE_PIN R2 [get_ports {sw[15]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]


##Pmod Header JA
    ##Sch name = JA1
    #set_property PACKAGE_PIN J1 [get_ports {JA[0]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
    ##Sch name = JA2
    #set_property PACKAGE_PIN L2 [get_ports {JA[1]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[1]}]
    ##Sch name = JA3
    #set_property PACKAGE_PIN J2 [get_ports {JA[2]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[2]}]
    ##Sch name = JA4
    #set_property PACKAGE_PIN G2 [get_ports {JA[3]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
    ##Sch name = JA7
    #set_property PACKAGE_PIN H1 [get_ports {JA[4]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
    ##Sch name = JA8
    #set_property PACKAGE_PIN K2 [get_ports {JA[5]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
    ##Sch name = JA9
    #set_property PACKAGE_PIN H2 [get_ports {JA[6]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
    ##Sch name = JA10
    #set_property PACKAGE_PIN G3 [get_ports {JA[7]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]


##Pmod Header JB
##Sch name = JB1
#set_property PACKAGE_PIN A14 [get_ports {JB[0]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[0]}]
##Sch name = JB2
#set_property PACKAGE_PIN A16 [get_ports {JB[1]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[1]}]
##Sch name = JB3
#set_property PACKAGE_PIN B15 [get_ports {JB[2]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[2]}]
##Sch name = JB4
#set_property PACKAGE_PIN B16 [get_ports {JB[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[3]}]
##Sch name = JB7
#set_property PACKAGE_PIN A15 [get_ports {JB[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Sch name = JB8
#set_property PACKAGE_PIN A17 [get_ports {JB[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[5]}]
##Sch name = JB9
#set_property PACKAGE_PIN C15 [get_ports {JB[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[6]}]
##Sch name = JB10
#set_property PACKAGE_PIN C16 [get_ports {JB[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[7]}]


##Pmod Header JC ***** H-Bridge Motors ***
##Sch name = JC1== ENA
set_property PACKAGE_PIN K17 [get_ports {LeftPWMOut}]
	set_property IOSTANDARD LVCMOS33 [get_ports {LeftPWMOut}]
##Sch name = JC2 = IN1
set_property PACKAGE_PIN M18 [get_ports {TankDir[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {TankDir[0]}]
##Sch name = JC3 = IN2
set_property PACKAGE_PIN N17 [get_ports {TankDir[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {TankDir[1]}]
##Sch name = JC4
#set_property PACKAGE_PIN P18 [get_ports {JC[3]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
##Sch name = JC7 = ENB
set_property PACKAGE_PIN L17 [get_ports {RightPWMOut}]
	set_property IOSTANDARD LVCMOS33 [get_ports {RightPWMOut}]
##Sch name = JC8 = IN3
set_property PACKAGE_PIN M19 [get_ports {TankDir[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {TankDir[2]}]
##Sch name = JC9 = IN4
set_property PACKAGE_PIN P17 [get_ports {TankDir[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {TankDir[3]}]
##Sch name = JC10
#set_property PACKAGE_PIN R18 [get_ports {JC[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]
	
	
	set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
	set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
	set_property CONFIG_MODE SPIx4 [current_design]
