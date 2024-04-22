function [u,v,a] = newmark(M,K,F,un,vn,an,dt)
% R�solution du probl�me � l'aide d'un sch�ma de Newmark
%   M,K,F : matrices du syst�me M*�+K*u=F
%   un : les valeurs de u � l'instant pr�c�dent
%   vn : les valeurs de la d�riv�e 1er en temps de u � l'instant pr�c�dent
%   an : les valeurs de la d�riv�e 2nd en temps de u � l'instant pr�c�dent
%   u : les valeurs de u au nouvel instant
%   v : les valeurs de la d�riv�e 1er en temps de u au nouvel instant
%   a : les valeurs de la d�riv�e 2nd en temps de u au nouvel instant

    % Param�tres du sch�ma de Newmark
    beta = 1/4;
    gamma = 1/2;
    
    % Calculs
    a = zeros(size(K,2),1); % TODO calcul de la d�riv�e 2nd
    v = zeros(size(K,2),1); % TODO calcul de la d�riv�e 1er
    u = zeros(size(K,2),1); % TODO calcul du champs
    a = inv(M + K*beta*dt^2 +gamma*dt^2*K)*(F -K*(dt^2*(1.5-beta-gamma)*an+dt*vn+un));
    v = vn + dt*((1-gamma)*an+gamma*a);
    u = inv(K)*(F - M*a);
end