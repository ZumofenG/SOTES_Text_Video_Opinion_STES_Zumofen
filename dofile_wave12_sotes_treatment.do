* SOTES Project - Switzerland - Universität Bern
* Paper // Banking on text or video: What is the influence of information format on the individual perception and opinion formation on an unknown and complex issue?
* Author // Zumofen G., Stadelmann-Steffen, I., & Sträter, R.

clear all
cd "/users/zumofeng/OneDrive/010_SOTES/P11_video_text/data"
capture log close
log using banking_text_video_svpwcongress.log, replace
set more off

**************
* 1. Dataset management - Appending wave 1 and 2
use "data_wave1_sotes_info.dta", clear
append using data_wave2_sotes_info.dta, force

label define wave_label 1"W1" 2"W2"
label values wave wave_label
fre wave



*****************
* 1. Preprocess data - Control variables
* 1.1: Sociodemograpphic + political related variables
rename F870 ideological_orientation
recode ideological_orientation (99999=.)
fre ideological_orientation

rename F880 party_identification
fre party_identification


rename F890 political_interest
fre political_interest
recode political_interest (6=.)
fre political_interest

rename S01 educ
recode educ (14=.) (13=.)
generate education = 0 if educ==1 | educ==2
replace education = 1 if educ==3
replace education = 2 if educ==4 | educ==5 | educ==7
replace education = 3 if educ==6 | educ==8
replace education = 4 if educ==9 | educ==10 | educ==11 | educ==12
label define education_label 0"No diploma" 1"Primary" 2"Secondary (without baccalureate)" 3"Secondary II" 4"Tertiary"
label value education education_label
fre education

rename S03 revenu
recode revenu (7=.)
fre revenu

rename S04 living
recode living (6=.)
fre living

rename S05 living2
recode living2 (4=.)
fre living2

rename S13 sex 
recode sex (4=3) (1=0) (2=1)
label define sex_label 0"Men" 1"Women" 3"Non-binary"
label value sex sex_label
fre sex

rename S14 age
sum age


* 1.2: Energy related variables
recode F100(1=5 "Sehr wichtig") (2=4 "Eher wichtig") (3=3 "Weder noch") (4=2 "Eher nicht wichtig") (5=1 "Gar nicht wichtig") (6=.), generate (energy_importance)
fre energy_importance


recode F12001 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F12002 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F12003 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F12004 (6=.) (1=5)(2=4)(4=2) (5=1)
alpha F12001 F12002 F12003 F12004
* Cronbach alpha = 0.78
generate energy_independence = (F12004 + F12003 + F12002 + F12001)/4
label define indep_label 1"Gar nicht wichtig" 2"Eher nicht wichtig" 3"Weder noch" 4"Eher wichtig" 5"Sehr wichtig"
label values energy_independence indep_label
fre energy_independence

rename F12001 energy_indep_house
label values energy_indep_house indep_label
fre energy_indep_house

rename F12002 energy_indep_region
label values energy_indep_region indep_label
fre energy_indep_region

rename F12003 energy_indep_swiss
label values energy_indep_swiss indep_label
fre energy_indep_swiss

rename F12004 energy_indep_europa
label values energy_indep_europa indep_label
fre energy_indep_europa

label define living_label 1"Gar nicht wichtig" 2"Eher nicht wichtig" 3"Weder noch" 4"Eher wichtig" 5"Sehr wichtig"
label values energy_independence indep_label
recode F13001 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13002 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13003 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13004 (6=.) (1=5)(2=4)(4=2) (5=1)
recode F13005 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13006 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13007 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13008 (6=.) (1=5)(2=4)(4=2) (5=1)
recode F13009 (6=.) (1=5)(2=4)(4=2) (5=1)
recode F13010 (6=.)(1=5)(2=4)(4=2) (5=1)
recode F13011 (6=.)(1=5)(2=4)(4=2) (5=1)
rename F13001 energy_living_purchasecost
label values energy_living_purchasecost living_label
rename F13002 energy_living_operationalcost
label values energy_living_operationalcost living_label
rename F13003 energy_living_indep
label values energy_living_indep living_label
rename F13004 energy_living_co2
label values energy_living_co2 living_label
rename F13005 energy_living_modern
label values energy_living_modern living_label
rename F13006 energy_living_reliable
label values energy_living_reliable living_label
rename F13007 energy_living_visible
label values energy_living_visible living_label
rename F13008 energy_living_easy
label values energy_living_easy living_label
rename F13009 energy_living_value
label values energy_living_value living_label
rename F13010 energy_living_sustainable
label values energy_living_sustainable living_label
rename F13011 energy_living_space
label values energy_living_space living_label


