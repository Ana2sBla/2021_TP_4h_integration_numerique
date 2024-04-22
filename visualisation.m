function visualisation(xh,zh,varargin)
% Visualise les champs dans un graphique.
% Les deux premiers arguments sont obligatoires et doivent être donnée dans cet ordre :
%   - xh : la discrétisation initiale en x
%   - zh : la discrétisation initiale en z
%
% A partir de là, d'autres arguments peuvent être ajouté, sous la forme de
% couples Name,Values1,Values2 ... :
%   - 'phi',phi : visualise le potentiel des vitesses scalaire phi
%   - 'eta',eta : visualise la forme de la surface libre à partir des valeurs eta 
%   - 'pression',p : visualise le champs de pression p
%   - 'vitesses',u,v : visualise le champs de vitesse V=u.ex+v.ez
%   - 'positions',x,z : visualise les trajectoires au milieu du domaine
%   - 't',t : affiche l'instant t où l'on visualise ces données
%
%   example:
%     visualisation(xh,yh,'phi',phi);
%     visualisation(xh,yh,'phi',phi,'vitesses',u,v);

    % Arguments par defauts
    plot_phi = false;
    plot_eta = false;
    plot_vitesses = false;
    plot_positions = false;
    plot_title = false;

    % Analyse des arguments
    j = 1;
    while j <= nargin-2
        switch varargin{j}
            case 'phi'
                plot_phi = true;
                phi = varargin{j+1};
                assert(numel(phi) == numel(xh),'Mauvaise taille pour phi');
                text_phi = 'Potentiel des vitesses';
                j = j + 2;
            case 'eta'
                plot_eta = true;
                eta = varargin{j+1};
                assert(numel(eta) == size(xh,2),'Mauvaise taille pour eta');
                j = j + 2;
            case 'pression'
                plot_phi = true;
                phi = varargin{j+1};
                assert(numel(phi) == numel(xh),'Mauvaise taille pour la pression');
                text_phi = 'Pression (Pa)';
                j = j + 2;
            case 'vitesses'
                plot_vitesses = true;
                assert(numel(varargin{j+1}) == numel(varargin{j+2}) && numel(varargin{j+2}) == numel(xh),'Mauvaise taille pour la vitesse');
                v = [varargin{j+1}(:) varargin{j+2}(:)];
                j = j + 3;
            case 'positions'
                plot_positions = true;
                assert(numel(varargin{j+1}) == numel(xh) && numel(varargin{j+2}) == numel(zh),'Mauvaise taille pour la position');
                x1h = reshape(varargin{j+1}(:),size(xh));
                z1h = reshape(varargin{j+2}(:),size(zh));
                xh = xh + x1h;
                zh = zh + z1h;
                j = j + 3;
            case 't' 
                plot_title = true;
                t = varargin{j+1}(1);
                j = j + 2;
            otherwise
                warning('Mauvais arguments, ils ont été ignorés');
        end
    end
    
    % Pour toujours afficher les mises à jours dans la même figure
    persistent VISU_H;
    if isempty(VISU_H) || ~ishandle(VISU_H)
        VISU_H = gcf;
        h1 = subplot(1,4,1:3,'Tag','1','NextPlot','add');
        h2 = subplot(1,4,4);
        if plot_phi
            caxis(h1,[min(phi(:)) max(phi(:))]);
        end
        ylim(h1,[min(zh(:)) max(zh(:))]);
    else
        h = get(VISU_H,'Children');
        h1 = h(arrayfun(@(x) strcmpi(get(x,'Tag'),'1'),h));
        cla(h1);
        h1 = h(arrayfun(@(x) strcmpi(get(x,'Tag'),'1'),h));
        h2 = h(arrayfun(@(x) strcmpi(get(x,'Tag'),''),h));
    end
    
    % 1ere courbes
    c_vals = get(h1,'Clim');
    y_vals = get(h1,'Ylim');
    
    if plot_phi
        contourf(h1,xh,zh,reshape(phi,size(xh)));
        hcbar = colorbar(h1,'southoutside');
        caxis(h1,[min([c_vals(1);phi(:)]) max([c_vals(2);phi(:)])]);
        xlabel(hcbar,text_phi);
    end
    if plot_vitesses
        quiver(h1,xh,zh,reshape(v(:,1),size(xh)),reshape(v(:,2),size(xh)),0,'k');
    end
    if plot_eta
        plot(h1,xh(end,:),eta(:),'k','Linewidth',2);
        y_vals = [y_vals(1) max([y_vals(2);eta(:)])];
    end
    xlabel(h1,'x'); xlim(h1,[0 max(xh(:))]);
    ylabel(h1,'z'); ylim(h1,[min([y_vals(1);zh(:)]) max([y_vals(2);zh(:)])]);
    if plot_title
        title(h1,['t=' num2str(t)]);
    end
    
    % 2nd courbes
    y_ids = 1:ceil(size(xh,1)/10):size(xh,1);
    ids = sub2ind(size(xh),y_ids(:),ceil(size(xh,2)/2)*ones(numel(y_ids),1));
    if plot_positions
        h = get(h2,'Children');
        if isempty(h)
            scatter(h2,x1h(ids),zh(ids),10,zh(ids)-z1h(ids),'filled');
            xlabel(h2,'x');
            ylabel(h2,'z');
            title(h2,'Trajectoires');
        else
            x_h = cat(2,get(h,'XData'),x1h(ids)');
            y_h = cat(2,get(h,'YData'),zh(ids)');
            c_h = cat(1,get(h,'CData'),zh(ids)-z1h(ids));
            n = min(size(x_h,2),1000)-1;
            % update the plot
            set(h,'XData',x_h(end-n:end));
            set(h,'YData',y_h(end-n:end));
            set(h,'CData',c_h(end-n:end));
        end
    end
    
    drawnow; % update the plot
end
