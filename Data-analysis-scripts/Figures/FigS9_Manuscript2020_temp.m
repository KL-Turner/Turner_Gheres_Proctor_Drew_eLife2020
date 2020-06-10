function [] = FigS9_Manuscript2020_temp(rootFolder,AnalysisResults)
%________________________________________________________________________________________________________________________
% Written by Kevin L. Turner
% The Pennsylvania State University, Dept. of Biomedical Engineering
% https://github.com/KL-Turner
%________________________________________________________________________________________________________________________
%
% Purpose: Generate figure panel S9 for Turner_Kederasetti_Gheres_Proctor_Costanzo_Drew_Manuscript2020
%________________________________________________________________________________________________________________________

%% Set-up and process data for Fig S9 (a-c)
animalIDs = {'T99','T101','T102','T103','T105','T108','T109','T110','T111','T119','T120','T121','T122','T123'};
colorB = [(192/256),(0/256),(256/256)];   % NREM color
colorC = [(255/256),(140/256),(0/256)];   % REM color
% Mean HbT and heart rate comparison between behaviors
behavFields = {'Awake','NREM','REM'};
for aa = 1:length(animalIDs)
    animalID = animalIDs{1,aa};
    for bb = 1:length(behavFields)
        behavField = behavFields{1,bb};
        data.BehavioralDistributions.(behavField).EMG(aa,1) = mean(AnalysisResults.(animalID).BehaviorDistributions.(behavField).EMG);
        data.BehavioralDistributions.(behavField).Whisk(aa,1) = mean(AnalysisResults.(animalID).BehaviorDistributions.(behavField).Whisk);
        data.BehavioralDistributions.(behavField).Heart(aa,1) = mean(AnalysisResults.(animalID).BehaviorDistributions.(behavField).HR);
        data.BehavioralDistributions.(behavField).animalIDs{aa,1} = animalID;
        data.BehavioralDistributions.(behavField).behaviors{aa,1} = behavField;
    end
end
% take the mean and standard deviation of each set of signals
for cc = 1:length(behavFields)
    behavField = behavFields{1,cc};
    data.BehavioralDistributions.(behavField).meanEMG = mean(data.BehavioralDistributions.(behavField).EMG,1);
    data.BehavioralDistributions.(behavField).stdEMG = std(data.BehavioralDistributions.(behavField).EMG,0,1);
    data.BehavioralDistributions.(behavField).meanWhisk = mean(data.BehavioralDistributions.(behavField).Whisk,1);
    data.BehavioralDistributions.(behavField).stdWhisk = std(data.BehavioralDistributions.(behavField).Whisk,0,1);
    data.BehavioralDistributions.(behavField).meanHeart = mean(data.BehavioralDistributions.(behavField).Heart,1);
    data.BehavioralDistributions.(behavField).stdHeart = std(data.BehavioralDistributions.(behavField).Heart,0,1);
end
%% EMG stats
EMG_alphaConf = [0.05,0.01,0.001];
numComparisons = 2;
EMGtableSize = cat(1,data.BehavioralDistributions.Awake.EMG,data.BehavioralDistributions.NREM.EMG,data.BehavioralDistributions.REM.EMG);
EMGTable = table('Size',[size(EMGtableSize,1),3],'VariableTypes',{'string','double','string'},'VariableNames',{'Mouse','EMG','Behavior'});
EMGTable.Mouse = cat(1,data.BehavioralDistributions.Awake.animalIDs,data.BehavioralDistributions.NREM.animalIDs,data.BehavioralDistributions.REM.animalIDs);
EMGTable.EMG = cat(1,data.BehavioralDistributions.Awake.EMG,data.BehavioralDistributions.NREM.EMG,data.BehavioralDistributions.REM.EMG);
EMGTable.Behavior = cat(1,data.BehavioralDistributions.Awake.behaviors,data.BehavioralDistributions.NREM.behaviors,data.BehavioralDistributions.REM.behaviors);
EMGFitFormula = 'EMG ~ 1 + Behavior + (1|Mouse)';
EMGStats = fitglme(EMGTable,EMGFitFormula);
for z = 1:length(EMG_alphaConf)
    EMGCI{z,1} = coefCI(EMGStats,'Alpha',(EMG_alphaConf(z)/numComparisons)); %#ok<*AGROW>
