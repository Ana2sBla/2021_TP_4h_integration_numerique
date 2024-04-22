 function [Mh,Kh,Fh] = systeme(xh,zh,th)
% Calcule le système matriciel Mh*ü+Kh*u=Fh.
% xh : discrétisation en x
% zh : discrétisation en z
% th : discrétisation en temps t
% Mh : matrice 
% Kh : matrice
% Fh : matrice ou chaque colonne n est le vecteur F^n

    g = 9.81; % gravité [m/s^2]

    Nx = size(xh,2);
    Nz = size(zh,1);
    Nzx = size(xh);
    Nt = numel(th);
    N = numel(xh);
    
    hx = xh(1,2) - xh(1,1);
    hz = zh(2,1) - zh(1,1);

    % Incompressibilité K1*u^{n} = 0
    % TODO calcul des K1
    M1 = sparse((Nz-2)*(Nx-2),N);
    K1 = sparse((Nz-2)*(Nx-2),N);
    F1 = sparse((Nz-2)*(Nx-2),Nt);
    k = 0;
    for i=2:Nx-1
        for j=2:Nz-1
            k = k + 1;
            K1(k,index(i-1,j,Nzx)) = 1/(hx^2);
            K1(k,index(i+1,j,Nzx)) = -1/(hx^2);
            K1(k,index(i,j+1,Nzx)) = 1/(hz^2);
            K1(k,index(i,j-1,Nzx)) = 1/(hz^2);
            K1(k,index(i,j,Nzx)) = -2/(hx^2)-2/(hz^2);
        end
    end

    
    % Condition de surface libre M2*diff(u,t$2) + K2*u^{n} = 0 
    M2 = sparse(Nx,N);
    K2 = sparse(Nx,N);
    F2 = sparse(Nx,Nt);
    for i=1:Nx
        M2(i,index(i,Nz,Nzx)) = 1;
        K2(i,index(i,Nz,Nzx)) = g/hz;
        K2(i,index(i,Nz-1,Nzx)) = -g/hz;
    end

    % Condition de batteur gauche K3*u^{n} = F3
    M3 = sparse(Nz-2,N);
    K3 = sparse(Nz-2,N);
    F3 = sparse(Nz-2,Nt);
    for j=2:Nz-1
        K3(j-1,index(2,j,Nzx)) = 1/hx;
        K3(j-1,index(1,j,Nzx)) = -1/hx;
    end
    F3 = 0.1*(1-zh(2:end-1,1)/1)*cos(2*pi/2*th(:))';

    % Condition de batteur droite K4*u^{n} = F4
    M4 = sparse(Nz-2,N);
    K4 = sparse(Nz-2,N);
    F4 = sparse(Nz-2,Nt);
    for j=2:Nz-1
        K4(j-1,index(Nx,j,Nzx)) = 1/hx;
        K4(j-1,index(Nx-1,j,Nzx)) = -1/hx;
    end
    F4 = sparse(Nz-2,Nt);

    % Condition de bords Gf K5*u^{n} = 0
    M5 = sparse(Nx,N);
    K5 = sparse(Nx,N);
    F5 = sparse(Nx,Nt);
    for i=1:Nx
        K5(i,index(i,2,Nzx)) = 1/hz;
        K5(i,index(i,1,Nzx)) = -1/hz;
    end

    % Assemblage système Mh*ü + Kh*u = Fh
    Mh = [M1;M2;M3;M4;M5];
    Kh = [K1;K2;K3;K4;K5];
    Fh = [F1;F2;F3;F4;F5];
end