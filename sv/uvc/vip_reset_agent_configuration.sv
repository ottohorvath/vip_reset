`ifndef VIP_RESET_AGENT_CONFIGURATION_SV
`define VIP_RESET_AGENT_CONFIGURATION_SV

class vip_reset_agent_configuration extends uvm_object;
    `uvm_object_utils(vip_reset_agent_configuration)

    protected bit                           active               ;
    protected bit                           reset_active_low     ;
    protected bit                           start_with_auto_reset;
    protected vip_reset_types::pulse_t      auto_reset_type      ;

    //==========================================================================
    function new(string name = "vip_reset_agent_configuration");
        super.new(name);
        set_default();
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    set_default();
        active                = 1;
        reset_active_low      = 1;
        start_with_auto_reset = 1;
        auto_reset_type       = vip_reset_types::ASYNC_SYNC;
    endfunction
    //==========================================================================

    `ACCESSOR(bit, active)
    `ACCESSOR(bit, reset_active_low)
    `ACCESSOR(bit, start_with_auto_reset)
    `ACCESSOR(vip_reset_types::pulse_t, auto_reset_type)
endclass
`endif//VIP_RESET_AGENT_CONFIGURATION_SV