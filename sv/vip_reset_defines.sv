`ifndef VIP_RESET_DEFINES_SV
`define VIP_RESET_DEFINES_SV

`define GETTER(type,var)\
function ``type`` get_``var``();\
    return ``var``;\
endfunction

`define SETTER(type,var)\
function void set_``var``(input ``type`` ``var``_);\
    ``var``=``var``_;\
endfunction

`define TESTER(type,var)\
function bit is_``var``(input ``type`` ``var``_);\
    return (``var`` == ``var``_);\
endfunction

`define ACCESSOR(type,var)\
`GETTER(``type``,``var``)\
`SETTER(``type``,``var``)\
`TESTER(``type``,``var``)

`ifndef GTN
    `define GTN get_type_name()
`endif

`ifndef CHK
`define CHK(expr, msg, sev=error, id=`GTN) \
    if (!(``expr``))\
        `uvm_``sev``(``id``, $sformatf("Failed (%s) '%s' ", `"expr`", ``msg``))
`endif

`ifndef CHK_FATAL
`define CHK_FATAL(expr, msg, id=`GTN) \
    `CHK(``expr``,``msg``,fatal,``id``)
`endif

`ifndef CHK_RAND
`define CHK_RAND(var, with_c) \
    `CHK_FATAL(``var``.randomize() ``with_c``,"Randomize failed!")
`endif

`ifndef CHK_STD_RAND
`define CHK_STD_RAND(vars, with_c) \
    `CHK_FATAL(std::randomize``vars`` ``with_c``,"Randomize failed!")
`endif

`endif//VIP_RESET_DEFINES_SV