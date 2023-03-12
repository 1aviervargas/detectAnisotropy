function aMap = detectAnisotropy(vol, pxSize, minF, maxF, maskThr)

%detectAnisotropy - method to detect anisotropy in reconstructed cryo-EM
%analyzing the noise power along diferent directions.
%
%   OUTPUT PARAMETER: 
%
%   AMap: anisotropy map for each direction given by the elevation and
%   azimut angles
%
%   INPUT PARAMETERS: 
%
%   vol: cryo-EM map to be processed
%   pxSize: pixel size of the map in A/px
%   minF: minimum frequency to evaluate the noise power (in A). Typical 
%   value 10 
%   maxF: minimum frequency to evaluate the noise power (in A). Typical
%   value 3
%   maskThr: Circular soft mask radii indicating the noise in the cryo-EM. 
%   It ranges goes between [0 0.5]. Typical values are 0.2 or 0.3 to select 
%   noise in the map.
%
%   If this method was useful to you, please cite the following paper:
%   R Sanchez-Garcia, Jose Manuel Cuadra-Troncoso, J Vargas, 
%   "Cryo-EM map anisotropy can be attenuated by map post-processing and a 
%   new method for its estimation" 
%   BioRxiv, doi:  https://doi.org/10.1101/2022.12.08.517920 (2022)
%
%   Javier Vargas, 28/02/23
%   jvargas@ucm.es
%   Copyright 2023, Universidad Complutense de Madrid
%   $ Revision: 1.0.0.0
%   $ Date: 28/02/23
%
%Copyright 2023 Javier Vargas @UCM
%
%
%Redistribution and use in source and binary forms, with or without modification, 
%are permitted provided that the following conditions are met:
%
%1. Redistributions of source code must retain the above copyright notice, 
%this list of conditions and the following disclaimer.
%
%2. Redistributions in binary form must reproduce the above copyright notice, 
%this list of conditions and the following disclaimer in the documentation 
%and/or other materials provided with the distribution.
%
%3. Neither the name of the copyright holder nor the names of its contributors 
%may be used to endorse or promote products derived from this software without 
%specific prior written permission.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
%DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
%SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
%CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
%OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
%USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


sampling = 100;
minF = pxSize/minF;
maxF = pxSize/maxF;

u = linspace(-0.5, 0.5, size(vol,1));
v = linspace(-0.5, 0.5, size(vol,1));
w = linspace(-0.5, 0.5, size(vol,1));

[X Y Z] = meshgrid(u,v,w);

%Clean unused variables
clear u v w;

noiseWindow = (1-exp(-((X).^2+(Y).^2+(Z).^2)/(2*maskThr^2)));
noiseWindow = (noiseWindow.^6);
noiseWindow = noiseWindow./max(noiseWindow(:));

clear X Y Z

%Noise normalization
vol = vol-mean(vol(noiseWindow>0.5));
vol = vol/std(vol(noiseWindow>0.5));

vol = vol.*noiseWindow;
temp = fftshift(fftn(vol));

%Noise power in Fourier
noisePower = temp.*conj(temp);

%Clean unused variables
clear W vol V temp; 

%%
az = linspace(-pi,pi,sampling);
el = linspace(-pi/2,pi/2,sampling);

az = reshape(repmat(az,sampling,1),1,sampling*sampling);
el = repmat(el,1,sampling);

aMap = zeros(1,sampling*sampling);
x0 = size(noisePower)/2;

parfor i = 1:sampling*sampling
        
        [ux uy uz] = sph2cart(az(i),el(i), 1);
        slice = obliqueslice(noisePower,x0,[ux uy uz],'OutputSize','Full','FillValues',nan,'Method','nearest');
        
        x = (linspace(-size(slice,1)/2,size(slice,1)/2,size(slice,1)))/size(noisePower,1);
        y = linspace(-size(slice,2)/2,size(slice,2)/2,size(slice,2))/size(noisePower,1);        
        [X Y] = meshgrid(y,x);
        [Theta,Rho] = cart2pol(X,Y);
        
        mask = ((~isnan(slice)).*(Rho>minF).*(Rho<maxF))>0.5;          
        aMap(i) = sum(slice(mask(:)))/sum(mask(:));
end
    
aMap = reshape(aMap, sampling,sampling);
aMap = aMap./max(aMap(:));

figure,imagesc(az,el,aMap); colorbar
xlabel('Azimut (rad)');
ylabel('Elevation (rad)');
saveas(gcf,'AMap','tif')
