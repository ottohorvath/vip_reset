`ifndef VIP_RESET_SEQUENCE_SV
`define VIP_RESET_SEQUENCE_SV

class vip_reset_sequence extends uvm_sequence #(vip_reset_seq_item);
    `uvm_object_utils(vip_reset_sequence)

    vip_reset_types::pulse_t    request;
    real                        before_assertion;
    real                        during_assertion;

    //==========================================================================
    function new(string name = "vip_reset_sequence");
        super.new(name);
    endfunction
    //==========================================================================

    //==========================================================================
    task
    body();
        vip_reset_seq_item  t;
        t = vip_reset_seq_item::type_id::create("reset_seq");
        start_item(t);
        t.request           = request         ;
        t.before_assertion  = before_assertion;
        if (during_assertion == 0.0)
        begin
            during_assertion = 1.0;
            `uvm_warning(`GTN,"'during_assertion' increased from '0.0' to '1.0'")
        end
        t.during_assertion  = during_assertion;
        finish_item(t);
    endtask
    //==========================================================================
endclass
`endif//VIP_RESET_SEQUENCE_SV