function [ y ] = mu( h,k,N )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
y=sum((1:k).*h(1:k))/sum(h(1:N));


end

