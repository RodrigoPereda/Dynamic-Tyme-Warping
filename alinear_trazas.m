%% Función alinear_trazas

function [y_ref_alineado, y_traza2_alineado, y_traza3_alineado, indice_x1, indice_y1, indice_x2, indice_y2] = alinear_trazas(y_ref, y_traza2, y_traza3, path1, path2)

% Convertir a índices válidos
indice_x1 = path1(:,1) - 1; % Indice que aproxima y_ref a y_traza2
indice_y1 = path1(:,2) - 1; % Indice que aproxima y_traza2 a y_ref

indice_x2 = path2(:,1) - 1; % Se puede usar x1 o x2 indistintivamente, se usará x1
indice_y2 = path2(:,2) - 1; % Indice que aproxima y_traza3 a y_ref

% Evitar índices fuera de rango
indice_x1(indice_x1 < 1) = 1;
indice_y1(indice_y1 < 1) = 1;
indice_x1(indice_x1 > length(y_ref)) = length(y_ref);
indice_y1(indice_y1 > length(y_traza2)) = length(y_traza2);

indice_x2(indice_x2 < 1) = 1;
indice_y2(indice_y2 < 1) = 1;
indice_x2(indice_x2 > length(y_ref)) = length(y_ref);
indice_y2(indice_y2 > length(y_traza3)) = length(y_traza3);

% Alineamiento
y_ref_alineado = y_ref(indice_x1);
y_traza2_alineado = y_traza2(indice_y1);
y_traza3_alineado = y_traza3(indice_y2);

end