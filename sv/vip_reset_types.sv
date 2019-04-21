`ifndef VIP_RESET_TYPES_SV
`define VIP_RESET_TYPES_SV

class vip_reset_types;

    typedef enum bit [1:0]
    {
        ASYNC,
        ASYNC_SYNC,
        SYNC
    } pulse_t;

    typedef enum bit
    {
        POSEDGE,
        NEGEDGE
    } change_t;

endclass
`endif//VIP_RESET_TYPES_SV