% Set this folder as the current folder and add all paths 
cd('./');
addpath(genpath('./'));

% Add datasets' folder to path
addpath(genpath('../datasets'))

% Figure default
set(0, 'DefaultAxesFontSize', 25);
set(0, 'DefaultLineLineWidth', 2);