rename F140 prosumerism
recode prosumerism (7=.) (1=6) (6=1) (2=5) (5=2) (3=4) (4=3)
label define prosumerism_label 1"No" 2"Probably not" 3"Never thought about it" 4"Yes, but I cannot afford it" 5"Yes, I thought about it" 6"Yes, I already do it"
label value prosumerism prosumerism_label
fre prosumerism

recode F840 (99999=.)
rename F840 tradeoff_energy_environment
fre tradeoff_energy_environment


* 1.3: STES related variables
recode F200 (3=.) (2=0)
rename F200 stes_awareness
fre stes_awareness
sort wave
by wave: fre stes_awareness
* A third of participants (35% 32%) are aware of STES

* STES knowledge
recode F210 (6=.) (1=5)(2=4)(4=2) (5=1)
rename F210 stes_knowledge
label define knowledge_label 1"Gar nicht vertraut" 2"Eher nicht vertraut" 3"Weder noch" 4"Eher vertraut" 5"Sehr vertraut"
label values stes_knowledge knowledge_label
fre stes_knowledge
by wave: fre stes_knowledge

* STES: already heard about some of the STES systems
rename F2201 stes_water_awareness
rename F2202 stes_ice_awareness
rename F2203 stes_thermo_awareness
rename F2204 stes_borehole_awareness
rename F2205 stes_latent_awareness
rename F2206 stes_other_awareness

fre stes_water_awareness
by wave: fre stes_water_awareness
fre stes_ice_awareness
by wave: fre stes_ice_awareness
fre stes_thermo_awarenes
by wave: fre stes_thermo_awareness
fre stes_borehole_awareness
by wave: fre stes_borehole_awareness
fre stes_latent_awareness
by wave: fre stes_latent_awareness
fre stes_other_awareness
by wave: fre stes_other_awareness

* Determine how many participants were exposed to a technology that they were already aware of
generate stes_awareness_specific = 1 if stes_water_awareness==1 & F60001!=.
replace stes_awareness_specific = 1 if stes_ice_awareness==1 & F60002!=.
replace stes_awareness_specific = 1 if stes_thermo_awareness==1 & F60004!=.
replace stes_awareness_specific = 1 if stes_borehole_awareness==1 & F60003!=.
replace stes_awareness_specific = 1 if stes_latent_awareness==1 & F60005!=.
recode stes_awareness_specific (.=0)
fre stes_awareness_specific
* 19% of respondents were exposed to a STES system that they already heard about. 

* STES: How did you hear about STES?
rename F23001 stes_discussion_channel
rename F23002 stes_professional_channel
rename F23003 stes_media_channel
rename F23004 stes_internet_channel
rename F23005 stes_property_channel
rename F23006 stes_retrofit_channel
rename F23007 stes_districtproject_channel
rename F23008 stes_energyadvisor_channel

fre stes_discussion_channel
fre stes_professional_channel
fre stes_media_channel
fre stes_internet_channel
fre stes_property_channel
fre stes_retrofit_channel
fre stes_districtproject_channel
fre stes_energyadvisor_channel
* --> Mostly media (63%), and the Internet (30%), or discussion with relatives (41%)

*****************
* 2. Preprocess dependent variables
* 2.1 STES related dependent variables

label define stes_potential_label 1"Not important" 2"Rather not important" 3"Neutral" 4"Rather important" 5"Very important"
* STES: Potential to solve challenges
recode F240 (6=.) (7=.) (1=5) (5=1) (2=4) (4=2)
rename F240 stes_potential_onlyaware
label values stes_potential_onlyaware stes_potential_label
fre stes_potential_onlyaware
* --> High potential: 82-83% consider that it has a very or rather important role to solve energy/environment challenges

