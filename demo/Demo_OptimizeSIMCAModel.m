%Demo_OptimizeSIMCAModel.m
%Author: Michael Fong, last revised 5/29/2023

%This demo illustrates the steps involved in training and optimizing a SIMCA model for
%pure mCP. Requires the DD-SIMCA MATLAB program by Zontov et al. (2017)

%1) The NIST mCP dataset is divided into a training set (pure mCP
%spectra) and a test set (pure and impure mCP samples). 

%2) The loading spectra and PCA scores are plotted for the first six
%principal components of the training dataset for inspection.

%3) SIMCA models with different numbers of principal components (1 to 10)
%are generated to evaluate the Type I and Type II errors and identify the
%most optimal model.

%4) For each model, outliers are identified by ROBPCA and excluded. The
%final SIMCA model is generated from the cleaned dataset. Acceptance plots
%are generated for each model.

%5) The Type I and Type II errors are calculated and plotted for each
%model. (Fig. 4 in the manuscript.)

%6) The acceptance plot is generated for the optimized SIMCA model (Fig. 1
%in the manuscript.)

clear 
close all

%Load NIST data: Spectra have been corrected for the background and
%baseline shift and normalized to unit length.
NIST_data=importdata('SIMCA_NISTData.csv');

A=NIST_data.data; %UV-visible spectra of each sample: Rows = Sample, Columns = Absorbances from 350 nm to 750 nm. 
sample_info=NIST_data.textdata; %Sample info: Measurement date and time, Sample Name

clear NIST_data

