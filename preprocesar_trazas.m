%% Función preprocesar_trazas

function [y_ref, y_traza2, y_traza3, n_traza, long_max] = preprocesar_trazas(y1, y2, y3)

%% Tratamiento de los datos leidos 

y1 = y1';
y2 = y2';
y3 = y3';

% Buscar la traza más larga para usarla de referencia
l1 = length(y1);
l2 = length(y2);
l3 = length(y3);
longitudes = [l1, l2, l3];
[long_max, n_traza] = max(longitudes);

switch n_traza
    case 1
        y_ref = y1;
        y_traza2 = y2;
        y_traza3 = y3;
    case 2
        y_ref = y2;
        y_traza2 = y1;
        y_traza3 = y3;
    case 3
        y_ref = y3;
        y_traza2 = y1;
        y_traza3 = y2;
end
end