function output = test( a, b , r)
%TEST Summary of this function goes here
%   Detailed explanation goes here

c = a*b;
total =0;

% okay sum(sum((a*b).*r))
% okay tmp = (a*b).*r;sum(tmp(:))
% no okay sum(sum((a*b)*r))
tmp = (a*b)*r;
sum(c(:))

for i = 1 :5
    for j = 1:5
        if (r(i,j)==1)
            total = total + c(i,j);
        end 
    end
end




end

