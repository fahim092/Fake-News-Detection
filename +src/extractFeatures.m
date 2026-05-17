function [X_train_tfidf, X_test_tfidf] = extractFeatures(X_train, X_test, vocab)
% EXTRACTFEATURES  Convert raw text arrays to TF-IDF feature matrices.
%
%   Inputs:
%     X_train  - (nTrain x 1) string array of training documents
%     X_test   - (nTest  x 1) string array of test documents
%     vocab    - (V x 1)      string array of vocabulary terms
%
%   Outputs:
%     X_train_tfidf - (nTrain x V) sparse TF-IDF matrix
%     X_test_tfidf  - (nTest  x V) sparse TF-IDF matrix

    MAX_VOCAB = 3000;   % cap vocabulary for speed
    if numel(vocab) > MAX_VOCAB
        vocab = vocab(1:MAX_VOCAB);
    end

    V      = numel(vocab);
    nTrain = numel(X_train);
    nTest  = numel(X_test);

    % Compute TF-IDF for training set
    [tf_train, df] = computeTF(X_train, vocab, V);

    % IDF (smooth variant)
    idf = log((nTrain + 1) ./ (df + 1)) + 1;   % shape: (1 x V)

    X_train_tfidf = tf_train .* idf;

    % Apply same IDF to test set
    [tf_test, ~]  = computeTF(X_test, vocab, V);
    X_test_tfidf  = tf_test  .* idf;

    fprintf('      Vocabulary size used: %d\n', V);
end

%% ---- helper ----
function [TF, DF] = computeTF(docs, vocab, V)
    N  = numel(docs);
    TF = zeros(N, V, 'single');
    DF = zeros(1, V, 'single');

    vocabMap = containers.Map(vocab, 1:V);

    for i = 1:N
        words  = split(docs(i), ' ');
        words(words == "") = [];
        nWords = numel(words);
        if nWords == 0; continue; end

        counts = zeros(1, V, 'single');
        for w = 1:numel(words)
            wd = words(w);
            if isKey(vocabMap, char(wd))
                j = vocabMap(char(wd));
                counts(j) = counts(j) + 1;
            end
        end

        TF(i,:) = counts / nWords;          % term frequency
        DF       = DF + (counts > 0);       % document frequency
    end
end
