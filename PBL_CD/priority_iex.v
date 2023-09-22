module priority_iex (

	input priority , use_priority ,
	output priority_ie1 , priority_ie2

);

//~b + a , decide o controle dos buffers ie1 da prioridade
    not not_1 (not_use_priority_w , use_priority);//~b
	or or_1 (priority_ie1 , priority , not_use_priority_w);//~b + a

//nand(ab) , decide o controle dos buffers ie2 da prioridade

	nand nand_1 (priority_ie2 , priority , use_priority);

endmodule 