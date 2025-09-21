module parallel_to_serial
(input clk,
input load,
input [7:0] parallel_in,
output serial_out);
reg [7:0] shift_register;
always_ff @ (posedge clk) begin
  for (int i = 0; i < 7; i++)
     shift_register [i] <= load ? parallel_in [i] : shift_register [i+1];
  shift_register [7] <= parallel_in [7];
 // A more “standard” approach would be (Why didn’t I do that?) :
 // shift_register [7:0] <= load ? parallel_in : {1’b0,shift_register [7:1]};
end
assign serial_out = shift_register [0];
endmodule