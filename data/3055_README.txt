NIST Data Publication:
UV-visible absorbance spectra of purified and unpurified m-cresol purple samples
in sodium hydroxide and sodium chloride solutions at pH 12
Version 1.0.0
DOI: https://doi.org/10.18434/mds2-3055

Authors:
  Michael  Fong
    National Institute of Standards and Technology
  Yuichiro  Takeshita
    Monterey Bay Aquarium Research Institute
  Regina  Easley
    National Institute of Standards and Technology
  Jason   Waters
    National Institute of Standards and Technology

Contact:
  Michael Fong
    michael.fong@nist.gov

Description:

M-cresol purple is the most widely used pH indicator dye for seawater pH
measurements. Impurities in the indicator are known to absorb strongly at one of
the wavelengths used in spectrophotometric pH determination and lead to large
biases in the pH measurements. This dataset repository contains measurements of the UV-
visible absorbance spectra (350 nm to 750 nm) of purified and unpurified
m-cresol purple samples in sodium hydroxide and sodium chloride solutions at pH
12 and an ionic strength of 0.7 mol/kg soln. The UV-visible absorbance
measurements were collected on an Agilent Cary 100 spectrophotometer at NIST. These data
were used to train a SIMCA model for detecting residual impurities in purified
m-cresol purple relevant to climate quality pH measurements. A second dataset is included consisting of 
similar measurements of various purified m-cresol purple samples collected on an Agilent 8453 spectrophotometer
at MBARI. This dataset was used to test the performance of the SIMCA model on samples measured on a different
spectrophotometer. The SIMCA model and results are published in the manuscript 
"Detection of impurities in m-cresol purple with SIMCA for the quality control of spectrophotometric pH measurements
in seawater."


-------------------
General Information
-------------------
The NIST data was collected: March 10, 2022 to November 17, 2022.
The MBARI data was collected: November 16, 2018 to November 27, 2018.

File format: CSV

Key funding sources:

M.B. Fong was supported by a fellowship from the NIST NRC Postdoctoral Research Associateship Program. 
Work and personnel at MBARI was funded by the David and Lucile Packard Foundation, NSF OCE-2049117, and NSF OCE-1736864.  

--------------
Data Use Notes
--------------

This data is publicly available according to the NIST statements of
copyright, fair use and licensing; see
https://www.nist.gov/director/copyright-fair-use-and-licensing-statements-srd-data-and-software

You may cite the use of this data as follows:
Fong, Michael, Takeshita, Yuichiro, Easley, Regina, Waters, Jason  (2023), UV-visible absorbance
spectra of purified and unpurified m-cresol purple samples in sodium hydroxide
and sodium chloride solutions at pH 12, Version 1.0.0, National Institute of
Standards and Technology, https://doi.org/10.18434/mds2-3055 (Accessed: [give
download date])

----------
References
----------

Fong, M.B., Takeshita, Y., Easley, R., Waters, J. (in prep) Detection of impurities in m-cresol purple with SIMCA 
for the quality control of spectrophotometric pH measurements in seawater. Marine Chemistry.

Takeshita, Y., Warren, J.K., Liu, X., Spaulding, R.S., Byrne, R.H., Carter, B.R., Degrandpre, M.D., Murata, A., Watanabe, S. (2021)
Consistency and stability of purified meta-cresol purple for spectrophotometric pH measurements in seawater. Marine Chemistry, 236.

-------------
Data Overview
-------------

File List
   A. SIMCA_NISTData.csv       
      Full dataset from Fong et al. (2023) used to train and test the SIMCA model.       
        
   B. SIMCA_NISTData_cleaned.csv        
      Cleaned dataset from Fong et al. (2023) with two outliers (identified by robust PCA) removed from the training set. 

   C. MBARI_mCP_data.csv        
      Purified m-cresol purple dataset from Takeshita et al. (2021).

---------------
Version History
---------------

1.0.0 (this version)
  initial release

--------------------------
Methodological Information
--------------------------

Full methodological information is described in the manuscript by Fong et al. (2023).
See Takeshita et al. (2021) for the methodological information for the MBARI measurements.

Instrument: Agilent Cary 100 spectrophotometer (on single and double beam mode) using a 10 cm cell for NIST measurements
	    Agilent 8453 spectrophotometer using a 10 cm cell for MBARI measurements.

Parameter measured: Absorbance from 350 nm to 750 nm

Measurement temperature: 25 ± 0.012 °C (mean ± combined std. uncertainty) for NIST measurements
			 25 ± 0.02 °C (mean ± combined std. uncertainty) for MBARI measurements

Sample type: 

	Purified and unpurified m-cresol purple solutions from different manufacturers in a background of ~0.01 mol/kg soln
	sodium hydroxide and ~0.69 mol/kg soln sodium chloride.

	Samples in the MBARI dataset are purified m-cresol purple from different manufacturers. 

Sample pH: 12

Data processing:

For each sample, triplicate measurements of the sample spectrum were corrected for the background absorbance and averaged.
This mean spectrum was then further adjusted for baseline shifts (between 725 nm to 735 nm) and normalized to unit length. 

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: SIMCA_NISTData.csv, SIMCA_NISTData_cleaned.csv, and MBARI_mCP_data.csv 
-----------------------------------------

Number of variables: 403


Number of rows: Each row contains the data for one measurement.
	171 measurements for SIMCA_NISTData.csv 
	169 measurements for SIMCA_NISTData_cleaned.csv
	29 measurements for MBARI_mCP_data.csv


Data fields
    A. Date and Time
       Description: Located in Column 1. 
                    Provides the date and time of the measurement in the format mon/day/year hr:min.
		    The format in MBARI_mCP_data.csv is mon/day/year


    B. Sample ID
       Description: Located in Column 2.
                    The name of the m-cresol purple sample, identifying the manufacturer, lot number, and measurement number. (See Table 1 in the manuscript by Fong et al., 2023)
		    Samples named 586B, 754B, 901B, 296B, 203B, 216A, 807A are solutions prepared from AL883-67t. The manufacturers are not identified in the MBARI dataset.

    C. Absorbance at wavelength n
       Description: Located in Columns 3 to 403. 
                    The absorbance at wavelength n, where n = 350 nm to 750 nm. Column 3 starts with the absorbances at 350 nm, and Column 403 contains the absorbances at 750 nm.


