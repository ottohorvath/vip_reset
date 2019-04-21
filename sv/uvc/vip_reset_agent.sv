`ifndef VIP_RESET_AGENT_SV
`define VIP_RESET_AGENT_SV

class vip_reset_agent extends uvm_agent;
    `uvm_component_utils(vip_reset_agent)

    protected vip_reset_agent_configuration     configuration;
    protected vip_reset_monitor                 monitor;
    protected vip_reset_driver                  driver;
    protected vip_reset_sequencer               sequencer;
    protected virtual vip_reset_signal_if       vif;

    //==========================================================================
    function new(string name = "vip_reset_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    build_phase(uvm_phase phase);
        if (!uvm_config_db#(vip_reset_agent_configuration)::get(this,"","configuration",configuration))
        begin
            `uvm_info(get_type_name(),
                "No agent configuration is pushed to config_db, thus using a default one!",UVM_DEBUG)
            configuration = vip_reset_agent_configuration::type_id::create("default_configuration");
        end
        is_active = (configuration.get_active())? UVM_ACTIVE : UVM_PASSIVE;
        if (is_active)
        begin
            if (!uvm_config_db#(virtual vip_reset_signal_if)::get(this,"","vif",vif))
            begin
                `uvm_fatal(get_type_name(),"No VIF is pushed to config_db!")
            end
            driver    = vip_reset_driver   ::type_id::create("driver",   this);
            sequencer = vip_reset_sequencer::type_id::create("sequencer",this);
            uvm_config_db#(virtual vip_reset_signal_if)  ::set(this,"driver","intf",vif);
            uvm_config_db#(vip_reset_agent_configuration)::set(this,"driver","configuration",configuration);
        end
        monitor    = vip_reset_monitor   ::type_id::create("monitor",   this);
        uvm_config_db#(virtual vip_reset_signal_if)  ::set(this,"monitor","intf",vif);
        uvm_config_db#(vip_reset_agent_configuration)::set(this,"monitor","configuration",configuration);
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    connect_phase(uvm_phase phase);
        if (is_active)
        begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    //==========================================================================

    `GETTER(vip_reset_agent_configuration, configuration)
    `GETTER(vip_reset_monitor, monitor)
    `GETTER(vip_reset_driver, driver)
    `GETTER(vip_reset_sequencer, sequencer)
    `GETTER(virtual vip_reset_signal_if, vif)
endclass
`endif//VIP_RESET_AGENT_SV