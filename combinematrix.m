
imagesize_x = 150;
imagesize_y = 150;
R = floor(imagesize_x / scaleparameter);
C = floor(imagesize_y / scaleparameter);
resultsize = ((floor(imagesize_x / R) * 2 - 1) ^ 2 );
resultmatrix = zeros(resultsize * 8, 40);
matrix1 = dlmread('output.txt');
matrix2 = dlmread('output2.txt');
matrix1'
matrix2'
%matrix3 = dlmread('natureoutput3.txt');
resultmatrix(:,1:25) = matrix1;
resultmatrix(:,26:40) = matrix2;
%resultmatrix(:,11:20) = matrix3;
resultmatrix
dlmwrite('output1.txt',resultmatrix);