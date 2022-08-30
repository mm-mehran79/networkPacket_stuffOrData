## constraint file for stuff or data module on xc7a200tffg1156-2
## Clock signal
set_property -dict { PACKAGE_PIN AL20    IOSTANDARD LVCMOS33 } [get_ports clk ];
create_clock -add -name sys_clk_pin -period 2.50  [get_ports clk ];
## PM:
set_property -dict { PACKAGE_PIN AG18   IOSTANDARD LVCMOS33 } [get_ports  pm[0] ];
set_property -dict { PACKAGE_PIN AK23   IOSTANDARD LVCMOS33 } [get_ports  pm[1] ];
set_property -dict { PACKAGE_PIN AL23   IOSTANDARD LVCMOS33 } [get_ports  pm[2] ];
set_property -dict { PACKAGE_PIN AM22   IOSTANDARD LVCMOS33 } [get_ports  pm[3] ];
set_property -dict { PACKAGE_PIN AN22   IOSTANDARD LVCMOS33 } [get_ports  pm[4] ];
set_property -dict { PACKAGE_PIN AP21   IOSTANDARD LVCMOS33 } [get_ports  pm[5] ];
set_property -dict { PACKAGE_PIN AP22   IOSTANDARD LVCMOS33 } [get_ports  pm[6] ];
set_property -dict { PACKAGE_PIN AN20   IOSTANDARD LVCMOS33 } [get_ports  pm[7] ];
## CM:
set_property -dict { PACKAGE_PIN AP20   IOSTANDARD LVCMOS33 } [get_ports  cm[0] ];
set_property -dict { PACKAGE_PIN AN19   IOSTANDARD LVCMOS33 } [get_ports  cm[1] ];
set_property -dict { PACKAGE_PIN AP19   IOSTANDARD LVCMOS33 } [get_ports  cm[2] ];
set_property -dict { PACKAGE_PIN AL21   IOSTANDARD LVCMOS33 } [get_ports  cm[3] ];
set_property -dict { PACKAGE_PIN AM21   IOSTANDARD LVCMOS33 } [get_ports  cm[4] ];
set_property -dict { PACKAGE_PIN AN17   IOSTANDARD LVCMOS33 } [get_ports  cm[5] ];
set_property -dict { PACKAGE_PIN AN18   IOSTANDARD LVCMOS33 } [get_ports  cm[6] ];
set_property -dict { PACKAGE_PIN AP16   IOSTANDARD LVCMOS33 } [get_ports  cm[7] ];
## DS:
set_property -dict { PACKAGE_PIN AM18   IOSTANDARD LVCMOS33 } [get_ports ds]
## sof:
set_property -dict { PACKAGE_PIN AP17   IOSTANDARD LVCMOS33 } [get_ports sof]
set_property -dict { PACKAGE_PIN AL16   IOSTANDARD LVCMOS33 } [get_ports sof_out]
## valid:
set_property -dict { PACKAGE_PIN AM17   IOSTANDARD LVCMOS33 } [get_ports valid_in]
set_property -dict { PACKAGE_PIN AM16   IOSTANDARD LVCMOS33 } [get_ports valid_out]
## error pins:
set_property -dict { PACKAGE_PIN AM20   IOSTANDARD LVCMOS33 } [get_ports input_err]
set_property -dict { PACKAGE_PIN AL18   IOSTANDARD LVCMOS33 } [get_ports err_sof_early]
set_property -dict { PACKAGE_PIN AL19   IOSTANDARD LVCMOS33 } [get_ports err_sof_late]