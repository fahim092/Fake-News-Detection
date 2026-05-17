function results = trainDeepLearning(X_train, X_test, y_train, y_test, vocab)
% TRAINDEEPLEARNING  Build and train an LSTM network for fake news detection.
%
%   Architecture:
%     Embedding -> BiLSTM -> Dropout -> FC -> Softmax
%
%   Requires: Deep Learning Toolbox

    if ~license('test','Neural_Network_Toolbox')
        warning('Deep Learning Toolbox not available. Skipping LSTM training.');
        results = struct('modelName','LSTM (skipped)', ...
                         'accuracy',NaN, 'precision',NaN, ...
                         'recall',NaN,  'f1',NaN, 'confMat',[]);
        return;
    end

    MAX_VOCAB  = 3000;
    MAX_SEQ    = 100;   % max tokens per document

    %% Build word-index map
    vocabUsed = vocab(1:min(numel(vocab), MAX_VOCAB));
    wordMap   = containers.Map(vocabUsed, 1:numel(vocabUsed));
    UNK       = numel(vocabUsed) + 1;   % index for unknown tokens
    vocabSize = UNK;

    %% Encode text -> integer sequences
    X_tr_enc = encodeText(X_train, wordMap, UNK, MAX_SEQ);
    X_te_enc = encodeText(X_test,  wordMap, UNK, MAX_SEQ);

    %% Convert labels to categorical
    y_tr_cat = categorical(y_train, [0 1], {'Real','Fake'});
    y_te_cat = categorical(y_test,  [0 1], {'Real','Fake'});

    %% Convert to cell array of sequences (required by sequenceInputLayer)
    X_tr_cell = mat2seqCell(X_tr_enc);
    X_te_cell = mat2seqCell(X_te_enc);

    %% Define network layers
    embDim   = 64;
    lstmUnits= 128;

    layers = [ ...
        sequenceInputLayer(1, 'Name','input')
        wordEmbeddingLayer(embDim, vocabSize, 'Name','embed')
        bilstmLayer(lstmUnits, 'OutputMode','last', 'Name','bilstm')
        dropoutLayer(0.4, 'Name','drop')
        fullyConnectedLayer(2, 'Name','fc')
        softmaxLayer('Name','softmax')
        classificationLayer('Name','output') ];

    %% Training options
    opts = trainingOptions('adam', ...
        'MaxEpochs',          10, ...
        'MiniBatchSize',      64, ...
        'InitialLearnRate',   1e-3, ...
        'GradientThreshold',  1, ...
        'Shuffle',            'every-epoch', ...
        'ValidationData',     {X_te_cell, y_te_cat}, ...
        'ValidationFrequency',30, ...
        'Verbose',            false, ...
        'Plots',              'none');

    %% Train
    fprintf('         Training BiLSTM network (this may take a moment)...\n');
    tic;
    net = trainNetwork(X_tr_cell, y_tr_cat, layers, opts);
    trainTime = toc;

    %% Evaluate
    pred  = classify(net, X_te_cell);
    actual = y_te_cat;

    predBin   = double(pred   == 'Fake');
    actualBin = double(actual == 'Fake');

    TP = sum(predBin == 1 & actualBin == 1);
    FP = sum(predBin == 1 & actualBin == 0);
    TN = sum(predBin == 0 & actualBin == 0);
    FN = sum(predBin == 0 & actualBin == 1);

    acc  = (TP+TN) / numel(actualBin);
    prec = TP / max(TP+FP, 1);
    rec  = TP / max(TP+FN, 1);
    f1   = 2*prec*rec / max(prec+rec, 1e-9);

    results.modelName  = 'BiLSTM';
    results.accuracy   = acc;
    results.precision  = prec;
    results.recall     = rec;
    results.f1         = f1;
    results.trainTime  = trainTime;
    results.confMat    = [TN FP; FN TP];
    results.predictions= predBin;

    save(fullfile('models','lstm_model.mat'), 'net', 'wordMap', 'MAX_SEQ');

    fprintf('         BiLSTM Accuracy: %.2f%%\n', acc*100);
end

%% ---- helpers ----
function encoded = encodeText(texts, wordMap, unk, maxLen)
    N = numel(texts);
    encoded = unk * ones(N, maxLen, 'int32');
    for i = 1:N
        words = split(texts(i), ' ');
        words(words=="") = [];
        L = min(numel(words), maxLen);
        for j = 1:L
            w = char(words(j));
            if isKey(wordMap, w)
                encoded(i,j) = int32(wordMap(w));
            end
        end
    end
end

function C = mat2seqCell(M)
    % Each row becomes a (1 x T) sequence stored in a cell
    N = size(M,1);
    C = cell(N,1);
    for i = 1:N
        C{i} = double(M(i,:));   % 1 x MAX_SEQ
    end
end
