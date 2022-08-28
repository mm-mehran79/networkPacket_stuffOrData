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
module stuff_or_data
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
    reg [MPT_W+1:0] x1_s2, x1_s3, x1_s4 , cm2_pm , cm2_pm2, x1_s3_pm, x1_s3_2pm, x1_s4_pm, x1_s4_2pm;
    reg [MPT_W-1:0] cm_fetched, pm_fetched;
    reg [MPT_W:0] cm_negetive;
    reg [MPT_W-1:0] counter, x2_s3, x2_s4;
//-------------------------------------------------------
//--------------------------------------- wire deceleration
    wire [MPT_W:0] s3_final, s4_final;
    // wire [MPT_W-1:0] g1,g2;
//-------------------------------------------------------

    enum { FETCH, S1, S2, S3, S4 } state;
    //localparam FETCH = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4; // state machine's states

//--------------------------------------- sequential Logic
    always @( posedge clk ) begin
        unique case (state)
            FETCH:begin
                ds <= 0;
                valid_out <= 0;
                counter <= 'd1;
                pm_fetched <= pm;
                cm_fetched <= cm;
                cm2_pm <= {cm,1'b0} - pm;
                cm2_pm2 <= {cm,1'b0} - {pm,1'b0};
                if (sof) begin
                    // err_sof_late <= 0;
                    state <= S1;
                    sof_out <= 1;
                    // input_err <= 0;
                end else begin
                    // err_sof_late <= 1;
                    state <= FETCH;//vain
                    // input_err <= 1;//vain
                end
            end
            S1:begin
                sof_out <= 0;
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    cm_negetive <= -cm_fetched;
                    ds <= &(cm_fetched~^pm_fetched);
                    x1_s2 <= cm2_pm[MPT_W+1]?{cm_fetched,1'b0}:cm2_pm;
                    x1_s3 <= {cm_fetched,1'b0} + cm_fetched;
                    x1_s3_pm <= cm_fetched + cm2_pm;
                    x1_s3_2pm <= cm_fetched + cm2_pm2;
                    state <= &(counter~^pm_fetched)?FETCH:&(cm_fetched~^pm_fetched)?S1:S2;
                end else begin
                    valid_out <= 0;
                    ds <= 0;
                    state <= state;
                end
                
            end
            S2:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <= ~cm2_pm[MPT_W+1];
                    x2_s3 <= x1_s3_2pm[MPT_W+1]?(x1_s3_pm[MPT_W+1]?x1_s3:x1_s3_pm):x1_s3_2pm;
                    x1_s4 <= x1_s2 + {cm_fetched, 1'b0};
                    x1_s4_pm <= x1_s2 + cm2_pm;
                    x1_s4_2pm <= x1_s2 + cm2_pm2;
                    state <= &(counter~^pm_fetched)?FETCH:S3;
                end else begin
                    valid_out <= 0;
                    ds <= 0;
                    state <= state;
                end
            end
            S3:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <=  s3_final[MPT_W]^cm_negetive[MPT_W];
                    x1_s3 <= x2_s3 + {cm_fetched, 1'b0};
                    x1_s3_pm <= x2_s3 + cm2_pm;
                    x1_s3_2pm <= x2_s3 + cm2_pm2;
                    x2_s4 <= x1_s4_2pm[MPT_W+1]?(x1_s4_pm[MPT_W+1]?x1_s4:x1_s4_pm):x1_s4_2pm;
                    state <= &(counter~^pm_fetched)?FETCH:S4;
                end else begin
                    valid_out <= 0;
                    ds <= 0;
                    state <= state;
                end
            end
            S4:begin
                if (valid_in) begin
                    valid_out <= 1;
                    counter <= counter + 1;
                    ds <= s4_final[MPT_W]^cm_negetive[MPT_W];
                    x2_s3 <= x1_s3_2pm[MPT_W+1]?(x1_s3_pm[MPT_W+1]?x1_s3:x1_s3_pm):x1_s3_2pm;
                    x1_s4 <=  x2_s4 + {cm_fetched, 1'b0};
                    x1_s4_pm <=  x2_s4 + cm2_pm;
                    x1_s4_2pm <=  x2_s4 + cm2_pm2;
                    state <= &(counter~^pm_fetched)?FETCH:S3;
                end else begin
                    valid_out <= 0;
                    ds <= 0;
                    state <= state;
                end
            end 
        endcase
    end
//-------------------------------------------------------
//--------------------------------------- sequential Logic
    assign s3_final = x2_s3 + cm_negetive[MPT_W-1:0];
    assign s4_final = x2_s4 + cm_negetive[MPT_W-1:0];
//-------------------------------------------------------

endmodule