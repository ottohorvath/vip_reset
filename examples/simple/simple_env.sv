`ifndef SIMPLE_ENV_SV
`define SIMPLE_ENV_SV

class simple_env extends uvm_env;
    `uvm_component_utils(simple_env)

    vip_reset_agent     rst_agt;

    `uvm_analysis_imp_decl(_dut_reset)
    uvm_analysis_imp_dut_reset #(vip_reset_monitor_item,simple_env) dut_reset_imp;

    //==========================================================================
    function new(string name="simple_env", uvm_component parent=null);
        super.new(name,parent);
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    build_phase(uvm_phase phase);
        rst_agt = vip_reset_agent::type_id::create("rst_agt",this);
        dut_reset_imp = new("dut_reset_imp",this);
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    connect_phase(uvm_phase phase);
        rst_agt.get_monitor().get_ap().connect(dut_reset_imp);
    endfunction
    //==========================================================================

    virtual function void
    write_dut_reset(input vip_reset_monitor_item t);
        `uvm_info(get_type_name(),t.convert2string(),UVM_NONE)
    endfunction
endclass
`endif//SIMPLE_ENV_SV