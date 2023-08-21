%This demo illustrates the steps for performing instrument standardization with PDS and classifying new mCP samples with the DD-SIMCA model. 

%1)Subset selection of instrument standardization samples: Subset and order
%the instrument standardization samples by leverage.

%2)Perform Piecewise Direct Standardization using the optimized window
%size.

%3)Apply the SIMCA model to the standardized spectra.

%This demo generates Fig. 5 from the manuscript.

%Requires PLS Toolbox (https://eigenvector.com/software/pls-toolbox/)

%Michael Fong (last updated on 5/30/2023)

clear
close all

%Load MBARI mCP data: Spectra have been corrected for the background and
%baseline shift and normalized to unit length.

MBARI_data=importdata('MBARI_mCP_data.csv');
MBARI.A=MBARI_data.data; %UV-visible spectra of each sample: Rows = Sample, Columns = Absorbances from 350 nm to 750 nm. 
MBARI.sample_info=MBARI_data.textdata; %Sample info: Measurement date and time, Sample Name

% clear MBARI_data

%Load NIST data: Spectra have been corrected for the background and
%baseline shift and normalized to unit length.
NIST_data=importdata('SIMCA_NISTData_cleaned.csv');

NIST.A=NIST_data.data; %UV-visible spectra of each sample: Rows = Sample, Columns = Absorbances from 350 nm to 750 nm. 
NIST.sample_info=NIST_data.textdata; %Sample info: Measurement date and time, Sample Name


 clear NIST_data

%Instrument standardization samples: FB4 dye in the NIST dataset and Dye 1
%(USF dye) in the MBARI dataset
    idx_FB4=any(startsWith(string({NIST.sample_info{:,2}}'),'FB4'),2); %Indices for the FB4 samples in the NIST dataset
    idx_cal=any([startsWith(string({MBARI.sample_info{:,2}}'),'Dye1')],2); %Indices for the Dye 1 samples (USF dye) in the MBARI dataset.

%Subset the MBARI dataset into a calibration and test set
    D_cal0=MBARI.A(idx_cal,:); %Dye 1 measurements used for instrument standardization
    D_test=MBARI.A(~idx_cal,:); %Other dye samples are in the test set.
    test_labels={MBARI.sample_info{~idx_cal,2}}'; %Labels for the test set samples
    
%Subset selection: MBARI dataset
[D_cal, D_cal_nos]=stdsslct(D_cal0,6); %PLS Toolbox function. Subset selection of instrument standardization samples by leverage. 6 samples are used for standardization.

%Subset selection: NIST dataset
FB4_NIST = NIST.A(idx_FB4,:); %Spectra of the FB4 dye in the NIST dataset
[FB4_NIST, FB4_NIST_nos]=stdsslct(FB4_NIST,6); %Subset selection: Select 6 of the FB4 spectra for standardization. The two subsets must have the same number of samples.

 %Piecewise Direct Standardization
  options.pds.win = 101; %Window size. This parameter needs to be optimized. A window size of 101 was found to be optimal for this data. (See manuscript.)
 [transfermodel,x1t,x2t] = caltransfer(FB4_NIST,D_cal,'pds',options); %PDS function in PLS toolbox
            
 %Apply PDS model to new data

 test_trans = caltransfer(D_test,transfermodel,options);

 A_trans =double([x2t; test_trans]); %Standardized spectra
 A_trans = normv2(A_trans); %Normalize spectra to unit length             
             
%Apply SIMCA model to data after instrument standardization.

CL=cell(size(x2t,1),1);
[CL{1:size(x2t,1)}]=deal('cal');
test_labels={CL{:}, test_labels{:}}';

 NewClass=ClassifymCPSamples(test_labels, A_trans);            

%Custom acceptance plot: This is Fig. 5 in the manuscript.
 figure

    plot(NewClass.AcceptancePlotData.x, NewClass.AcceptancePlotData.y,'-g')
    hold on
    grid on
    box on

    h1=plot(NewClass.AcceptancePlotData.SD_New(1:size(x2t,1)),NewClass.AcceptancePlotData.OD_New(1:size(x2t,1)),'o','MarkerEdgeColor',[0.5 0.5 0.5]); %Subset of data used as the calibration transfer samples     
    ht=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye2', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye2', 12)),'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5]); 
    h2=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye8', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye8', 12)),'o','MarkerFaceColor',[0.27 1 0],'MarkerEdgeColor',[0.27 1 0]); %Subset used to test the calibration transfer        
    h3=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye4', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye4', 12)),'o','MarkerFaceColor','b','MarkerEdgeColor','b');
    h4=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye9', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye9', 12)),'o','MarkerFaceColor','k','MarkerEdgeColor','k');
    h5=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye6', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye6', 12)),'o','MarkerFaceColor',[0.5 0 0.5],'MarkerEdgeColor',[0.5 0 0.5]);
    h6=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye3', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye3', 12)),'o','MarkerFaceColor','r','MarkerEdgeColor','r');
    h7=plot(NewClass.AcceptancePlotData.SD_New(strncmp(test_labels,'Dye5', 12)),NewClass.AcceptancePlotData.OD_New(strncmp(test_labels,'Dye5', 12)),'o','MarkerFaceColor',[0.5 0.5 0],'MarkerEdgeColor',[0.5 0.5 0]);


    legend([h1 ht h6 h3 h7 h5 h2 h4],'1- Calibration','2','3', '4', '5','6','8', '9', 'Location','NorthWest') 

     xlabel('log(1 + h/h_0)', 'FontWeight', 'bold');
     ylabel('log(1 + v/v_0)', 'FontWeight', 'bold');

     ylim([0 4])
     xlim([0 3])

     title(NewClass.AcceptancePlotTitle)
                 

               
