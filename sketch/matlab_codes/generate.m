%Load an example dataset.  The contents are as follows:
%  gridDATA      30x30x30                       216000  double array
%  gridX          1x30                             240  double array
%  gridY          1x30                             240  double array
%  gridZ          1x30                             240  double array
clear;
addpath(genpath('../CONVERT_voxels_to_stl/CONVERT_voxels_to_stl'))
addpath(genpath('./mesh'))


imgE = imread('../../images/Sample3.png');
% imgSwp = imread('../../images/Sample1sweep.png');
% imgSwp = imresize(imgSwp,[size(imgE,1) size(imgE,2)]);

% Data for Sample1: [29 2] [29 64] 61 ... [2 6] [52 6]
% Data for Sample2: [1 1] [40 1]  ... [1 68] [40 68]
% Data for Sample3: [7 1] [35 1]  ... [1 62] [41 62]

se = strel('disk',2);
imgbw = imclose(rgb2gray(imgE),se);
imgbw = imfill(imgbw,'holes');

[B,L] = bwboundaries(imgbw,'noholes');
boundary = B{1};

A = uint8(zeros(size(imgE)));
for k=1:size(boundary,1)
    A(boundary(k,1),boundary(k,2),1) = 255;A(boundary(k,1),boundary(k,2),2) = 255;A(boundary(k,1),boundary(k,2),3) = 255;
end

diaC = [];
for i=1:62
    row = A(i,:);
    indx = find(row);
    diaC = [diaC (indx(2)-indx(1))]; 
end
cSize = max(diaC);

model = repmat(1, [cSize cSize (61-6)]);
for i=1:size(diaC,2)
    circle = createcircle(cSize,diaC(1,i)/2);
    circlenew = uint8(circle).*255;
    imgbw = imclose(circlenew,se);
    imgbw = imfill(imgbw,'holes');
    [B,L] = bwboundaries(imgbw,'noholes'); 
    boundary  = B{1};
    A = uint8(zeros(size(circle)));
    for k=1:size(boundary,1)
        A(boundary(k,1),boundary(k,2),1) = 255;A(boundary(k,1),boundary(k,2),2) = 255;A(boundary(k,1),boundary(k,2),3) = 255;
    end
    model(:,:,i) = rgb2gray(A);
%     model(:,:,i) = circle;
end

gridX = [-size(model,1)/2:size(model,1)/2-1];
gridY = [-size(model,2)/2:size(model,2)/2-1];
gridZ = [-size(model,3)/2:size(model,3)/2-1];

% Surf-2-Solid
VariableName = [];
for i=1:size(gridZ,2)
    VariableName = surf2solid(gridX,gridY,model(:,:,i)*i*2);
    stlwrite(strcat('./temp/',int2str(i),'.stl'),VariableName,'mode','ascii');
end



[faces,vertices] = CONVERT_voxels_to_stl('./New.stl',model,gridX,gridY,gridZ,'ascii');
%Plot the original data:
% figure;
% imagesc(squeeze(sum(gridINPUT,3)));
% colormap(gray);
% axis equal tight
% 
% 
% %Load and plot the stl file:
% figure
% [stlcoords] = READ_stl('temp.stl');
% xco = squeeze( stlcoords(:,1,:) )';
% yco = squeeze( stlcoords(:,2,:) )';
% zco = squeeze( stlcoords(:,3,:) )';
% [hpat] = patch(xco,yco,zco,'b');
% axis equal