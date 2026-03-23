function [theta_est, delta_est] = PLL(Signal)
    phase_est = 0;
    freq_est = 0;
    N = length(Signal);
    theta_est = zeros(N, 1);
    delta_est = zeros(N, 1);

    % Filtre de boucle
    alpha = 0.13;
    beta = 0.01;

    Signal = Signal.^4;
    for k=2:N

        % erreur
        ek = imag(Signal(k)*exp(-1j*phase_est));
        
        % mise à jour de la fréquence
        freq_est = freq_est + beta*ek;
        delta_est(k,1) = freq_est;

        % mise à jour de la phase
        phase_est = phase_est + freq_est + alpha*ek;
        theta_est(k,1) = phase_est;

    end
end