%make the txt a readable document for liblinear

A1= zeros(392,6);

 A1 = dlmread('testreport.txt');

 A1=A1';
% A2 = randn(1,100);
 i=linspace(1,392,392);
% formatSpec = '+1 %d:%4.2f %8.3f\n';
% fprintf(fileID,formatSpec,i,A1,A2)

for j=1:1:392
    for k=1:6
        cell(k,1)={'+1 '};
        cell(k,j+1+3*(j-1))={j};
        cell(k,j+2+3*(j-1))={':'};
        cell(k,j+3+3*(j-1))={A1(k,j)};
        cell(k,j+4+3*(j-1))={' '};
       
    end
end 

dlmcell('detectoutput',cell);
%detection part
[heart_scale_label, heart_scale_inst] = libsvmread('train');
% heart_scale_inst=sparse(heart_scale_inst);
model = train(heart_scale_label, heart_scale_inst, '-c 1');
[test_label, test_inst] = libsvmread('detectoutput2');
[predict_label, accuracy, dec_values] = predict(test_label, test_inst, model); % test the training data
