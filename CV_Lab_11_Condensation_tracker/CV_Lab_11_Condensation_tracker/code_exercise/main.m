clear all;close all;clc;
load('..\data\params.mat');
% params.num_particles=300;
params.hist_bin=20;
params.model=1;
params.alpha=0.2;
params.sigma_position=5;
params.sigma_observe=0.5;
params.initial_velocity=[8,0];
params
condensationTracker('video3',params)