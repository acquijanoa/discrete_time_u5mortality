%let homepath = J:\HCHS\STATISTICS\GRAS\QAngarita\LHS\LHS0001;
%let job = LHS000102;
proc printto log = "&homepath./scripts/&job./&job._&sysdate..log" 
			print = "&homepath./scripts/&job./&job._&sysdate..lst" new;
run; 

/*
	Program name: LHS000102.sas	

	Description: Impute missing data in LHS000101

	Version: SAS 9.4
			
	Input:	&homepath./data/derived/lhs000101_24aug25

	Output: &homepath./data/derived/lhs000102_24aug25

*/
libname raw "&homepath/data/raw" access=readonly;
libname derv "&homepath/data/derived";
run;

* define macro variables;
%let db_out = derv.&job._&sysdate.; 
%let db_in = derv.lhs000101_24aug25;

* missing data pattern ;
proc mi data = &db_in seed = 220825 nimpute=10 out = db_out;
	class ethnicity_c3 mage_birth_c3 anc_quality_score_c2 any_substance_use wealth_index_c3 
			time_months_c6 meduc_c3 strata birth_order_spacing_c5 region;  
	var is_alive time_months_c6 meduc_c3 preterm_birth mage_birth_c3 wealth_index_c3 child_sex urban region
			anc_quality_score_c2 ethnicity_c3 birth_weight any_substance_use birth_order_spacing_c5 weight strata;
	fcs logistic(any_substance_use anc_quality_score_c2 / likelihood=augment);
	fcs reg(birth_weight);
	fcs discrim(ethnicity_c3 / classeffects=include);
run;

* update categorical variables;
data &db_out.;
	set db_out;
	
	* recode birth_weight_c3 after imputing values;
	if birth_weight < 2500 then birth_weight_c3 = 1; 
	    else if 2500 <= birth_weight < 4000 then birth_weight_c3 = 2; 
	    else if birth_weight >= 4000 then birth_weight_c3 = 3; 
	    else birth_weight_c3 = .; 
    	label birth_weight_c3 = "Birth weight (3-categories)";
run;
proc printto; run;