recode F400 (6=.) (1=5) (5=1) (2=4) (4=2)
rename F400 stes_potential_before
label values stes_potential_before stes_potential_label
fre stes_potential_before
by wave: fre stes_potential_before

* Impact on STES opinion
* Potential STES to solve energy/enbironment (F720)
rename F72001 stes_potential_climatechange
recode stes_potential_climatechange (6=.) (1=5) (5=1) (2=4) (4=2)
fre stes_potential_climatechange
rename F72002 stes_potential_energysecurity
recode stes_potential_energysecurity (6=.) (1=5) (5=1) (2=4) (4=2)
fre stes_potential_energysecurity
rename F72003 stes_potential_energystrategy
recode stes_potential_energystrategy (6=.) (1=5) (5=1) (2=4) (4=2)
fre stes_potential_energystrategy
rename F72004 stes_potential_indepnational
recode stes_potential_indepnational (6=.) (1=5) (5=1) (2=4) (4=2)
fre stes_potential_indepnational
rename F72005 stes_potential_indepregional
recode stes_potential_indepregional (6=.) (1=5) (5=1) (2=4) (4=2)
fre stes_potential_indepregional
rename F72006 stes_potential_indepindividual
recode stes_potential_indepindividual (6=.) (1=5) (5=1) (2=4) (4=2)
fre stes_potential_indepindividual

alpha stes_potential_climatechange stes_potential_energysecurity stes_potential_energystrategy stes_potential_indepnational stes_potential_indepregional stes_potential_indepindividual
* Cronbach alpha (reliability score) = 0.90 --> Aggregate variable

generate stes_potential_after = (stes_potential_climatechange+stes_potential_energysecurity+stes_potential_energystrategy+stes_potential_indepnational+stes_potential_indepregional+stes_potential_indepindividual)/6
fre stes_potential_after
by wave: fre stes_potential_after
sum stes_potential_after
by wave: sum stes_potential_after

* Einstellung STES - Opinion STES
rename F73001 stes_opinion1
recode stes_opinion1 (6=.) (1=5) (2=4) (4=2) (5=1)
fre stes_opinion1

rename F73002 stes_opinion2
recode stes_opinion2 (6=.) 
fre stes_opinion2

rename F73003 stes_opinion3 
recode stes_opinion3 (6=.) (1=5) (2=4) (4=2) (5=1)
fre stes_opinion3

rename F73004 stes_opinion4 
recode stes_opinion4 (6=.) (1=5) (2=4) (4=2) (5=1)
fre stes_opinion4

rename F73005 stes_opinion5
recode stes_opinion5 (6=.) 
fre stes_opinion5

alpha stes_opinion1 stes_opinion2 stes_opinion3 stes_opinion4 stes_opinion5
* Cronbach alpha: 0.77 --> It is possible to aggregate data (above threshold 0.7).

generate stes_perceived_usefulness =(stes_opinion1+stes_opinion2+stes_opinion3+stes_opinion4+stes_opinion5)/5
label define stes_opinion 1"Strongly disagree" 2"Disagree" 3"Neutral" 4"Agree" 5 "Strongly agree"
label value stes_perceived_usefulness stes_opinion
sum stes_perceived_usefulness
fre stes_perceived_usefulness
by wave: sum stes_perceived_usefulness


* 2.2 Information perception related variables
* Impact on information perception
rename F750 complexity_info
fre complexity_info
recode complexity_info (6=.)

rename F760 useful_info
fre useful_info
recode useful_info (6=.)

rename F770 credibility_info
recode credibility_info (6=.)
fre credibility_info



* 2.3 Intention to install (SFH-level) and to support (District level)
* Sociopolitical acceptance of STES

* Intention to install STES systems (SFH level)
rename F60001 install_water
recode install_water (6=.) (1=5) (2=4) (4=2) (5=1)
label define install_label 1"Very unlikely" 2"Rather unlikely" 3"Neither nor " 4"Rather likely" 5"Very likely"
label value install_water install_label
fre install_water
by wave: sum install_water

rename F60002 install_ice
recode install_ice (6=.) (1=5) (2=4) (4=2) (5=1)
label value install_ice install_label
fre install_ice
by wave: sum install_ice

