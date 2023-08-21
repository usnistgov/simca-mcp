function [sc, V, Var_exp, U, dg]=Plot_PCAScoresLoadingSpectra(M,th,w,opt)

%opt - Input 1 to toggle mean-centering. 0 for no mean-centering

%Performs PCA on a set of spectra and plots the
%first six loading spectra and scores profiles

    
     if opt == 1
              S_M=mean(M);
              M= M-S_M; %mean center
     end
     
          [U,dg,V]=svd(M);
          sc=U*dg; %scores
          
                Var_exp=100*(diag(dg.^2)/sum(diag(dg.^2)));
%           

%Loading spectra        
             figure
                 subplot(6,1,1)
                 hold on
                  title(th)
                 box on
                for i=1:6 

                    subplot(6,1,i)
                    plot(w,V(:,i),'LineWidth',1.5,'Color',[0.5 0.5 0.5])

                    if i < 6
                        set(gca,'XTickLabel',[])
                    end
                    
                      set(gca,'fontsize',10)
                end
                
              

                xlabel('Wavelength (nm)','fontweight','bold')
                
                     [ax,h]=suplabel('Loading Spectra','y');
                     set(h,'fontweight','bold')
            
    %Scores profiles        
            figure
                 subplot(6,1,1)
                 hold on
                  title(th)
                 box on
                for i=1:6 

                    subplot(6,1,i)
                    plot(sc(:,i),'Marker','o','Color',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])


                    if i < 6
                        set(gca,'XTickLabel',[])
                    end

                         xlim([1 size(M,1)])
                
                         set(gca,'fontsize',10)
                end
                
                         xlabel('Sample No.','fontweight','bold')
                
                     [ax,h]=suplabel('Scores','y');
                     set(h,'fontweight','bold')
                     
                     
   