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
module stuff_or_data_met
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
    reg [MPT_W-1:0] cm_fetched, pm_fetched, cm_negetive;
    reg [MPT_W-1:0] counter, x2_s3, x2_s4;
//-------------------------------------------------------
//--------------------------------------- wire deceleration
    wire s3_final, s4_final;
    wire [MPT_W-1:0] P3, P4, G3, G4 ;
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
                    ds <= ~|(cm_fetched^pm_fetched);
                    x1_s2 <= cm2_pm[MPT_W+1]?{cm_fetched,1'b0}:cm2_pm;
                    x1_s3 <= {cm_fetched,1'b0} + cm_fetched;
                    x1_s3_pm <= cm_fetched + cm2_pm;
                    x1_s3_2pm <= cm_fetched + cm2_pm2;
                    state <= ~|(counter^pm_fetched)?FETCH:|(cm_fetched^pm_fetched)?S2:S1;
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
                    state <= |(counter^pm_fetched)?S3:FETCH;
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
                    ds <= ~s3_final;
                    x1_s3 <= x2_s3 + {cm_fetched, 1'b0};
                    x1_s3_pm <= x2_s3 + cm2_pm;
                    x1_s3_2pm <= x2_s3 + cm2_pm2;
                    x2_s4 <= x1_s4_2pm[MPT_W+1]?(x1_s4_pm[MPT_W+1]?x1_s4:x1_s4_pm):x1_s4_2pm;
                    state <= |(counter^pm_fetched)?S4:FETCH;
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
                    ds <= ~s4_final;
                    x2_s3 <= x1_s3_2pm[MPT_W+1]?(x1_s3_pm[MPT_W+1]?x1_s3:x1_s3_pm):x1_s3_2pm;
                    x1_s4 <=  x2_s4 + {cm_fetched, 1'b0};
                    x1_s4_pm <=  x2_s4 + cm2_pm;
                    x1_s4_2pm <=  x2_s4 + cm2_pm2;
                    state <= |(counter^pm_fetched)?S3:FETCH;
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
    // assign {s3_final, garbage1} = x2_s3 + cm_negetive;
    // assign {s4_final, garbage2} = x2_s4 + cm_negetive;
    assign P3 = x2_s3 ^ cm_negetive;
    assign G3 = x2_s3 & cm_negetive;
    assign P4 = x2_s4 ^ cm_negetive;
    assign G4 = x2_s4 & cm_negetive;
    assign f3 = (cm_negetive[8]&G3[7]) | (cm_negetive[8]&P3[7]&G3[6]) | (cm_negetive[8]&P3[7]&P3[6]&G3[5]) |
    (cm_negetive[8]&P3[7]&P3[6]&P3[5]&G3[4]) | (cm_negetive[8]&P3[7]&P3[6]&P3[5]&P3[4]&G3[3]) | (cm_negetive[8]&P3[7]&P3[6]&P3[5]&P3[4]&P3[3]&G3[2]) |
    (cm_negetive[8]&P3[7]&P3[6]&P3[5]&P3[4]&P3[3]&P3[2]&G3[1]) | (cm_negetive[8]&P3[7]&P3[6]&P3[5]&P3[4]&P3[3]&P3[2]&P3[1]&G3[0]);
    assign f4 = (cm_negetive[8]&G4[7]) | (cm_negetive[8]&P4[7]&G4[6]) | (cm_negetive[8]&P4[7]&P4[6]&G4[5]) |
    (cm_negetive[8]&P4[7]&P4[6]&P4[5]&G4[4]) | (cm_negetive[8]&P4[7]&P4[6]&P4[5]&P4[4]&G4[3]) | (cm_negetive[8]&P4[7]&P4[6]&P4[5]&P4[4]&P4[3]&G4[2]) |
    (cm_negetive[8]&P4[7]&P4[6]&P4[5]&P4[4]&P4[3]&P4[2]&G4[1]) | (cm_negetive[8]&P4[7]&P4[6]&P4[5]&P4[4]&P4[3]&P4[2]&P4[1]&G4[0]);
//-------------------------------------------------------

endmodule