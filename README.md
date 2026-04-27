# DT_Geography_vs_Income_Carbon_Tax

Working Paper Insee - Geography versus Income: The Heterogeneous Effects of Carbon Taxation (FR: Géographie ou Revenus : les effets distributifs de la taxation carbone)
Also: IA No 117 policy note - Taxing firm emissions or household emissions: effects by income level and territory (FR: Taxer les émissions des entreprises ou taxer celles des ménages : effets selon les revenus et les territoires)

To reproduce the Working Paper:
- use R for Data files
- use Matlab (2025b if possible) for Model files


File "Data Households emissions": use R
- Households_BdF_2017.R runs the code from the Working Paper, section 1.1. 
- Households_BdF_2017_AAV.R runs the from from the policy note (Appendix).


File "Data Firms emissions": use R
- Emissions_firms_cities.R runs the code from the section 1.2. of the Working Paper. 
- Emissions_firms_UU.R runs a robustness fromthe section 1.2. of the Working Paper, using urban units instead of city codes.
- Emissions_firms_AAV.R runs the from from the policy note (Appendix).


File "Working Paper UU": run the code for the model of the Working Paper, use MATLAB (2025b if possible)
- Step 1: To run steady states run MAIN2_SS
- Step 2: To see calibration run Graph1_calibration.m
- Step 3: To run transitional dynamics, run MAIN3_TRANS (it lasts a few minutes)
- For additional info, see the README.pdf in the file


File "IA AAV": run the code for the model of the policy note, use MATLAB (2025b if possible)
- Step 1: To run steady states run MAIN2_SS
- Step 2: To see calibration run Graph1_calibration.m, or run directly MAIN0_Calib.m
- Step 3: To run transitional dynamics, run MAIN3_TRANS (it lasts a few minutes)
- For additional info, see the README.pdf in the file




