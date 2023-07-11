`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2023 18:18:18
// Design Name: 
// Module Name: shifter2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shifter2(
    input [25:0] A,
    output reg [27:0] Out
    );

always@(*)
begin
Out = {2'b00,(A<<2)};
end
endmodule
