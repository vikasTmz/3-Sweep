function [C] = createcircle(dsize,r)
    imageSizeX = dsize;
    imageSizeY = dsize;
    [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    % Next create the circle in the image.
    centerX = imageSizeX/2;
    centerY = imageSizeY/2;
    radius = r;
    circlePixels = abs((rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 - radius.^2) <= 50;
    % circlePixels is a 2D "logical" array.
    % Now, display it.
    C = circlePixels;
end