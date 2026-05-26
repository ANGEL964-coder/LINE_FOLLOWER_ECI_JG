module pwm (
    input  wire              clk,
    input  wire              rst_n,
    output reg               Q_motor_der,
    output reg               Q_motor_izq,
    input  wire signed [7:0] error
);

    reg [7:0] duty_motor_der;
    reg [7:0] duty_motor_izq;
    reg [7:0] cont;

    always @(*) begin
        duty_motor_der = error + 8'd192;
        duty_motor_izq = 8'd255 - duty_motor_der;
    end

    always @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin
            cont         <= 8'd0;
            Q_motor_der  <= 1'b0;
            Q_motor_izq  <= 1'b0;
        end
        else begin

            cont <= cont + 8'd1;

            // PWM izquierdo
            if (cont < duty_motor_izq)
                Q_motor_izq <= 1'b1;
            else
                Q_motor_izq <= 1'b0;

            // PWM derecho
            if (cont < duty_motor_der)
                Q_motor_der <= 1'b1;
            else
                Q_motor_der <= 1'b0;
        end
    end

endmodule
