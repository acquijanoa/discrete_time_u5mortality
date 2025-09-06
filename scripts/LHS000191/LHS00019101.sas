
%macro labels;
	attrib label length = $ 150 ;

	* Create labels;
if variable = 'time_months_c6' and ClassVal1 = '1' then do;label = "{\b Time to death or censoring (in months)\b0 \line \li250    [0-1)}"; order = 0.01; main = 1; end;
if variable = 'time_months_c6' and ClassVal1 = '2' then do;label = "^S={indent=2mm} [1-6)"; order = 0.02; end;
if variable = 'time_months_c6' and ClassVal1 = '3' then do;label = "^S={indent=2mm} [6-12)"; order = 0.03; end;
if variable = 'time_months_c6' and ClassVal1 = '4' then do;label = "^S={indent=2mm} [12-24)"; order = 0.04; end;
if variable = 'time_months_c6' and ClassVal1 = '5' then do;label = "^S={indent=2mm} [24-36)"; order = 0.05; end;
if variable = 'time_months_c6' and ClassVal1 = '6' then do;label = "^S={indent=2mm} [36-60)"; order = 0.06; end;

if variable = 'child_sex' and ClassVal1 = '0' then do;label = "{\b Child sex \b0 \line \li250   Male}"; order = 0.10; main = 1; end;
if variable = 'child_sex' and ClassVal1 = '1' then do;label = "^S={indent=2mm} Female"; order = 0.11; end;

if variable = 'birth_weight_c3' and ClassVal1 = '1' then do; label = "{\b Birth weight \b0 \line \li250   Low}"; order = 1; main = 1;  end;
if variable = 'birth_weight_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Normal"; order = 1.1; end;
if variable = 'birth_weight_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} Macrosomia"; order = 1.2; end;
if variable = 'birth_weight_c3' and ClassVal1 = '.' then do;label = "^S={indent=2mm} Not weighed or unknown"; order = 1.4; end;

if variable = 'preterm_birth' and ClassVal1 = '0' then do;label = "{\b Preterm birth \b0 \line \li250   No}"; order = 2.0; main = 1;end;
if variable = 'preterm_birth' and ClassVal1 = '1' then do;label = "^S={indent=2mm} Yes"; order = 2.1; end;

if variable = 'birth_order_spacing_c5' and ClassVal1 = '0' then do; label = "{\b Birth order and spacing \b0 \line \li250    Firstborn}"; order = 3.1; main = 1; end;
if variable = 'birth_order_spacing_c5' and ClassVal1 = '1' then do; label = "^S={indent=2mm} 2-3 & <36 months"; order = 3.2; end;
if variable = 'birth_order_spacing_c5' and ClassVal1 = '2' then do; label = "^S={indent=2mm} 2-3 & 36+ months"; order = 3.3; end;
if variable = 'birth_order_spacing_c5' and ClassVal1 = '3' then do; label = "^S={indent=2mm} 4+ & <36 months"; order = 3.4; end;
if variable = 'birth_order_spacing_c5' and ClassVal1 = '4' then do; label = "^S={indent=2mm} 4+ & 36+ months"; order = 3.5; end;
if variable = 'birth_order_spacing_c5' and ClassVal1 = '.' then do; label = "^S={indent=2mm} Missing"; order = 3.6; end;

if variable = 'mage_birth_c3' and ClassVal1 = '1' then do; label = "{\b Mother's age at birth \b0 \line \li250   <18 years}"; order = 4.0; main=1; end;
if variable = 'mage_birth_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} 18-34 years"; order = 4.1; end;
if variable = 'mage_birth_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} 35+ years"; order = 4.2; end;

if variable = 'meduc_c3' and ClassVal1 = '1' then do;label = "{\b Maternal education \b0 \line \li250    No education}"; order = 5.0; main = 1;end;
if variable = 'meduc_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Primary"; order = 5.1; end;
if variable = 'meduc_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} Secondary or Higher"; order = 5.2; end;

if variable = 'ethnicity_c3' and ClassVal1 = '1' then do;label = "{\b Maternal ethnicity \b0 \line \li250   Indigenous}"; order = 6.0; main = 1;end;
if variable = 'ethnicity_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Afrodescendent"; order = 6.1; end;
if variable = 'ethnicity_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} Non-Indigenous/Non-Afrodescendent"; order = 6.2; end;

if variable = 'anc_quality_score_c2' and ClassVal1 = '0' then do; label = "{\b Antenatal care quality \b0 \line \li250   Poor/Moderate}"; order = 7.0; main=1; end;
if variable = 'anc_quality_score_c2' and ClassVal1 = '1' then do; label = "^S={indent=2mm} High"; order = 7.1; end;
if variable = 'anc_quality_score_c2' and ClassVal1 = '.' then do; label = "^S={indent=2mm} Missing"; order = 7.2; end;
 
if variable = 'any_substance_use' and ClassVal1 = '0' then do; label = "{\b Substance use during pregnancy \b0 \line \li250    No}"; order = 8.0; main = 1;end;
if variable = 'any_substance_use' and ClassVal1 = '1' then do; label = "^S={indent=2mm} Yes"; order = 8.1; end;
if variable = 'any_substance_use' and ClassVal1 = '.' then do; label = "^S={indent=2mm} Missing"; order = 8.2; end;

if variable = 'wealth_index_c3' and ClassVal1 = '1' then do;label = "{\b Wealth index \b0 \line \li250   Poorest/Poorer}"; order=9.0; main = 1; end;
if variable = 'wealth_index_c3' and ClassVal1 = '2' then do;label = "^S={indent=2mm} Middle"; order=9.1; end;
if variable = 'wealth_index_c3' and ClassVal1 = '3' then do;label = "^S={indent=2mm} Wealthier/Wealthiest"; order=9.2; end;

if variable = 'urban' and ClassVal1 = '0' then do; label = "{\b Place of residence \b0 \line \li250   Rural}"; order=10.0; main = 1; end;
if variable = 'urban' and ClassVal1 = '1' then do; label = "^S={indent=2mm} Urban"; order=10.1; end;

%mend labels;
