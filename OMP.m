function c=OMP(basis, Image, unitsize, imagesize, imagenumber, imagenumber2);
iteration = 100;
rowsize = (floor(imagesize / unitsize) * 2 - 1);
resultsize = ((floor(imagesize / unitsize) * 2 - 1) ^ 2 );
resultindex = zeros(1, iteration);
result = zeros(resultsize * 8, 1); %init result array
loop_column = 1;
loop_row = 1;
residual = Image;
umatrix = zeros(imagesize, imagesize, iteration);
    for count = 1:iteration
        %find maxinner product 
        maxinnerproduct = 0;
        maxinnerindex = 1;
        maxcolumnindex = 1;
        maxrowindex = 1;
        maxbasis = zeros(unitsize, unitsize);
        for i = 1:resultsize

            loop_row = floor((i - 1) / rowsize) * unitsize / 2 + 1; 
            loop_column = floor(rem(i - 1, rowsize) / 2 * unitsize) + 1;
            subresidual = residual(loop_row:(loop_row + unitsize - 1), loop_column:(loop_column + unitsize - 1));
            for basiscount = 1:8
                innerproduct = (vpa(sum(dot(subresidual, basis(:,:,basiscount))), 4));
                if innerproduct > maxinnerproduct
                    maxinnerproduct = innerproduct;
                    maxinnerindex = (i - 1) * 8 + basiscount;
                    maxcolumnindex = loop_column;
                    maxrowindex = loop_row;
                    maxbasis = basis(:,:,basiscount);
                end
            end


        end
        result(maxinnerindex, 1) = result(maxinnerindex, 1) + maxinnerproduct;
        
        if(count == 1)
            blank = zeros(imagesize, imagesize);
            blank(maxrowindex:(maxrowindex + unitsize - 1), maxcolumnindex:(maxcolumnindex + unitsize - 1)) = maxbasis;
            umatrix(:,:,count) = blank(:,:);
        else
            temp = 0;
            blank = zeros(imagesize, imagesize);
            blank(maxrowindex:(maxrowindex + unitsize - 1), maxcolumnindex:(maxcolumnindex + unitsize - 1)) = maxbasis;

            for m=1:count-1 
                divisor = sum(dot(umatrix(:,:,m),umatrix(:,:,m)));
%                if(sum(dot(umatrix(:,:,m),umatrix(:,:,m))) == 0)
%                    divisor = 1;
%                end
                temp = temp + (sum(dot(blank,umatrix(:,:,m)))/divisor)*umatrix(:,:,m);
            end
            temp;
            umatrix(:,:,count) = blank - temp;
        end
%        subresidualtemp = residual(maxrowindex:(maxrowindex + unitsize - 1), maxcolumnindex:(maxcolumnindex + unitsize - 1));
%        subresidualtemp = subresidualtemp - dot(R, umatrix(:,i)) * umatrix(:,i)/dot(umatrix(:,i),umatrix(:,i));
        

        divisor = sum(dot(umatrix(:,:,count),umatrix(:,:,count)));
%        if(divisor == 0 )
%            divisor = 1;
 %       end
 
        residual = residual - sum(dot(residual, umatrix(:,:,count))) * umatrix(:,:,count)/divisor;
        %       
 
 %update residual       
 %       subresidualtemp = residual(maxrowindex:(maxrowindex + unitsize - 1), maxcolumnindex:(maxcolumnindex + unitsize - 1));
 %       subresidualtemp = subresidualtemp - maxinnerproduct * (maxbasis)
 %       residual(maxrowindex:(maxrowindex + unitsize - 1), maxcolumnindex:(maxcolumnindex + unitsize - 1)) = subresidualtemp;
 %      resultindex(count) = maxinnerindex;

        resultindex(count) = maxinnerindex;
        umatrix(:,:,1);
        count;
        imagetext = [];
        imagetempnumber = int2str(imagenumber);
        imagetempnumber2 = int2str(imagenumber2);
        imagetext = strcat('No. ', imagetempnumber, ' ', imagetempnumber2, ' ')
        imagetext = strcat(int2str(count), ' iteration, ')
    end





c = result;
%d=121;k=400;
%D=zeros(d,d,k);
%D(:,:,:)=GW(:,:,:);
%r=zeros(d,d,k);
%r(:,:,1)=Image;
% x=zeros(d,k);
% u=zeros(d,k);
% rd=zeros(1,2*d);
% ru=zeros(1,k);
% rd_maxindex=zeros(1,k);
% error=zeros(1,k);
% 
% for i=1:k
%     for j=1:2*d
%       rd(j)=dot(r(:,i),D(:,j));
%     end
%     [rd_max,rd_maxindex(1,i)] =max(rd);
%     if(i==1)
%         u(:,1)=D(:,rd_maxindex(1,1));
%     end
%     minus=0;
%     if(i>1)
%         for past=2:i;
%         minus=dot(u(:,past-1),D(:,rd_maxindex(1,i)))*u(:,past-1)/(norm(u(:,past-1))*norm(u(:,past-1)))+minus;
%         end
%          u(:,i)=D(:,rd_maxindex(1,i))-minus;
%     end
%     ru(1,i)=dot(r(:,i),u(:,i));
%     x(:,i+1)=x(:,i)+ru(1,i)*u(:,i)/norm(u(:,i));
%     r(:,i+1)=r(:,i)-ru(1,i)*u(:,i)/norm(u(:,i));
%     error(i)=norm(x(:,1)-x(:,i+1));
% end

end