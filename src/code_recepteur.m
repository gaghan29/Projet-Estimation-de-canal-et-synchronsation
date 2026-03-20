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

% Paramètres filtre
Fse = 10;
alpha = 0.3;
span = 10;


h = rcosdesign(alpha, span, Fse, 'sqrt');

signal_filtre = filtre_adapte(signal_recu);

% Normalisation de l'amplitude pour l'affichage
%signal_filtre = signal_filtre / max(abs(signal_filtre));

% AFFICHAGE DE LA CONSTELLATION
figure;
hold on;
% On affiche les points. Pour une lecture optimale, on devrait 
% échantillonner tous les Fse, mais ici on affiche tout pour voir la forme.
plot(real(signal_filtre(1:2000)), imag(signal_filtre(1:2000)), '.');
grid on;
axis square;
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title(['Constellation après filtre RRC (Fse = ', num2str(Fse), ')']);

%h = rcosdesign(0.3, 10, 10);
spectre_filtre = (abs(fftshift(fft(h)))).^2;
figure;
plot(spectre_filtre);
title('Spectre filtre adapté');


% Affichage animation

% for i = 1:892
%     figure(1);
%     plot(signal_recu(i*1000:(i+1)*1000), '*');
%     xlim([-0.15 0.15])
%     ylim([-0.15 0.15])
%     drawnow limitrate
% end

% for j = 1:15
%     Appliquer le filtre adapté
%     signal_filtre = filtre_adapte(signal_recu, j);
% 
%     Normalisation pour l'affichage
%     signal_filtre = signal_filtre / max(abs(signal_filtre));
% 
%     figure(1);
%     plot(signal_filtre(1000:2000));
%     title(sprintf('Fse =%.2f', j))
%     drawnow limitrate
%     pause(2)
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
