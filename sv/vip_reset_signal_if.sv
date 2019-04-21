interface   vip_reset_signal_if(
    input wire  logic   clock,
    output      logic   reset
);
    bit     agent_is_active;
    logic   rst_drv;
    assign  reset = (agent_is_active) ? (rst_drv) : (1'bz);

    //==========================================================================
    task automatic
    wait_posedge_clock();
        @ (posedge clock);
    endtask
    //==========================================================================
endinterface