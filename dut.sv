`timescale 1ns/1ps
import p2s_pkg::*;

module parallel_to_serial (par_to_ser_if.DUT ifc);

   logic [P2S_SERIAL_LEN-1:0] shift_register;

   assign ifc.serial_out = shift_register[0];

   always_ff @(posedge ifc.clk, negedge ifc.rst_n)
   begin
      if(!ifc.rst_n)
         shift_register <= '0;
      else if(ifc.load)
         shift_register <= ifc.parallel_in;
      else
         shift_register <= {1'b0, shift_register[P2S_SERIAL_LEN-1:1]};
   end
endmodule