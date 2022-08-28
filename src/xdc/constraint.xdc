## Clock signal
set_property -dict { PACKAGE_PIN H7    IOSTANDARD LVCMOS33 } [get_ports clk ];
create_clock -add -name sys_clk_pin -period 2.50  [get_ports clk ];
## PM:
set_property -dict { PACKAGE_PIN AL34   IOSTANDARD LVCMOS33 } [get_ports  pm[0] ];
set_property -dict { PACKAGE_PIN AM34   IOSTANDARD LVCMOS33 } [get_ports  pm[1] ];
set_property -dict { PACKAGE_PIN AJ33   IOSTANDARD LVCMOS33 } [get_ports  pm[2] ];
set_property -dict { PACKAGE_PIN AJ34   IOSTANDARD LVCMOS33 } [get_ports  pm[3] ];
set_property -dict { PACKAGE_PIN AN34   IOSTANDARD LVCMOS33 } [get_ports  pm[4] ];
set_property -dict { PACKAGE_PIN AP34   IOSTANDARD LVCMOS33 } [get_ports  pm[5] ];
set_property -dict { PACKAGE_PIN AK33   IOSTANDARD LVCMOS33 } [get_ports  pm[6] ];
set_property -dict { PACKAGE_PIN AL33   IOSTANDARD LVCMOS33 } [get_ports  pm[7] ];
## CM:
set_property -dict { PACKAGE_PIN AP33   IOSTANDARD LVCMOS33 } [get_ports  cm[0] ];
set_property -dict { PACKAGE_PIN AL32   IOSTANDARD LVCMOS33 } [get_ports  cm[1] ];
set_property -dict { PACKAGE_PIN AM32   IOSTANDARD LVCMOS33 } [get_ports  cm[2] ];
set_property -dict { PACKAGE_PIN AJ31   IOSTANDARD LVCMOS33 } [get_ports  cm[3] ];
set_property -dict { PACKAGE_PIN AK32   IOSTANDARD LVCMOS33 } [get_ports  cm[4] ];
set_property -dict { PACKAGE_PIN AM31   IOSTANDARD LVCMOS33 } [get_ports  cm[5] ];
set_property -dict { PACKAGE_PIN AN32   IOSTANDARD LVCMOS33 } [get_ports  cm[6] ];
set_property -dict { PACKAGE_PIN AJ30   IOSTANDARD LVCMOS33 } [get_ports  cm[7] ];
## DS:
set_property -dict { PACKAGE_PIN AK31   IOSTANDARD LVCMOS33 } [get_ports ds]
## sof:
set_property -dict { PACKAGE_PIN AN31   IOSTANDARD LVCMOS33 } [get_ports sof]
set_property -dict { PACKAGE_PIN AP31   IOSTANDARD LVCMOS33 } [get_ports sof_out]
## valid:
set_property -dict { PACKAGE_PIN AJ29   IOSTANDARD LVCMOS33 } [get_ports valid_in]
set_property -dict { PACKAGE_PIN AK30   IOSTANDARD LVCMOS33 } [get_ports valid_out]