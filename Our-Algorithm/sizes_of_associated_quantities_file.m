Q:=Log(abs_dis)/(Log(Log(abs_dis)));


bound_A:=2;
bl_size_beta:=2;//Floor(n/3);
bound_k:=StringToInteger(Read("integer_k_number_of_ideals_taken.m"));

if(n eq 10) then
	alpha:=0.935;
	fb_bound_B:=BachBound(K);//970357;
elif(n eq 15) then
	alpha:=0.990;
	fb_bound_B:=BachBound(K);//132526880;
elif(n eq 20) then
	alpha:=0.952 ;
	fb_bound_B:=BachBound(K);//883661511529;
elif(n eq 25) then
	alpha:=0.911 ;
	fb_bound_B:=BachBound(K);//997850477380847 ;
end if;
