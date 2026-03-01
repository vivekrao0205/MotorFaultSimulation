`timescale 1s/1ms

module motor_signal(
    input clk,
    output reg [15:0] motor_current,
    output reg [15:0] vibration,
    output reg [15:0] temperature,
    output reg [15:0] rotor_flux,
    output reg [15:0] stator_flux,
    output reg [15:0] voltage
);

integer time_sec = 0;

always @(posedge clk) begin
    time_sec = time_sec + 1;

    //  Healthy
    if(time_sec <= 2) begin
        motor_current <= 50;
        vibration <= 20;
        temperature <= 40;
        rotor_flux <= 100;
        stator_flux <= 100;
        voltage <= 230;
    end

    //  Rotor Fault
    else if(time_sec <= 4) begin
        motor_current <= 90;
        vibration <= 50;
        temperature <= 65;
        rotor_flux <= 50;
        stator_flux <= 100;
        voltage <= 230;
    end

    // Stator Fault
    else if(time_sec <= 6) begin
        motor_current <= 95;
        vibration <= 45;
        temperature <= 90;
        rotor_flux <= 100;
        stator_flux <= 40;
        voltage <= 230;
    end

    // Bearing Fault
    else if(time_sec <= 8) begin
        motor_current <= 70;
        vibration <= 85;
        temperature <= 50;
        rotor_flux <= 100;
        stator_flux <= 100;
        voltage <= 230;
    end

    // Voltage Unbalance
    else begin
        motor_current <= 60;
        vibration <= 30;
        temperature <= 50;
        rotor_flux <= 100;
        stator_flux <= 100;
        voltage <= 160;
    end
end

endmodule
