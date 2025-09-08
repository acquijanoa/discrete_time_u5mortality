%let homepath = <INSERT THE PATH TO THE ROOT FOLDER>;
%let job = LHS000106;
proc printto log = "&homepath./scripts/&job./&job._&sysdate..log" 
			print = "&homepath./scripts/&job./&job._&sysdate..lst" new;
run; 

/*
	Program name: LHS000106.sas	

	Description: Generate Table 2 including univariate descriptive 
				analysis, but with frequencies and weighted percentage.

	Version: SAS 9.4

	Input:  &homepath./data/derived/lhs000101_24aug25

	Output: &homepath/scripts/lhs000106/lhs000106_T2_24aug25.rtf

*/
options nodate nonumber;

libname raw "&homepath/data/raw" ACCESS=READONLY;
libname derv "&homepath/data/derived";
libname hchstyle 'J:\hchs\sc\styledef\sty904';

* Include files;
%include "&homepath./scripts/lhs000190/lhs000190.sas";
%include "&homepath./scripts/lhs000191/lhs00019101.sas";

ods escapechar "^";

* define macro variables;
%let db_out = derv.&job._&sysdate.; 
%let db_in_15 = derv.lhs000101_24aug25;

* create the variable death;
data db_in_15;
	set &db_in_15.;
	death = (is_alive = 0);
run;

* Number of ids;
proc sql noprint;
	select count(distinct(cats(womenid,birthid))) into:n_births 
	from &db_in_15.; 
quit;

%macro design_based_pct_byvar(var=);
* Calculate design-based percentage and frequencies ;
proc surveyfreq data = db_in_15 missing; 
	cluster psu; 
	strata strata;
	weight weight;
	table  &var. / nototal ;
	ods output OneWay=OneWay(keep=&var. Frequency Percent rename=(&var.=ClassVal1));
run; 
* Number of deaths;
proc surveyfreq data = db_in_15 missing; 
	cluster psu; 
	strata strata;
	weight weight;
	table death * &var. / nototal row;
	ods output CrossTabs=CrossTabs( keep=&var. death Frequency RowPercent
						rename=(&var.=ClassVal1 RowPercent=Per_d Frequency=Freq_d) where=(death=1) );
run;
* Merge the dataset with percentages and ChisQ p-value;
	data &var._out;
		merge OneWay Crosstabs(drop=death);
		by ClassVal1;
		length  Variable $50;
		Variable = "&var.";
	run;
%mend design_based_pct_byvar;

* Use the macro to calculate percentages;
%design_based_pct_byvar(var = time_months_c6);
%design_based_pct_byvar(var = birth_weight_c3);
%design_based_pct_byvar(var = preterm_birth);
%design_based_pct_byvar(var = child_sex);
%design_based_pct_byvar(var = mage_birth_c3);
%design_based_pct_byvar(var = meduc_c3);
%design_based_pct_byvar(var = ethnicity_c3);
%design_based_pct_byvar(var = anc_quality_score_c2);
%design_based_pct_byvar(var = any_substance_use);
%design_based_pct_byvar(var = wealth_index_c3);
%design_based_pct_byvar(var = urban);
%design_based_pct_byvar(var = birth_order_spacing_c5);

* Join the datasets;
data db_join;
	set time_months_c6_out urban_out birth_weight_c3_out birth_order_spacing_c5_out
			child_sex_out meduc_c3_out ethnicity_c3_out preterm_birth_out
			wealth_index_c3_out anc_quality_score_c2_out any_substance_use_out mage_birth_c3_out;
	by variable;
run;

* Insert label to the dataset;
data db_join;
	set db_join;
	* call the macro to create the column label to print in the report;
	%labels;
	* adjust percent;
	percent = percent/100;
	per_d = per_d/100;
run;

* Print RTF report;
libname hchstyle 'J:\hchs\sc\styledef\sty904';
ods listing close;
ods path sashelp.tmplmst(read) hchstyle.hchs_stp(read);
ods rtf file = "&homepath\scripts\&job.\&job._T2_&sysdate..rtf" style = manuscrt bodytitle;
%let fs = 11pt;
%let fs_body = 11pt;
%let fs_titles = 11pt;
%let lft_mgn = 1.3in;
%let rgt_mgn = 1.1in;
proc report data = db_join;
	title j=center height=11pt font='times roman' bold "^S={leftmargin=1.2in rightmargin=1.1in}Table 2. Child and Maternal socioeconomic factors by child survival status, DHS 2015 (N=%qtrim(&n_births))";
	footnote1 j=left height=9.5pt font='times roman' "^S={leftmargin=&lft_mgn rightmargin=&rgt_mgn}Note: Percentages are weighted using sampling weights and account for complex survey design.";
	footnote3 j=left height=10pt font='times roman' "{\line \line Job &job run using DHS2015 data on %sysfunc(today(), date9.) at %qtrim(%sysfunc(time(), timeampm.))}";
	columns order label frequency percent freq_d per_d;
	define order / order group noprint order = internal;
	define label / display group ' ' style(header)=[just=left] style=[width = 3.5in];
	define frequency / analysis 'N' style=[vjust = bottom];
	define percent / analysis "Weighted %" style=[vjust=bottom just=right width=0.8in]; 
	define freq_d / analysis 'Deaths' style=[vjust = bottom];
	define per_d / analysis "Weighted %" style=[vjust=bottom just=right width=0.8in]; 
	format frequency Freq_d 8.0 percent per_d percent8.2 ;
run;
ods rtf close;


proc printto; run;
