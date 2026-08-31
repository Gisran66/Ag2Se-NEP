function metrics = plot_results(output_file)
%PLOT_RESULTS Plot archived Ag-Se NEP training outputs (MATLAB R2021a+).
%   metrics = plot_results;                  % display without saving
%   metrics = plot_results('training_results.png');
%   Input files are resolved relative to this function. An optional output
%   path is resolved by MATLAB relative to the current working directory.
%   No training or scientific-input modification is performed.
%
%   GPUMD comparison files: first half = NEP, second half = DFT reference.
%   Energy and virial: eV/atom; force: eV/Angstrom; stress: GPa.
%   Loss columns 1:7: generation, total, L1, L2, energy, force, virial.
%   Test-loss columns are not used: this archive has no independent test set.

if nargin < 1
    output_file = '';
end
data_dir = fileparts(mfilename('fullpath'));
loss_data = readmatrix(fullfile(data_dir, 'loss.out'), 'FileType', 'text');
assert(size(loss_data, 2) >= 7 && all(isfinite(loss_data(:, 1:7)), 'all'), ...
    'loss.out must contain at least seven finite columns.');

fig = figure('Color', 'w', 'Position', [100 100 1400 850]);
tiles = tiledlayout(fig, 2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
title(tiles, 'Ag-Se NEP: training-set diagnostics (not an independent test)');

ax = nexttile(tiles);
loglog(ax, loss_data(:, 1), loss_data(:, 5:7), 'LineWidth', 1.2);
xlabel(ax, 'Generation'); ylabel(ax, 'Training RMSE (native units)');
title(ax, 'Training losses'); grid(ax, 'on');
legend(ax, {'Energy (eV/atom)', 'Force (eV/Angstrom)', 'Virial (eV/atom)'}, ...
    'Location', 'best');

names = {'energy', 'force', 'virial', 'stress'};
units = {'meV/atom', 'meV/Angstrom', 'meV/atom', 'GPa'};
scales = [1000 1000 1000 1];
n_components = [1 3 6 6];
metrics = struct();
for k = 1:numel(names)
    name = names{k};
    raw = readmatrix(fullfile(data_dir, [name '_train.out']), 'FileType', 'text');
    n = n_components(k);
    assert(size(raw, 2) == 2*n && ~isempty(raw), ...
        '%s_train.out must contain %d columns.', name, 2*n);
    valid = all(isfinite(raw), 2);
    % Exclude very large missing-label sentinels in stress/virial output.
    if k >= 3
        valid = valid & all(abs(raw) < 1e6, 2);
    end
    assert(any(valid), 'No valid rows in %s_train.out.', name);
    if any(~valid)
        warning('plot_results:ExcludedRows', ...
            '%s: excluding %d nonfinite/missing-label rows.', name, sum(~valid));
    end
    prediction = raw(valid, 1:n) * scales(k);
    reference = raw(valid, n+1:2*n) * scales(k);
    prediction = prediction(:);
    reference = reference(:);
    residual = prediction - reference;
    denominator = sum((reference - mean(reference)).^2);
    result = struct('unit', units{k}, 'components', numel(reference), ...
        'excluded_rows', sum(~valid), 'MAE', mean(abs(residual)), ...
        'RMSE', sqrt(mean(residual.^2)), 'R2', NaN);
    if denominator > 0
        result.R2 = 1 - sum(residual.^2)/denominator;
    end
    metrics.(name) = result;
    fprintf('%s: N=%d, MAE=%.9g, RMSE=%.9g %s, R2=%.9g, excluded rows=%d\n', ...
        name, result.components, result.MAE, result.RMSE, units{k}, ...
        result.R2, result.excluded_rows);

    ax = nexttile(tiles);
    ids = unique(round(linspace(1, numel(reference), min(numel(reference), 100000))));
    plot(ax, reference(ids), prediction(ids), '.', 'MarkerSize', 3);
    hold(ax, 'on');
    bounds = [min([reference; prediction]), max([reference; prediction])];
    padding = max(0.04*diff(bounds), 1e-6*max(1, max(abs(bounds))));
    bounds = bounds + [-padding padding];
    plot(ax, bounds, bounds, 'k--', 'LineWidth', 1);
    xlim(ax, bounds); ylim(ax, bounds); axis(ax, 'square'); grid(ax, 'on');
    xlabel(ax, ['DFT (' units{k} ')']); ylabel(ax, ['NEP (' units{k} ')']);
    title(ax, sprintf('%s: RMSE %.4g %s', name, result.RMSE, units{k}));
    subtitle(ax, sprintf('R^2 = %.5f; shown %d/%d components', ...
        result.R2, numel(ids), result.components));
end

ax = nexttile(tiles);
loglog(ax, loss_data(:, 1), loss_data(:, 2:4), 'LineWidth', 1.2);
xlabel(ax, 'Generation'); ylabel(ax, 'Loss value');
title(ax, 'Total loss and regularization'); grid(ax, 'on');
legend(ax, {'Total', 'L1', 'L2'}, 'Location', 'best');
drawnow;
if ~isempty(output_file)
    exportgraphics(fig, output_file, 'Resolution', 180);
    fprintf('Saved figure: %s\n', output_file);
end
end
