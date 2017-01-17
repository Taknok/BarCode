function [ output ] = resize( x, len )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
u = len / 7;
i=(1:len);
a = (length(i)-floor(u))/(length(x)-1);
b = 1 - a;

output = x(floor((i-b)/a));

end

