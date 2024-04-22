function x = trajectoire(u,dt)
% Calcule les trajectoires discrète x à partir de la vitesse associé u et le pas de temps dt 
    x = cumsum(dt*u,2);
end