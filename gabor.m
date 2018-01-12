
close all;
clc;
imagesize_x = 150;
imagesize_y = 150;
scaleparameter = 4;
inputimagecount = 15;
% Parameter Setting
R = floor(imagesize_x / scaleparameter);
C = floor(imagesize_y / scaleparameter);
Kmax = pi / 2;
f = sqrt( 3 );
Delt = 2 * pi;
Delt2 = Delt * Delt/3;
GW = [];
sketchbasis = [];
for i = 1:32
    GW(:,:,i) = zeros(R, C);
end

% Show the Gabor Wavelets
%5 scales, 80orientation,generating 400 gabor wavelet dictionary
i=1;
for v = 0 : 4
    for u = 1 : 8
        temp = GaborWavelet ( R, C, Kmax, f, u, v, Delt2 );
        GW(:,:,i) = temp;  % Create the Gabor wavelets
        i=i+1;
    end
end

for j = 24 : 32
   sketchbasis(:,:,j-23) = real(GW(:,:,j));
   sketchbasis(:,:,j-23) = sketchbasis(:,:,j-23) / sqrt(sum(dot(sketchbasis(:,:,j-23),sketchbasis(:,:,j-23))));
end
tic;
resultsize = ((floor(imagesize_x / R) * 2 - 1) ^ 2 );

outputmatrix = zeros(resultsize * 8, inputimagecount);
natureoutputmatrix = zeros(resultsize * 8, inputimagecount);
%testoutputmatrix = zeros(resultsize * 8, inputimagecount);

%{
for i = 1 : inputimagecount
    number = int2str(i + 25);
   imagename = strcat(number, '.jpg');
   I=imread(imagename);
   Image=rgb2gray(I);
    Image = single(Image);
   c=OMP(sketchbasis, Image, R, imagesize_x, i + 25);
   outputmatrix(:,i) = c;
   imagetext = strcat(number, ' image done')
end
dlmwrite('output2.txt', outputmatrix);
toc



for i = 11:12
    number = int2str(i);
    imagename = strcat(number, '.jpg');
    imagename = strcat('n', imagename);
    I=imread(imagename);
    Image=rgb2gray(I);
    Image = single(Image);
    c=OMP(sketchbasis, Image, R, imagesize_x, i);
    natureoutputmatrix(:,i) = c;
    imagetext = strcat(number, ' image done')
end 
dlmwrite('natureoutput11.txt', natureoutputmatrix);
toc
%}


%{
testoutputmatrix = zeros(resultsize * 8, 67);
testimagecount = 5;
for i = 9:9
    number = int2str(i);
    imagename = strcat(number, '.jpg');
    imagename = strcat('t', imagename);
    I=imread(imagename);
    Image=rgb2gray(I);
    Image = single(Image);
    c=OMP(sketchbasis, Image, R, imagesize_x, i);
    testoutputmatrix(:,i) = c;
end
dlmwrite('testoutput9.txt', testoutputmatrix);

%}


tic;

detectimagecount = 1;
I = imread('ds1.jpg');
ImageOrigin = rgb2gray(I);
ImageOrigin = single(ImageOrigin);
[heightOrigin, widthOrigin, dimOrigin] = size(ImageOrigin);

count = 1;
while (count + 1) * imagesize_x / 2 <= widthOrigin % && (count + 1) * imagesize_x / 2 <= 300
%    if count == 4
        Imagetemp = zeros(imagesize_x, imagesize_y);


        Image = imresize(ImageOrigin, ((count + 1) * imagesize_x / 2)/widthOrigin);
        [height, width, dim] = size(Image);
        height;
        width;
        columnnumber = floor(width / ((imagesize_x)/2)) - 1;
        rownumber = floor(height / ((imagesize_y)/2)) - 1;
        detectoutputmatrix = [];
        detectoutputmatrix = zeros(resultsize * 8, rownumber * columnnumber);
        for j = 1:rownumber
            for i = 1:columnnumber
                Imagetemp = Image( 1 + (150 / 2 * (j-1)): 150 + (75 * (j - 1)), 1 + (150 / 2 * (i-1)): 75 * (i + 1));
                c=OMP(sketchbasis, Imagetemp, R, imagesize_x, i, j);
                detectoutputmatrix(:,(j - 1) * columnnumber + i) = c;
                count
            end
        end
        ouputfilename = strcat('dsoutput', int2str(count), '.txt');
        dlmwrite(ouputfilename, detectoutputmatrix);

 %   end
    count = count + 1;
end
toc