%Subset the full dataset into a training and test dataset
 
    %Dyes in the training set:

        %USF dye, 100% purity
        %FB4 dye, 100% purity 
        %AL883-67, 99.95% purity 

    %Dyes in the test set:

        %AL883-41, 99.1% purity
        %Acros, 98.65% purity   
        %Ricca, 98.75% purity
        %Alfa Aesar, 98.84% purity        
        %Flash 1, 100% purity
        %AL883-22, 99.86% purity
        %Loba Chemie, 99.5% purity 
        %AL883-67t, 99.95% purity (Sample names: 203B, 754B, 296B, 216A,
        %807A, 901B, 586B)
        
   idx_train=any([startsWith(string({sample_info{:,2}}'),'USF') startsWith(string({sample_info{:,2}}'),'FB4')...
               startsWith(string({sample_info{:,2}}'),'AL883_67')],2);
           
   idx_test=~idx_train;   
      
      %Test and training datasets.
      A_train = A(idx_train,:);
      A_test= A(idx_test,:);   

      %List of sample/measurement dates in the Training and Test sets. 
      sample_train = [{sample_info{idx_train,1}}' {sample_info{idx_train,2}}'];
      sample_test = [{sample_info{idx_test,1}}' {sample_info{idx_test,2}}'];
  
      
   %Plot loading spectra and PCA scores for the training dataset. The first
   %six prinicpal components are plotted.
    
   th='Training Dataset';
   w=350:750;
   opt=0; %No mean centering
   [sc, V, Var_exp, U, dg]=Plot_PCAScoresLoadingSpectra(A_train,th,w,opt);
 
 %Label samples in the Test set.
    
       class_test=cell(size(A_test,1),1);
       
       class_test(startsWith(string({sample_test{:,2}}'),'AL883_41'))={'AL41'};
       class_test(startsWith(string({sample_test{:,2}}'),'Acros'))={'Acr'};
       class_test(startsWith(string({sample_test{:,2}}'),'FB4'))={'FB4'};
       class_test(startsWith(string({sample_test{:,2}}'),'Flash1'))={'F1'};
       class_test(startsWith(string({sample_test{:,2}}'),'AL883_22'))={'AL22'};
       class_test(startsWith(string({sample_test{:,2}}'),'Lobal'))={'LB'};
       class_test(startsWith(string({sample_test{:,2}}'),'203B'))={'AL67t'};
       class_test(startsWith(string({sample_test{:,2}}'),'754B'))={'AL67t'};
       class_test(startsWith(string({sample_test{:,2}}'),'296B'))={'AL67t'};
       class_test(startsWith(string({sample_test{:,2}}'),'216A'))={'AL67t'};
       class_test(startsWith(string({sample_test{:,2}}'),'807A'))={'AL67t'};
       class_test(startsWith(string({sample_test{:,2}}'),'901B'))={'AL67t'};
       class_test(startsWith(string({sample_test{:,2}}'),'586B'))={'AL67t'};       
       class_test(startsWith(string({sample_test{:,2}}'),'AL883_67'))={'AL67t'};       
       class_test(startsWith(string({sample_test{:,2}}'),'Alfa'))={'Alf'}; 
       class_test(startsWith(string({sample_test{:,2}}'),'Ricca'))={'Ric'};
       

   %Label Test Set samples as pure = 0 or impure = 1.
   
   ExternalObjects = nan(size(A_test,1),1);
   
       ExternalObjects(startsWith(string(class_test),'AL67t'))= 0;
       ExternalObjects(startsWith(string(class_test),'FB4'))= 0;
       ExternalObjects(startsWith(string(class_test),'F1'))= 0;
       ExternalObjects(startsWith(string(class_test),'AL67'))= 0;
       ExternalObjects(startsWith(string(class_test),'AL22'))= 1;
       ExternalObjects(startsWith(string(class_test),'AL41'))= 1;
       ExternalObjects(startsWith(string(class_test),'Acr'))= 1;
       ExternalObjects(startsWith(string(class_test),'LB'))= 1;
       ExternalObjects(startsWith(string(class_test),'Alf'))= 1;
       ExternalObjects(startsWith(string(class_test),'Ric'))= 1;
  
   %Initialize arrays:        
           PercentError2 =nan(10,6); %Type II error: Rate of wrong acceptances of impure dyes 
           PercentError1 =nan(10,1); %Type I error (rate of wrong rejection of pure dye samples) in the Test Set.
           PercentError1_train=nan(10,4); %Type I error in the Training Set.
           
           num_outliers =nan(10,1); %Number of outliers identified in the intermediate step with ROBPCA.
  
%Optimize the SIMCA model by testing different numbers of prinicipal
%components and evaluating the Type I and Type II errors.

    for numPC = 1:10 %Number of prinicipal components in the model
        
    %create initial the DD-SIMCA model object
     Model = DDSimca(A_train, numPC);      
     
   %Intermediate step: Detect outliers in the training set with ROBPCA. Remove these from the dataset and then generate the SIMCA model from the cleaned data.  
    
   %Set the model parameters. The model will update automatically.
        Model.Alpha = 0.05; %Target Type I error
        Model.Gamma = 0.001;%Outlier significance level   
        Model.EstimationMethod='robust'; %Robust PCA for outlier detection
        
        num_outliers(numPC) = sum(Model.OutlierObjects); %Number of outliers
        
        A_clean=A_train(~Model.OutlierObjects,:); %Cleaned data with outliers removed
        
        if numPC==1
            A_clean=A_train; %The 1 PC model is not stable. 
        end
        
    %Generate SIMCA model with CLEANED dataset.
     Model = DDSimca(A_clean, numPC);          
   
    %Set model parameters
    Model.Alpha = 0.05; %Target Type I error
    Model.Gamma = 0.001; %Outlier significance level
        
    %Classify samples in the test set with the SIMCA model
    NewClass = DDSTask(Model, A_test);
    NewClass.Labels=class_test;
    NewClass.ShowLabels();
         
    %Make acceptance plots starting with 2 PCs.
         if numPC>1
             [NewClass.AcceptancePlotData, fig_handle]=NewClass.AcceptancePlot();
             NewClass.AcceptancePlotTitle=['Num. of PCs = ' num2str(numPC)];
             title(NewClass.AcceptancePlotTitle)
             grid on
             box on
         end
          
        %Calculate Type I error:
        PercentError1(numPC)= (1-(sum(NewClass.ExternalObjects(ExternalObjects==0)==0)/sum(ExternalObjects==0)))*100;%Type I error: Rate of wrong rejection of pure dye samples
        
        
        %Calculate Type II error for the impure dyes: AL22, AL41, Acr, LB,
        %Alfa, Ricca
        PercentError2(numPC,:)=[(1-(sum(NewClass.ExternalObjects(startsWith(string(class_test),'AL22')))/sum(startsWith(string(class_test),'AL22'))))*100 ...
             (1-(sum(NewClass.ExternalObjects(startsWith(string(class_test),'AL41')))/sum(startsWith(string(class_test),'AL41'))))*100 ...
             (1-(sum(NewClass.ExternalObjects(startsWith(string(class_test),'Acr')))/sum(startsWith(string(class_test),'Acr'))))*100 ...
             (1-(sum(NewClass.ExternalObjects(startsWith(string(class_test),'LB')))/sum(startsWith(string(class_test),'LB'))))*100 ...
             (1-(sum(NewClass.ExternalObjects(startsWith(string(class_test),'Alf')))/sum(startsWith(string(class_test),'Alf'))))*100 ...
             (1-(sum(NewClass.ExternalObjects(startsWith(string(class_test),'Ric')))/sum(startsWith(string(class_test),'Ric'))))*100];
        
     %Calculate Type I error in the training dataset:
        Model_Check = DDSTask(Model, A_clean);
        PercentError1_train(numPC)=(sum(Model_Check.ExternalObjects)/size(A_clean,1))*100;

    end
   
    
    %Plot Type I and Type II errors. This is Fig. 4 in the manuscript. The
    %Type II errors for Acros, Ricca, and Alfa Aesar are not plotted.
    
    figure
    
    plot(1:10,PercentError2(:,1),'Color','k','Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k')
    hold on
    plot(1:10,PercentError2(:,2),'Color',[0.5 0 0.5],'Marker','d','MarkerEdgeColor',[0.5 0 0.5],'MarkerFaceColor',[0.5 0 0.5])
    plot(1:10,PercentError2(:,4),'Color',[1 0.54 0],'Marker','^','MarkerEdgeColor',[1 0.54 0],'MarkerFaceColor',[1 0.54 0])
    plot(1:10,PercentError1,'Color', 'b','Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b')
    plot(1:10,PercentError1_train,'Color', [0.5 0.5 0.5],'Marker','o','MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
    plot(1:10,PercentError2(:,1),'Color','k','Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k')
    
    grid on 
    box on
    xlabel('Number of PCs','fontweight','bold')
    ylabel('Percent Error','fontweight','bold')
    
    lh = legend('AL883-22', 'AL883-41','Loba Chemie','Pure (\geq99.95%) - Test','Pure (\geq99.95%) - Training');

    set(gca,'fontsize', 15)
    set(lh,'fontsize',10)
    xlim([1 10])
    
    pause %Hit any key to continue
    close all
    clear
    
    load('NIST_mCP_SIMCAModel.mat') %Loads the optimized SIMCA model with 5 PC's.
    
    %Acceptance Plot for the optimized SIMCA model: Fig. 1 in manuscript
    
      figure
            plot(TestClass.AcceptancePlotData.x, TestClass.AcceptancePlotData.y,'-g')
            hold on
            grid on
            box on
            
                h1= plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'AL67t', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'AL67t', 12)),'og','MarkerFaceColor','g');                
                h2=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'F1', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'F1', 12)),'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5]);    
                h3=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'AL22', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'AL22', 12)),'ob','MarkerFaceColor','b');                
                h4=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'AL41', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'AL41', 12)),'ok','MarkerFaceColor','k');                
                h5=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'LB', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'LB', 12)),'o','MarkerFaceColor',[0.5 0 0.5],'MarkerEdgeColor',[0.5 0 0.5]);    
                h6=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'Acr', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'Acr', 12)),'or','MarkerFaceColor','r');                
                h7=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'Ric', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'Ric', 12)),'o','MarkerFaceColor',[1 0.27 0],'MarkerEdgeColor',[1 0.27 0]);                
                h8=plot(TestClass.AcceptancePlotData.SD_New(strncmp(TestClass.Labels,'Alf', 12)),TestClass.AcceptancePlotData.OD_New(strncmp(TestClass.Labels,'Alf', 12)),'o','MarkerFaceColor',[0.5 0.5 0],'MarkerEdgeColor',[0.5 0.5 0]);
       
                legend([h1 h2 h3 h4 h5 h6 h7 h8],'AL883-67t','F1', 'AL883-22', 'AL883-41', 'Loba Chemie', 'Acros', 'Ricca','Alfa Aesar', 'Location','NorthWest')       
        
                 xlabel('log(1 + h/h_0)', 'FontWeight', 'bold');
                 ylabel('log(1 + v/v_0)', 'FontWeight', 'bold');
                
                 title(TestClass.AcceptancePlotTitle)    
    

    
    