rename F60003 install_borehole
recode install_borehole (6=.) (1=5) (2=4) (4=2) (5=1)
label value install_borehole install_label
fre install_borehole
by wave: sum install_borehole

rename F60004 install_thermo
recode install_thermo (6=.) (1=5) (2=4) (4=2) (5=1)
label value install_thermo install_label
fre install_thermo
by wave: sum install_thermo

rename F60005 install_latent
recode install_latent (6=.) (1=5) (2=4) (4=2) (5=1)
label value install_latent install_label
fre install_latent
by wave: sum install_latent

by wave: sum install*
* More likely to be accepted is water, then borehole (less likely is thermo)

generate install_water2=install_water
recode install_water2 (.=0)
generate install_ice2=install_ice
recode install_ice2 (.=0)
generate install_thermo2=install_thermo
recode install_thermo2 (.=0)
generate install_borehole2=install_borehole
recode install_borehole2 (.=0)
generate install_latent2=install_latent
recode install_latent2 (.=0)

* Create an additive index. This is why I can recode missing into zero. Goal is to have the average rating over the two STES they were exposed to.
generate install_stes=(install_water2+install_ice2+install_borehole2+install_thermo2+install_latent2)

fre install_stes
sum install_stes
by wave: sum install_stes


* Intention to support STES systems (District level)
rename F61001 support_water
recode support_water (6=.) (1=5) (2=4) (4=2) (5=1)
label define support_label 1"Absolutely no" 2"Rather no" 3"Neither nor " 4"Rather yes" 5"Absolutely yes"
label value support_water support_label
fre support_water
by wave: sum support_water

rename F61002 support_ice
recode support_ice (6=.) (1=5) (2=4) (4=2) (5=1)
label value support_ice support_label
fre support_ice
by wave: sum support_ice

rename F61003 support_borehole
recode support_borehole (6=.) (1=5) (2=4) (4=2) (5=1)
label value support_borehole support_label
fre support_borehole
by wave: sum support_borehole

rename F61004 support_thermo
recode support_thermo (6=.) (1=5) (2=4) (4=2) (5=1)
label value support_thermo support_label
fre support_thermo
by wave: sum support_thermo
* Slightly big difference

rename F61005 support_latent
recode support_latent (6=.) (1=5) (2=4) (4=2) (5=1)
label value support_latent support_label
fre support_latent
by wave: sum support_latent

sum support*
* More likely to be supported is water, then borehole (but below)

generate support_water2=support_water
recode support_water2 (.=0)
generate support_ice2=support_ice
recode support_ice2 (.=0)
generate support_thermo2=support_thermo
recode support_thermo2 (.=0)
generate support_borehole2=support_borehole
recode support_borehole2 (.=0)
generate support_latent2=support_latent
recode support_latent2 (.=0)

generate support_stes=(support_water2+support_ice2+support_borehole2+support_thermo2+support_latent2)

fre support_stes
sum support_stes
by wave: sum support_stes

* Acceptance seems lower in second wave (but difference not significant)

gen accept = (install_water + support_water + install_ice + support_ice + install_borehole + support_borehole + install_thermo + support_thermo + install_latent + support_latent)/10
sort hTreatment
by hTreatment: sum accept







*******************
* 3. Empirical results
* 3.1. STES awareness - Relative ignorance
sort wave
fre stes_awareness
by wave: fre stes_awareness
by wave: sum stes_awareness

fre stes_knowledge
by wave: fre stes_knowledge
by wave: sum stes_knowledge

fre stes_awareness_specific
* Regarding the experiment (exposition to information related to STES), only 19.46% of respondents were exposed to a STES system that they already knew.


* 3.2.1 Impact of format on perception of information
* Hypothesis 1
ttest stes_perceived_usefulness, by(hFormat)
ttest stes_perceived_usefulness if wave==1, by(hFormat)
ttest stes_perceived_usefulness if wave==2, by(hFormat)
* Significant difference in perceived usefulness between video and text !!!!
* Direct impact on socio-political acceptance


ttest install_water, by(hFormat)
ttest install_water if wave==1, by(hFormat)
ttest install_water if wave==2, by(hFormat)
* No impact

