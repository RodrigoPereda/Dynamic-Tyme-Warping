%% Función my_dtw

function [D, path] = my_dtw(y_ref, y_traza)
   
    % M y N longitudes de ambas trazas
    N = length(y_ref);
    M = length(y_traza);

    % D es la matriz de distancias acumuladas con bordes infinitos y punto
    % de partida = 0
    D = inf(N+1, M+1);
    D(1,1) = 0;

    % Calcular y rellenar la matriz D
    for i = 2:N+1
        for j = 2:M+1
            d_cuadratica = (y_ref(i-1) - y_traza(j-1))^2;
            D(i,j) = d_cuadratica + min([D(i-1,j), D(i,j-1), D(i-1,j-1)]);
        end
    end

    % '(i, j-1)' --> Distancia Horizontal
    % '(i-1, j)' --> Distancia Vertical
    % '(i, j)'   --> Distancia Diagonal

    % Retroceso para obtener el camino óptimo
    i = N+1;
    j = M+1;
    path = [i, j];

    % Encontrar el camino hasta llegar al i = 0, j = 0
    while i > 1 || j > 1
        if i == 1
            j = j - 1;
        elseif j == 1
            i = i - 1;
        else
            [~, n] = min([D(i-1,j), D(i,j-1), D(i-1,j-1)]);
            switch n 
                case 1
                    i = i - 1;
                case 2
                    j = j - 1;
                case 3
                    i = i - 1;
                    j = j - 1;
            end
        end
        path = [i, j; path]; % Ir guardando el camino
    end
end