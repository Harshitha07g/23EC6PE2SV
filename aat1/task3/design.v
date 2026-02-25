module atm_controller (
    input  logic clk,
    input  logic rst,
    input  logic card_inserted,
    input  logic pin_correct,
    input  logic balance_ok,
    output logic dispense_cash
);

typedef enum logic [1:0] {
    IDLE,
    CHECK_PIN,
    DISPENSE
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always_comb begin
    next_state = current_state;
    dispense_cash = 0;

    case (current_state)

        IDLE:
            if (card_inserted)
                next_state = CHECK_PIN;

        CHECK_PIN:
            if (pin_correct && balance_ok)
                next_state = DISPENSE;
            else
                next_state = IDLE;

        DISPENSE: begin
            dispense_cash = 1;
            next_state = IDLE;
        end

    endcase
end

endmodule
