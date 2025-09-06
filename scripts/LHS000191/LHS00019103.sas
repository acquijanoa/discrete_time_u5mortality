%macro labels;

	attrib label length = $ 150 ;

	* categorize the p-value into 4 levels;
	if probt <= 0.01 then pv = 1; 
	else if probt > 0.01 and probt <= 0.05 then pv = 2;
	else if probt > 0.05 and probt <= 0.1 then pv = 3;
	else if probt > 0.1 then pv = 4;

	* Sntadrd error negative to be formatted within parenthesis;
	std = -1 * stderr;

	* Create labels;
if variable = 'Intercept' then do; label = "{\b Intercept \b0}"; order = 0.01; StdErr  = 99; end;

if variable = 'age' and ClassVal1 = '1' then do; label = "{\b Child's age (in months) \b0 \line \li250   [0-1)}"; order = 0.1; StdErr  = 99; pv=5; end;
if variable = 'age' and ClassVal1 = '2' then do; label = "^S={indent=2mm} [1-6)"; order = 0.2; end;
if variable = 'age' and ClassVal1 = '3' then do; label = "^S={indent=2mm} [6-12)"; order = 0.3; end;
if variable = 'age' and ClassVal1 = '4' then do; label = "^S={indent=2mm} [12-24)"; order = 0.4; end;
if variable = 'age' and ClassVal1 = '5' then do; label = "^S={indent=2mm} [24-36)"; order = 0.5; end;
if variable = 'age' and ClassVal1 = '6' then do; label = "^S={indent=2mm} [36-60)"; order = 0.6; end;

if variable = 'birth_weight_c3' and ClassVal1 = '2' then do; label = "{\b Birth weight \b0 \line \li250   Normal}"; order = 1.10; pv=5; end;
if variable = 'birth_weight_c3' and ClassVal1 = '1' then do;label = "^S={indent=2mm} Low"; order = 1.11; end;
if variable = 'birth_weight_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} Macrosomia"; order = 1.12; end;

if variable = 'preterm_birth' and ClassVal1 = '0' then do;label = "{\b Preterm birth \b0 \line \li250   No}"; order = 1.20; pv=5; end;
if variable = 'preterm_birth' and ClassVal1 = '1' then do;label = "^S={indent=2mm} Yes"; order = 1.21; end; 

if variable = 'child_sex' and ClassVal1 = '1' then do;label = "{\b Child sex \b0 \line \li250   Male}"; order = 1.00; pv=5; end;
if variable = 'child_sex' and ClassVal1 = '0' then do;label = "^S={indent=2mm} Female"; order = 1.01; end;

if variable = 'birth_order_spacing_' and ClassVal1 = '0' then do; label = "{\b Birth order and spacing \b0 \line \li250   Firstborn}"; order = 1.40;  StdErr = 99; pv=5; end;
if variable = 'birth_order_spacing_' and ClassVal1 = '1' then do;label = "^S={indent=2mm} 2-3 & <36 months"; order = 1.41; end;
if variable = 'birth_order_spacing_' and ClassVal1 = '2' then do;label = "^S={indent=2mm} 2-3 & 36+ months"; order = 1.42; end;
if variable = 'birth_order_spacing_' and ClassVal1 = '3' then do;label = "^S={indent=2mm} 4+ & <36 months"; order = 1.43; end;
if variable = 'birth_order_spacing_' and ClassVal1 = '4' then do;label = "^S={indent=2mm} 4+ & 36+ months"; order = 1.44; end;

if variable = 'mage_birth_c3' and ClassVal1 = '2' then do; label = "{\b Mother's age at birth \b0 \line \li250   18-34 years}"; order = 2.10; StdErr = 99; pv=5; end;
if variable = 'mage_birth_c3' and ClassVal1 = '1' then do;label = "^S={indent=2mm} <18 years"; order = 2.11; end;
if variable = 'mage_birth_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} 35+ years"; order = 2.12; end;

if variable = 'meduc_c3' and ClassVal1 = '1' then do;label = "{\b Maternal education \b0 \line \li250   No education}"; order = 2.20; pv=5; end;
if variable = 'meduc_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Primary"; order = 2.21; end;
if variable = 'meduc_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} Secondary or Higher"; order = 2.22; end;

if variable = 'ethnicity_c3' and ClassVal1 = '3' then do;label = "{\b Maternal ethnicity \b0 \line \li250   Non-Indigenous/Non-Afrodescendent}"; order = 2.30; pv=5; end;
if variable = 'ethnicity_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Afrodescendent"; order = 2.31; end;
if variable = 'ethnicity_c3' and ClassVal1 = '1' then do;label = "^S={indent=2mm} Indigenous"; order = 2.32; end;

if variable = 'anc_quality_score_c2' and ClassVal1 = '1' then do; label = "{\b Antenatal Care quality \b0 \line \li250   High}"; order = 2.40; StdErr = 99; pv=5; end;
if variable = 'anc_quality_score_c2' and ClassVal1 = '0' then do; label = "^S={indent=2mm} Poor/Moderate"; order = 2.41; end;

if variable = 'any_substance_use' and ClassVal1 = '1' then do; label = "{\b Substance use during pregnancy \b0 \line \li250   Yes}"; order = 2.50; pv=5; end;
if variable = 'any_substance_use' and ClassVal1 = '0' then do; label = "^S={indent=2mm} No"; order = 2.51; end;

if variable = 'wealth_index_c3' and ClassVal1 = '3' then do;label = "{\b Wealth index \b0 \line \li250   Wealthier/Wealthiest}"; order = 3.10; pv=5; end;
if variable = 'wealth_index_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Middle"; order = 3.11; end;
if variable = 'wealth_index_c3' and ClassVal1 = '1' then do;label = "^S={indent=2mm} Poorer/Poorest"; order = 3.12; end;

if variable = 'urban' and ClassVal1 = '1' then do; label = "{\b Place of residence \b0 \line \li250   Urban}"; order = 3.20; StdErr = 99; pv=5; end;
if variable = 'urban' and ClassVal1 = '0' then do; label = "^S={indent=2mm} Rural"; order = 3.21; end;

%mend labels;
