module simple_dut #(
    parameter DW = 8
)(
    input   wire logic            rstn ,
    input   wire logic            clk ,
    output       logic [(DW-1):0] dout
);
    always_ff @ (posedge clk or negedge rstn)
    begin
        if (~rstn)  dout <= 'b0;
        else        dout <= dout + 'b1;
    end
endmodule