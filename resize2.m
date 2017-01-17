function [ output ] = resize2( x, len )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


output = x(floor(((0:len-1) / len) * length(x))+1);


end

