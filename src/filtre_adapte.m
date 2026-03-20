function rl = filtre_adapte(yl)
    alpha = 0.3;
    Fse = 10;
    span = 10;
    
    % Création d'une porte unité de durée T_s
    % On utilise ones(1, Fse) pour couvrir exactement un symbole
    h = rcosdesign(alpha, span, Fse);
    
    % Normalisation du filtre (pour ne pas changer l'énergie du signal)
    h_adapte = conj(h) / sum(h);
    
    % Convolution
    % 'same' pour garder l'alignement temporel
    rl = conv(yl, h_adapte, 'same'); 
end