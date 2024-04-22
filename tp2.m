%% Methodes Numériques MSX03 (M1 - ENS CACHAN)
%  TP2 - Génération de vagues dans un canal - Houle

L = 25; % Longueur en x [m]
H = 1; % longueur en z [m]

Tf = 20; % temps final [s]
Nt = 100; % Nombre de pas de temps

Nx = 10; % Nombre de points en x
Nz = 5; % Nombre de points en z


%% Discrétisation
hx = L/(Nx-1);
hz = H/(Nz-1);
dt = Tf/(Nt-1);
[x0h,z0h] = meshgrid(0:hx:L,-H:hz:0);
th = 0:dt:Tf;

% Affiche la discrétisation choisie
figure('Name','Discrétisation');
    scatter(x0h(:),z0h(:),'+');
    hold on
    text(x0h(:),z0h(:),strsplit(num2str(1:numel(x0h))),'HorizontalAlignment','center','VerticalAlignment','bottom');

%% Construction du système
[Mh,Kh,Fh] = systeme(x0h,z0h,th);
    
%% Résolution du système par newmark
N = size(x0h);


phih = zeros(numel(x0h),Nt);
dphih = zeros(numel(x0h),Nt);
ddphih = zeros(numel(x0h),Nt);

for i=2:Nt
    [phih(:,i),dphih(:,i),ddphih(:,i)] = newmark(Mh,Kh,Fh(:,i),phih(:,i-1),dphih(:,i-1),ddphih(:,i-1),dt); 
    visualisation(x0h,z0h,'phi',phih(:,i));

end

%%
p = pression(dphih);

for i=2:Nt
    visualisation(x0h,z0h,'pression',p(:,i));
    
end
%%
p = pression(dphih);
eta = elevation(dphih,N);
for i=2:Nt
    visualisation(x0h,z0h,'eta',eta(:,i),'pression',p(:,i));
end
%%
for i=2:Nt
    [u,v] = gradient(x0h,z0h,th,phih);
    visualisation(x0h,z0h,'phi',phih(:,i),'vitesses',u(:,i), v(:,i));
end
%%
x1h = trajectoire(u,dt);
y1h = trajectoire(v,dt);
for i=2:Nt

    visualisation(x0h,z0h,'positions',x1h(:,i), y1h(:,i));
end
