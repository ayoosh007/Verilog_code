// Half Adder Module
module half_adder (
    input a, b,
    output sum, carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Full Adder Module
module full_adder (
    input a, b, cin,
    output sum, carry
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit Parallel Adder Module
module parallel_adder_4bit (
    input [3:0] A, B,  // 4-bit inputs
    input Cin,         // Carry input
    output [3:0] Sum,  // 4-bit sum output
    output Cout        // Carry output
);
    wire c1, c2, c3; // Internal carry signals

    full_adder fa0 (A[0], B[0], Cin, Sum[0], c1);
    full_adder fa1 (A[1], B[1], c1, Sum[1], c2);
    full_adder fa2 (A[2], B[2], c2, Sum[2], c3);
    full_adder fa3 (A[3], B[3], c3, Sum[3], Cout);
endmodule

// 4-bit Array Multiplier using Parallel Adders
module array_multiplier_4bit (
    input [3:0] A, B,   // 4-bit inputs
    output [7:0] P      // 8-bit product output
);
    wire [3:0] pp0, pp1, pp2, pp3; // Partial products
    wire [3:0] sum1, sum2, sum3;
    wire c1, c2, c3;

    // **Generate Partial Products using 16 AND Gates**
    assign pp0 = A & {4{B[0]}};
    assign pp1 = A & {4{B[1]}};
    assign pp2 = A & {4{B[2]}};
    assign pp3 = A & {4{B[3]}};

    // **Summation using 4-bit Parallel Adders**
    parallel_adder_4bit pa1 (pp1, {pp0[3:1], 1'b0}, 1'b0, sum1, c1);
    parallel_adder_4bit pa2 (pp2, {sum1[3:1], c1}, 1'b0, sum2, c2);
    parallel_adder_4bit pa3 (pp3, {sum2[3:1], c2}, 1'b0, sum3, c3);

    // **Assigning Final Output**
    assign P[0] = pp0[0];   // LSB
    assign P[1] = sum1[0];
    assign P[2] = sum1[1];
    assign P[3] = sum2[0];
    assign P[4] = sum2[1];
    assign P[5] = sum3[0];
    assign P[6] = sum3[1];
    assign P[7] = sum3[3] | c3;  // MSB

endmodule