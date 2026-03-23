function rl = filtre_adapte(yl, alpha, Fse, span)

    % filtre de la forme racine de cosinus surélevé
    h = rcosdesign(alpha, span, Fse);
    
    % Normalisation du filtre (pour ne pas changer l'énergie du signal)
    h_adapte = conj(h) / sum(h);
    
    % Convolution
    % 'same' pour garder l'alignement temporel
    rl = conv(yl, h_adapte, 'same');
end