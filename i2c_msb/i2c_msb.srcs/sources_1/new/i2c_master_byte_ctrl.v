`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 11:34:16
// Design Name: 
// Module Name: i2c_master_byte_ctrl
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


module i2c_master_byte_ctrl (
    input clk,
    input rst,
    input nReset,
    input ena,
    input [15:0] clk_cnt,
    input start,
    input stop,
    input read,
    input write,
    input ack_in,
    input [7:0] din,
    output reg cmd_ack,
    output ack_out,
    output reg [7:0] dout,
    output i2c_busy,
    output i2c_al,
    input scl_i,
    output scl_o,
    output scl_oen,
    input sda_i,
    output sda_o,
    output sda_oen
);

// Internal signals
reg [7:0] shift_reg; // Shift register for data
reg [3:0] bit_cnt;   // Bit counter
reg sda_out;         // SDA output
reg scl_out;         // SCL output
reg busy;            // Busy signal

// Initialize outputs
assign scl_o = scl_out;
assign sda_o = sda_out;
assign scl_oen = ~scl_out;
assign sda_oen = ~sda_out;
assign i2c_busy = busy;
assign ack_out = ~shift_reg[0]; // Acknowledge bit

// Main state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_reg <= 8'h00;
        bit_cnt <= 4'h0;
        sda_out <= 1'b1;
        scl_out <= 1'b1;
        busy <= 1'b0;
        cmd_ack <= 1'b0;
        dout <= 8'h00;
    end else if (nReset) begin
        if (ena) begin
            if (start) begin
                // Start condition
                sda_out <= 1'b0;
                scl_out <= 1'b1;
                busy <= 1'b1;
                bit_cnt <= 4'h8;
                shift_reg <= din;
            end else if (stop) begin
                // Stop condition
                sda_out <= 1'b0;
                scl_out <= 1'b1;
                busy <= 1'b0;
            end else if (read || write) begin
                // Data transfer
                if (bit_cnt > 0) begin
                    scl_out <= ~scl_out;
                    if (scl_out) begin
                        if (write)
                            sda_out <= shift_reg[7];
                        shift_reg <= {shift_reg[6:0], 1'b0};
                        bit_cnt <= bit_cnt - 1;
                    end
                end else begin
                    cmd_ack <= 1'b1;
                    dout <= shift_reg;
                end
            end
        end
    end
end

endmodule