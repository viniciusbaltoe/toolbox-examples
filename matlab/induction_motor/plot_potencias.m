% Create data and 3-by-1 tiled chart layout
tiledlayout(2,1)

% PMI plot
ax1 = nexttile;
plot(ax1, wr, PMI)
title(ax1, 'Potencia Ativa x Velocidade')
ylabel(ax1, 'PMI (W)')
xlabel(ax1, 'wr (rad/s)')

% QMI plot
ax2 = nexttile;
plot(ax2, wr, QMI)
title(ax2, 'Potencia Reativa x Velocidade')
ylabel(ax2, 'QMI (VA)')
xlabel(ax2, 'wr (rad/s)')