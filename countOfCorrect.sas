%let n = 6;

data _NULL_;
	declare hash h (ordered:'a');
	rc=h.definekey('numberOfCorrect');
	rc=h.definedata('numberOfCorrect', 'Frequency');
	rc=h.definedone();
	array a{&n} _temporary_;

	do i=1 to &n;
		a[i]=i;
	end;

	do i=1 to fact(&n);
		call allperm(i, of a[*]);
		numberOfCorrect=0;
		do j=1 to &n;
			if j=a{j} then numberOfCorrect=numberOfCorrect+1;
		end;
		call missing(Frequency);
		rc=h.find();
		Frequency=sum(Frequency, 1);
		rc=h.replace();
	end;
	h.output (dataset: "count_Freq");
run;