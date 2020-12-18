clc;
clf;
close all;
image = im2double(imread('training_images/train08.jpg'));
[numA,numB] = count_lego(image,true) %Plotting Figures
