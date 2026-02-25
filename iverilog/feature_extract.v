module feature_extract(
    input clk,
    input [15:0] motor_current,
    input [15:0] vibration,
    input [15:0] temperature,
    output reg [15:0] avg_current,
    output reg [15:0] avg_vibration,
    output reg [15:0] avg_temperature
);

reg [31:0] sum_current = 0;
reg [31:0] sum_vibration = 0;
reg [31:0] sum_temperature = 0;
reg [7:0] count = 0;

always @(posedge clk) begin
    sum_current    <= sum_current + motor_current;
    sum_vibration  <= sum_vibration + vibration;
    sum_temperature<= sum_temperature + temperature;

    count <= count + 1;

    if(count == 2) begin
        avg_current     <= sum_current / 10;
        avg_vibration   <= sum_vibration / 10;
        avg_temperature <= sum_temperature / 10;

        sum_current = 0;
        sum_vibration = 0;
        sum_temperature = 0;
        count = 0;
    end
end

endmodule

// cd iverilog
// iverilog -o motor_sim *.v
// vvp motor_sim
// gtkwave motor.vcd

// iverilog -o motor_sim *.v; vvp motor_sim; gtkwave motor.vcd

// iverilog -o motor_sim *.v
// vvp motor_sim
// dir motor.vcd
// gtkwave motor.vcd
