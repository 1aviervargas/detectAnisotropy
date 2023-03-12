%   Javier Vargas, 28/02/23
%   jvargas@ucm.es
%   Copyright 2023, Universidad Complutense de Madrid
%   $ Revision: 1.0.0.0
%   $ Date: 28/02/23
%Copyright 2023 Javier Vargas @UCM

clear all
close all
 
%This example obtains the anisotropy maps for EMD-8731 map cryo-EM map as example:
gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-8731/other/emd_8731_half_map_1.map.gz','.');
gunzip('https://files.wwpdb.org/pub/emdb/structures/EMD-8731/other/emd_8731_half_map_2.map.gz','.');
vol1 = ReadMRC('emd_8731_half_map_1.map');
vol2 = ReadMRC('emd_8731_half_map_2.map');
vol = 0.5*(vol1+vol2);
clear vol1 vol2;
%Sampling rate of the cryo-EM volume 
px =1.31;

%Circular mask indicating the noise in the cryo-EM map. A value of 1 corresponds 
%to a circular soft mask with diameter equals to the volume size, while a value 
%of 0 corresponds to a circular mask of radious 0. Typical values are
%between 0.1-0.3.
maskThr = 0.2;

%Frequency range in A [minF, maxF], where we are going to evaluate the noise power. 
maxF = 4;
minF = 15;

%Compute the anisotropy map.
aMap = detectAnisotropy(vol, px, minF, maxF, maskThr);