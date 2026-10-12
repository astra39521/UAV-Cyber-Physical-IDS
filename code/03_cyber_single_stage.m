%% 03_cyber_single_stage.m
% Single-stage multi-class classification on Cyber data
% Classes: Benign + DoS attack + Replay + Evil Twin + FDI

clear; clc; close all;

trainPath = fullfile('..', 'data', 'Cyber_Train_70.csv');
testPath  = fullfile('..', 'data', 'Cyber_Test_30.csv');
if ~isfile(trainPath)
    trainPath = fullfile(getenv('USERPROFILE'), 'Downloads', 'Cyber_Train_70.csv');
    testPath  = fullfile(getenv('USERPROFILE'), 'Downloads', 'Cyber_Test_30.csv');
end

opts = detectImportOptions(trainPath);
opts.VariableNamingRule = 'preserve';
TrainT = readtable(trainPath, opts);
TestT  = readtable(testPath, opts);
TrainT.class = string(TrainT.class);
TestT.class  = string(TestT.class);

fprintf('Train: %d | Test: %d\n', height(TrainT), height(TestT));

classOrder = ["benign", "DoS attack", "Replay", "Evil Twin", "FDI"];
featureNames = setdiff(TrainT.Properties.VariableNames, {'class'}, 'stable');

Xtrain = zeros(height(TrainT), numel(featureNames));
Xtest  = zeros(height(TestT),  numel(featureNames));
for k = 1:numel(featureNames)
    Xtrain(:,k) = str2double(string(TrainT.(featureNames{k})));
    Xtest(:,k)  = str2double(string(TestT.(featureNames{k})));
end

keep = var(Xtrain, 0, 1, 'omitnan') > 1e-8;
Xtrain = Xtrain(:, keep); Xtest = Xtest(:, keep);

for k = 1:size(Xtrain,2)
    m = median(Xtrain(:,k), 'omitnan'); if isnan(m), m = 0; end
    Xtrain(isnan(Xtrain(:,k)),k) = m;
    Xtest(isnan(Xtest(:,k)),k)   = m;
end

YtrainCat = categorical(TrainT.class, classOrder);
YtestCat  = categorical(TestT.class, classOrder);
validTr = ~isundefined(YtrainCat); validTe = ~isundefined(YtestCat);
Xtrain = Xtrain(validTr,:); YtrainCat = YtrainCat(validTr);
Xtest  = Xtest(validTe,:);  YtestCat  = YtestCat(validTe);

[Ytrain, classNames] = grp2idx(YtrainCat);
Ytest = grp2idx(YtestCat);

xmin = min(Xtrain); xrange = max(Xtrain)-xmin; xrange(xrange==0)=1;
Xtrain = (Xtrain-xmin)./xrange; Xtest = (Xtest-xmin)./xrange;

modelNames = {'Decision Tree','Random Forest','Bagged Trees','KNN (K=5)','SVM (RBF)','Majority Vote'};
acc = zeros(6,1); predAll = cell(6,1);

mdl = fitctree(Xtrain, Ytrain, 'MinLeafSize',5);
predAll{1} = predict(mdl, Xtest); acc(1) = mean(predAll{1}==Ytest);

mdl = TreeBagger(50, Xtrain, Ytrain, 'Method','classification','MinLeafSize',5);
predAll{2} = str2double(predict(mdl, Xtest)); acc(2) = mean(predAll{2}==Ytest);

mdl = fitcensemble(Xtrain, Ytrain, 'Method','Bag','NumLearningCycles',50);
predAll{3} = predict(mdl, Xtest); acc(3) = mean(predAll{3}==Ytest);

mdl = fitcknn(Xtrain, Ytrain, 'NumNeighbors',5);
predAll{4} = predict(mdl, Xtest); acc(4) = mean(predAll{4}==Ytest);

mdl = fitcecoc(Xtrain, Ytrain, 'Learners', templateSVM('KernelFunction','rbf','Standardize',false));
predAll{5} = predict(mdl, Xtest); acc(5) = mean(predAll{5}==Ytest);

predAll{6} = mode([predAll{1}, predAll{2}, predAll{3}], 2);
acc(6) = mean(predAll{6}==Ytest);

fprintf('\n%-20s %10s %10s\n', 'Model', 'Accuracy', 'Error');
[~,idx] = sort(acc,'descend');
for i=1:6
    k=idx(i);
    fprintf('%-20s %10.4f %10.4f\n', modelNames{k}, acc(k), 1-acc(k));
end
fprintf('Best: %s (%.2f%%)\n', modelNames{idx(1)}, 100*acc(idx(1)));

figure; bar(100*acc); set(gca,'XTickLabel',modelNames,'XTickLabelRotation',15);
ylabel('Accuracy (%)'); title('Cyber Single-Stage (5 Classes)'); grid on; ylim([min(acc)*100-5 100]);

figure; confusionchart(Ytest, predAll{idx(1)});
title(sprintf('Best: %s | %.2f%%', modelNames{idx(1)}, 100*acc(idx(1))));
