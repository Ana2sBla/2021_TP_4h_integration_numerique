function p = pression(dphi)
% Calcule le champs de pression p à partir d'un champs dphi
    rho = 1000; % Masse volumique [kg/m^3]
    %p = zeros(size(dphi)); % TODO
    p = -rho*dphi;
end