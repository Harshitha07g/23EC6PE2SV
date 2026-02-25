module atm_controller_tb;

logic clk;
logic rst;
logic card_inserted;
logic pin_correct;
logic balance_ok;
logic dispense_cash;

atm_controller dut (
    .clk(clk),
    .rst(rst),
    .card_inserted(card_inserted),
    .pin_correct(pin_correct),
    .balance_ok(balance_ok),
    .dispense_cash(dispense_cash)
);

always #5 clk = ~clk;

//////////////////////////////////////////////////
// Functional Coverage
//////////////////////////////////////////////////

covergroup atm_cg @(posedge clk);

    // State + Transition Coverage
    coverpoint dut.current_state {

        bins idle      = {dut.IDLE};
        bins check_pin = {dut.CHECK_PIN};
        bins dispense  = {dut.DISPENSE};

        bins idle_to_check   = (dut.IDLE => dut.CHECK_PIN);
        bins check_to_disp   = (dut.CHECK_PIN => dut.DISPENSE);
        bins check_to_idle   = (dut.CHECK_PIN => dut.IDLE);
        bins disp_to_idle    = (dut.DISPENSE => dut.IDLE);
    }

    // Output coverage
    coverpoint dispense_cash {
        bins zero = {0};
        bins one  = {1};
    }

endgroup

atm_cg cg;

//////////////////////////////////////////////////
// Assertion
//////////////////////////////////////////////////

property dispense_rule;
    @(posedge clk)
    dispense_cash |-> (pin_correct && balance_ok);
endproperty

assert property (dispense_rule);

//////////////////////////////////////////////////
// Test Stimulus
//////////////////////////////////////////////////

initial begin
    clk = 0;
    rst = 1;

    card_inserted = 0;
    pin_correct   = 0;
    balance_ok    = 0;

    cg = new();

    #10 rst = 0;

    // 1️⃣ Invalid PIN
    card_inserted = 1; #10;
    card_inserted = 0;
    pin_correct = 0;
    balance_ok  = 1; #10;

    // 2️⃣ Valid PIN, low balance
    card_inserted = 1; #10;
    card_inserted = 0;
    pin_correct = 1;
    balance_ok  = 0; #10;

    // 3️⃣ Valid transaction
    card_inserted = 1; #10;
    card_inserted = 0;
    pin_correct = 1;
    balance_ok  = 1; #10;

    #20;

    $display("Coverage = %0.2f %%", cg.get_coverage());
    $finish;
end

//////////////////////////////////////////////////
// Dump file
//////////////////////////////////////////////////

initial begin
    $dumpfile("atm_controller.vcd");
    $dumpvars(0, atm_controller_tb);
end

endmodule
