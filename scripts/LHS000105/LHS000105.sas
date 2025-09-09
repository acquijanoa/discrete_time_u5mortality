%let homepath = <PATH TO ROOT FOLDER>;
%let job = LHS000105;
proc printto log = "&homepath./scripts/&job./&job._&sysdate..log" 
			print = "&homepath./scripts/&job./&job._&sysdate..lst" new;
run; 

/*

	Program name: LHS000105.sas	

	Description: 	Fits the cloglog model and compute hazard ratios

	SAS version: 	9.4 

	Input: 	&homepath./data/derived/lhs000103_24aug25.sas7bdat	
 
	Output: &homepath./output/lhs000104_T3_24aug25.rtf
			&homepath./data/derived/lhs000104_24aug25.sas7bdat

*/
options nonumber nodate;

* Import libraries;
libname raw "&homepath/data/raw" ACCESS=READONLY;
libname derv "&homepath/data/derived";
run;

* Include needed files;
%include "&homepath./scripts/LHS000190/lhs000190.sas"; 
%include "&homepath./scripts/LHS000191/lhs00019103.sas";

* define macro variables;
%let db_out = derv.&job._&sysdate.; 
%let db_in = derv.LHS000103_24aug25;

ods escapechar '^';

* Create format to use in the final report;
proc format;
	value $ labels
	'age-2' = '[1-6) vs [0-1)'
	'age-3' = '[6-12) vs [0-1)'
	'age-4' = '[12-24) vs [0-1)'
	'age-5' = '[24-36) vs [0-1)'
	'age-6' = '[36-60) vs [0-1)'
	'birth_weight_c3-1' = 'Low Birth Wt vs Normal Wt'
	'preterm-1' = 'Preterm Yes vs No'
	'birth_order_spacing_c5-2' = "B. order-spacing 2-3 & <36 vs Firstborn" 
	'birth_order_spacing_c5-3' = "B. order-spacing 2-3 & 36+ vs Firstborn" 
	'birth_order_spacing_c5-4' = "B. order-spacing 4+ & <36 vs Firstborn" 
	'birth_order_spacing_c5-5' = "B. order-spacing 4+ & 36+ vs Firstborn"
	'ethnicity_c3-1' = 'Ethnicity Indigenous vs Non-indigenous'
 	'wealth_index_c3-1' = 'Wealth Index Poorer/est vs Richer/est'
	;
run;

* Count number of ids;
proc sql noprint;
	select count(distinct(cats(womenid,birthid))) into:n_births
	from &db_in;
quit;

* Fit the logistic model;
proc surveylogistic data = &db_in;
	by _imputation_;
	cluster psu;
	strata strata; 
	weight weight;
	class age(Ref="1") meduc_c3(Ref="1") wealth_index_c3(ref='3') mage_birth_c3(ref="2") preterm_birth(ref='0') birth_order_spacing_c5(ref='0') region(ref='5')
		  birth_weight_c3(ref="2") child_sex(ref='1') urban ethnicity_c3(ref='3') anc_quality_score_c2(ref='1') any_substance_use(ref='1') / param=ref;
	model died(event='1') = age child_sex birth_weight_c3 preterm_birth meduc_c3 ethnicity_c3  wealth_index_c3 urban
								 anc_quality_score_c2 birth_order_spacing_c5 mage_birth_c3 any_substance_use / link = cloglog; 
	ods output  ParameterEstimates = db_estimates0;
run;

* Arrange the dataset with the beta estimates;
data db_estimates;
  length Parameter $82;
  set db_estimates0;

   if missing(ClassVal0) then
    Parameter = Variable;
  else
    Parameter = catx('_', Variable, ClassVal0);

  keep _imputation_ Parameter Estimate StdErr DF;
run;

* Obtain the list of effects to use in MIANALYZE;
proc sql noprint;
	select distinct Parameter into:var_list separated by ' ' 
	from db_estimates
	;
quit;

* Combine the estimates;
proc mianalyze parms=db_estimates;
	modeleffects &var_list;
	ods output ParameterEstimates = db_estimates_pooled_mi;
run;

* Estimates;
data db_estimates_pooled;
	set db_estimates_pooled_mi;

	* position;
	pos = findc(Parm, '_', 'b');

	if anydigit(substr(Parm, pos+1)) then do;
		ClassVal1 = substr(Parm, pos+1);
		Variable = substr(Parm, 1, pos-1);
	end;
	else do;
		ClassVal1 = '';
		Variable = Parm;	
	end;

	* keep variables;
	keep Variable ClassVal1 Estimate StdErr LCLMean UCLMean Probt;
run;

* Insert reference values;
proc sql noprint;
	insert into db_estimates_pooled (Variable,ClassVal1,Estimate)
	values ('wealth_index_c3','3',97)
	values ('birth_weight_c3','2',97)
	values ('birth_order_spacing_','0',97)
	values ('ethnicity_c3','3',97)
	values ('age','1',97)
	values ('preterm_birth','0',97);
quit;

* Insert labels to use in the report;
data &db_out.;
	set db_estimates_pooled;
	keep order label response estimate0 lower_exp upper_exp;

	response = "Hazard ratio";
	%labels;

	* lower and upper confidence;
	if estimate ^= 97 then estimate0 = exp(estimate);
	else estimate0 = 97;
	lower_exp = exp(lclmean);
	upper_exp = exp(uclmean); 

	if (lower_exp < 1 and upper_exp < 1) or (lower_exp > 1 and upper_exp > 1) or missing(lower_exp);
run;

* Print RTF report;
libname hchstyle 'J:\hchs\sc\styledef\sty904';
ods path sashelp.tmplmst(read) hchstyle.hchs_stp(read);
ods listing close;

ods rtf file = "&homepath./scripts/&job./&job._T0_&sysdate..rtf" style=manuscrt bodytitle;
%let fs = 11pt;
%let fs_body = 11pt;
%let fs_titles = 11pt;
%let lft_mgn = 1 in;
%let rgt_mgn = 1 in;
proc report data = &db_out.;
	title j=center height=&fs font='times roman' bold "Table XX. Discrete-Time Survival Hazard Ratio Estimates, Demography and Health Survey 2015 (N=%qtrim(&n_births))";
	footnote1 J=LEFT HEIGHT=9.5pt FONT='times roman' "^S={leftmargin=&lft_mgn rightmargin=&rgt_mgn} Note(s): Estimates are weighted using sampling weights and account for complex survey design." ; 
	footnote2 J=LEFT HEIGHT=9.5pt FONT='times roman' "^S={leftmargin=1.6in rightmargin=&rgt_mgn} Hazard Ratio estimates are pooled across 10 imputed datasets following Rubin rules and standard errors incorporate both within and between-imputation variability." ; 
	footnote3 J=LEFT HEIGHT=10pt FONT='times roman' "{\line \line Job &job run using DHS 2015 data on %sysfunc(today(), date9.) at%sysfunc(time(), timeampm.) }";
	columns order label response,(Estimate0 Lower_exp Upper_exp);
	define order / order group noprint order = internal;
	define label / display group ' ' style(header)=[just=left] style=[cellwidth=3.5in];
	define estimate0 / analysis 'Estimate' style=[vjust=bottom];
	define response / across ' ' ;
	define lower_exp / analysis 'Lower CL' style=[vjust=bottom]; 
	define upper_exp / analysis 'Upper CL' style=[vjust=bottom]; 
	format std paren. estimate0 refnum. lower_exp upper_exp 8.2;
	compute after _page_ / style = [just=left];
		line "* p <=.10, ** p <=.05, *** p <=.01 ";
	endcomp;
run;
ods rtf close;

proc printto; run;
