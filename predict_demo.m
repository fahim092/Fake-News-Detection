%% =========================================================
%  FAKE NEWS DETECTION - INTERACTIVE PREDICTION DEMO
%  Run this AFTER running main.m (models must be trained)
% ==========================================================

clc; clear; close all;

fprintf('============================================\n');
fprintf('   FAKE NEWS DETECTOR - PREDICTION DEMO\n');
fprintf('============================================\n\n');

%% Load trained models
if ~isfile(fullfile('models','svm.mat'))
    error('Models not found. Please run main.m first.');
end

load(fullfile('models','svm.mat'),  'svmModel');
load(fullfile('models','naive_bayes.mat'), 'nbModel');

%% Load vocabulary (reconstructed from preprocessing)
[~, ~, ~, ~, vocab] = src.loadAndPreprocess();
[~, dummy_tfidf]    = src.extractFeatures(["dummy text"], ["dummy text"], vocab);

%% ---- Demo Inputs ----
testArticles = {
    'Scientists confirm that vaccines are safe and effective based on extensive clinical trials and peer-reviewed studies.'
    'SHOCKING: Government secretly putting chemicals in water to control population mind control exposed!'
    'The Federal Reserve raised interest rates by 25 basis points citing persistent inflation data.'
    'You will not believe this miracle cure doctors are hiding from you to make billions!'
    'New climate report by international panel shows global temperatures rising 1.1 degrees.'
    'BREAKING: Celebrities caught in underground reptilian conspiracy meeting in Antarctica!'
};

fprintf('%-5s  %-55s  %s\n', 'No.', 'Article Snippet', 'Prediction');
fprintf('%s\n', repmat('-', 1, 80));

for i = 1:numel(testArticles)
    article = string(testArticles{i});

    % Preprocess
    article_clean = lower(article);
    article_clean = regexprep(article_clean, '[^a-zA-Z\s]', ' ');
    article_clean = strtrim(regexprep(article_clean, '\s+', ' '));

    % Feature extraction
    [feat, ~] = src.extractFeatures(article_clean, article_clean, vocab);
    feat_row  = feat(1,:);

    % SVM prediction
    pred = predict(svmModel, feat_row);
    label = '✓ REAL';
    if double(string(pred)) == 1
        label = '✗ FAKE';
    end

    snippet = char(article);
    if numel(snippet) > 55
        snippet = [snippet(1:52), '...'];
    end
    fprintf('%-5d  %-55s  %s\n', i, snippet, label);
end

fprintf('\n============================================\n');
fprintf('  Modify testArticles{} to test your text!\n');
fprintf('============================================\n');
