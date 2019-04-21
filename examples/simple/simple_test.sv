`ifndef SIMPLE_TEST_SV
`define SIMPLE_TEST_SV

class simple_test extends uvm_test;
    `uvm_component_utils(simple_test)

    simple_env           env;
    vip_reset_sequence   seq;

    //==========================================================================
    function new(string name="simple_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction
    //==========================================================================

    //==========================================================================
    function void
    build_phase(uvm_phase phase);
        env = simple_env::type_id::create("env",this);
        uvm_top.enable_print_topology = 1;
    endfunction
    //==========================================================================

    //==========================================================================
    task
    run_phase(uvm_phase phase);
        phase.raise_objection(this,"Starting test!");
        // Async-sync is tested by the auto reset config
        #100;
        // Async
        seq = vip_reset_sequence::type_id::create("reset_seq");
        seq.request          = vip_reset_types::ASYNC;
        seq.before_assertion = 6.0;
        seq.during_assertion = 8.0;
        seq.start(env.rst_agt.get_sequencer());
        #100;
        // Sync
        seq.request          = vip_reset_types::SYNC;
        // Delays below should not matter
        seq.before_assertion = 6.0;
        seq.during_assertion = 8.0;
        seq.start(env.rst_agt.get_sequencer());
        #100;
        phase.drop_objection(this,"Ending test!");
    endtask
    //==========================================================================
endclass
`endif//SIMPLE_TEST_SV