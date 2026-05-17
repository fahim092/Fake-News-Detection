function evaluateAndVisualize(mlResults, dlResults, y_test)
% EVALUATEANDVISUALIZE  Plot confusion matrices, accuracy bars, ROC curves.

    if ~isfolder('results')
        mkdir('results');
    end

    allResults = [mlResults, dlResults];
    names      = {allResults.modelName};
    accs       = [allResults.accuracy]  * 100;
    precs      = [allResults.precision] * 100;
    recs       = [allResults.recall]    * 100;
    f1s        = [allResults.f1]        * 100;

    %% ---- Figure 1: Accuracy Comparison Bar Chart ----
    fig1 = figure('Name','Model Accuracy Comparison','NumberTitle','off', ...
                  'Position',[100 100 900 500], 'Color','white');

    b = bar(accs, 'FaceColor','flat');
    colors = [0.2 0.6 0.9; 0.9 0.3 0.3; 0.3 0.8 0.4; 0.8 0.5 0.2];
    for k = 1:numel(accs)
        b.CData(k,:) = colors(min(k,end),:);
    end
    set(gca, 'XTickLabel', names, 'XTickLabelRotation', 15, ...
             'FontSize', 12, 'YLim', [0 105]);
    ylabel('Accuracy (%)');
    title('Model Accuracy Comparison', 'FontSize', 14, 'FontWeight','bold');
    grid on; box off;
    % Add value labels on bars
    for k = 1:numel(accs)
        text(k, accs(k)+1, sprintf('%.1f%%', accs(k)), ...
             'HorizontalAlignment','center', 'FontSize', 11, 'FontWeight','bold');
    end
    saveas(fig1, fullfile('results','accuracy_comparison.png'));

    %% ---- Figure 2: Grouped Metrics Bar Chart ----
    fig2 = figure('Name','Metrics Comparison','NumberTitle','off', ...
                  'Position',[100 100 1000 500], 'Color','white');
    metricsData = [accs; precs; recs; f1s]';
    bar(metricsData);
    set(gca, 'XTickLabel', names, 'XTickLabelRotation', 15, ...
             'FontSize', 11, 'YLim', [0 115]);
    legend({'Accuracy','Precision','Recall','F1-Score'}, ...
           'Location','northeast', 'FontSize', 11);
    ylabel('Score (%)');
    title('Detailed Metrics Comparison', 'FontSize', 14, 'FontWeight','bold');
    grid on; box off;
    saveas(fig2, fullfile('results','metrics_comparison.png'));

    %% ---- Figure 3: Confusion Matrices ----
    nModels = numel(allResults);
    fig3 = figure('Name','Confusion Matrices','NumberTitle','off', ...
                  'Position',[50 50 400*nModels 400], 'Color','white');

    for k = 1:nModels
        subplot(1, nModels, k);
        cm = allResults(k).confMat;   % [TN FP; FN TP]
        if isempty(cm) || any(isnan(cm(:))); continue; end
        imagesc(cm);
        colormap(gca, flipud(hot));
        colorbar;
        textLabels = {'Real','Fake'};
        set(gca, 'XTick',1:2,'XTickLabel',textLabels, ...
                 'YTick',1:2,'YTickLabel',textLabels, 'FontSize',12);
        xlabel('Predicted'); ylabel('Actual');
        title(allResults(k).modelName, 'FontSize',12, 'FontWeight','bold');
        % Annotate cells
        for r = 1:2
            for c = 1:2
                text(c, r, num2str(cm(r,c)), ...
                     'HorizontalAlignment','center', ...
                     'FontSize',14, 'FontWeight','bold', 'Color','white');
            end
        end
    end
    sgtitle('Confusion Matrices', 'FontSize',14, 'FontWeight','bold');
    saveas(fig3, fullfile('results','confusion_matrices.png'));

    %% ---- Save Summary CSV ----
    T = table(names', accs', precs', recs', f1s', ...
        'VariableNames', {'Model','Accuracy','Precision','Recall','F1_Score'});
    writetable(T, fullfile('results','summary_results.csv'));
    fprintf('      Summary saved to results/summary_results.csv\n');

    %% ---- Print final summary ----
    fprintf('\n');
    fprintf('  ╔══════════════════════════════════════════════════╗\n');
    fprintf('  ║           FINAL RESULTS SUMMARY                  ║\n');
    fprintf('  ╠══════════════════════════════════════════════════╣\n');
    fprintf('  ║  %-18s %8s %8s %8s %8s ║\n','Model','Acc%','Prec%','Rec%','F1%');
    fprintf('  ╠══════════════════════════════════════════════════╣\n');
    for k = 1:numel(allResults)
        fprintf('  ║  %-18s %8.1f %8.1f %8.1f %8.1f ║\n', ...
            allResults(k).modelName, accs(k), precs(k), recs(k), f1s(k));
    end
    fprintf('  ╚══════════════════════════════════════════════════╝\n');
end
