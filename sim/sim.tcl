	#  cd H:/Parman/DorS/sim
	alias clc ".main clear"
	clc

	exec vlib work
	vmap work work
	
	file mkdir files
	file mkdir scr
	file mkdir tb
	file mkdir wlf
	file mkdir wave
	
	set project_path		".."
	set include_path		"$project_path/src/inc"
	
	# You can set the test bench name!
	set TB					"stuff_or_data_tb"
	#set TB					"tb_sync_fifo_array_class"
	set wlf_save_name		"wlf/vsim.wlf"
	set opened_wlf_name		"ref_sim"
	set run_time			"5 ms"

	
#===============================================================================
#===============================================================================
	
#========== complile modules
	onerror {break}
	do scr/compile_all.tcl
	
#========== simulate design
	vsim	-voptargs=+acc $TB
#========== adding signals to wave window
	do wave/wave.tcl
#========== run simulation
	run -all
	