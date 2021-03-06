% Omega_0.m
% Функция Omega_0 вычисляет значения смещения нуля ЛГ
function [OMEGA_0_1,OMEGA_0_2]= Omega_0(p,A,nju,Delta_QdivQ,N_rel)


	     DEG_to_RAD = pi / 180	          ;% перевод [рад] в [град]
	  ARCSEC_to_RAD = (1 / 3600) * DEG_to_RAD ;% перевод [угл.сек] в [рад]
	Hz_to_RADperSEC = 2 * pi                  ;% перевод [Гц] в [рад/с]
	        CM_to_M = 1 / 100                 ;% превод [см] в [м]
RADperSEC_to_DEGperHOUR = 3600 / DEG_to_RAD       ;% перевод [рад/с] в [град/ч]

% переводим в СИ амплитуду и частоту
		A = A * ARCSEC_to_RAD
	      nju = nju * Hz_to_RADperSEC

% M - активный масштабный множитель, учитывающий свойства 
% усиливающей среды [-]
	M = 496459

% fi - угол, [град]
	fi = 0
	fi = fi * DEG_to_RAD;

% Delta_is - изотопический сдвиг частоты 
% лазерного перехода [c^-1]
	Delta_is = 2 * pi * 875e+6

% Ku - параметр доплеровской ширины линии [c^-1]
	      Ku = 2 * pi * 910e+6

% gamma_a0, gamma_b0 - константы релаксации соответственно 
% верхнего и нижнего лазерных состояний и лазерного 
% перехода в приближении нулевого давления [c^-1]
	 gamma_a0 = 2 * pi * 17.4e+6
	 gamma_b0 = 2 * pi * 10.3e+6
	gamma_ab0 = 2 * pi * 13.8e+6

% Ka, Kb, Kab - коэффициенты линейной зависимости 
% от давления [(c*Top)^-1]
	 Ka = 2 * pi * 3.9e+6
	 Kb = 2 * pi * 7.5e+6
	Kab = 2 * pi * 60e+6


% lamda_a - параметр пленения резонансного излучения [-]
	lamda_a = 0.59

% c - скорость света [m/c]
	c = 2.9979e+8

% L - периметр осевого контура резонатора [cm]
	L = 20 * CM_to_M

% K_scat - коэффициент потерь на рассеяние [-]
	K_scat = [100e-6 10e-6]

% эффективные углы дифракционной расходимости излучения в сечениях,
% где расположены плоские и сферические зеркала ["]
	Teta_f = 207 * ARCSEC_to_RAD;
	Teta_s = 205 * ARCSEC_to_RAD;

% модули локальных комплексных безразмерных коэффициентов связи встречных
% волн через поглощение и пропускание на плоских зеркалах [-]
	b_f = 1.13e-8

% модули локальных комплексных безразмерных коэффициентов связи встречных
% волн через поглощение на сферических зеркалах [-]
	b_s = 3.72e-9

% kappa - угол потерь на рассеяние [град]
	kappa = 0.31 * DEG_to_RAD;

% GE - суммарные резонаторные потери за один проход [-]
	   GE = 400e-6

% =Расчет==================================================================

% модули локальных комплексных безразмерных коэффициентов связи встречных
% волн через обратное рассеяние...
% a_f - на плоских зеркалах [-]
a_f = sqrt(K_scat) * Teta_f / 4 

% a_s - на сферических зеркалах [-]
a_s = sqrt(K_scat) * Teta_s / 4 

% комбинация коэффициентов связи
r1_r2_sin_epsilon_12 = 4 * ((c / L) ^2) *(  (a_f .^ 2 + a_s .^ 2) * sin(2 * kappa) + 2 * (a_f .* b_f + a_s .* b_s) * cos(kappa) + 2 * (a_f .* a_s * cos(2 * kappa) + (a_f * b_s + a_s * b_f) * cos(kappa)) * cos(2 * fi))

% нормированный на параметр доплеровской ширины линии Ku изотопический
% сдвиг Delta_is частоты лазерного перехода. [-]
epsilons = Delta_is / Ku

% константы релаксации соответственно верхнего и нижнего лазерных
% состояний и прехода [c^-1]
 gamma_a = gamma_a0 + Ka * p
 gamma_b = gamma_b0 + Kb * p
gamma_ab = gamma_ab0 + Kab * p

% x0(p)
x0 = 2 * sqrt(pi) * (lamda_a / (1 - lamda_a)) * ((gamma_ab / Ku) .*( gamma_b ./ (gamma_a + gamma_b))) * exp( -(epsilons ^ 2) / 4)

% F(lamda_a)
F = (-1) + (1 / pi * epsilons ^ 2) * (((1 - lamda_a) / lamda_a) ^ 2) * (((gamma_a + gamma_b) ./ (gamma_b)) .^ 2) * exp((epsilons ^ 2) / 2)

% h - параметр отображающий свойства активной среды
h = x0 .* (1 + x0 .* F)

% D - параметр учитывающий фактор неравнодобротности резонатора ЛГ
D = Delta_QdivQ .* (1 + h) ./ (1 - h)

% alfa_p - обратное время релаксации суммы интенсивности встречных волн
alfa_p = (c/L) * GE * (N_rel - 1);

% alfa_m - обратное время релаксации разности интенсивности встречных волн
alfa_m = alfa_p .* (1 - h) ./ (1 + h)

% w - амплитудное значение расщепления круговых частот встречных волн ЛГ
% вследствие угловой вибрации моноблока. [рад/с]
w = M * nju * A

% OMEGA_0 - сдвиг нуля, обусловленный мультипликативным взаимодействием
% факторов неодинаковости усиления встречных волн (вследствие
% неравнодобротности резонатора) и их связи через обратное рассеяние на
% зеркалах. [град/ч]

OMEGA_0_1 = ((D .* alfa_m * r1_r2_sin_epsilon_12(1)) ./ (M * (alfa_p - alfa_m))) .* ((1 ./ ((alfa_m .^ 2 + w .^ 2) .^ (1 / 2))) - (1 ./ ((alfa_p .^ 2 + w.^2) .^ (1 / 2))));

OMEGA_0_2 = ((D .* alfa_m * r1_r2_sin_epsilon_12(2)) ./ (M * (alfa_p - alfa_m))) .* ((1 ./ ((alfa_m .^ 2 + w .^ 2) .^ (1 / 2))) - (1 ./ ((alfa_p .^ 2+w .^ 2) .^ (1 / 2))));

% переходим от рад/с к град/ч
OMEGA_0_1 = OMEGA_0_1 * RADperSEC_to_DEGperHOUR
OMEGA_0_2 = OMEGA_0_2 * RADperSEC_to_DEGperHOUR

endfunction
