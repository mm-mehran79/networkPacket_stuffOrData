//===========================================================
//
//			stuff or data
//
//			Implemented by Mehran Mazaheri
//          
//          delay : 1 period 
//          
//          pm must not be zero
//          {counter} must count down to use less lut and speed up
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
    output reg input_err,
    output reg err_sof_early,
    output reg err_sof_late,
    output reg sof_out,
    output reg valid_out,
    output reg ds
);
//--------------------------------------- reg deceleration
    reg [MPT_W+1:0] x1_s2, x1_s3, x1_s4 , cm2_pm , cm2_pm2, x1_s3_pm, x1_s3_2pm, x1_s4_pm, x1_s4_2pm;
    reg [MPT_W-1:0] cm_fetched, pm_fetched;
    reg [MPT_W:0] cm_pm, g3;
    reg [MPT_W-1:0] counter, x2_s3, x2_s4, g1, g2;
    reg ds_s3raw, ds_s4raw;
//-------------------------------------------------------
//-------------------------------------------------------

    enum { FETCH, S1, S2, S3, S4 } state;

//--------------------------------------- sequential Logic
    task reset_output;
        ds <= 1'b0;
        valid_out <= 1'b0;
        input_err <= 1'b0;
    endtask
    task set_variables;
        counter <= 'd1;
        pm_fetched <= pm;
        cm_fetched <= cm;
        cm2_pm <= {cm,1'b0} - pm;
        cm2_pm2 <= {cm,1'b0} - {pm,1'b0};
        cm_pm <= cm - pm;
        g3 <= pm - cm;
        state <= S1;
        sof_out <= 1'b1;
        err_sof_late <= 1'b0;
    endtask
    always @( posedge clk ) begin
        unique case (state)
            FETCH:begin
                err_sof_early <= 0;
                if (sof) begin
                    reset_output;
                    set_variables;
                    err_sof_late <= 0;
                end else begin
                    err_sof_late <= 1;
                    reset_output;
                    state <= FETCH;//vain
                    // input_err <= 1;//vain
                end
            end
            S1:begin
                if (sof) begin
                    err_sof_early <= 1'b1;
                    reset_output;
                    set_variables;
                end else begin
                    sof_out <= 0;
                    err_sof_early <= 1'b0;
                    input_err <= g3[MPT_W];
                    // err_sof_late <= 0;
                    if (valid_in) begin
                        valid_out <= 1;
                        counter <= counter + 1;
                        ds <= &(cm_fetched~^pm_fetched);
                        x1_s2 <= cm2_pm[MPT_W+1]?{cm_fetched,1'b0}:cm2_pm;
                        x1_s3 <= {cm_fetched,1'b0} + cm_fetched;
                        x1_s3_pm <= cm_fetched + cm2_pm;
                        x1_s3_2pm <= cm_fetched + cm2_pm2;
                        {ds_s3raw, g1} <= cm_fetched + cm_pm;
                        state <= &(counter~^pm_fetched)?FETCH:&(cm_fetched~^pm_fetched)?S1:S2;
                end else begin
                    valid_out <= 0;
                    ds <= 0;
                    state <= state;
                    end
                end
            end
            S2:begin
                if (sof) begin
                    err_sof_early <= 1'b1;
                    reset_output;
                    set_variables;
                end else begin
                    if (valid_in) begin
                        valid_out <= 1;
                        counter <= counter + 1;
                        ds <= ~cm2_pm[MPT_W+1];
                        x2_s3 <= x1_s3_2pm[MPT_W+1]?(x1_s3_pm[MPT_W+1]?x1_s3:x1_s3_pm):x1_s3_2pm;
                        x1_s4 <= x1_s2 + {cm_fetched, 1'b0};
                        x1_s4_pm <= x1_s2 + cm2_pm;
                        x1_s4_2pm <= x1_s2 + cm2_pm2;
                        {ds_s4raw, g2} <= x1_s2 + cm_pm;
                        state <= &(counter~^pm_fetched)?FETCH:S3;
                    end else begin
                        valid_out <= 0;
                        ds <= 0;
                        state <= state;
                    end
                end
            end
            S3:begin
                if (sof) begin
                    err_sof_early <= 1'b1;
                    reset_output;
                    set_variables;
                end else begin
                    if (valid_in) begin
                        valid_out <= 1;
                        counter <= counter + 1;
                        ds <=  x1_s3_2pm[MPT_W+1]?(x1_s3_pm[MPT_W+1]?0:ds_s3raw):1;;
                        x1_s3 <= x2_s3 + {cm_fetched, 1'b0};
                        x1_s3_pm <= x2_s3 + cm2_pm;
                        x1_s3_2pm <= x2_s3 + cm2_pm2;
                        x2_s4 <= x1_s4_2pm[MPT_W+1]?(x1_s4_pm[MPT_W+1]?x1_s4:x1_s4_pm):x1_s4_2pm;
                        {ds_s3raw, g1} <= x2_s3 + cm_pm;
                        state <= &(counter~^pm_fetched)?FETCH:S4;
                    end else begin
                        valid_out <= 0;
                        ds <= 0;
                        state <= state;
                    end
                end
            end
            S4:begin
                if (sof) begin
                    err_sof_early <= 1'b1;
                    reset_output;
                    set_variables;
                end else begin
                    if (valid_in) begin
                        valid_out <= 1;
                        counter <= counter + 1;
                        ds <= x1_s4_2pm[MPT_W+1]?(x1_s4_pm[MPT_W+1]?0:ds_s4raw):1;
                        x2_s3 <= x1_s3_2pm[MPT_W+1]?(x1_s3_pm[MPT_W+1]?x1_s3:x1_s3_pm):x1_s3_2pm;
                        {ds_s4raw, g2} <= x2_s4 + cm_pm;
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
            end 
        endcase
    end
endmodule