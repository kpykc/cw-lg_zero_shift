% plot_lg_param.m
% ФАКС, ПСКЛА, 4 курс, гр. ВЛ-22
% Курсовой проект
% "Расчет смещения нуля вибрирующего ЛГ от его параметров"
% Лаврущенко А. Н., Шевченко В.Ю.
EXEC_PATH=":./:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11";


% Параметры ЛГ из статьи
% Давление:                   p=6.5 [Top]
% Ампилитуда колебаний:       A=120 ["]
% Круговая частота колебаний: nju=350 [c^-1]
% Фактор неравноподобности
% резонатора:                 Delta_QdivQ = 0.005 [-]
% Относительное превышение
% накачкой своего порогового 
% значения:                   N_rel=2.5 [-]

% Переменные параметры
 	  p=2:0.1:6.5 ;
	  A=60:2:200 ;
	nju=300:5:500 ;
Delta_QdivQ=0:0.001:0.05 ;
      N_rel=1.1:0.1:2.5 ;

%real_lg=[p|A|nju|Delta_QdivQ|N_rel]
real_lg=[6.5,120,350,0.01,1.3]

grid on

% Вариация p
[res1,res2]=Omega_0(p,real_lg(2),real_lg(3),real_lg(4),real_lg(5))
% Название графика
title "Omega_0(p)"
% название оси абсцисс
xlabel "p,[Top]"
% название оси ординат
ylabel "Omega_0, [deg/hour]"
% установка формата выводимого изображения
__gnuplot_set__ term png
% имя файла в который сохраняется изображение
__gnuplot_set__ output "p.png"
% вызов фукции-построителя графика
plot(p,res1,"-@*6;K_scat 1;",p,res2,"-b;K_scat 2;")

% Вариация A
[res1,res2]=Omega_0(real_lg(1),A,real_lg(3),real_lg(4),real_lg(5))
title "Omega_0(A)"
xlabel "A, [\"]"
ylabel "Omega_0, [deg/hour]"
__gnuplot_set__ term png
__gnuplot_set__ output "A.png"
plot(A,res1,"-@*6;K_scat 1;",A,res2,"-b;K_scat 2;")

% Вариация nju
[res1,res2]=Omega_0(real_lg(1),real_lg(2),nju,real_lg(4),real_lg(5))
title "Omega_0(nju)"
xlabel "nju, [1/c]=[Hz]"
ylabel "Omega_0, [deg/hour]"
__gnuplot_set__ term png
__gnuplot_set__ output "nju.png"
plot(nju,res1,"-@*6;K_scat 1;",nju,res2,"-b;K_scat 2;")

% Вариация Delta_QdivQ
[res1,res2]=Omega_0(real_lg(1),real_lg(2),real_lg(3),Delta_QdivQ,real_lg(5))
title "Omega_0(Delta_QdivQ)"
xlabel "Delta_QdivQ"
ylabel "Omega_0, [deg/hour]"
__gnuplot_set__ term png
__gnuplot_set__ output "Delta_QdivQ.png"
plot(Delta_QdivQ,res1,"-@*6;K_scat 1;",Delta_QdivQ,res2,"-b;K_scat 2;")

% Вариация N_rel
[res1,res2]=Omega_0(real_lg(1),real_lg(2),real_lg(3),real_lg(4),N_rel)
title "Omega_0(N_rel)"
xlabel "N_rel"
ylabel "Omega_0, [deg/hour]"
__gnuplot_set__ term png
__gnuplot_set__ output "N_rel.png"
plot(N_rel,res1,"-@*6;K_scat 1;",N_rel,res2,"-b;K_scat 2;")

% Очищаем память переменных
clear *