end
%% Whisker variance stats
Whisk_alphaConf = [0.05,0.01,0.001];
numComparisons = 2;
WhisktableSize = cat(1,data.BehavioralDistributions.Awake.Whisk,data.BehavioralDistributions.NREM.Whisk,data.BehavioralDistributions.REM.Whisk);
WhiskTable = table('Size',[size(WhisktableSize,1),3],'VariableTypes',{'string','double','string'},'VariableNames',{'Mouse','Whisk','Behavior'});
WhiskTable.Mouse = cat(1,data.BehavioralDistributions.Awake.animalIDs,data.BehavioralDistributions.NREM.animalIDs,data.BehavioralDistributions.REM.animalIDs);
WhiskTable.Whisk = cat(1,data.BehavioralDistributions.Awake.Whisk,data.BehavioralDistributions.NREM.Whisk,data.BehavioralDistributions.REM.Whisk);
WhiskTable.Behavior = cat(1,data.BehavioralDistributions.Awake.behaviors,data.BehavioralDistributions.NREM.behaviors,data.BehavioralDistributions.REM.behaviors);
WhiskFitFormula = 'Whisk ~ 1 + Behavior + (1|Mouse)';
WhiskStats = fitglme(WhiskTable,WhiskFitFormula);
for z = 1:length(Whisk_alphaConf)
    WhiskCI{z,1} = coefCI(WhiskStats,'Alpha',(Whisk_alphaConf(z)/numComparisons));
end
%% HR stats
Heart_alphaConf = [0.05,0.01,0.001];
numComparisons = 2;
HearttableSize = cat(1,data.BehavioralDistributions.Awake.Heart,data.BehavioralDistributions.NREM.Heart,data.BehavioralDistributions.REM.Heart);
HeartTable = table('Size',[size(HearttableSize,1),3],'VariableTypes',{'string','double','string'},'VariableNames',{'Mouse','Heart','Behavior'});
HeartTable.Mouse = cat(1,data.BehavioralDistributions.Awake.animalIDs,data.BehavioralDistributions.NREM.animalIDs,data.BehavioralDistributions.REM.animalIDs);
HeartTable.Heart = cat(1,data.BehavioralDistributions.Awake.Heart,data.BehavioralDistributions.NREM.Heart,data.BehavioralDistributions.REM.Heart);
HeartTable.Behavior = cat(1,data.BehavioralDistributions.Awake.behaviors,data.BehavioralDistributions.NREM.behaviors,data.BehavioralDistributions.REM.behaviors);
HeartFitFormula = 'Heart ~ 1 + Behavior + (1|Mouse)';
HeartStats = fitglme(HeartTable,HeartFitFormula);
for z = 1:length(Heart_alphaConf)
    HeartCI{z,1} = coefCI(HeartStats,'Alpha',(Heart_alphaConf(z)/numComparisons));
