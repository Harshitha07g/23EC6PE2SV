`timescale 1ns/1ps

interface clock_if (input logic clk);

    logic reset;
    logic [5:0] seconds;
    logic [5:0] minutes;

    modport DUT (
        input  clk, reset,
        output seconds, minutes
    );

    modport TB (
        input  clk,
        output reset,
        input  seconds, minutes
    );

endinterface
