function [sn]=normv2(s)

%This code is from:

% MATLAB program MCR-ALS:                      
% multivariate curve resolution (MCR)           
% alternating least squares (ALS)               
% written by Roma Tauler and Anna de Juan       
% last update, December 2003                    
% Chemometrics and Solution Equilibria group    
% University of Barcelona                      
% Department of Analytical Chemistry            
% Diagonal 647, Barcelona 08028                 
% e-mail roma@quimio.qui.ub.es                  

%Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 3.0
%Unported License 

% https://creativecommons.org/licenses/by-nc-sa/3.0/legalcode 

% normalitzacio s=s/sqrt(sum(si)2))
[m,n]=size(s);
for i=1:m,
sr=sqrt(sum(s(i,:).*s(i,:)));
sn(i,:)=s(i,:)./sr;
end
end
