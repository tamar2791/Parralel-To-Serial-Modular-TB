package p2s_pkg;

    parameter int P2S_DEFAULT_NUM_ITEMS = 10;
    parameter int P2S_SERIAL_LEN = 8;

    typedef struct packed {
        logic [7:0] data;
    } p2s_item_t;

    typedef struct packed {
        logic [7:0] par;
        logic [7:0] ser;
    } p2s_txn_t;
    
endpackage