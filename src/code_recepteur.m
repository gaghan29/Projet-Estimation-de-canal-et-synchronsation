clear
close all
clc

level = 1;

% Chargement du fichier contenant le signal reçu
load '../data/signal_recu.mat';
if level > 1
  signal_recu = signal_recu(1:5:end);
end

%% Paramètres généraux
debut_signal = 49; % Points
fin_signal = 655408; % Points

% Paramètres filtre
Fse = 10; % Echantillonnage
alpha = 0.3;
span = 10;

%% Début réception du signal

% Chaine de communication
% Bloc filtrage adapté
signal_filtre = filtre_adapte(signal_recu, alpha, Fse, span);

% Bloc échantillonnage
signal_ech = signal_filtre(debut_signal:Fse:fin_signal);

% Normalisation
signal_ech = signal_ech/sqrt(mean(abs(signal_ech).^2));

% Bloc PLL
[theta_est, delta_est] = PLL(signal_ech);

% Bloc de compensation de phase
signal_comp = signal_ech .* exp(-1j *(theta_est / 4)).*exp(1j*pi/4);

% Bloc de décision
% Mapping de gray
%bits_decode = zeros(2, length(signal_comp));
% demod_part_reelle = real(signal_comp);
% demod_part_imaginaire = imag(signal_comp);

% Assignation des bits
% for i = 1:length(signal_comp)
%     if (demod_part_reelle(i)>0) && (demod_part_imaginaire(i)>0)
%         bits_decode(1, i) = 1; 
%         bits_decode(2, i) = 0;
%     elseif (demod_part_reelle(i) > 0) && (demod_part_imaginaire(i) < 0)
%         bits_decode(1, i) = 1;
%         bits_decode(2, i) = 1;
%     elseif (demod_part_reelle(i) < 0) && (demod_part_imaginaire(i) < 0)
%         bits_decode(1, i) = 0;
%         bits_decode(2, i) = 1;
%     else
%         bits_decode(1, i) = 0;
%         bits_decode(2, i) = 0;
%     end
% end

% 1. On s'assure que I et Q sont des lignes (1 x 65500)
Re_positif = (real(signal_comp) > 0).'; 
Im_positif = (imag(signal_comp) > 0).';
Re_negatif = (~Re_positif); 
Im_negatif = (~Im_positif);

% 2. Initialisation
constellation_variantes = zeros(16, length(signal_comp));

% 3. Remplissage corrigé
constellation_variantes(1:2, :) = [Re_positif ; Im_positif];          % Variante 1
constellation_variantes(3:4, :) = [Re_positif ; Im_negatif];          % Variante 2
constellation_variantes(5:6, :) = [Re_negatif ; Im_positif];          % Variante 3
constellation_variantes(7:8, :) = [Re_negatif ; Im_negatif];          % Variante 4
% 
constellation_variantes(9:10, :) = [Im_positif ; Re_positif];         % Variante 5
constellation_variantes(11:12, :) = [Im_positif ; Re_negatif];        % Variante 6
constellation_variantes(13:14, :) = [Im_negatif ; Re_positif];        % Variante 7
constellation_variantes(15:16, :) = [Im_negatif ; Re_negatif];        % Variante 8



%% Affichages 

signal_reel = real(signal_recu);
signal_complexe = imag(signal_recu);

% Affichage partie réelle signal brut
figure;
plot(signal_reel);
ylabel('Amplitude');
title('Partie réellle');
grid on;

% Affichage partie imaginaire signal brut
figure;
plot(signal_complexe);
ylabel('Amplitude');
title('Partie imaginaire');
grid on;

% Affichage constéllation signal brut
figure;
plot(signal_recu(1:1000));
ylabel('Amplitude');
title('Constéllation signal brut');
grid on;

% Affichage animation

% for i = 1:892
%     figure(1);
%     plot(signal_recu(i*1000:(i+1)*1000), '*');
%     xlim([-0.15 0.15])
%     ylim([-0.15 0.15])
%     drawnow limitrate
% end

p = 4;
signal_p = signal_recu.^p;

% DSP
dsp = (abs(fft(signal_p))).^2;
figure;
plot(dsp); xlim([0 100])
title('DSP')
ylabel('Amplitude');
grid on;

% Fréquence et phase estimée
figure;
subplot(121);
plot(delta_est); 
ylabel('Amplitude');
title('Fréquence estimée');
grid on;

subplot(122); 
plot(theta_est);
ylabel('Amplitude');
title('Phase estimée');
grid on;

% Affichage constéllation apres PLL
figure;
plot(signal_comp,'.');
title('Constéllation apres la PLL');
grid on;

% % Détermination de la bonne constéllation : 
j = 1;
figure; 
for i=1:2:15
    % Décodage de source
    hatMatBitImg = reshape(constellation_variantes(i:i+1,:),[],8);
    matImg = bi2de(hatMatBitImg);
    T = floor(sqrt(length(matImg))); % Changer ici la taille de l'image
    Img = reshape(matImg(1:T*T),T,T);

    subplot(2,4,j);
    imagesc(Img);
    colormap gray
    title(['Constellation n° ', num2str(j)]);
    j = j + 1;
end


% Décodage de source
hatMatBitImg = reshape(constellation_variantes(1:2,:),[],8);
matImg = bi2de(hatMatBitImg);
T = floor(sqrt(length(matImg))); % Changer ici la taille de l'image
Img = reshape(matImg(1:T*T),T,T);

% Affichage image
figure;
imagesc(Img)
colormap gray


% %% Affichages 
% 
% % Constéllation
% figure;
% hold on;
% plot(real(signal_ech(1:2000)), imag(signal_ech(1:2000)), '.');
% grid on;
% axis square;
% xlabel('In-Phase (I)');
% ylabel('Quadrature (Q)');
% title(['Constellation après filtre RRC (Fse = ', num2str(Fse), ')']);
% 
% % Spectre filtre adapté
% spectre_filtre = (abs(fftshift(fft(h)))).^2;
% figure;
% plot(spectre_filtre);
% title('Spectre filtre adapté');
% grid on;
% 
% 
% % Affichage animation
% 
% % for i = 1:892
% %     figure(1);
% %     plot(signal_recu(i*1000:(i+1)*1000), '*');
% %     xlim([-0.15 0.15])
% %     ylim([-0.15 0.15])
% %     drawnow limitrate
% % end
% 
% % for j = 1:15
% %     Appliquer le filtre adapté
% %     signal_filtre = filtre_adapte(signal_recu, j);
% % 
% %     Normalisation pour l'affichage
% %     signal_filtre = signal_filtre / max(abs(signal_filtre));
% % 
% %     figure(1);
% %     plot(signal_filtre(1000:2000));
% %     title(sprintf('Fse =%.2f', j))
% %     drawnow limitrate
% %     pause(2)
% % end
% 
% %% Votre récepteur
% % En entrée : signal_recu, signal équivalent à rl(kTe) avec Te le temps
% % d'échantillonnage
% 
% % hatB doit être une matrice de log2(M) lignes et Ns
% % calculé grace à la fonction de2bi(foo,2) foo étant ici une représentation entière des étiquettes
% %% Décodage de source
% % hatMatBitImg = reshape(hatB(:),[],8);
% % matImg = bi2de(hatMatBitImg);
% % T = 1 % Changer ici la taille de l'image
% % Img = reshape(matImg,T,T);
% 
% %% Affichage
% % figure
% % imagesc(Img)
% % colormap gray