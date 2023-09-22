module bufferif_3bit (
    input [2:0] bufin,
    input control,
    output [2:0] bufout
);
    
    and and_buf [2:0] (bufout , bufin , control);

endmodule