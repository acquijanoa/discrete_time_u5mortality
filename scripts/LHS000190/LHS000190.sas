/*
	
	Program: LHS000190

	Description: Include the format value for derived variables

	Creation date: 15may25

*/

proc format; 
	value ethnicity_c3_fmt 
		1 = 'Indigenous'
		2 = 'Afrodescendent'
		3 = 'Other';
	value meduc_c3_fmt
		1 = 'No education'
		2 = 'Primary'
		3 = 'Secondary or Higher'; 
	value meduc_c2_fmt
		1 = 'No education'
		2-3 = 'Primary, Secondary or Higher'; 
	value floor_mat_c4_fmt
		1 = 'Natural' 
		2 = 'Rudimentary'
		3 = 'Finished'
		4 = 'Other';
	value child_sex_fmt
		0 = 'Male' 
		1 = 'Female';
	value hh_head_c4_fmt
		1 = 'Head'
		2 = 'Wife or Husband'
		3 = 'Son or Daughter'
		4 = 'Other';
	value fuel_cooking_c3_fmt
		1 = 'Non-solid'
		2 = 'Solid'
		3 = 'Other';
	value mom_occupation_c3_fmt
	    1 = "Not working / Domestic / Services"
	    2 = "Professional / Director / Administrative"
	    3 = "Other";
	value preceding_birth_interval_c4_fmt
		0 = 'Firstborn'
		1 = '<24 months'
		2 = '24-35 months'
		3 = '36+ months';
	value preceding_birth_interval_c3_fmt
		0 = 'Firstborn'
		1 = '<35 months'
		2 = '36+ months';
	value birth_weight_c4_fmt
		1 = 'Extremely or very low'
		2 = 'Low'
		3 = 'Normal '
		4 = 'Macrosomia'
		. = 'Not weighed or unknown' ;
	value birth_weight_c3_fmt
		1 = 'Low'
		2 = 'Normal '
		3 = 'Macrosomia'
		. = 'Missing' ;
	value age_month_fmt
		0 = '0 months'
		1-11 = '1-11 months'
		12-23 = '12-23 months'
		24-35 = '24-35 months'
		36-47 = '36-47 months'
		48-60 = '48-60 months'
		;
	value wealth_index_fmt
		1 = 'Poorest'
		2 = 'Poorer'
		3 = 'Middle'
		4 = 'Wealthier'
		5 = 'Wealthiest' 
		;
	value wealth_index_c3_fmt
		1 = 'Poorest/Poorer'
		2 = 'Middle'
		3 = 'Wealthier/Wealthiest' 
		;
	value mage_birth_fmt
		low - <18 = "<18"
		18-34 = "18-34"
		35-high = "35+"
		;
	value mage_birth_c3_fmt
		1 = "<=18"
		2 = "(18,35)"
		3 = "35+"
		;
	value urban_fmt
		0 = 'Rural'
		1 = 'Urban';
	value anc_quality_score_c2_fmt
		0 = "Poor/Moderate"
		1 = "High"
		. = "Missing"
		;
	value birth_order_c3_fmt
		1 = 'Firstborn'
		2 = '2-3'
		3 = '4+'   
		;
	value birth_order_spacing_c5_fmt
		0 = 'Firstborn'
		1 = '2-3 & <36 months'
		2 = '2-3 & >=36 months'
		3 = '4+ & <36 months'
		4 = '4+ & >=36 months'
		. = 'Missing'
		;
	value ssubreg_fmt
	     1 = "Guajira, Cesar, Magdalena"
	     2 = "Barranquilla A. M."
	     3 = "Atlantico, San Andres, Bolivar Norte"
	     4 = "Bolivar Sur, Sucre, Cordoba"
	     5 = "Santanderes"
	     6 = "Boyaca, Cmarca, Meta"
	     7 = "Medellin A.M."
	     8 = "Antioquia sin Medellin"
	     9 = "Caldas, Risaralda, Quindio"
	    10 = "Tolima, Huila, Caqueta"
	    11 = "Cali A.M."
	    12 = "Valle sin Cali ni Litoral"
	    13 = "Cauca y Narino sin Litoral"
	    14 = "Litoral Pacifico"
	    15 = "Bogota"
	    16 = "Orinoquia y Amazonia"
		;
	value any_substance_use_fmt
		0 = 'No'
		1 = 'Yes'
		. = 'Missing';
	value preterm_birth_fmt
		0 = 'No'
		1 = 'Yes'
		. = 'Missing';
	value refnum 
		97 = 'Ref.'
		99 = ' '
		. = ' '
		other = [8.2];
	value paren (round)
		99 = ' '
		. = ' '
		other = [negparen.2]; 
	value pv
		1 = '***'
		2 = '**'
		3 = '*'
		4 = ' '
		5 = ' '
		. = '---';
run;
