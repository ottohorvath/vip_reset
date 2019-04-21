module simple_tb_top;
    import uvm_pkg::*;
    import simple_pkg::*;

    bit     dut_clock = 1;
    real    per       = 3.2;
    initial forever #(per/2) dut_clock = ~dut_clock;

    logic   dut_reset;

    vip_reset_signal_if     rst_if(.clock(dut_clock), .reset(dut_reset));
    simple_dut              u_dut( .clk(  dut_clock), .rstn( dut_reset));

    initial
    begin
        uvm_config_db#(virtual vip_reset_signal_if)::set(null,"*env.rst_agt","vif",rst_if);
        uvm_top.run_test();
    end
endmodule