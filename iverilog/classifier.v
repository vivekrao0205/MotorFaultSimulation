module classifier(
    input [15:0] motor_current,
    input [15:0] vibration,
    input [15:0] temperature,
    input [15:0] rotor_flux,
    input [15:0] stator_flux,
    input [15:0] voltage,
    output reg [2:0] fault_type
);

always @(*) begin

    if (voltage < 180)
        fault_type = 3'b100;

    else if (vibration > 80)
        fault_type = 3'b011;

    else if (stator_flux < 60 && temperature > 80)
        fault_type = 3'b010;

    else if (rotor_flux < 60 && motor_current > 80)
        fault_type = 3'b001;

    else
        fault_type = 3'b000;

end

endmodule
