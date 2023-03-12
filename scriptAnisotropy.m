%This script generates some figures in the paper:
%
%   R Sanchez-Garcia, Jose Manuel Cuadra-Troncoso, J Vargas, 
%   "Cryo-EM map anisotropy can be attenuated by map post-processing and a 
%   new method for its estimation" 
%   BioRxiv, doi:  https://doi.org/10.1101/2022.12.08.517920 (2022)
%
% To generate different figures modify the value of example to 1, 2, 3 or 4

example  = 4; % modify this to 1,2,3 or4

switch example
    
    case 1        
        gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-13202/other/emd_13202_half_map_1.map.gz','.');
        gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-13202/other/emd_13202_half_map_2.map.gz','.');        
        vol1 = ReadMRC('emd_13202_half_map_1.map');
        vol2 = ReadMRC('emd_13202_half_map_2.map');
        vol = 0.5*(vol1+vol2);
        clear vol1 vol2;
        factor = 80;
        px = 1.302;
        resolution = 4.5;
        figuresExperimentalMaps(vol,px,resolution,factor);
        
    case 2
                
        gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-8910/other/emd_8910_half_map_1.map.gz','.');
        gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-8910/other/emd_8910_half_map_2.map.gz','.');        
        vol1 = ReadMRC('emd_8910_half_map_1.map');
        vol2 = ReadMRC('emd_8910_half_map_2.map');
        vol = 0.5*(vol1+vol2);        
        clear vol1 vol2;

        factor = 80;
        px = 1.350; 
        resolution = 4;
        figuresExperimentalMaps(vol,px,resolution,factor);

    case 3                
        gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-24688/map/emd_24688.map.gz','.');
        vol = ReadMRC('emd_24688.map');
        
        factor = 10;
        px = 1.137;
        resolution = 4.5;
        figuresExperimentalMaps(vol,px,resolution,factor);
               
    otherwise
        
        [X Y Z]= meshgrid(linspace(-100,100,201));
        T = zeros(201,201,201);
        
        V = T;
        V(101-1:101+1,101-1:101+1,101-70:101+70)=1;
        V = V + 0.025*randn(201,201,201);
        
        FV = abs(fftshift(fftn(fftshift(V))));
        
        WriteMRC(V,1,'filamentReal.mrc');
        WriteMRC(FV,1,'filamentFourier.mrc');
        
        figure, imagesc(squeeze(V(:,:,100)),[0, 1]); colormap gray; colorbar; axis off
        set(gcf, 'color', 'white');
        
        figure, imagesc(squeeze(V(:,100,:)),[0, 1]); colormap gray; colorbar; axis off
        set(gcf, 'color', 'white');
        
        figure, imagesc(squeeze(V(100,:,:)),[0, 1]); colormap gray; colorbar; axis off
        set(gcf, 'color', 'white');
        
        figure, imagesc(squeeze(FV(:,:,100)),[0 300]); colormap gray; colorbar; axis off
        set(gcf, 'color', 'white');
        
        figure, imagesc(squeeze(FV(:,100,:)),[0, 300]); colormap gray; colorbar; axis off
        set(gcf, 'color', 'white');
        
        figure, imagesc(squeeze(FV(100,:,:)),[0, 300]); colormap gray; colorbar; axis off
        set(gcf, 'color', 'white');
                
end


function figuresExperimentalMaps(vol,px,resolution,factor)

[sx sy sz]= size(vol);
freq = (2*px*0.5*sx)/(resolution);
fv = abs(fftshift(fftn(fftshift(vol))));
sli = fv(:,:,floor(sx/2));
range = [0 max(sli(:))/factor];

figure, imagesc(squeeze(fv(:,:,floor(sx/2))),range), colorbar
h = circle(sz/2,sz/2,freq);
axis off;
title('Z-axis');

figure, imagesc(squeeze(fv(:,floor(sx/2),:)),range), colorbar
h = circle(sz/2,sz/2,freq);
axis off;
title('Y-axis');

figure, imagesc(squeeze(fv(floor(sx/2),:,:)),range), colorbar
h = circle(sz/2,sz/2,freq);
axis off;
title('X-axis');

end



function h = circle(x,y,r)
hold on;
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'r','LineWidth',1.5);
hold off;
end