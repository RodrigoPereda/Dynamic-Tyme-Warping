%% Función interpolar_trazas

function [y1_final, y2_final, y3_final, yavg_final] = interpolar_trazas(y_ref_alineado, y_traza2_alineado, y_traza3_alineado, long_max)


% Interpolación a N puntos
N = long_max;
puntos_interp = linspace(0, 1, N);
x_ref1 = linspace(0, 1, length(y_ref_alineado));
x_o1 = linspace(0, 1, length(y_traza2_alineado));
x_o2 = linspace(0, 1, length(y_traza3_alineado));

yref_interp1 = interp1(x_ref1, y_ref_alineado, puntos_interp, 'linear', 'extrap');
yo1_interp = interp1(x_o1, y_traza2_alineado, puntos_interp, 'linear', 'extrap');
yo2_interp = interp1(x_o2, y_traza3_alineado, puntos_interp, 'linear', 'extrap');

% Pasar a vector columna
y1_final = yref_interp1';
y2_final = yo1_interp';
y3_final = yo2_interp';

% Promedio
yavg_final = mean([yref_interp1; yo1_interp; yo2_interp], 1);

end
