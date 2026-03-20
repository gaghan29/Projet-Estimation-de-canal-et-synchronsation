clear
close all
clc

level = 1;

% Chargement du fichier contenant le signal reçu
load '../data/signal_recu.mat';
if level > 1
  signal_recu = signal_recu(1:5:end);
end

signal_reel = real(signal_recu);
signal_complexe = imag(signal_recu);

figure;
plot(signal_recu(1:1000));
ylabel('Amplitude');
title('Signal brut');
grid on;

figure;
plot(signal_reel);
ylabel('Amplitude');
title('Partie réellle');
grid on;

figure;
plot(signal_complexe);
ylabel('Amplitude');
title('Partie imaginaire');
grid on;

p = 4;
signal_p = signal_recu.^p;

% DSP
dsp = (abs(fft(signal_p))).^2;
figure;
plot(dsp); xlim([0 100])
title('DSP')
grid on;

%% Début réception du signal

% Paramètres généraux
debut_signal = 8; % Points
fin_signal = 655000; % Points

% Paramètres filtre
Fse = 10;
alpha = 0.3;
span = 10;

% Chaine de communication
h = rcosdesign(alpha, span, Fse, 'sqrt');

% Bloc filtrage adapté
signal_filtre = filtre_adapte(signal_recu);

% Bloc échantillonnage
signal_ech = signal_filtre(debut_signal:Fse:end);

%Normalisation
signal_ech = signal_ech / sqrt(mean(abs(signal_ech).^2));

% Bloc PLL
[theta_est, delta_est] = PLL(signal_ech);

figure;
subplot(121);
plot(delta_est); 
title('Fréquence estimée')

subplot(122); 
plot(theta_est);
title('Phase estimée')

% Bloc de compensation de phase
%signal_comp = signal_ech .* exp(1j*(2*pi*theta_est) + delta_est);  
signal_comp = signal_ech .* exp(-1j *(theta_est / 4));

figure;
%plot(real(signal_comp), imag(signal_comp),'.');
plot(signal_comp,'.');
title('Signal rephasé apres la PLL')
grid on;

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
