function [ output ] = corre( sth, sp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s_th = sth - mean(sth);
s_p = sp - mean(sp);

output = (dot(s_th, s_p))/(norm(s_th)*norm(s_p));

end

