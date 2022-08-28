	vlog -64 -vopt -sv	+acc -incr -source  +define+SIM +PATH=$project_path $project_path/src/hdl/*.sv
	# vlog -64 -vopt -sv	+acc -incr -source  +define+SIM "tb/inc/*.sv"
	vlog -64 -vopt -sv	+acc -incr -source  +define+SIM "tb/*.sv"
	