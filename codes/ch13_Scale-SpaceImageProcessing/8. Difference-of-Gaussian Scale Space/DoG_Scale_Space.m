% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% DoG scale space pyramid

clear, clc, close all

% Change based on your operating system
currDir = pwd;
[pathStr, name, ext] = fileparts(currDir);
binDir = [pathStr filesep 'vlfeat-0.9.16' filesep 'bin'];
exe = [binDir '/win64/sift.exe'];
% exe = [binDir '/win32/sift.exe'];
% exe = [binDir '/maci64/sift'];
% exe = [binDir '/maci/sift'];
% exe = [binDir '/glnxa64/sift'];
% exe = [binDir '/glnx86/sift'];

% Call SIFT executable
cmd = ['"' exe '" dog.pgm --gss --levels=4 --octaves 5'];
system(cmd);

% Visualize results
for octave = -1:3
    figure
    for level = 0:3
        subplot(2,2,level+1);
        imshow(sprintf('dog_%02d_%03d.pgm', octave, level));
        title(sprintf('Octave %d, Level %d', octave, level));
    end % level
end % octave



















