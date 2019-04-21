`ifndef VIP_RESET_MONITOR_ITEM_SV
`define VIP_RESET_MONITOR_ITEM_SV

class vip_reset_monitor_item extends uvm_sequence_item;
    `uvm_object_utils(vip_reset_monitor_item)

    vip_reset_types::change_t       change;

    //==========================================================================
    function new(string name = "vip_reset_monitor_item");
        super.new(name);
    endfunction
    //==========================================================================

    //==========================================================================
    virtual function string
    convert2string();
        string s;
        s = $sformatf("Reset event = %s",
            (change == vip_reset_types::POSEDGE) ? "POSEDGE": "NEGEDGE");
        return s;
    endfunction
    //==========================================================================

    //==========================================================================
    virtual function bit
    do_compare(uvm_object rhs, uvm_comparer comparer);
        vip_reset_monitor_item rhs_;
        bit suc;
        `CHK_FATAL($cast(rhs_,rhs), "wrong type of RHS")
        suc = 1;
        suc &= super.do_compare(rhs, comparer);
        suc &= this.change == rhs_.change;
        return suc;
    endfunction
    //==========================================================================
endclass
`endif//VIP_RESET_MONITOR_ITEM_SV