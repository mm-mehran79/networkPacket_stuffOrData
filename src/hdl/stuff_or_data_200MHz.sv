//===========================================================
//
//			stuff or data
//
//			Implemented by Mehran Mazaheri
//          
//          delay : 1 period 
//          
//===========================================================
`timescale 1ns/1ns
module stuff_or_data_200MHz
#(
    parameter MPT_W = 8
)
(
    input wire clk,
    input wire [MPT_W-1:0]pm,
    input wire [MPT_W-1:0]cm,
    input wire valid_in,
    input wire sof,
    // output reg input_err,
    // output reg err_sof_early,
    // output reg err_sof_late,
    output reg sof_out,
    output reg valid_out,
    output reg ds
);
//--------------------------------------- reg deceleration
    reg [MPT_W:0] synchronus_alu_output;
    reg [MPT_W-1:0] cm_fetched, pm_fetched;
    reg [MPT_W-1:0] counter;
//-------------------------------------------------------
//--------------------------------------- wire deceleration
    wire [MPT_W-1:0] final_alu_output;
    wire [MPT_W:0] alu_output;
//-------------------------------------------------------

//--------------------------------------- sequential Logic
    always @( posedge clk ) begin
        if (!sof) begin
            synchronus_alu_output <= alu_output;
            counter <= counter + 1;
            if (final_alu_output < cm_fetched) begin
                ds <= 1;
            end 
            else begin
                ds <= 0;
            end
            sof_out <= 0;
            valid_out <= 1;
        end 
        else begin
            synchronus_alu_output <= cm;
            cm_fetched <= cm;
            pm_fetched <= pm;
            counter <= 'd1;
            ds <= 1'b0;
            sof_out <= 1;
            valid_out <= 0;
        end
    end
//-------------------------------------------------------

//--------------------------------------- combinational Logic
    assign alu_output = cm + final_alu_output;
    assign final_alu_output = synchronus_alu_output >= pm? synchronus_alu_output - pm: synchronus_alu_output;
//-------------------------------------------------------

endmodule