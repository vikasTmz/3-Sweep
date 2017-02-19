x = -2:0.25:2;
y = x;
z = x.*exp(-x.^2-(y').^2);
surf(x,y,z);
VariableName = surf2solid(x,y,z);
stlwrite('FileName.stl',VariableName);