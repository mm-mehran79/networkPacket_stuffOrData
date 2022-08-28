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
module stuff_or_data_300MHz
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
    reg [MPT_W+1:0] x1_s2, x1_s3, x1_s4;
    reg [MPT_W-1:0] cm_fetched, pm_fetched;
    reg [MPT_W-1:0] counter, x2_s3, x2_s4;
//-------------------------------------------------------
    enum { FETCH, S1, S2, S3, S4 } state;
    //localparam FETCH = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4; // state machine's states

//--------------------------------------- sequential Logic
    always @( posedge clk ) begin
        unique case (state)
            FETCH:begin
                valid_out <= 0;
                sof_out <= 0;
                counter <= 'd1;
                pm_fetched <= pm;
                cm_fetched <= cm;
                if (sof) begin
                    // err_sof_late <= 0;
                    state <= S1;
                    sof_out <= 0;
                    // input_err <= 0;
                end else begin
                    // err_sof_late <= 1;
                    state <= FETCH;//vain
                    // input_err <= 1;//vain
                end
            end
            S1:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <= &(cm_fetched~^pm_fetched);
                    x1_s2 <= ( {cm_fetched,1'b0} < pm_fetched )?{cm_fetched,1'b0}:{cm_fetched,1'b0}-pm_fetched;
                    x1_s3 <= {cm_fetched,1'b0} + cm_fetched;
                    state <= (counter == pm_fetched)?FETCH:(cm_fetched == pm_fetched)?S1:S2;
                end else begin
                    valid_out <= 0;
                    state <= S1;
                end
                
            end
            S2:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <= (x1_s2 < cm_fetched);
                    x2_s3 <= ( x1_s3 < {pm_fetched, 1'b0} )? (( x1_s3 < pm_fetched )? x1_s3: x1_s3 - pm_fetched):x1_s3 - {pm_fetched, 1'b0};
                    x1_s4 <= x1_s2 + {cm_fetched, 1'b0};
                    state <= (counter == pm_fetched)?FETCH:S3;
                end else begin
                    valid_out <= 0;
                    state <= S2;
                end
            end
            S3:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <= (x2_s3 < cm_fetched);
                    x1_s3 <= {cm_fetched, 1'b0} + x2_s3;
                    x2_s4 <= ( x1_s4 < {pm_fetched, 1'b0})? (( x1_s4 < pm_fetched )? x1_s4: x1_s4 - pm_fetched):x1_s4 - {pm_fetched, 1'b0};
                    state <= (counter == pm_fetched)?FETCH:S4;
                end else begin
                    valid_out <= 0;
                    state <= S3;
                end
            end
            S4:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <= (x2_s4 < cm_fetched);
                    x2_s3 <= ( x1_s3 < {pm_fetched, 1'b0} )? (( x1_s3 < pm_fetched )? x1_s3: x1_s3 - pm_fetched):x1_s3 - {pm_fetched, 1'b0};
                    x1_s4 <= {cm_fetched, 1'b0} + x2_s4;
                    state <= (counter == pm_fetched)?FETCH:S3;
                end else begin
                    valid_out <= 0;
                    state <= S4;
                end
            end 
        endcase
    end
//-------------------------------------------------------


endmodule