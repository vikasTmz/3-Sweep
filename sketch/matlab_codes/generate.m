%Load an example dataset.  The contents are as follows:
%  gridDATA      30x30x30                       216000  double array
%  gridX          1x30                             240  double array
%  gridY          1x30                             240  double array
%  gridZ          1x30                             240  double array

addpath(genpath('../CONVERT_voxels_to_stl/CONVERT_voxels_to_stl'))


imgE = imread('../../images/Sample1.png');
imgSwp = imread('../../images/Sample1sweep.png');
imgSwp = imresize(imgSwp,[size(imgE,1) size(imgE,2)]);%[194 2] [194 498]  ... [6 41] [382 41]

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
for i=41:474
    row = A(i,:);
    indx = find(row);
    diaC = [diaC (indx(2)-indx(1))]; 
end
cSize = max(diaC);

model = repmat(1, [cSize cSize (474-41)]);
for i=1:size(diaC,2)
    circle = createcircle(cSize,diaC(1,i)/2);
    model(:,:,i) = circle;
end



[faces,vertices] = CONVERT_voxels_to_stl('first.stl',model,gridX,gridY,gridZ,'ascii');
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