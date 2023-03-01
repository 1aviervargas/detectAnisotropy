# detectAnisotropy
 Computational method to detect anisotropy (preferential orientations) in cryo-EM maps.
 
In this work, we propose a method to evaluate the presence of preferential orientations in cryo-EM reconstructions that is robust to the dependence of the SSNR to the macromolecular 3D shape, limitation that affects most of the existing methods for anisotropic resolution estimation. Our method is based on analyzing the noise power orientation distribution to determine the presence of anisotropy in the cryo-EM map.

DetectAnisotropy is developed by the Vargas lab at the Optics Department of the Universidad Complutense de Madrid.

## The Matlab code is organized as follows: 

ProcessMe: script to run the different examples.
detectAnisotropy: Matlab function to obtain the anisotropy map.
scriptAnisotropy: script to generate Figure 6 in [1]
ReadMRC, WriteMRC, WriteMRCHeader: auxiliary functions to read and write MRC files.

Please if this work was useful to you cite the paper [1] (now a preprint).

For bug reports, questions or comments please contact Javier Vargas (jvargas@fis.ucm.es)

[1] R Sanchez-Garcia, Jose Manuel Cuadra-Troncoso, J Vargas, "Cryo-EM map anisotropy can be attenuated by map post-processing and a new method for its estimation" 
BioRxiv, doi:  https://doi.org/10.1101/2022.12.08.517920 (2022)

## System requirements:
The code provided requires Matlab to be run. We have tested the code on Matlab's versions 2020a and 2022a running in Windows 10 and Linux (Ubuntu 20.04). This software requires Matlab´s Parallel Computing toolbox if parallel acceleration is desired. To run the methods proposed here it is not required any non-standard hardware.

## Installation guide:
To use the proposed approaches copy the files to your local machine at your desired destination. No compilation is required so the installation time on a "normal" desktop computer is zero, taking into account that Matlab is already installed.