ttest install_ice, by(hFormat)
ttest install_ice if wave==1, by(hFormat)
ttest install_ice if wave==2, by(hFormat)
* Significant impact at 90% (higher acceptance for video)


ttest install_thermo, by(hFormat)
ttest install_thermo if wave==1, by(hFormat)
ttest install_thermo if wave==2, by(hFormat)
* No impact

ttest install_borehole, by(hFormat)
ttest install_borehole if wave==1, by(hFormat)
ttest install_borehole if wave==2, by(hFormat)
* No impact

ttest install_latent, by(hFormat)
ttest install_latent if wave==1, by(hFormat)
ttest install_latent if wave==2, by(hFormat)
* Significant difference. Higher acceptance for text (only at 0.049)

ttest support_water, by(hFormat)
ttest support_water if wave==1, by(hFormat)
ttest support_water if wave==2, by(hFormat)
* No impact


ttest support_ice, by(hFormat)
ttest support_ice if wave==1, by(hFormat)
ttest support_ice if wave==2, by(hFormat)
* No impact

ttest support_thermo, by(hFormat)
ttest support_thermo if wave==1, by(hFormat)
ttest support_thermo if wave==2, by(hFormat)
* No impact

ttest support_borehole, by(hFormat)
ttest support_borehole if wave==1, by(hFormat)
ttest support_borehole if wave==2, by(hFormat)
* No impact

ttest support_latent, by(hFormat)
ttest support_latent if wave==1, by(hFormat)
ttest support_latent if wave==2, by(hFormat)
* No impact

ttest install_stes, by(hFormat)
ttest install_stes if wave==1, by(hFormat)
ttest install_stes if wave==2, by(hFormat)
* No direct impact on market acceptance

ttest support_stes, by(hFormat)
ttest support_stes if wave==1, by(hFormat)
ttest support_stes if wave==2, by(hFormat)
* No direct impact on community acceptance

fre complexity_info
recode complexity_info (1=5) (2=4) (4=2) (5=1)
label define complex_label 1"Not complex at all" 2"Rather not complex" 3"Neutral" 4"Rather complex" 5"Very complex"
label value complexity_info complex_label
ttest complexity_info, by(hFormat)
ttest complexity_info if wave==1, by(hFormat)
ttest complexity_info if wave==2, by(hFormat)
* p-value: 0.000 --> Information from VIDEO is  perceived significiantly less complex than TEXT


fre useful_info
recode useful_info (1=5) (2=4) (4=2) (5=1)
label define useful_label 1"Not useful at all" 2"Rather not useful" 3"Neutral" 4"Rather useful" 5"Very useful"
label value useful_info useful_label
ttest useful_info, by(hFormat)
ttest useful_info if wave==1, by(hFormat)
ttest useful_info if wave==2, by(hFormat)
* p-value: 0.010 --> Information from VIDEO is perceived significiantly more useful than TEXT


fre credibility_info
recode credibility_info (1=5) (2=4) (4=2) (5=1)
label define credible_label 1"Not credible at all" 2"Rather not credible" 3"Neutral" 4"Rather credible" 5"Very credible"
label value credibility_info credible_label
ttest credibility_info, by(hFormat)
ttest credibility_info if wave==1, by(hFormat)
ttest credibility_info if wave==2, by(hFormat)
* p-value: 0.027 --> Information from VIDEO is perceived significantly more credible than TEXT


* 3.2.2 Impact of treatment on perception of information
oneway complexity_info hTreatment
oneway complexity_info hTreatment if wave==1
oneway complexity_info hTreatment if wave==2
* --> No significant differences

oneway useful_info hTreatment
oneway useful_info hTreatment if wave==1
oneway useful_info hTreatment if wave==2
* No significant differences

oneway credibility_info hTreatment, bonferroni
oneway credibility_info hTreatment if wave==1, scheffe
oneway credibility_info hTreatment if wave==2, bonferroni
* Slight differences

* 3.5 Impact on perceived usefulness
sort hFormat
by hFormat: sum stes_perceived_usefulness if hTreatment==1
by hFormat: sum stes_perceived_usefulness if hTreatment==2
by hFormat: sum stes_perceived_usefulness if hTreatment==3
by hFormat: sum stes_perceived_usefulness if hTreatment==4


