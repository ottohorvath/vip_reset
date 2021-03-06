`ifndef VIP_RESET_DRIVER_SV
`define VIP_RESET_DRIVER_SV

class vip_reset_driver extends uvm_driver #(vip_reset_seq_item);
    `uvm_component_utils(vip_reset_driver)

    protected virtual vip_reset_signal_if       intf;
    protected vip_reset_agent_configuration     configuration;
    protected bit                               new_item_rcvd;
    protected event                             clock_tick_e;

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
        intf.agent_is_active = 1'b1;
    endfunction
    //==========================================================================

    //==========================================================================
    task
    run_phase(uvm_phase phase);
        if (configuration.get_reset_active_low())
        begin
            intf.rst_drv = 1'b1;
        end else begin
            intf.rst_drv = 1'b0;
        end
        if (configuration.get_start_with_auto_reset())
        begin
            vip_reset_seq_item      auto_reset_item;
            auto_reset_item                  = vip_reset_seq_item::type_id::create("auto_reset_item");
            auto_reset_item.request          = configuration.get_auto_reset_type();
            auto_reset_item.before_assertion = 3.0;
            auto_reset_item.during_assertion = 2.0 ;
            req = auto_reset_item;
            new_item_rcvd = 1;
        end
        fork
            process_incoming_requests();
            reset_driver();
            monitor_clock();
        join
    endtask
    //==========================================================================

    //==========================================================================
    protected task
    process_incoming_requests();
        forever
        begin
            seq_item_port.get_next_item(req);
            new_item_rcvd = 1;
            wait (new_item_rcvd == 0);
            seq_item_port.item_done();
        end
    endtask
    //==========================================================================

    //==========================================================================
    protected task
    reset_driver();
        forever
        begin
            wait(new_item_rcvd);
            void'(req.begin_tr());
            case(req.request)
                vip_reset_types::ASYNC:
                begin
                    if (req.before_assertion > 0.0)
                    begin
                        # (req.before_assertion);
                    end
                    assert_reset();
                    # (req.during_assertion);
                    deassert_reset();
                end
                vip_reset_types::ASYNC_SYNC:
                begin
                    if (req.before_assertion > 0.0)
                    begin
                        # (req.before_assertion);
                    end
                    if (clock_tick_e.triggered)
                    begin
                        `uvm_warning(`GTN, "Reset assertion coincided with clock tick, nothing is driven out!")
                    end else begin
                        assert_reset();
                        @ (clock_tick_e);
                        deassert_reset();
                    end
                end
                vip_reset_types::SYNC:
                begin
                    if (clock_tick_e.triggered)
                    begin
                        assert_reset();
                    end else begin
                        @ (clock_tick_e);
                        assert_reset();
                    end
                    @ (clock_tick_e);
                    deassert_reset();
                end
            endcase
            req.end_tr();
            new_item_rcvd = 0;
        end
    endtask
    //==========================================================================

    //==========================================================================
    protected task
    monitor_clock();
        forever
        begin
            intf.wait_posedge_clock();
            -> clock_tick_e;
        end
    endtask
    //==========================================================================

    //==========================================================================
    protected function void
    assert_reset();
        intf.reset = (configuration.get_reset_active_low()) ? (0):(1);
    endfunction
    //==========================================================================

    //==========================================================================
    protected function void
    deassert_reset();
        intf.reset = (configuration.get_reset_active_low()) ? (1):(0);
    endfunction
    //==========================================================================
endclass
`endif//VIP_RESET_DRIVER_SV