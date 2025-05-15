module avalon (
    input wire clk,
    input wire resetn,
    output reg valid,
    input wire ready,
    output reg [7:0] data
);
    parameter aguadar_FSM = 3'd0,
              aguadar_1ciclo = 3'd1,
              enviar_dado4 = 3'd2,
              enviar_dado5 = 3'd3,
              enviar_dado6 = 3'd4,
              termino_transmissao = 3'd5;

    reg [2:0] estado_atual, proximo_estado;

    always @(posedge clk or posedge resetn) begin
        if (resetn)
            estado_atual <= aguadar_FSM;
        else
            estado_atual <= proximo_estado;
    end

    always @(*) begin
        case (estado_atual)
            aguadar_FSM:
                proximo_estado = (ready) ? aguadar_1ciclo : aguadar_FSM;

            aguadar_1ciclo:
                proximo_estado = enviar_dado4;

            enviar_dado4:
                proximo_estado = (ready) ? enviar_dado5 : enviar_dado4;

            enviar_dado5:
                proximo_estado = (ready) ? enviar_dado6 : enviar_dado5;

            enviar_dado6:
                proximo_estado = (ready) ? termino_transmissao : enviar_dado6;

            termino_transmissao:
                proximo_estado = termino_transmissao;

            default:
                proximo_estado = aguadar_FSM;
        endcase
    end

    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            valid <= 0;
            data  <= 8'd0;
        end else begin
            case (proximo_estado)
                aguadar_FSM, aguadar_1ciclo, termino_transmissao: begin
                    valid <= 0;
                    data  <= 8'dX;  
                end

                enviar_dado4: begin
                    valid <= 1;
                    data  <= 8'd4;
                end

                enviar_dado5: begin
                    valid <= 1;
                    data  <= 8'd5;
                end

                enviar_dado6: begin
                    valid <= 1;
                    data  <= 8'd6;
                end

                default: begin
                    valid <= 0;
                    data  <= 8'dX;
                end
            endcase
        end
    end

endmodule

