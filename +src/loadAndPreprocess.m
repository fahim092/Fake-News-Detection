function [X_train, X_test, y_train, y_test, vocab] = loadAndPreprocess()
% LOADANDPREPROCESS  Load dataset, clean text, split into train/test sets.
%
%   Since we cannot ship a real dataset, this function either:
%     (a) loads  data/news_dataset.csv  if it exists, OR
%     (b) generates a synthetic dataset for demonstration.
%
%   CSV format expected:  text , label
%                         "...", 1      (1 = Fake, 0 = Real)

    dataFile = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'news_dataset.csv');

    if isfile(dataFile)
        fprintf('      Reading CSV: %s\n', dataFile);
        T      = readtable(dataFile, 'TextType', 'string');
        texts  = T.text;
        labels = T.label;
    else
        fprintf('      [NOTE] Dataset not found. Generating synthetic data...\n');
        [texts, labels] = generateSyntheticData(1000);
    end

    % ---- Text Cleaning ----
    texts = lower(texts);
    texts = regexprep(texts, '[^a-zA-Z\s]', ' ');   % remove punctuation/numbers
    texts = strtrim(regexprep(texts, '\s+', ' '));   % collapse whitespace

    % ---- Build Vocabulary ----
    allWords = split(join(texts, ' '), ' ');
    allWords(allWords == "") = [];
    vocab = unique(allWords);
    vocab = vocab(strlength(vocab) > 2);             % drop 1-2 char tokens

    % ---- Train / Test Split (80 / 20) ----
    N   = numel(texts);
    rng(42);                                         % reproducibility
    idx = randperm(N);
    nTr = round(0.8 * N);

    X_train = texts(idx(1:nTr));
    X_test  = texts(idx(nTr+1:end));
    y_train = labels(idx(1:nTr));
    y_test  = labels(idx(nTr+1:end));
end

%% ---- helper: synthetic dataset ----
function [texts, labels] = generateSyntheticData(N)
    fakePhrases = ["shocking truth revealed", "you won't believe", ...
                   "mainstream media hiding", "secret exposed", ...
                   "hoax confirmed", "miracle cure discovered", ...
                   "government lies", "viral conspiracy"];
    realPhrases = ["according to researchers", "study published in", ...
                   "officials confirmed", "data shows", ...
                   "analysis indicates", "report released by", ...
                   "scientists found", "evidence suggests"];

    texts  = strings(N, 1);
    labels = zeros(N, 1);

    for i = 1:N
        if rand < 0.5
            phrase       = fakePhrases(randi(numel(fakePhrases)));
            texts(i)     = phrase + " and more fake content number " + i;
            labels(i)    = 1;   % Fake
        else
            phrase       = realPhrases(randi(numel(realPhrases)));
            texts(i)     = phrase + " with verified information number " + i;
            labels(i)    = 0;   % Real
        end
    end
end
