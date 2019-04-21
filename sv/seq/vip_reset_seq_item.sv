`ifndef VIP_RESET_SEQ_ITEM_SV
`define VIP_RESET_SEQ_ITEM_SV

class vip_reset_seq_item extends uvm_sequence_item;
    `uvm_object_utils(vip_reset_seq_item)

    vip_reset_types::pulse_t    request         ;
    real                        before_assertion;
    real                        during_assertion;

    //==========================================================================
    function new(string name = "vip_reset_seq_item");
        super.new(name);
    endfunction
    //==========================================================================
endclass
`endif//VIP_RESET_SEQ_ITEM_SV