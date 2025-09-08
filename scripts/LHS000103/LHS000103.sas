%let homepath = <INSERT THE PATH TO THE ROOT FOLDER>;
%let job = LHS000103;
proc printto log = "&homepath./scripts/&job./&job._&sysdate..log" 
			print = "&homepath./scripts/&job./&job._&sysdate..lst" new;
run; 

/*
	Program name: LHS000103.sas	

	Description: convert wide format imputed data 
				to time-months format data

	Version: SAS 9.4

	Input:  ../data/derived/lhs000102_24aug25.sas7bdat

	Output: ../data/derived/lhs000103_24aug25.sas7bdat
			../scripts/lhs000104/lhs000104_contents_24aug25.rtf

*/
libname raw "&homepath/data/raw" ACCESS=READONLY;
libname derv "&homepath/data/derived";
run;

* define macro variables;
%let db_out = derv.&job._&sysdate.; 
%let db_in = derv.lhs000102_24aug25;

* process dataset;
data &db_out.(label = 'DHS 2015 - Derived Variables using child recode data (Person-month format)');
	set &db_in.;
			
	* Creating the exposure by AGE;
		do age = 1 to ceil(time_months_c6);

		    if age = ceil(time_months_c6) and age_death = time_months then died = 1;
		    else died = 0;
		    label died = "event indicator (1=death at current age, 0=alive)";

		    output;
		end;
run;

ods rtf file = "&homepath./scripts/&job./&job._contents_&sysdate..rtf";
proc contents data = &db_out.;
run;
ods rtf close;

proc printto; run;
