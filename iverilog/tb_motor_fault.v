`timescale 1s/1ms

module tb_motor_fault;

reg clk = 0;
integer i = 0;

// Raw motor signals
wire [15:0] motor_current;
wire [15:0] vibration;
wire [15:0] temperature;
wire [15:0] rotor_flux;
wire [15:0] stator_flux;
wire [15:0] voltage;

// Processed signals
wire [15:0] avg_current;
wire [15:0] avg_vibration;
wire [15:0] avg_temperature;

// Fault output
wire [2:0] fault_type;

// Storage arrays for summary
reg [15:0] curr_store [1:10];
reg [15:0] vib_store  [1:10];
reg [15:0] temp_store [1:10];
reg [15:0] rf_store   [1:10];
reg [15:0] sf_store   [1:10];
reg [15:0] volt_store [1:10];
reg [2:0]  fault_store[1:10];

//////////////////////////////////////////////////////////
// Module Instantiation
//////////////////////////////////////////////////////////

motor_signal MS(
    .clk(clk),
    .motor_current(motor_current),
    .vibration(vibration),
    .temperature(temperature),
    .rotor_flux(rotor_flux),
    .stator_flux(stator_flux),
    .voltage(voltage)
);

feature_extract FE(
    .clk(clk),
    .motor_current(motor_current),
    .vibration(vibration),
    .temperature(temperature),
    .avg_current(avg_current),
    .avg_vibration(avg_vibration),
    .avg_temperature(avg_temperature)
);

classifier CL(
    .avg_current(avg_current),
    .avg_vibration(avg_vibration),
    .avg_temperature(avg_temperature),
    .rotor_flux(rotor_flux),
    .stator_flux(stator_flux),
    .voltage(voltage),
    .fault_type(fault_type)
);

//////////////////////////////////////////////////////////
// Clock Generation
//////////////////////////////////////////////////////////

always #0.5 clk = ~clk;

//////////////////////////////////////////////////////////
// LIVE ADVANCED OUTPUT + STORE DATA
//////////////////////////////////////////////////////////

always @(posedge clk) begin
    i = i + 1;

    // Store values
    curr_store[i]  = motor_current;
    vib_store[i]   = vibration;
    temp_store[i]  = temperature;
    rf_store[i]    = rotor_flux;
    sf_store[i]    = stator_flux;
    volt_store[i]  = voltage;
    fault_store[i] = fault_type;

    // Live detailed output
    $display("--------------------------------------------------");
    $display("Time = %0d sec", i);
    $display("Current=%0d  Vibration=%0d  Temp=%0d", 
              motor_current, vibration, temperature);
    $display("RotorFlux=%0d  StatorFlux=%0d  Voltage=%0d",
              rotor_flux, stator_flux, voltage);

    case(fault_type)
        3'b000: $display("STATUS: HEALTHY MOTOR");
        3'b001: $display("STATUS: ROTOR FAULT DETECTED");
        3'b010: $display("STATUS: STATOR FAULT DETECTED");
        3'b011: $display("STATUS: BEARING FAULT DETECTED");
        3'b100: $display("STATUS: VOLTAGE IMBALANCE DETECTED");
        default: $display("STATUS: UNKNOWN");
    endcase
end

//////////////////////////////////////////////////////////
// FINAL SUMMARY AT END
//////////////////////////////////////////////////////////

initial begin
    $dumpfile("motor.vcd");
    $dumpvars(0, tb_motor_fault);

    #10;

    $display("\n=========== FINAL SUMMARY ===========");

    for (i = 1; i <= 10; i = i + 1) begin
        $display("Time=%0d | Curr=%0d Vib=%0d Temp=%0d RF=%0d SF=%0d V=%0d | Fault=%03b",
            i,
            curr_store[i],
            vib_store[i],
            temp_store[i],
            rf_store[i],
            sf_store[i],
            volt_store[i],
            fault_store[i]);
    end

    $display("======================================\n");

    $finish;
end

endmodule
