`timescale 1ns/1ps

import p2s_pkg::*;

module tb;

  logic clk;
  logic rst_n;

  initial clk = '0;
  always #5ns clk = ~clk;

  initial begin
    rst_n = '0;
    repeat (3) @(posedge clk);
    rst_n = '1;
  end

  par_to_ser_if if0 (.clk, .rst_n);

  parallel_to_serial dut0 (if0);

  mailbox #(p2s_item_t) mbx_gen2drv = new();
  mailbox #(p2s_txn_t) mbx_mon2sb = new();

  localparam int NUM_ITEMS = P2S_DEFAULT_NUM_ITEMS;

  p2s_generator gen = new(mbx_gen2drv, NUM_ITEMS, 32'hDEAD_BEEF);
  p2s_driver drv = new(if0, mbx_gen2drv, NUM_ITEMS);
  p2s_monitor mon = new(if0, mbx_mon2sb);
  p2s_scoreboard sb = new(mbx_mon2sb, NUM_ITEMS);

  initial begin
    fork
      gen.run();
      drv.run();
      mon.run();
      sb.run();
    join_any
    disable fork;

    repeat (2) @(posedge clk);

    $finish;
  end

endmodule