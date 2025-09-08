%let homepath = <INSERT THE PATH TO THE ROOT FOLDER>;
%let job = LHS000101;
proc printto log = "&homepath./scripts/&job./&job._&sysdate..log" 
			print = "&homepath./scripts/&job./&job._&sysdate..lst" new;
run; 

/*
	Program name: LHS000101.sas	

	Description: Process children recode data and create a derv file 
					using data from 2015 to use in the analysis

	Version: SAS 9.4

	Input: COKR72FL (Child recode from DHS 2015)

	Output: &homepath/data/derived/LHS000101

*/
libname raw "&homepath/data/raw" access=readonly;
libname derv "&homepath/data/derived";
run;

* define macro variables;
%let db_out = derv.&job._&sysdate.; 
%let db_in = raw.cokr72fl;

* processed dataset;
data &db_out.(label = "DHS 2015 derived variables using child recode data on &sysdate.");
	set &db_in.;
	keep  strata psu weight doi time age_death age_month child_sex hhid status yob womenid birthid
			mage_birth_c3 meduc_c3 ethnicity_c3 birth_weight time_months_c6 anc_quality urban bord v101
			birth_weight_c3 preceding_birth_interval_c3 anc_quality_score anc_quality_score_c2
			preterm_birth v190 b5 time_months birth_order_c3 birth_order_spacing_c5
			any_substance_use wealth_index_c3 ;		

		* design-related variables;
		strata = v022;
		label strata = 'Stratification variable';

		psu = v001;
		label psu = 'Cluster variable';

		hhid = v002;
		label hhid = 'Household id';

		weight = v005 / 1000000;
		label weight = 'Sampling weight';

		womenid = caseid;
		label womenid = 'Women id';

		birthid = bidx;
		label birthid = 'Case id in DHS';
	
		* region;
		rename  v101 = region
				BORD = birth_order
				SMUNIP = municipality
				ssubreg = subregion
				sdepto = depto
				v190 = wealth_index
				b5 = is_alive;
		
		* urban; 
		if v025 = 1 then urban = 1;
		else if v025 = 2 then urban = 0;
		label urban = "Urban area of residence";
	
		* doi: date of interview; 
		doi = v008;
		label doi = 'Date of interview';

		* yoi: year of interview;
		yoi = int(1900 + (v008-1)/12);
		label yoi = 'Year of interview';
		
		* Child-related variables;
		dob = b3;
		label dob = "Date of birth";

		age_death = b7;
		label age_death = "Child's age at death in months";

		age_month = doi - dob;
		label age_month = "Child's age in months at interview";

		yob = int(1900 + (dob - 1)/12);
		label yob = "Child's year of birth";
		
		* child_sex;
		if b4 = 2 then child_sex = 1; 
		else child_sex = 0;
		label child_sex = "Sex of child (1=female, 0=male)";

		* This is calculated even if the child has died or not;
		time = min(b7, age_month) / 12;
		label time = "Time to death or censoring (in years)";

		time2 = min(b7, 59, age_month) / 12;
		label time2 = "Time to death or censoring (max 59 months) in years";

		* Time to death or censoring in months; 
		time_months = min(b7, age_month);
		label time_months = "Time to death or censoring (in months)";

		* Categorical time_months; 
		if time_months = 0 then time_months_c6 = 1;
		else if 1 <= time_months < 5 then time_months_c6 = 2;
		else if 5 <= time_months < 12 then time_months_c6 = 3;
		else if 12 <= time_months < 24 then time_months_c6 = 4;
		else if 24 <= time_months < 36 then time_months_c6 = 5;
		else if 36 <= time_months < 60 then time_months_c6 = 6;
		label time_months_c6 = "6-categories time to death or censoring in months";

		* status variable; 
		status = 0;
		if min(b7, age_month) >= 60 then status = 1;
		else if age_month < 60 then status = 0;
		label status = "Child survival status by age 60 months (1=survived, 0=died)";

		* birth_order_c3;
		if bord = 1 then birth_order_c3 = 1;
		else if bord in (2,3) then birth_order_c3 = 2;
		else if bord > 3 then birth_order_c3 = 3;
		label birth_order_c3 = "birth order (3 categories)";

		* preceding_birth_interval_c4;
		if bord = 1 then preceding_birth_interval_c4 = 0;
		else if 0 <= b11 < 24 then preceding_birth_interval_c4 = 1;
		else if 24 <= b11 < 36 then preceding_birth_interval_c4 = 2;
		else if b11 >= 36 then preceding_birth_interval_c4 = 3;
		else preceding_birth_interval_c4 = .;
		label preceding_birth_interval_c4 = '4-categories preceding birth interval';

		* preceding_birth_interval_c3;
		if preceding_birth_interval_c4 = 0 then preceding_birth_interval_c3 = 0;
		else if preceding_birth_interval_c4 in (1,2) then preceding_birth_interval_c3 = 1;
		else if preceding_birth_interval_c4 = 3 then preceding_birth_interval_c3 = 2;
		else preceding_birth_interval_c3 = .;
		label preceding_birth_interval_c3 = '3-categories preceding birth interval including firstborns';

		* Preceding_birth_interval_lt36;
		if preceding_birth_interval_c3 = 1 then preceding_birth_interval_lt36 = 1;
		else preceding_birth_interval_lt36 = 0;

		* birth_order_spacing_c5;
		if bord = 1 then birth_order_spacing_c5 = 0;
		else do;
			if bord in (2,3) then do;
				if 0 < b11 < 36 then birth_order_spacing_c5 = 1;
				else if b11 >= 36 then birth_order_spacing_c5 = 2;
			end;
			else if bord > 3 then do;
				if 0 < b11 < 36 then birth_order_spacing_c5 = 3;
				else if b11 >= 36 then birth_order_spacing_c5 = 4;
			end;
		end;
		label birth_order_spacing_c5 = "Birth order and spacing (5-categories)";
		
		* weight_at_birth;
		if m19 in (9996, 9998) then birth_weight = .;
	    else birth_weight = m19;
		label birth_weight = 'Birth weight in grams';

	    * 3-levels birth weight;
	    if 0 < birth_weight < 2500 then birth_weight_c3 = 1; 
	    else if 2500 <= birth_weight < 4000 then birth_weight_c3 = 2; 
	    else if birth_weight >= 4000 then birth_weight_c3 = 3; 
	    else birth_weight = .; 
    	label birth_weight_c3 = "Birth weight (3 categories)";

		* preterm_birth;
		if s445 = 1 then preterm_birth = 1;
		else if s445 = 0 then preterm_birth = 0;
		else preterm_birth = .;
		label preterm_birth = "Child reported as born prematurely";

		* mother's age at child birth;
		mage_birth = round((B3 - V011) / 12, 1);
		label mage_birth = "Mother's age at child's birth (in years)";

		* mother's age at child birth;
		if mage_birth = . then mage_birth_c3 = .;
		else if mage_birth <=19 then mage_birth_c3 = 1;
		else if mage_birth >19 and mage_birth < 35 then mage_birth_c3 = 2;
		else if mage_birth >= 35 then mage_birth_c3 = 3;
		label mage_birth_c3 = "Mother's age at child's birth (3 categories)";

		if v106 = 0 then meduc_c3 = 1;
		else if v106 = 1 then meduc_c3 = 2;
		else if v106 in (2,3) then meduc_c3 = 3;
		label meduc_c3 = "Mother's education (3 categories)";
		
		* Ethnicity variable
			* 1 = "Indigenous";
     		* 2 = "Gypsy (ROM)";
     		* 3 = "Raizal from archipelago (San Andres)";
     		* 4 = "Palanquero from San Basilio";
     		* 5 = "Black/Mulato/Afro-Colombian/Afro-descendant";
     		* 6 = "None of the above
		;
		if v131 = 1 then ethnicity_c3 = 1;
		else if v131 in (3,4,5) then ethnicity_c3 = 2;
		else if v131 in (2,6) then ethnicity_c3 = 3;
		else ehtnicity_v3 = .;
		label ethnicity_c3 = 'Self-reported ethnicity (3 categories)';

		* ANC quality score;
		if missing(M42a) or  missing(M42c) or  missing(M42d) or  missing(M42e) then anc_quality = .;
		else anc_quality = sum(of M42a M42c M42d M42e);
		label anc_quality = "ANC quality score (0-4)";

		* Any antenatal care;
		if missing(m57e) or missing(m57m) or missing(m57n) or missing(m57o) or missing(m57p) or missing(m57x) then any_antenatal = .;
		else any_antenatal = sum(of m57e m57m m57n m57o m57p m57x);
		label any_antenatal = "Any antenatal care";

		* Any substance use during pregnancy;
		if missing(s428) and missing(s430) and (missing(s433a) or s433a =8) and (missing(s433b) or s433b =8) and
				(missing(s433c) or s433c=8) and (missing(s433x) or s433x =8) then any_substance_use = .;
		else if S428 = 1 or S430 = 1 or S433a = 1 or S433b = 1 or S433c = 1 or S433x = 1  then  any_substance_use = 1;
		else any_substance_use = 0;
		label any_substance_use = 'Any substance use during pregnancy';

		* 3 categories wealth index;
		if v190 in (1,2) then wealth_index_c3 = 1;
		else if v190 = 3 then wealth_index_c3 = 2;
		else if v190 in (4,5) then wealth_index_c3 = 3;
		else wealth_index_c3 = .;
		label wealth_index_c3 = 'Household wealth index (3 categories)';

		* Number of ANC visits;
		if m14 = 98 or missing(m14) then anc_visits_c4 = .;
		else if m14 = 0 then anc_visits_c4 = 0;
        else if m14 in (1,2,3) then anc_visits_c4 = 1;
		else if m14 in (4,5,6,7) then anc_visits_c4 = 2;
		else if m14 > 7 then anc_visits_c4 = 3;
		else anc_visits_c4 = .;
		label anc_visits_c4 = 'Number of antenatal visits (4-categories)';

		* Tetanus_2_plus;
		if missing(m1) or m1 = 8 then tetanus_2_plus = .;
		else if m1 >= 2 then tetanus_2_plus = 1;
		else if m1 <2 then tetanus_2_plus = 0;
		label tetanus_2_plus = 'at least two tetanus toxoid injections during pregnancy (>=2)';
 
		* Anc_1st_trimester;
		if missing(m13) or m13 = 98 then anc_1st_trimester = .;
		else if m13 <=2 then anc_1st_trimester = 1;
		else anc_1st_trimester = 0;

		* skilled prenatal care;
		if missing(m57e) or missing(m57m) or missing(m57n) or missing(m57o) or missing(m57p) or missing(m57x) then  skilled_prenatal = .;
		else if m57e = 1 or m57m = 1 or m57n = 1 or m57o = 1 or m57p = 1 then skilled_prenatal = 2;
		else skilled_prenatal = 0;
		label skilled_prenatal = "Mother saw at least one skilled provider during antenatal care.";

		* anc_quality score;
		if nmiss(anc_visits_c4, tetanus_2_plus, anc_1st_trimester, m42c, m42d, m42e, skilled_prenatal) > 2 then anc_quality_score = .;
		else anc_quality_score = anc_visits_c4 + tetanus_2_plus + anc_1st_trimester + m42c + m42d + m42e + skilled_prenatal;
		label anc_quality_score = "Antenatal Care Quality Score"; 

		* anc_quality_score_c2;
		if missing(anc_quality_score) then anc_quality_score_c2 = .;
		else if anc_quality_score <=7 then anc_quality_score_c2 = 0;
		else if anc_quality_score in (8,9,10) then anc_quality_score_c2 = 1;
		label anc_quality_score_c2 = "Adequate Antenatal Care Quality Score (2 categories)"; 

		if time_months < 60;
run;

proc sort data = &db_out.; by womenid; run;

ods rtf file = "&homepath./scripts/&job./&job._contents_&sysdate..rtf";
proc contents data = &db_out.;
run;
proc sql;
	title 'Number of women ids in the dataset';
	select count(distinct(womenid)) as n
	from &db_out.;
quit;
ods rtf close;

proc printto; run;
