/*
*jjjch, 6/21/2020;
*After reading the following two articles, I decided to implement it in SAS;

*ordering of binary variables;
*https://yetanothermathprogrammingconsultant.blogspot.com/2020/06/small-example-ordering-of-binary.html;
*Optimize with indexing in linear programming;
*https://stackoverflow.com/questions/62432731/optimize-with-indexing-in-linear-programming;
*/
data indata;
   input v @@;
   datalines;
1 3 6 4 7 9 6 2 3
;
run;

proc optmodel printlevel=2;
   set OBS;
   num v {OBS};
   read data indata into OBS=[_N_] v;

   var z >=0;
   var delta{OBS} binary;
   impvar y_left = sum {i in OBS} (1-delta[i])*v[i];
   impvar y_right = sum {i in OBS} delta[i]*v[i];
   impvar k = 1 + sum {i in OBS} (1-delta[i]);

   con def_delta{i in OBS diff {card(OBS)}}: delta[i+1]>=delta[i];
   con def_z1: -z <= y_left - y_right;
   con def_z2: y_left - y_right <= z;

   min my_obj = z;
   solve OBJECTIVE my_obj;
   create data outdata1 from [i=OBS] delta=delta;
   create data outdata2 from z k y_left y_right;
quit;
