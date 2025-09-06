%let homepath = J:\HCHS\STATISTICS\GRAS\QAngarita\LHS\LHS0001;
%let job = lhs000199;
%let subjob = lhs00019902;

proc printto log = "&homepath./scripts/&job./&subjob._&sysdate..log"
	print = "&homepath./scripts/&job./&subjob._&sysdate..lst" new;
run;

/*
	
	Program: LHS00019902.sas

	Description: Produce the missing data report for the dhs 2015 
				child_recode dataset
	
	Programmer: Alvaro Quijano-Angarita

	Date: 15may25

	Version:
				15may25: Create the file


*/
options nodate nonumber;

* include SAS code for formats and macros;
%include "&homepath./scripts/lhs000190/lhs000190.sas";
%include "&homepath./scripts/lhs000191/lhs00019102.sas";

* set libraries;
libname raw "&homepath/data/raw" ACCESS=READONLY;
libname derv "&homepath/data/derived";
run;

* define macro variables;
%let prg = AQA;
%let db_in = ;

* Create a missing data report (dhs2015);
%missing_report(data = raw.cokr72fl, 
					outpath = &homepath./scripts/&job./,
					outname = &subjob._missing_dhs15_&sysdate.,
					subtitle = 'DHS 2015 (cokr72fl)');

* Create a missing data report (dhs2010);
%missing_report(data = raw.cokr61fl, 
					outpath = &homepath./scripts/&job./,
					outname = &subjob.missing_dhs10_&sysdate.,
					subtitle = 'DHS 2010 (cokr61fl)');

proc printto; run;
