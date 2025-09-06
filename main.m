%% Función Main

%% Lectura de las distintas gráficas de los ratios Mg/Ca

fig1 = openfig('VS_LAN100_1.fig','invisible');
fig2 = openfig('VS_LAN100_2.fig','invisible');
fig3 = openfig('VS_LAN100_3.fig','invisible'); 


% Lectura datos Traza 1
Ejes_Trama1 = findall(fig1,'type','axes');
Curva_Trama1 = findall(Ejes_Trama1,'type','line');
x1 = get(Curva_Trama1, 'XData');
y1 = get(Curva_Trama1, 'YData');

% Lectura datos Traza 2
Ejes_Trama2 = findall(fig2,'type','axes');
Curva_Trama2 = findall(Ejes_Trama2,'type','line');
x2 = get(Curva_Trama2, 'XData');
y2 = get(Curva_Trama2, 'YData');

% Lectura datos Traza 3
Ejes_Trama3 = findall(fig3,'type','axes');
Curva_Trama3 = findall(Ejes_Trama3,'type','line');
x3 = get(Curva_Trama3, 'XData');
y3 = get(Curva_Trama3, 'YData');


%% Preprocesado de las trazas

[y_ref, y_traza2, y_traza3, n_traza, long_max] = preprocesar_trazas(y1, y2, y3);

%% Aplicación del DTW

% Aplicación de la función DTW
[D1, path1] = my_dtw(y_ref, y_traza2);
[D2, path2] = my_dtw(y_ref, y_traza3);

% Dos valores del DTW: la matriz distancia y el camino recorrido

%% Alineamiento de las trazas

[y_ref_alineado, y_traza2_alineado, y_traza3_alineado, indice_x1, indice_y1, indice_x2, indice_y2] = alinear_trazas(y_ref, y_traza2, y_traza3, path1, path2);

%% Interpolación para igualar longitud de trazas


[y1_final, y2_final, y3_final, yavg_final] = interpolar_trazas(y_ref_alineado, y_traza2_alineado, y_traza3_alineado, long_max);


%% Valo cuantitativo de semejanzas entre las trazas

corr_12 = corr(y1_final, y2_final);
corr_13 = corr(y1_final, y3_final);
corr_23 = corr(y2_final, y3_final);

% Mostrar resultados en pantalla

fprintf('Traza Ref vs Traza 2:\n');
fprintf('Correlación Pearson: %.4f\n', corr_12);

fprintf('Traza Ref vs Traza 3:\n');
fprintf('Correlación Pearson: %.4f\n', corr_13);

fprintf('Traza 2 vs Traza 3:\n');
fprintf('Correlación Pearson: %.4f\n', corr_23);

%% Representación de:  Todas las trazas / Aplicadas el DTW / Traza Promedia

% Trazas Originales
figure;
subplot(3,1,1);
plot(y1, 'b', 'DisplayName', 'Traza 1');
hold on;
plot(y2, 'r', 'DisplayName', 'Traza 2');
plot(y3, 'g', 'DisplayName', 'Traza 3');
legend('Traza 1','Traza 2','Traza 3');
title('Perfiles originales');
xlabel('Distancia');
ylabel('Relación Mg/Ca');
        
% Trazas procesadas por el DTW
subplot(3,1,2);   
    % Switch para que cada traza tenga siempre el mismo color
switch n_traza
    case 1
        plot(y1_final, 'b', 'DisplayName', 'Traza 1 ref');
        hold on;
        plot(y2_final, 'r', 'DisplayName', 'Traza 2');
        plot(y3_final, 'g', 'DisplayName', 'Traza 3');
    case 2
        plot(y1_final, 'r', 'DisplayName', 'Traza 2 ref');
        hold on;
        plot(y2_final, 'b', 'DisplayName', 'Traza 1');
        plot(y3_final, 'g', 'DisplayName', 'Traza 3');
    case 3
        plot(y1_final, 'g', 'DisplayName', 'Traza 3 ref');
        hold on;
        plot(y2_final, 'b', 'DisplayName', 'Traza 1');
        plot(y3_final, 'r', 'DisplayName', 'Traza 2');
