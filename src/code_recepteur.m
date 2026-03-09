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
plot(signal_reel); xlim([1110 1210])
ylabel('Amplitude');
title('Partie réellle');
grid on;

figure;
plot(signal_complexe); xlim([1110 1210])
ylabel('Amplitude');
title('Partie imaginaire');
grid on;

dsp = (abs(fft(signal_recu))).^2;
figure;
plot(dsp); xlim([0 100])

for i = 1:700
    figure(1);
    plot(signal_reel(i*1000:(i+1)*1000), signal_complexe(i*1000:(i+1)*1000));
    drawnow limitrate
end
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
