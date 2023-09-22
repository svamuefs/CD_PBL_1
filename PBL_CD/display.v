//display_decoder 3 in 7 out

module display (
    input [2:0] user ,
    output [6:0] output_segments
	 
);


    wire [2:0] not_user;

        not not_user_1 [2:0] (not_user , user);


    wire [6:0] T1 , T2 , T3;
    
//abc = user bits , a = [2] ... c  = [0]

//b~c + a A

//b~c
    and and_term_01 (T1[0] , user[1] , not_user[0] );
//a
    and and_term_02 (T2[0] , user[2] );
    or or_terms_0 (output_segments[0] , T1[0] , T2[0]);


//~ab~c + a~b~c + abc B

//~ab~c
    and and_term_11 (T1[1] , not_user[2] , user[1] , not_user[0] );       
//a~b~c
    and and_term_12 (T2[1] , user[2] , not_user[1] , not_user[0] );       
//abc
    and and_term_13 (T3[1] , user[2] , user[1] , user[0] );
    or or_terms_1 (output_segments[1] , T1[1] , T2[1] , T3[1]);


//~ab + a~b~c + bc C

//~ab
    and and_term_21 (T1[2] , not_user[2] , user[1] );
//a~b~c
    and and_term_22 (T2[2] , user[2] , not_user[1] , not_user[0] );       
//bc
    and and_term_23 (T3[2] , user[1] , user[0] );
    or or_terms_2 (output_segments[2] , T1[2], T2[2] , T3[2]);

// b~c + a D

//b~c
    and and_term_31 (T1[3] , user[1] , not_user[0] );
//a
    and and_term_32 (T2[3] , user[2] );
    or or_terms_3 (output_segments[3] , T1[3] , T2[3]);


//~bc + b~c + a E

//~bc
    and and_term_41 (T1[4] , not_user[1] , user[0] );
//b~c
    and and_term_42 (T2[4] , user[1] , not_user[0] );
//a
    and and_term_43 (T3[4] , user[2] );
    or or_terms_4 (output_segments[4] , T1[4] , T2[4] , T3[4]);


//c + ~ab + a~b F

//c
    and and_term_51 (T1[5] , user[0] );
//~ab
    and and_term_52 (T2[5] , not_user[2] , user[1] ); 
//a~b
    and and_term_53 (T3[5] , user[2] , not_user[1] );
    or or_terms_5 (output_segments[5] , T1[5] , T2[5] , T3[5]);

//~a~c + ac + ~b~c G

//~a~c
    and and_term_61 (T1[6] , not_user[2] , not_user[0] ); 
//ac
    and and_term_62 (T2[6] , user[2] , user[0] );         
//~b~c
    and and_term_63 (T3[6] , not_user[1] , not_user[0] ); 
    or or_terms_6 (output_segments[6] , T1[6] , T2[6] , T3[6]);

endmodule


