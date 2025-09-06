%let homepath = J:\HCHS\STATISTICS\GRAS\QAngarita\LHS\LHS0001;

/*
	Program name: LHS00019901.sas	

	Description: Misc to explore the datasets

	Author: Alvaro Quijano

	Version:
			14may25: create the file from the original file (BIOS992 class)
					 
	Output: 

*/
libname raw "&homepath/data/raw" ACCESS=READONLY;
libname derv "&homepath/data/derived";
%include "&homepath./scripts/lhs000190/lhs000190.sas";
run;

* define macro variables;
%let prg = AQA;
%let db_in = raw.cokr72fl;
%let derv_01 = derv.lhs000101_05aug25;
%let derv_03 = derv.lhs000103_05aug25;
%let derv_04 = derv.lhs000104_30jul25;

proc freq data = &derv_01;
	table preceding_birth_interval_lt36 / list missing;
run;

/*
proc surveylogistic data = &derv_04.;
	cluster psu;
	strata strata; 
	weight weight;
	class age(ref='1') birth_weight_c4(ref="3") ethnicity_c3(ref="3") anc_quality_score_c3(ref='1') / param=ref;
	model died(event='1') = age preterm_birth ethnicity_c3 birth_weight_c4 anc_quality_score_c3;
run;
*/

* educ_c3 mage_birth skilled_birth_attendance urban age_1stbirth
				wealth_index birth_weight_c4;
