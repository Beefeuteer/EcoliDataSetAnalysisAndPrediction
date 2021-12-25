clc;
clear;
close all;
%**************Classların numeric karşılığı**************
%   cp  (cytoplasm)                                     1
%   im  (inner membrane without signal sequence)        2
%   pp  (perisplasm)                                    3
%   imU (inner membrane, uncleavable signal sequence)   4
%   om  (outer membrane)                                5
%   omL (outer membrane lipoprotein)                    6
%   imL (inner membrane lipoprotein)                    7
%   imS (inner membrane, cleavable signal sequence)     8
%**************Classların numeric karşılığı**************

%WE USED TWO DATA FOR THIS PROJECT BECAUSE MATLAB GAVE US SOME ERRORS WHILE
%WE IMPORT DATA WITH CATEGORICAL VALUE SO THERE ARE TWO DATA SETS FOR THE
%DIFFERENT OPERATIONS SUCH AS "ecoli.data" and "ecoliKNN.data"
%WE USED ECOLI KNN DATA ON THE PREDICT OPERATION AND USED OTHER ECOLI DATA
%ON THE OTHER OPERATIONS.

%Reads the chosen dataset
load('ecoli.data')
fprintf('**What you want to do?**');
fprintf(2,'\nFor the operations(1)\nFind centered data matrix(2)\nFor PCA algorithm(3)\nSample data to find specific category(4)\n');
todo=input('Choose a thing to do: ');
switch todo
    case 1

%Chose the attribute from dataset
fprintf('**Attributes**');
fprintf(2,'\nmcg(1)\ngvh(2)\nlip(3)\nchg(4)\naac(5)\nalm1(6)\nalm2(7)\nClasses(8)\n');
Attribute=input('Choose an attribute: ');

fprintf('**Operations**');
fprintf(2,'\nmean(1)\nmedian(2)\nsum(3)\nmax(4)\nrange(5)\nskewness(6)\nkurtosis(7)\nboxplot(8)\noutliers(9)\nNothing(0)\n');
Operation=input('Choose an operation: ');
    switch Operation
        case 1
        Mean=mean(ecoli(:,Attribute))
        case 2
        Median=median(ecoli(:,Attribute))
        case 3
        Sum=sum(ecoli(:,Attribute))
        case 4
        Max=max(ecoli(:,Attribute))
        Min=min(ecoli(:,Attribute))
        case 5
        Range=range(ecoli(:,Attribute))
        case 6
        Skewness=skewness(ecoli(:,Attribute))
        if skewness(ecoli(:,Attribute))>0
                 disp('curve to right')
            elseif skewness(ecoli(:,Attribute))<0
                 disp('curve to left')
            else disp('curve is symetric')
        end
        case 7
        Kurtosis=kurtosis(ecoli(:,Attribute))
        if kurtosis(ecoli(:,Attribute))
                 disp('curve to platykurtic')
            elseif kurtosis(ecoli(:,Attribute))>3
                 disp('curve to leptokurtic')
            else disp('curve is mesokurtic')
        end
        case 8
        boxplot(ecoli(:,Attribute))
        case 9
        K=ecoli(:,Attribute);
        LL=quantile(K,0.25) -1.5*iqr(K);
        UL=quantile(K,0.75) +1.5*iqr(K);
        count=0;
        for i=1:length(K)
             if(K(i)>UL || K(i)<LL)
                 count=count+1;
            end
        end
        outliers=count
        
        otherwise
            disp('You did not choose anything');
    end  
    case 2
    %Finds the centered data matrix
     load('ecoli.data')
     ecoli(:,8)=[]; %we remove the class because we are trying to find centered data matrix
     meanecoli=mean(ecoli); %we get mean of the data set
     ecolinorm=ecoli-meanecoli; %then we subtract from the data
     newmean=mean(ecolinorm); %again we need to take mean of the new dataset called ecolinorm
     scatter(ecoli,meanecoli,'blue');
     hold on
     title('Red is scatter of centered data matrix','Blue is old data matrix');
     scatter(ecolinorm,newmean,'red');
     hold off
    case 3
     X=ecoli(:,[1,2,3,4,5,6,7]); %inputlarımız
     y=ecoli(:,[8]); %outputlarımız(classlar)
     m=2;
     [U, Z] = pca(X, 'NumComponents',m); %pca uygulanıyor
     figure;
     hold on
     scatter(Z(:,1), Z(:,2), 25, y, 'filled'); %grafik
     hold off
     colormap(jet); %farklı renklerle daha kolay görmek için
    case 4
    % Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 8);
    % Specify range and delimiter
    opts.DataLines = [1, Inf];
    opts.Delimiter = ",";
    % Specify column names and types
    opts.VariableNames = ["mcg", "gvh", "lip", "chg", "aac", "alm1", "alm2", "Class"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "categorical"];
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    % Specify variable properties
    opts = setvaropts(opts, "Class", "EmptyFieldRule", "auto");
    % Import the data
    ecoliKNN = readtable("ecoliKNN.data", opts);
    % Clear temporary variables
    clear opts
    
    %Predict KNN
    modelformed = fitcknn(ecoliKNN,'Class~mcg+gvh+lip+chg+aac+alm1+alm2');
    modelformed.NumNeighbors=3;
    mcg=input('Enter mcg: ');
    gvh=input('Enter gvh: ');
    lip=input('Enter lip: ');
    chg=input('Enter chg: ');
    aac=input('Enter aac: ');
    alm1=input('Enter alm1: ');
    alm2=input('Enter alm2: ');
    predict(modelformed,[mcg,gvh,lip,chg,aac,alm1,alm2])
end
