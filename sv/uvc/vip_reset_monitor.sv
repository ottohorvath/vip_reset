`ifndef VIP_RESET_MONITOR_SV
`define VIP_RESET_MONITOR_SV

class vip_reset_monitor extends uvm_monitor;
    `uvm_component_utils(vip_reset_monitor)

    protected uvm_analysis_port#(vip_reset_monitor_item)    ap           ;
    protected vip_reset_agent_configuration                 configuration;
    protected virtual vip_reset_signal_if                   intf         ;
    protected vip_reset_monitor_item                        item         ;

    //==========================================================================
    function new(string name = "vip_reset_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    build_phase(uvm_phase phase);
        if (!uvm_config_db#(vip_reset_agent_configuration)::get(this,"","configuration",configuration))
        begin
            `uvm_fatal(get_type_name(), "Cannot access 'configuration'!")
        end
        if (!uvm_config_db#(virtual vip_reset_signal_if)::get(this,"","intf",intf))
        begin
            `uvm_fatal(get_type_name(), "Cannot access 'intf'!")
        end
        ap = new("ap",this);
    endfunction
    //==========================================================================

    //==========================================================================
    task
    run_phase(uvm_phase phase);
        fork
            monitor_if();
        join
    endtask
    //==========================================================================

    //==========================================================================
    protected task
    monitor_if();
        bit     send;
        logic   prev_reset;

        prev_reset = intf.reset;
        forever
        begin
            send = 0;
            @ (intf.reset);
            item = vip_reset_monitor_item::type_id::create("monitor_item");
            if ({prev_reset, intf.reset} === 2'b01)
            begin
                send = 1;
                item.change = vip_reset_types::POSEDGE;
            end
            else if ({prev_reset, intf.reset} === 2'b10)
            begin
                send = 1;
                item.change = vip_reset_types::NEGEDGE;
            end
            if (send)
            begin
                void'(item.begin_tr());
                item.end_tr();
                ap.write(item);
            end
            prev_reset = intf.reset;
        end
    endtask
    //==========================================================================
    `GETTER(uvm_analysis_port#(vip_reset_monitor_item), ap)
endclass
`endif//VIP_RESET_MONITOR_SV