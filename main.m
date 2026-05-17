%% =========================================================
%  FAKE NEWS DETECTION USING MACHINE LEARNING & DEEP LEARNING
%  Main Script - Run this file to execute the full pipeline
%  =========================================================
%  Author  : [Your Name]
%  Course  : [Course Name]
%  Date    : 2025
% ==========================================================

clc; clear; close all;

fprintf('==============================================\n');
fprintf('   FAKE NEWS DETECTION SYSTEM - MATLAB\n');
fprintf('==============================================\n\n');

%% STEP 1: Load and Preprocess Data
fprintf('[1/5] Loading and preprocessing dataset...\n');
[X_train, X_test, y_train, y_test, vocab] = src.loadAndPreprocess();
fprintf('      Done! Training samples: %d | Test samples: %d\n\n', ...
    size(X_train,1), size(X_test,1));

%% STEP 2: Feature Extraction (TF-IDF)
fprintf('[2/5] Extracting TF-IDF features...\n');
[X_train_tfidf, X_test_tfidf] = src.extractFeatures(X_train, X_test, vocab);
fprintf('      Feature matrix size: %d x %d\n\n', size(X_train_tfidf));

%% STEP 3: Train ML Models
fprintf('[3/5] Training Machine Learning models...\n');
mlResults = src.trainMLModels(X_train_tfidf, X_test_tfidf, y_train, y_test);
fprintf('      ML Models trained successfully!\n\n');

%% STEP 4: Train Deep Learning Model (LSTM)
fprintf('[4/5] Training Deep Learning (LSTM) model...\n');
dlResults = src.trainDeepLearning(X_train, X_test, y_train, y_test, vocab);
fprintf('      LSTM Model trained successfully!\n\n');

%% STEP 5: Evaluate and Visualize Results
fprintf('[5/5] Evaluating and generating reports...\n');
src.evaluateAndVisualize(mlResults, dlResults, y_test);
fprintf('      Results saved to /results/ folder!\n\n');

fprintf('==============================================\n');
fprintf('   ALL DONE! Check the results/ folder.\n');
fprintf('==============================================\n');
