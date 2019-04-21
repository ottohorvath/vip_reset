`ifndef SIMPLE_PKG_SV
`define SIMPLE_PKG_SV

package simple_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import vip_reset_pkg::*;

    `include "simple_env.sv"
    `include "simple_test.sv"
endpackage
`endif//SIMPLE_PKG_SV