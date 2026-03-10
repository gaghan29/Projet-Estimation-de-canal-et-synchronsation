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


% --- Paramètres à déterminer ---
Fse = 11; %

% Appliquer le filtre adapté
signal_filtre = filtre_adapte(signal_recu, Fse);

% Normalisation pour l'affichage
signal_filtre = signal_filtre / max(abs(signal_filtre));

figure;
subplot(121); plot(signal_filtre(1000:2000))
subplot(122); plot(signal_recu(1000:2000))


% Affichage animation

% for i = 1:892
%     figure(1);
%     plot(signal_recu(i*1000:(i+1)*1000), '*');
%     xlim([-0.15 0.15])
%     ylim([-0.15 0.15])
%     drawnow limitrate
% end

% for j = 1:15
%     % Appliquer le filtre adapté
%     signal_filtre = filtre_adapte(signal_recu, j);
% 
%     % Normalisation pour l'affichage
%     signal_filtre = signal_filtre / max(abs(signal_filtre));
% 
%     figure(1);
%     plot(signal_filtre(1000:2000));
%     drawnow limitrate
%     pause(1)
% end
%% Votre récepteur
% En entrée : signal_recu, signal équivalent à rl(kTe) avec Te le temps
% d'échantillonnage

% hatB doit être une matrice de log2(M) lignes et Ns
% calculé grace à la fonction de2bi(foo,2) foo étant ici une représentation entière des étiquettes
%% Décodage de source
% hatMatBitImg = reshape(hatB(:),[],8);
% matImg = bi2de(hatMatBitImg);
% T = 1 % Changer ici la taille de l'image
% Img = reshape(matImg,T,T);

%% Affichage
% figure
% imagesc(Img)
% colormap gray
