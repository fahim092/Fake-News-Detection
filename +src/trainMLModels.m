function results = trainMLModels(X_train, X_test, y_train, y_test)
% TRAINMLMODELS  Train and evaluate three classical ML classifiers.
%
%   Models trained:
%     1. Naive Bayes (GaussianNB via fitcnb)
%     2. Support Vector Machine (fitcsvm with RBF kernel)
%     3. Decision Tree (fitctree)
%
%   Returns a struct with fields: modelName, accuracy, precision,
%   recall, f1, confMat, predictions.

    y_train = categorical(y_train);
    y_test  = categorical(y_test);

    results = struct();

    %% --- 1. Naive Bayes ---
    fprintf('         Training Naive Bayes...\n');
    tic;
    nbModel = fitcnb(X_train, y_train);
    nbTime  = toc;
    [nbPred, ~] = predict(nbModel, X_test);
    results(1) = buildResult('Naive Bayes', nbPred, y_test, nbTime);
    save(fullfile('models','naive_bayes.mat'), 'nbModel');

    %% --- 2. SVM ---
    fprintf('         Training SVM (Linear)...\n');
    tic;
    svmModel = fitcsvm(X_train, y_train, ...
                       'KernelFunction', 'linear', ...
                       'BoxConstraint',  1, ...
                       'Standardize',    true);
    svmTime  = toc;
    [svmPred, ~] = predict(svmModel, X_test);
    results(2) = buildResult('SVM (Linear)', svmPred, y_test, svmTime);
    save(fullfile('models','svm.mat'), 'svmModel');

    %% --- 3. Decision Tree ---
    fprintf('         Training Decision Tree...\n');
    tic;
    dtModel = fitctree(X_train, y_train, 'MaxNumSplits', 50);
    dtTime  = toc;
    [dtPred, ~] = predict(dtModel, X_test);
    results(3) = buildResult('Decision Tree', dtPred, y_test, dtTime);
    save(fullfile('models','decision_tree.mat'), 'dtModel');

    %% --- Print summary table ---
    fprintf('\n      --- ML Results Summary ---\n');
    fprintf('      %-20s %8s %8s %8s %8s\n', 'Model','Acc%','Prec%','Rec%','F1%');
    fprintf('      %s\n', repmat('-',1,60));
    for k = 1:numel(results)
        fprintf('      %-20s %8.2f %8.2f %8.2f %8.2f\n', ...
            results(k).modelName, ...
            results(k).accuracy   * 100, ...
            results(k).precision  * 100, ...
            results(k).recall     * 100, ...
            results(k).f1         * 100);
    end
end

%% ---- helper ----
function r = buildResult(name, pred, actual, trainTime)
    pred   = double(string(pred) == '1');
    actual = double(string(actual) == '1');

    TP = sum(pred == 1 & actual == 1);
    FP = sum(pred == 1 & actual == 0);
    TN = sum(pred == 0 & actual == 0);
    FN = sum(pred == 0 & actual == 1);

    acc  = (TP + TN) / numel(actual);
    prec = TP / max(TP + FP, 1);
    rec  = TP / max(TP + FN, 1);
    f1   = 2 * prec * rec / max(prec + rec, 1e-9);

    r.modelName   = name;
    r.accuracy    = acc;
    r.precision   = prec;
    r.recall      = rec;
    r.f1          = f1;
    r.trainTime   = trainTime;
    r.confMat     = [TN FP; FN TP];
    r.predictions = pred;
end
