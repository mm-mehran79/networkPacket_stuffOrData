//===========================================================
//
//			stuff or data testbench
//
//			Implemented by Mehran Mazaheri
//          
//          delay : 
//          
//===========================================================
`timescale 1ns/1ns
module stuff_or_data_tb #(
    parameter MPT_W = 8
);
    int NO_OF_TEST = 100;
    reg [MPT_W-1:0] pm,cm;
    reg ds, sof, valid_in;
    reg clk;
    initial begin
		clk				= 1'b0;
		#(3);
		while(1)
			clk = #(2) !clk;
	end
    initial begin
        for (int i=0; i<NO_OF_TEST; i++) begin
            pm = $urandom_range(2,2 ** MPT_W - 1);
            cm = $urandom_range(2,pm);
            //sof = $urandom%2;
            sof = 1;
            valid_in = 0;
            for (int j=1; j <= pm; ++j) begin
                //sof = $urandom%2;
                //valid_in = 1;
                valid_in = $urandom%2;
                while (valid_in == 1'b0) begin
                    @(negedge clk);
                    if (0 != uut.ds) begin
                        $display("ds isn't 0 while valid_in is zero");
                        $stop;
                    end
                    if (0 != uut.valid_out) begin
                        $display("valid_out isn't 0 while valid_in is zero");
                        $stop;
                    end
                    valid_in = $urandom%2;
                end
                @(negedge clk);
                if ((j * cm) % pm < cm) ds = 1'b1;
                else ds = 1'b0;
                if (ds !== uut.ds) begin 
                    $display("%d: %d !== %d pm = %d , cm = %d", j, ds, uut.ds, pm, cm);
                    $stop;
                end
                else $display("%d: %d is got. pm = %d , cm = %d", j, ds, pm, cm);
            end
        end
        $display("successfully ended by testbench");
        $stop;
    end
    stuff_or_data #(.MPT_W(MPT_W)) uut(
        .clk(clk),
        .pm(pm),
        .cm(cm),
        .sof(sof),
        .valid_in(valid_in),
        .sof_out(),
        .valid_out(),
        .err_sof_early(),
        .err_sof_late(),
        .input_err(),
        .ds()
    );
endmodule