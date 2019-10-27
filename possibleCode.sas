%let n = 11;

data _NULL_;
	declare hash h (ordered:'A');
	rc=h.definekey('max_connect_count');
	rc=h.definedata('max_connect_count', 'Frequency');
	rc=h.definedone();
	array a{&n} _TEMPORARY_;

	do i=1 to &n;
		a[i]=i;
	end;

	do i=1 to fact(&n);
		call allperm(i, of a[*]);
		max_connect_count=0;
		connect_count=0;

		do j=2 to &n;
			c=catx('_', a{j-1}, a{j});

			if c in ('1_2', '1_3', '1_4', '2_3', '2_4', '3_4'
		       , '2_1', '3_1', '4_1', '3_2', '4_2', '4_3') then
				connect_count=connect_count+1;
			else
				connect_count=0;
			max_connect_count=max(max_connect_count, connect_count);
		end;
		call missing(Frequency);
		rc=h.find();
		Frequency=sum(Frequency, 1);
		rc=h.replace();
	end;
	h.output (dataset: "max_connect_count_Freq");
run;

data _null_;
	myNumber=19*PERM(&n.-4+1, 3) * fact(&n.-4);
	put myNumber=;
run;