end
legend show;
title('Curvas Alineadas por DTW');
xlabel('Índice del camino DTW');
ylabel('Relación Mg/Ca');
grid on;


% Traza promedia
subplot(3,1,3);
plot(yavg_final, 'black', 'DisplayName', 'Traza Promedia');
hold on;
legend('yavg-final');
title('Traza Promedia');
xlabel('Distancia interpolada');
ylabel('Relación Mg/Ca');


%% Representación del funcionamiento del DTW

figure;
subplot(2,1,1);
hold on;
separacion = 10;

% Dibujar trazas originales desplazadas

plot(y_ref + separacion, 'r', 'LineWidth', 1.5, 'DisplayName', 'Traza referencia (desplazada)');
plot(y_traza2, 'b', 'LineWidth', 1.5, 'DisplayName', 'Traza sin alinear'); 

% Dibujar líneas de correspondencia (grises) del DTW (con y_ref desplazada)

for k = 1:length(indice_x1)
    x1 = indice_x1(k);
    x2 = indice_y1(k);

    y1_val = y_ref(x1) + separacion;   % Perfil desplazado verticalmente
    y2_val = y_traza2(x2);             

    plot([x1, x2], [y1_val, y2_val],'LineWidth', 0.5, 'Color', [0.5 0.5 0.5]); 
end

legend('y-ref + separación','y-traza2');
xlabel('Índice');
ylabel('Relación Mg/Ca');
title('Alinematiento Temporal - Correspondencia entre puntos (con desplazamiento vertical)');

subplot(2,1,2)
hold on;
% Dibujar trazas originales desplazadas
plot(y_ref + separacion, 'r', 'LineWidth', 1.5, 'DisplayName', 'Traza referencia (desplazada)');
plot(y_traza3, 'black', 'LineWidth', 1.5, 'DisplayName', 'Traza sin alinear');

% Dibujar líneas de correspondencia (grises) del DTW (con y_ref desplazada)
for k = 1:length(indice_x2)
    x1 = indice_x2(k);
    x2 = indice_y2(k);

    y1_val = y_ref(x1) + separacion;   % Perfil desplazado verticalmente
    y2_val = y_traza3(x2);             

    plot([x1, x2], [y1_val, y2_val],'LineWidth', 0.5, 'Color', [0.5 0.5 0.5]);
end

legend('y-ref + separación','y-traza3');
xlabel('Índice');
ylabel('Relación Mg/Ca');
title('Alinematiento Temporal - Correspondencia entre puntos (con desplazamiento vertical)');


%% Dibujar las matrices Distancia junto con el Camino Optimo
% Para D1
figure;
imagesc(D1);
colormap(white);     
axis equal tight;
grid on;
title('Matriz de Distancias D1');

% % Agregar los valores numéricos en cada celda
% [nFila, nCol] = size(D1);
% for i = 1:nFila
%     for j = 1:nCol
%         text(j, i, num2str(D1(i,j)), 'HorizontalAlignment', 'center','FontSize', 6,'FontWeight', 'bold','Color', 'white');
%     end
% end

% Dibuja el camino óptimo sobre la matriz
hold on;
plot(path1(:,2), path1(:,1), 'ro-', 'LineWidth', 1, 'MarkerSize', 6);

% Para D2
figure;
imagesc(D2);
colormap(white);     
axis equal tight;
grid on;
title('Matriz de Distancias D2');

% % Agregar los valores numéricos en cada celda
% [nFila, nCol] = size(D2);
% for i = 1:nFila
%     for j = 1:nCol
%         text(j, i, num2str(D2(i,j)), 'HorizontalAlignment', 'center','FontSize', 6,'FontWeight', 'bold','Color', 'white');
%     end
% end

% Dibuja el camino óptimo sobre la matriz
hold on;
plot(path2(:,2), path2(:,1), 'go-', 'LineWidth', 1, 'MarkerSize', 6);
