SIMCA mCP

version 1: July 2023

ABOUT SIMCA mCP:

This repository contains data and Matlab scripts to facilitate the implementation of 
a DD-SIMCA model for the acceptance testing of purified m-cresol purple (mCP) for spectrophotometric pH measurements
in seawater. The model was trained on measurements of UV-visible absorbance spectra of purified mCP and tested on
independent datasets consisting of purified and unpurified mCP samples. The repository contains demo scripts that will demonstrate
the training and optimization of the DD-SIMCA model and reproduce the figures in the associated publication (see citation below). 
A function is provided for users to classify new mCP samples with the model. 

You may cite the use of the data as follows:

Fong, Michael, Takeshita, Yuichiro, Easley, Regina, Waters, Jason  (2023), UV-visible absorbance
spectra of purified and unpurified m-cresol purple samples in sodium hydroxide
and sodium chloride solutions at pH 12, Version 1.0.0, National Institute of
Standards and Technology, https://doi.org/10.18434/mds2-3055 (Accessed: [give
download date])

You may cite the publication as follows:

Fong, M.B., Takeshita, Y., Easley, R., Waters, J. (in prep) Detection of impurities in m-cresol purple with SIMCA 
for the quality control of spectrophotometric pH measurements in seawater. Marine Chemistry.


Project Status: Maintenance only 

Testing Summary

The demo scripts have been tested to ensure that they can be run in Matlab R2019b and Matlab R2022a with only 
the provided functions, data files, and PLS Toolbox version 8.9.2 (Eigenvector Research) and that they reproduce
the figures in the associated manuscript.

Getting Started

Download the repository SIMCA mCP and add the main repository as well as all subfolders 
to MATLAB's search path. 

Run either of the m-files in the \demo folder to verify that the scripts work. 

Demo_OptimizeSIMCAModel.m will illustrate the training and optimization of the DD-SIMCA Model
and generate Fig. 1 and Fig. 4 from the manuscript.

Demo_ClassifyNewmCPSamples provides an example of classifying new mCP samples with the optimized model and generates Fig. 5
from the manuscript. This demo requires PLS Toolbox to perform the instrument standardization.

The demo scripts use the data contained in the folder \data.

New samples measured by the user can be classified with the SIMCA model by calling:

	NewClass = ClassifymCPSamples(class_labels, A_samples)		

The inputs are class_labels, a cell array of sample names, and A_samples, a matrix containing the spectra of the samples.
This function loads the optimized SIMCA model saved in mCP SIMCA Model\NIST_mCP_SIMCAModel.mat and calls DDSTask to classify the new samples

Prerequisites

Requires MATLAB and PLS Toolbox.

Author

Michael Fong

Copyright

This software was developed by employees of the National Institute of
Standards and Technology (NIST), an agency of the Federal Government and is
being made available as a public service. Pursuant to title 17 United States
Code Section 105, works of NIST employees are not subject to copyright
protection in the United States.  This software may be subject to foreign
copyright.  Permission in the United States and in foreign countries, to the
extent that NIST may hold copyright, to use, copy, modify, create derivative
works, and distribute this software and its documentation without fee is hereby
granted on a non-exclusive basis, provided that this notice and disclaimer of
warranty appears in all copies.

To see the latest statement, please visit:
https://www.nist.gov/director/copyright-fair-use-and-licensing-statements-srd-data-and-software

Also see the licenses:

	SIMCA mCP\LICENSE.md
	SIMCA mCP\functions\dd-simca-master\LICENSE.md
	SIMCA mCP\functions\suplabel\LICENSE.txt

Acknowledgments

	suplabel.m was written by Ben Barrowes (barrowes@alum.mit.edu)

	normv2.m was written by Roma Tauler and Anna de Juan,
	Chemometrics and Solution Equilibria Group, University of Barcelona
	
	This repository includes the DD-SIMCA tool developed by Zontov et al. (2017).

	Y.V. Zontov, O.Ye. Rodionova, S.V. Kucheryavskiy, A.L. Pomerantsev,
	DD-SIMCA – A MATLAB GUI tool for data driven SIMCA approach, Chemometrics and Intelligent Laboratory Systems, Volume 167, 2017,
	Pages 23-28, ISSN 0169-7439, DOI:[10.1016/j.chemolab.2017.05.010](https://doi.org/10.1016/j.chemolab.2017.05.010).

Contact

For questions, comments, or reporting any bugs, please contact Michael Fong (michael.fong@nist.gov).


