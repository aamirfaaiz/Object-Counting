clc;
clf;
close all;
image = im2double(imread('training_images/train01.jpg'));
[numA,numB] = count_lego(image,true) %Plotting Figures