sort hTreatment
* 3.4 Impact on socio-political acceptance

oneway stes_perceived_usefulness hTreatment, bonferroni
kwallis stes_perceived_usefulness, by(hTreatment)
* Significant difference with kwallis test.
by hTreatment: sum stes_perceived_usefulness
sum stes_perceived_usefulness
* Technological readiness increases socio-political acceptance (in comparison with technical that seem to slightly decrease)
kwallis stes_perceived_usefulness if wave==1, by(hTreatment)
kwallis stes_perceived_usefulness if wave==2, by(hTreatment)

* 3.4.1 Water storage
kwallis install_water, by(hTreatment)
by hTreatment: sum install_water
sum install_water
* No significant differences
kwallis install_water if wave==1, by(hTreatment)
kwallis install_water if wave==2, by(hTreatment)


kwallis support_water, by(hTreatment)
by hTreatment: sum support_water
sum support_water
* No significant differences
kwallis support_water if wave==1, by(hTreatment)
kwallis support_water if wave==2, by(hTreatment)


* 3.4.2 Ice storage
kwallis install_ice, by(hTreatment)
by hTreatment: sum install_ice
sum install_ice
* Significant difference
kwallis install_ice if wave==1, by(hTreatment)
kwallis install_ice if wave==2, by(hTreatment)


kwallis support_ice, by(hTreatment)
by hTreatment: sum support_ice
sum support_ice
* Significant differences
kwallis support_ice if wave==1, by(hTreatment)
kwallis support_ice if wave==2, by(hTreatment)


* 3.4.3 Thermochemical storage
kwallis install_thermo, by(hTreatment)
by hTreatment: sum install_thermo
sum install_thermo
* No significant differences
kwallis install_thermo if wave==1, by(hTreatment)
kwallis install_thermo if wave==2, by(hTreatment)


kwallis support_thermo, by(hTreatment)
by hTreatment: sum support_thermo
sum support_thermo
* No significant differences
kwallis support_thermo if wave==1, by(hTreatment)
kwallis support_thermo if wave==2, by(hTreatment)

* 3.4.4 Borehole storage
kwallis install_borehole, by(hTreatment)
by hTreatment: sum install_borehole
sum install_borehole
* No significant differences
kwallis install_borehole if wave==1, by(hTreatment)
kwallis install_borehole if wave==2, by(hTreatment)


kwallis support_borehole, by(hTreatment)
by hTreatment: sum support_borehole
sum support_borehole
* No significant differences
kwallis support_borehole if wave==1, by(hTreatment)
kwallis support_borehole if wave==2, by(hTreatment)

* 3.4.5 Latent heat storage
kwallis install_latent, by(hTreatment)
by hTreatment: sum install_latent
sum install_latent
* No significant differences
kwallis install_latent if wave==1, by(hTreatment)
kwallis install_latent if wave==2, by(hTreatment)


kwallis support_latent, by(hTreatment)
by hTreatment: sum support_latent
sum support_latent
* No significant differences
kwallis support_latent if wave==1, by(hTreatment)
kwallis support_latent if wave==2, by(hTreatment)


* 3.5 By format and treatment
sort hFormatTreatment
oneway stes_perceived_usefulness hFormatTreatment
* p-value: 0.0455 --> Significant differences
oneway stes_perceived_usefulness hFormatTreatment, bonferroni
kwallis stes_perceived_usefulness, by(hFormatTreatment)
* Significant differences
by hFormatTreatment: sum stes_perceived_usefulness

kwallis install_water, by(hFormatTreatment)
* --> No signficiant differences
kwallis install_ice, by(hFormatTreatment)
oneway install_ice hFormatTreatment, bonferroni
* p-value: 0.0008 --> Signficiant differences
* Video * Readiness/Independence is the way to go.
by hFormatTreatment: sum install_ice


oneway install_thermo hFormatTreatment
* --> No signficiant differences

oneway install_borehole hFormatTreatment
* --> No signficiant differences

oneway install_latent hFormatTreatment
kwallis install_latent, by(hFormatTreatment)
* Significant differences
by hFormatTreatment: sum install_latent
* Video * Readiness is the way to go.

oneway support_water hFormatTreatment
* --> No signficiant differences

