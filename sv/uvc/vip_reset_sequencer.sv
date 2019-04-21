`ifndef VIP_RESET_SEQUENCER_SV
`define VIP_RESET_SEQUENCER_SV

class vip_reset_sequencer extends uvm_sequencer#(vip_reset_seq_item);
    `uvm_component_utils(vip_reset_sequencer)

    //==========================================================================
    function new(string name = "vip_reset_sequencer", uvm_component parent=null);
        super.new(name,parent);
    endfunction
    //==========================================================================
endclass
`endif//VIP_RESET_SEQUENCER_SV