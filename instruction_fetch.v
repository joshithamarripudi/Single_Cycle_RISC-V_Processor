`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:03 03/20/2023 
// Design Name: 
// Module Name:    instruction_fetch 
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
module instruction_fetch(
    input clk,
    input reset,
    input Jump,
    input jr,
    input Branch,
    input bne,
    input zero,
    input jal,
    input signed [31:0] shifted,
    input [27:0] Jump_address,
    input [31:0] jr_address,
    output [31:0] jal_address,
    output [31:0] instruction,
    output reg [31:0] PC
    );

instruction_memory I1 (
.read_address(PC),
.reset(reset),
.instruction(instruction)
);

wire [31:0] PC_plus_four;
assign PC_plus_four = PC + 4;
assign jal_address = PC + 8;


always@(posedge clk)
begin
if(reset == 0)
	PC <= 0;
	
else if(Branch && zero)
    PC <= PC + 4 + shifted;
    
else if(bne && !zero)
    PC <= PC + 4 + shifted;
    
else if(Jump)
    PC <= {PC_plus_four[31:28],Jump_address};
    
else if(jr)
    PC <= jr_address;    
    
else 
	PC <= PC + 4;
end 

endmodule
