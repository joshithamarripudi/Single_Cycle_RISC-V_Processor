`timescale 1ns / 1ps
module SCDataPath(
    input clk,
    input reset,
    output [31:0] aluout,
    output [31:0] Instruction,
    output [31:0] ALU_A,
    output [31:0] ALU_B,
    
    output memread,
    output memtoreg,
    output [1:0] aluop,
    output [2:0] alucontrol,
    output memwrite,
    output alusrc,
    output regdst,
    output [31:0] writedata,
    output regwrite,
    output [4:0] writereg,
    output [31:0] Read_reg_data_2,
    output [31:0] Readdata
    
    );    
wire [31:0] instruction;
wire [31:0] PC_plus_4;
wire [31:0] PC;
wire Jump;
wire jr;
wire reg1;
wire jal;
wire Branch;
wire bne;
wire MemRead;
wire MemtoReg;
wire [1:0] ALUOp;
wire MemWrite;
wire ALSrc;
wire RegDst;
wire [31:0] write_data;
wire RegWrite;
wire [4:0] write_reg;
wire [31:0]read_reg_data_1;
wire [31:0]read_reg_data_2;
wire [31:0] extended;
wire zero;
wire [31:0] ALU_out;
wire [2:0] ALU_control;
wire [31:0] read_data;
wire signed [31:0] shifted;
wire [31:0] adder2_result;
wire [31:0] mux4_result;
wire [27:0] Out;
wire [31:0] jr_address;
wire [4:0] read_reg_1;
wire [31:0] jal_address;
wire [4:0] write_reg_1;
wire [31:0] write_data_1; 

    
instruction_fetch if1(
.clk(clk),
.reset(reset),
.Jump(Jump),
.jr(jr),
.jal(jal),
.Branch(Branch),
.bne(bne),
.zero(zero),
.shifted(shifted),
.Jump_address(Out),
.jr_address(jr_address),
.jal_address(jal_address),
.instruction(instruction),
.PC(PC)
);

control c1(
    .opcode(instruction[31:26]),
    .RegDst(RegDst),
    .Jump(Jump),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .jr(jr),
    .reg1(reg1),
    .jal(jal),
    .bne(bne)
);

adder a1(
.A(PC),
.B(4),
.sum(PC_plus_4)
);

mux m1(
    .A(instruction[20:16]),
    .B(instruction[15:11]),
    .sel(RegDst),
    .Out(write_reg)   
);

mux m6(
    .A(instruction[25:21]),
    .B(instruction[4:0]),
    .sel(reg1),
    .Out(read_reg_1)   
);

mux m7(
    .A(write_reg),
    .B(5'b11111),
    .sel(jal),
    .Out(write_reg_1)   
);

mux m8(
    .A(write_data),
    .B(jal_address),
    .sel(jal),
    .Out(write_data_1)   
);

mux m3(
    .A(ALU_out),
    .B(read_data),
    .sel(MemtoReg),
    .Out(write_data)
);

data_memory d1(
    .address(ALU_out),
    .write_data(read_reg_data_2),
    .read_data(read_data),
    .mem_read(MemRead),
    .mem_write(MemWrite),
    .clk(clk)
);

register_file r1(
    .read_reg_1(read_reg_1),
    .read_reg_2(instruction[20:16]),
    .write_reg(write_reg_1),
    .write_data(write_data_1),
    .read_reg_data_1(read_reg_data_1),
    .read_reg_data_2(read_reg_data_2),
    .RegWrite(RegWrite),
    .clk(clk)
);

assign jr_address = read_reg_data_1;

sign_extender ex1(
    .A(instruction[15:0]),
    .OUT(extended)
);

mux m2(
    .A(read_reg_data_2),
    .B(extended),
    .sel(ALUSrc),
    .Out(ALU_B) 
);

ALU_control ALUc(
    .ALUOp(ALUOp),
    .funct(instruction[5:0]),
    .ALU_control(ALU_control)
);

ALU alu1(
    .ALU_src_1(read_reg_data_1),
    .ALU_src_2(ALU_B),
    .ALU_control(ALU_control),
    .shamt(instruction[10:6]),
    .ALU_out(ALU_out),
    .zero(zero),
    .clk(clk)
);

shifter s1(
    .A(extended),
    .Out(shifted)   
);

adder a2(
.A(PC_plus_4),
.B(shifted),
.sum(adder2_result)
);

mux m4(
    .A(PC_plus_4),
    .B(adder2_result),
    .sel(Branch & zero),
    .Out(mux4_result)    
);

shifter2 s2(
    .A(instruction[25:0]),
    .Out(Out)  
);

mux m5(
    .A(mux4_result),
    .B({PC_plus_4, Out}),
    .sel(Jump),
    .Out(PC)    
);

assign aluout = ALU_out;
assign Instruction = instruction; 
assign ALU_A = read_reg_data_1;


assign memread = MemRead;
assign memtoreg = MemtoReg;              
assign aluop = ALUOp;            
assign memwrite = MemWrite;              
assign alusrc =ALUSrc;                 
assign regdst = RegDst;                
assign writedata = write_data;       
assign regwrite = RegWrite;               
assign writereg = write_reg;     
assign Read_reg_data_2 = read_reg_data_2; 
assign Readdata = read_data;
assign alucontrol = ALU_control;         

endmodule