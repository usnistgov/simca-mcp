function NewClass=ClassifymCPSamples(class_labels, A_samples)
%Classifies new mCP samples with the optimized SIMCA model and generates
%the acceptance plot

%Inputs:

%class_labels- nx1 cell array of sample names

%A_samples- UV-visible spectra of samples (350 nm to 750 nm). Spectra
%should be corrected for the background, baseline shifts, and normalized to
%unit length. They should also be corrected for differences in the
%spectrophotometer response using instrument standardization methods (e.g,
%PDS)

%Example: See Demo_ClassifyNewmCPSamples.m

 load('NIST_mCP_SIMCAModel.mat') %Loads the optimized SIMCA model with 5 PC's.

 NewClass = DDSTask(Model, A_samples); %Classify new samples.
 NewClass.Labels=class_labels;
 NewClass.ShowLabels();
 
 numPC=5;

%Default Acceptance Plot

 [NewClass.AcceptancePlotData, fig_handle]=NewClass.AcceptancePlot();
 NewClass.AcceptancePlotTitle=['Num. of PCs = ' num2str(numPC)];
 title(NewClass.AcceptancePlotTitle)
 grid on
 box on


         
    