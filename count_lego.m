function [count_A,count_B]=count_lego(I,plotFigures)
%COUNT_LEGO performs colour based thresholding to segment the cluttered
%image into two components - blue and red. This is the first segmentation
%step to distinguish between the two objects being identified. Colour
%Thresholding was generated through the Color Thresholder APP in MATLAB.
%The next step involved further image processing to count the objects in
%the image and the utilization of REGIONPROPS(inbuilt matlab function) to
%generate image properties such as the area and perimeter of the blobs.The
%classification is based on the magnitude of the areas of the blobs.
% 
% I - RGB (Double Precission Image)
% plotFigures - Set to true/false to plot image processing figures

%
%   Example
%   -------
%       image = im2double(imread('im1.jpg'));
%       [numA,numB] = count_lego(image,true) %Plotting Figures
%       
%   Aamir Faaiz
%   <mohamed.faaiz@kcl.ac.uk>
%   <DEC 2020>
%

% Future Work:
% Look into a combination of using areas and shape recognition for the classification stage

scene = I;
[mask_red, maskedRGBImageRed] = createRedMask(scene);
[mask_blue, maskedRGBImageBlue] = createBlueMask(scene);

BW_A = ~mask_blue;
BW_B = ~mask_red;
%Getting rid off the noise in the 
%image and ensuring the objects are
%visible enough for counting
se = strel('disk',4);
afterOpening_A = imopen(BW_A,se);
afterClosing_A = imclose(afterOpening_A,se);
afterOpening_B = imopen(BW_B,se);
afterClosing_B = imclose(afterOpening_B,se);

%Getting image properties for the blobs in the processed image
[L_A,~] = bwlabel(~afterClosing_A,4);
blobMeasurements_A = regionprops(L_A, 'Perimeter','Area');
[L_B,~] = bwlabel(~afterClosing_B,4);
blobMeasurements_B = regionprops(L_B, 'Perimeter','Area');

count_A = 0; 
count_B = 0;

for i=1:size(blobMeasurements_A)
    %Object A Area Checking
    if blobMeasurements_A(i).Area>30000 && blobMeasurements_A(i).Area<65000
        count_A = count_A +1;
     elseif blobMeasurements_A(i).Area>65000
         count_A = count_A +2; %In the event where two objects are present very close to each other
     
    end
end


for i=1:size(blobMeasurements_B)
    %Object B Area Checking
    if blobMeasurements_B(i).Area>17000 && blobMeasurements_B(i).Area<28000
        count_B = count_B +1;
    end
end

if plotFigures
    %Plotting figures for Object A
    figure;
    subplot(2, 5, 1);
    imshow(maskedRGBImageBlue);
    title('Scene-Blue Lego(ObjectA)');
    subplot(2, 5, 2);
    imshow(BW_A);
    title('BW(ObjectA)');
    subplot(2, 5, 3);
    imshow(afterOpening_A);
    title('After Opening-A(ObjectA)');
    subplot(2, 5, 4);
    imshow(afterClosing_A);
    title('After Closing(ObjectA)');
    subplot(2, 5, 5);
    title('Visualising Labels(ObjectA)');
    imshow(afterClosing_A,[])
    vislabels(L_A);
    
    %Plotting figures for Object B
    subplot(2, 5, 6);
    imshow(maskedRGBImageRed);
    title('Scene-Red Lego(ObjectB)');
    subplot(2, 5, 7);
    imshow(BW_B);
    title('BW(ObjectB)');
    subplot(2, 5, 8);
    imshow(afterOpening_B);
    title('After Opening(ObjectB)');
    subplot(2, 5, 9);
    imshow(afterClosing_B);
    title('After Closing(ObjectB)');
    subplot(2, 5, 10);
    title('Visualising Labels(ObjectB)');
    imshow(afterClosing_B,[])
    vislabels(L_B)
end