oneway support_ice hFormatTreatment
kwallis support_ice, by(hFormatTreatment)
*  --> No signficiant differences

oneway support_thermo hFormatTreatment
* --> No signficiant differences

oneway support_borehole hFormatTreatment
* --> No signficiant differences

oneway support_latent hFormatTreatment
kwallis support_latent, by(hFormatTreatment)
* --> Significant differences
oneway support_latent hFormatTreatment, bonferroni
by hFormatTreatment: sum support_latent
* Technical treatment drive acceptance down. Negative effect. 



* 3.4 Structural equation modelling - To analyze the impact of perceptions on acceptance
gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness)

gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (support_stes <- stes_perceived_usefulness)


* 3.5 Impact on positive affect
* Positive affect was directly measured with the stes_opinion1
ttest stes_opinion1, by(hFormat)
ttest stes_opinion2, by(hFormat)
ttest stes_opinion3, by(hFormat)
ttest stes_opinion4, by(hFormat)
ttest stes_opinion5, by(hFormat)
* Significant difference comes from:
* opinion1 (Alles in allem glaube ich, dass der Einsatz von saisonalen Wärmespeichern eine gute Sache ist)
* opinion3 (Ich glaube, dass der Einsatz von saisonalen Wärmespeichern für die Zukunft der Energieversorgung notwendig ist. )
* opinion4 (Ich bin froh, wenn Menschen bereit sind, finanziell in saisonale Wärmespeicher zu investieren. )

* But not opinion 2 and 5 ()

*3.6 Robustness check - Manipulation check
fre F780
label define manipulation_label 1 "Energy independence" 2 "Technical information" 3 "Technological readiness" 4 "Don't know"
labe values F780 manipulation_label
recode F780 (4=98)
rename F780 manipulation_check
fre manipulation_check
fre hTreatment

generate check=1 if hTreatment==2 & manipulation_check==1
replace check=1 if hTreatment==3 & manipulation_check==2
replace check=1 if hTreatment==4 & manipulation_check==3
replace check=0 if check==. & manipulation_check!=.
fre check

* Not a big success. Many respondent did not see the treatment.

gen check2 = check
replace check2=1 if hTreatment==1 & wave==2

* Robustness check - Manipulation check: test if group are homogenoud.
/* Risks are:
- Contamination errors (measurement error): for some respondents speaking about any technology might be perceived as technical features. For some respondents speaking about a technology might imply that this technology is ready For some respondents speaking about a storage might automatically mean increasing independence.
- Contamination error: Memory task that implies intellience. Contaminated by intelligence.
*/

tabulate manipulation_check check, chi2

tabulate stes_awareness check, chi2

ttest education, by(check)
ttest education, by(check2)
* Significant difference. Those who correctly answered have higher educated.

kwallis energy_importance, by(check)
sort check
by check: sum energy_importance
ttest energy_importance, by(check)

tabulate sprach check, chi2

ttest energy_independence, by(check)

ttest age, by(check)

tabulate sex check, chi2
tabulate sex check if sex!=3, chi2

ttest ideological_orientation, by(check)

* Based on this test of homogeneity, the only difference is "education". We can conclude that the intelligence and perception contaminated the question, which was not well-deisgned, and then note usable as such.

* 3.7 Robustness checks - Ecological validity
gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if wave==1

gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if wave==2

kwallis stes_perceived_usefulness if wave==2, by(hTreatment)
kwallis install_water if wave==2, by(hTreatment)
kwallis install_ice if wave==2, by(hTreatment)
kwallis install_thermo if wave==2, by(hTreatment)
kwallis install_borehole if wave==2, by(hTreatment)
kwallis install_latent if wave==2, by(hTreatment)
* Significant influence for borehole.

kwallis support_water if wave==2, by(hTreatment)
kwallis support_ice if wave==2, by(hTreatment)
kwallis support_thermo if wave==2, by(hTreatment)
kwallis support_borehole if wave==2, by(hTreatment)
kwallis support_latent if wave==2, by(hTreatment)


gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if living==2 | living==3

gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if living!=2 | living!=3

