`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 11:28:16
// Design Name: 
// Module Name: i2c_msb_TB
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


`timescale 1ns / 1ps

module i2c_msb_TB;

    // Inputs
    reg i_Clk;
    reg i_Rst;
    reg i_Enable;
    reg [6:0] i_Slave_addr;
    reg i_Wr_Start;
    reg i_Rd_Start;
    reg [7:0] i_Wr_Byte;

    // Outputs
    wire o_Busy;
    wire [7:0] o_Rd_Byte;
    wire o_Error;

    // Bidirectional signals
    wire io_scl;
    wire io_sda;

    // Instantiate the Unit Under Test (UUT)
    i2c_msb uut (
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
        .i_Enable(i_Enable),
        .i_Slave_addr(i_Slave_addr),
        .i_Wr_Start(i_Wr_Start),
        .i_Rd_Start(i_Rd_Start),
        .i_Wr_Byte(i_Wr_Byte),
        .o_Busy(o_Busy),
        .o_Rd_Byte(o_Rd_Byte),
        .o_Error(o_Error),
        .io_scl(io_scl),
        .io_sda(io_sda)
    );

    // Clock generation
    initial begin
        i_Clk = 0;
        forever #5 i_Clk = ~i_Clk; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        i_Rst = 1;
        i_Enable = 0;
        i_Slave_addr = 7'b1010101;
        i_Wr_Start = 0;
        i_Rd_Start = 0;
        i_Wr_Byte = 8'h00;

        // Apply reset
        #20;
        i_Rst = 0;
        i_Enable = 1;

        // Start write operation
        #20;
        i_Wr_Start = 1;
        i_Wr_Byte = 8'hA5;
        #20;
        i_Wr_Start = 0;

        // Wait for write operation to complete
        #200;

        // Start read operation
        #20;
        i_Rd_Start = 1;
        #20;
        i_Rd_Start = 0;

        // Wait for read operation to complete
        #200;

        // End simulation
        $finish;
    end

endmodule