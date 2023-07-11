`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:29 03/20/2023 
// Design Name: 
// Module Name:    instruction_memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module instruction_memory(
    input [31:0] read_address,
    input reset,
    output [31:0] instruction
    );

reg [7:0] Mem [115:0];
assign instruction = {Mem[read_address], Mem[read_address+1], Mem[read_address+2], Mem[read_address+3]};

initial
begin
			$readmemh("instruction_mem.mem", Mem);
end

endmodule
