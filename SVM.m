imagesize_x = 150;
imagesize_y = 150;
scaleparameter = 4;
inputX = [];
inputY = [];
testinputmatrix = [];
inputmatrix = [];
score = [];
% Parameter Setting
R = floor(imagesize_x / scaleparameter);
C = floor(imagesize_y / scaleparameter);
resultsize = ((floor(imagesize_x / R) * 2 - 1) ^ 2 );
inputimagecount = 39;
natureimagecount = 20;
testimagecount = 6;
detectimagecount = 3;
inputmatrix = zeros(resultsize * 8, inputimagecount);
natureinputmatrix = zeros(resultsize * 8, natureimagecount);
testinputmatrix = zeros(resultsize * 8, testimagecount);
detectinputmatrix = zeros(resultsize * 8, detectimagecount);
inputmatrix = dlmread('output1.txt')
natureinputmatrixtemp = dlmread('natureoutput.txt');
natureinputmatrix(:,1:natureimagecount) = natureinputmatrixtemp(:, 1:natureimagecount);
testinputmatrixtemp = dlmread('testoutput6.txt');
testinputmatrix(:,1) = testinputmatrixtemp(:,6);
testinputmatrixtemp = dlmread('testoutput7.txt');
testinputmatrix(:,2) = testinputmatrixtemp(:,7);
testinputmatrixtemp = dlmread('testoutput8.txt');
testinputmatrix(:,3) = testinputmatrixtemp(:,8);
testinputmatrixtemp = dlmread('testoutput9.txt');
testinputmatrix(:,4) = testinputmatrixtemp(:,9);
testinputmatrixtemp = dlmread('natureoutput11.txt');
testinputmatrix(:,5:6) = testinputmatrixtemp(:,10:11);
detectinputmatrix = dlmread('detectoutput.txt');
detectinputmatrix = detectinputmatrix';
detectinputmatrix2 = dlmread('detectoutput2.txt');



dsinputmatrix1 = dlmread('dsoutput1.txt');
dsinputmatrix1 = dsinputmatrix1';
dsinputmatrix2 = dlmread('dsoutput2.txt');
dsinputmatrix2 = dsinputmatrix2';
dsinputmatrix3 = dlmread('dsoutput3.txt');
dsinputmatrix3 = dsinputmatrix3';
dsinputmatrix4 = dlmread('dsoutput4.txt');
dsinputmatrix4 = dsinputmatrix4';

inputX = zeros(resultsize * 8, inputimagecount + natureimagecount);
inputX(:,1:inputimagecount) = inputmatrix(:, 1:inputimagecount);
inputX(:,inputimagecount + 1:inputimagecount + natureimagecount) = natureinputmatrix;
inputX = inputX';
inputY = zeros((inputimagecount + natureimagecount), 1);
for i = 1:inputimagecount 
   inputY(i, 1) = 1;
end
for i = inputimagecount + 1: inputimagecount + natureimagecount 
   inputY(i, 1) = -1;
end
inputY;
%figure;
%svmStruct = fitcsvm(inputX, inputY)
svmStruct = [];
score = [];
%c = cvpartition((inputimagecount + natureimagecount),'KFold',floor((inputimagecount + natureimagecount)/20));
%sigma = optimizableVariable('sigma',[1e-5,1e5],'Transform','log');
%box = optimizableVariable('box',[1e-5,1e5],'Transform','log');
%svmStruct = fitcsvm(inputX,inputY,'Standardize',true,'KernelFunction','RBF',...
%    'KernelScale','auto');





testinputmatrix = testinputmatrix';
svmStruct =  fitcsvm(inputX,inputY);
[~,score] = predict(svmStruct,testinputmatrix)

svmStruct =  fitcsvm(inputX,inputY,'KernelScale','auto','Standardize',true,'OutlierFraction',0.01);
[~,score] = predict(svmStruct,testinputmatrix);

svmStruct =  fitcsvm(inputX,inputY,'KernelFunction','mysigmoid','Standardize',true);        
[~,score] = predict(svmStruct,testinputmatrix);

testinputmatrix = [];

svmStruct =  fitcsvm(inputX,inputY);
[~,detectscore] = predict(svmStruct,detectinputmatrix)

svmStruct =  fitcsvm(inputX,inputY);
[~,detectscore2] = predict(svmStruct,detectinputmatrix2')
 
svmStruct =  fitcsvm(inputX,inputY);
Image = imread('ds1.jpg');
[heightOrigin, widthOrigin, dim] = size(Image);
maxscore = 0;
startposition = [0, 0];
windowsize = [0, 0];
for count = 1:3
    if count == 1
    [~,detectscore] = predict(svmStruct,dsinputmatrix1)
    elseif count ==2
    [~,detectscore] = predict(svmStruct,dsinputmatrix2)
    elseif count ==3
    [~,detectscore] = predict(svmStruct,dsinputmatrix3)
    elseif count == 4
    [~,detectscore] = predict(svmStruct,dsinputmatrix4)
    end
    detectscoretemp = detectscore(:,2)
    [maxscoretemp, maxindextemp] = max(detectscoretemp)
    if maxscoretemp > maxscore
        startposition = [floor(heightOrigin / (count + 1)) * rem(maxindextemp - 1, count) + 2, floor(widthOrigin / (count + 1)) * floor((maxindextemp - 1) / count) + 2 ]
        windowsize = [floor(imagesize_x * heightOrigin / (75 * (count + 1))), floor(imagesize_x * heightOrigin / (75 * (count + 1)))]
        maxscore = maxscoretemp;
    end
%    ind2sub(detectscoretemp, maxscore)
end
if maxscore> 0 
    draw_rect(Image, startposition, windowsize, 1);
else
    imshow(Image);  
    'undetected'
end