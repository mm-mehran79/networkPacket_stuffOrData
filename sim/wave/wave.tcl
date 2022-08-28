#========== adding signals to wave window
	# default radix (hex without base)
	radix -hexadecimal -enumnumeric
	# radix -hexadecimal -showbase
	# set languages(0) Tcl
	# set languages(1) "C Language"
	# for { set index 0 }  { $index < [array size languages] }  { incr index } {
   	# 	add wave -hex -group  	"deMapper1_shiftreg signals$index"	sim:/$TB/uut/sdh_module_inst/e1_ins/deMapper_ins2/shifregister\[$index\]/shiftreg_unit/*
	# }
	
	add wave -hex -group  	"TB signals"					sim:/$TB/*
	add wave -hex -group  	-r "uut signals"				sim:/$TB/uut/*

	
	#############################################

	configure wave -signalnamewidth 1

	configure wave -griddelta 40
	configure wave -gridoffset 0
	configure wave -gridperiod 10
	
	configure wave -timelineunits us
	configure wave -namecolwidth 200
	configure wave -valuecolwidth 50
	configure wave -justifyvalue right

	#########################################
	