end
%% Figure panel S9
summaryFigure = figure('Name','FigS9 (a-c)');
sgtitle('Figure Panel S9 (a-c) Turner Manuscript 2020')
%% [S9a] Mean EMG power during different behaviors
ax1 = subplot(1,3,1);
xInds = ones(1,length(animalIDs));
s1 = scatter(xInds*1,data.BehavioralDistributions.Awake.EMG,75,'MarkerEdgeColor','k','MarkerFaceColor',colors_Manuscript2020('rich black'),'jitter','on','jitterAmount',0.25);
hold on
e1 = errorbar(1,data.BehavioralDistributions.Awake.meanEMG,data.BehavioralDistributions.Awake.stdEMG,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e1.Color = 'black';
e1.MarkerSize = 10;
e1.CapSize = 10;
s2 = scatter(xInds*2,data.BehavioralDistributions.NREM.EMG,75,'MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
e2 = errorbar(2,data.BehavioralDistributions.NREM.meanEMG,data.BehavioralDistributions.NREM.stdEMG,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e2.Color = 'black';
e2.MarkerSize = 10;
e2.CapSize = 10;
s3 = scatter(xInds*3,data.BehavioralDistributions.REM.EMG,75,'MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
e3 = errorbar(3,data.BehavioralDistributions.REM.meanEMG,data.BehavioralDistributions.REM.stdEMG,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e3.Color = 'black';
e3.MarkerSize = 10;
e3.CapSize = 10;
title({'[S9a] Mean EMG power','during arousal states',''})
ylabel('EMG power (a.u.)')
legend([s1,s2,s3],'Not Asleep','NREM','REM')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis square
xlim([0,length(behavFields) + 1])
ylim([-2,0.5])
set(gca,'box','off')
ax1.TickLength = [0.03,0.03];
%% [S9b] Mean Whisker variance during different behaviors
ax2 = subplot(1,3,2);
xInds = ones(1,length(animalIDs));
scatter(xInds*1,data.BehavioralDistributions.Awake.Whisk,75,'MarkerEdgeColor','k','MarkerFaceColor',colors_Manuscript2020('rich black'),'jitter','on','jitterAmount',0.25);
hold on
e4 = errorbar(1,data.BehavioralDistributions.Awake.meanWhisk,data.BehavioralDistributions.Awake.stdWhisk,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e4.Color = 'black';
e4.MarkerSize = 10;
e4.CapSize = 10;
scatter(xInds*2,data.BehavioralDistributions.NREM.Whisk,75,'MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
e5 = errorbar(2,data.BehavioralDistributions.NREM.meanWhisk,data.BehavioralDistributions.NREM.stdWhisk,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e5.Color = 'black';
e5.MarkerSize = 10;
e5.CapSize = 10;
scatter(xInds*3,data.BehavioralDistributions.REM.Whisk,75,'MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
e6 = errorbar(3,data.BehavioralDistributions.REM.meanWhisk,data.BehavioralDistributions.REM.stdWhisk,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e6.Color = 'black';
e6.MarkerSize = 10;
e6.CapSize = 10;
title({'[S9b] Mean whisker variance','during arousal states',''})
ylabel('Whisker variance')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis square
xlim([0,length(behavFields) + 1])
ylim([0,45])
set(gca,'box','off')
ax2.TickLength = [0.03,0.03];
%% [S9c] Mean heart rate during different behaviors
ax3 = subplot(1,3,3);
xInds = ones(1,length(animalIDs));
scatter(xInds*1,data.BehavioralDistributions.Awake.Heart,75,'MarkerEdgeColor','k','MarkerFaceColor',colors_Manuscript2020('rich black'),'jitter','on','jitterAmount',0.25);
hold on
e7 = errorbar(1,data.BehavioralDistributions.Awake.meanHeart,data.BehavioralDistributions.Awake.stdHeart,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e7.Color = 'black';
e7.MarkerSize = 10;
e7.CapSize = 10;
scatter(xInds*2,data.BehavioralDistributions.NREM.Heart,75,'MarkerEdgeColor','k','MarkerFaceColor',colorB,'jitter','on','jitterAmount',0.25);
e8 = errorbar(2,data.BehavioralDistributions.NREM.meanHeart,data.BehavioralDistributions.NREM.stdHeart,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e8.Color = 'black';
e8.MarkerSize = 10;
e8.CapSize = 10;
scatter(xInds*3,data.BehavioralDistributions.REM.Heart,75,'MarkerEdgeColor','k','MarkerFaceColor',colorC,'jitter','on','jitterAmount',0.25);
e9 = errorbar(3,data.BehavioralDistributions.REM.meanHeart,data.BehavioralDistributions.REM.stdHeart,'d','MarkerEdgeColor','k','MarkerFaceColor','k');
e9.Color = 'black';
e9.MarkerSize = 10;
e9.CapSize = 10;
title({'[S9a] Mean heart rate','during arousal states',''})
ylabel('Heart rate (Hz)')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis square
xlim([0,length(behavFields) + 1])
ylim([5,9])
set(gca,'box','off')
ax3.TickLength = [0.03,0.03];
%% save figure(s)
dirpath = [rootFolder '\Summary Figures and Structures\'];
if ~exist(dirpath,'dir')
    mkdir(dirpath);
end
savefig(summaryFigure,[dirpath 'FigS9']);
set(summaryFigure,'PaperPositionMode','auto');
print('-painters','-dpdf','-bestfit',[dirpath 'FigS9'])
%% statistical diary
diaryFile = [dirpath 'FigS9_Statistics.txt'];
if exist(diaryFile,'file') == 2
    delete(diaryFile)
end
diary(diaryFile)
diary on
% EMG statistical diary
disp('======================================================================================================================')
disp('[S9a] Generalized linear mixed-effects model statistics for mean EMG during Not Asleep, NREM, and REM')
disp('======================================================================================================================')
disp(EMGStats)
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.05 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(EMGCI{1,1}(1,:))])
disp(['NREM: ' num2str(EMGCI{1,1}(2,:))])
disp(['REM: ' num2str(EMGCI{1,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.01 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(EMGCI{2,1}(1,:))])
disp(['NREM: ' num2str(EMGCI{2,1}(2,:))])
disp(['REM: ' num2str(EMGCI{2,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.001 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(EMGCI{3,1}(1,:))])
disp(['NREM: ' num2str(EMGCI{3,1}(2,:))])
disp(['REM: ' num2str(EMGCI{3,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
% heart rate statistical diary
disp('======================================================================================================================')
disp('[S9b] Generalized linear mixed-effects model statistics for whisker angle variance during Not Asleep, NREM, and REM')
disp('======================================================================================================================')
disp(WhiskStats)
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.05 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(WhiskCI{1,1}(1,:))])
disp(['NREM: ' num2str(WhiskCI{1,1}(2,:))])
disp(['REM: ' num2str(WhiskCI{1,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.01 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(WhiskCI{2,1}(1,:))])
disp(['NREM: ' num2str(WhiskCI{2,1}(2,:))])
disp(['REM: ' num2str(WhiskCI{2,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.001 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(WhiskCI{3,1}(1,:))])
disp(['NREM: ' num2str(WhiskCI{3,1}(2,:))])
disp(['REM: ' num2str(WhiskCI{3,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
% heart rate statistical diary
disp('======================================================================================================================')
disp('[S9c] Generalized linear mixed-effects model statistics for mean heart rate during Awake, NREM, and REM')
disp('======================================================================================================================')
disp(HeartStats)
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.05 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(HeartCI{1,1}(1,:))])
disp(['NREM: ' num2str(HeartCI{1,1}(2,:))])
disp(['REM: ' num2str(HeartCI{1,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.01 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(HeartCI{2,1}(1,:))])
disp(['NREM: ' num2str(HeartCI{2,1}(2,:))])
disp(['REM: ' num2str(HeartCI{2,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
disp('Alpha = 0.001 confidence interval with 3 comparisons to ''Not Asleep'' (Intercept): ')
disp(['Not Asleep: ' num2str(HeartCI{3,1}(1,:))])
disp(['NREM: ' num2str(HeartCI{3,1}(2,:))])
disp(['REM: ' num2str(HeartCI{3,1}(3,:))])
disp('----------------------------------------------------------------------------------------------------------------------')
diary off

end
