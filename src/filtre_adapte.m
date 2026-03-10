function rl = filtre_adapte(yl, Fse)
    % yl : signal d'entrée (complexe)
    % Fse : Facteur de suréchantillonnage (Samples per Symbol)
    
    % Création d'une porte unité de durée T_s
    % On utilise ones(1, Fse) pour couvrir exactement un symbole
    p1 = hamming(Fse);
    
    % Normalisation du filtre (pour ne pas changer l'énergie du signal)
    p1_adapte = conj(p1) / sum(p1);
    
    % Convolution
    % 'same' est parfait ici pour garder l'alignement temporel
    rl = conv(yl, p1_adapte, 'same'); 
end