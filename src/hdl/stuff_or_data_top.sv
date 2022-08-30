`timescale 1ns/1ns
module stuff_or_data_top
#(
    parameter MPT_W = 8
)
(
    input wire clk,
    input wire [MPT_W-1:0]pm,
    input wire [MPT_W-1:0]cm,
    input wire valid_in,
    input wire sof,
    output reg input_err,
    output reg err_sof_early,
    output reg err_sof_late,
    output reg sof_out,
    output reg valid_out,
    output reg ds
);
    wire sys_clk;

    IBUF ibufg_inst
    (
        .I(clk),
        .O(sys_clk)
    );

    stuff_or_data 
    #(.MPT_W(MPT_W)) uut
    (
        .clk(sys_clk),
        .pm(pm),
        .cm(cm),
        .valid_in(valid_in),
        .valid_out(valid_out),
        .sof(sof),
        .sof_out(sof_out),
        .ds(ds)
    );

endmodule