kwallis install_water if living==2 | living==3, by(hTreatment)
kwallis install_ice if living==2 | living==3, by(hTreatment)
kwallis install_thermo if living==2 | living==3, by(hTreatment)
kwallis install_borehole if living==2 | living==3, by(hTreatment)
kwallis install_latent if living==2 | living==3, by(hTreatment)

kwallis install_water if living!=2 | living!=3, by(hTreatment)
kwallis install_ice if living!=2 | living!=3, by(hTreatment)
kwallis install_thermo if living!=2 | living!=3, by(hTreatment)
kwallis install_borehole if living!=2 | living!=3, by(hTreatment)
kwallis install_latent if living!=2 | living!=3, by(hTreatment)

gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if stes_awareness==0

gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if stes_awareness==1


gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if stes_knowledge>=4

gsem (complexity_info <- 1.sex age education 2.stes_awareness 2.hFormat) (stes_perceived_usefulness <-  1.sex age education revenu 1.living 2.living 3.living 4.living 1.living2 2.living2 prosumerism energy_importance energy_independence complexity_info stes_potential_before 1.stes_awareness 2.hFormat 2.hTreatment 3.hTreatment 4.hTreatment) (install_stes <- stes_perceived_usefulness) if stes_knowledge<4

* 4. Descriptive statistics and structural consistency tests
* 4.1 Sex
fre sex
sum sex if sex!=3
sort hFormat
by hFormat: sum sex if sex!=3
tabulate sex hFormat if sex!=3, chi2

sort hTreatment
by hTreatment: sum sex if sex!=3
tabulate sex hTreatment if sex!=3, chi2
tabulate sex hTreatment if sex!=3, row col chi2

* 4.2 Age
fre age
sum age
sort hFormat
by hFormat: sum age
ttest age, by(hFormat)
sort hTreatment
by hTreatment: sum age
oneway age hTreatment

* 4.3 Education
fre education
sum education
sort hFormat
by hFormat: sum education
by hFormat: tab education
ttest education, by(hFormat)
sort hTreatment
by hTreatment: tab education
kwallis education, by(hTreatment)

* 4.4 Income
sum revenu
sort hFormat
by hFormat: sum revenu
tab revenu
by hFormat: tab revenu
ttest revenu, by(hFormat)
sort hTreatment
by hTreatment: tab revenu
kwallis revenu, by(hTreatment)

* 4.5 Living situation
tab living
sort hFormat
by hFormat: tab living
tabulate living hFormat, chi2

sort hTreatment
by hTreatment: tab living
tabulate living hTreatment, chi2

* 4.6 Living place
tab living2
sort hFormat
by hFormat: tab living2
tabulate living2 hFormat, chi2

sort hTreatment
by hTreatment: tab living2
tabulate living2 hTreatment, chi2

* 4.7 Energy importance
fre energy_importance
sum energy_importance
sort hFormat
by hFormat: sum energy_importance
ttest energy_importance, by(hFormat)

sort hTreatment
by hTreatment: sum energy_importance
oneway energy_importance hTreatment

* 4.8 Energy independence
tab energy_independence
sum energy_independence
sort hFormat
by hFormat: sum energy_independence
ttest energy_independence, by(hFormat)

sort hTreatment
by hTreatment: sum energy_independence
oneway energy_independence hTreatment

* 4.9 Prosumerism
tab prosumerism
sum prosumerism
sort hFormat
by hFormat: sum prosumerism
ttest prosumerism, by(hFormat)

sort hTreatment
by hTreatment: sum prosumerism
kwallis prosumerism, by(hTreatment)

* 4.10 STES familiarity
tab stes_awareness
sum stes_awareness
sort hFormat
by hFormat: tab stes_awareness
tabulate stes_awareness hFormat, chi2

sort hTreatment
by hTreatment: tab stes_awareness
tabulate stes_awareness hTreatment, chi2

*4.11 STES potential before
tab stes_potential_before
sum stes_potential_before
sort hFormat
by hFormat: sum stes_potential_before
ttest stes_potential_before, by(hFormat)

sort hTreatment
by hTreatment: sum stes_potential_before
oneway stes_potential_before hTreatment

* 4.12 N
fre hFormat if stes_perceived_usefulness!=.
fre hTreatment if stes_perceived_usefulness!=.

* 5. Robustness checks

* END







