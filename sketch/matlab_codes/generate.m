%Load an example dataset.  The contents are as follows:
%  gridDATA      30x30x30                       216000  double array
%  gridX          1x30                             240  double array
%  gridY          1x30                             240  double array
%  gridZ          1x30                             240  double array

addpath(genpath('../CONVERT_voxels_to_stl/CONVERT_voxels_to_stl'))


imgE = imread('../../images/Sample1.png');
% imgSwp = imread('../../images/Sample1sweep.png');
% imgSwp = imresize(imgSwp,[size(imgE,1) size(imgE,2)]);%[29 2] [29 64]  ... [2 6] [52 6]

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
for i=6:61
    row = A(i,:);
    indx = find(row);
    diaC = [diaC (indx(2)-indx(1))]; 
end
cSize = max(diaC);

model = repmat(1, [cSize cSize (61-6)]);
for i=1:size(diaC,2)
    circle = createcircle(cSize,diaC(1,i)/2);
%     circle = uint8(circle).*255;
%     imgbw = imclose(circle,se);
%     imgbw = imfill(imgbw,'holes');
%     [B,L] = bwboundaries(imgbw,'noholes'); 
%     boundary  = B{1};
    
    model(:,:,i) = circle;
end


gridX = [-size(model,1)/2:size(model,1)/2-1];
gridY = [-size(model,2)/2:size(model,2)/2-1];
gridZ = [-size(model,3)/2:size(model,3)/2-1];
[faces,vertices] = CONVERT_voxels_to_stl('../models/first.stl',model,gridX,gridY,gridZ,'ascii');
%Plot the original data:
figure;
imagesc(squeeze(sum(gridINPUT,3)));
colormap(gray);
axis equal tight


%Load and plot the stl file:
figure
[stlcoords] = READ_stl('temp.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal