interface par_to_ser_if #(
    parameter int SERIAL_LEN = 8
)(
    input logic clk,
    input logic rst_n
);

logic load;
logic [7:0] parallel_in;
logic serial_out;

clocking cb_drv @(posedge clk);
    default input #1step output #1step;
    output load, parallel_in;
    input serial_out;
endclocking

clocking cb_mon @(posedge clk);
    default input #1step;
    input load, parallel_in, serial_out;
endclocking

modport DRV (clocking cb_drv, input clk, rst_n);
modport MON (clocking cb_mon, input clk, rst_n);
modport DUT (
    input clk, rst_n, load, parallel_in,
    output serial_out
);