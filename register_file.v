`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:24 03/20/2023 
// Design Name: 
// Module Name:    register_file 
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
module register_file(
    input [4:0] read_reg_1,
    input [4:0] read_reg_2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_reg_data_1,
    output [31:0] read_reg_data_2,
    input RegWrite,
    input clk
    );
	 
reg [31:0] regMem [31:0];
initial begin
	$readmemh("register_mem.mem", regMem);
	end
	
	
always@(posedge clk) 
begin
	if(RegWrite)
		regMem[write_reg] = write_data;
end

assign read_reg_data_1 = regMem[read_reg_1];
assign read_reg_data_2 = regMem[read_reg_2];
	

endmodule
