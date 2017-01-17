function [ seuil ] = otsu( lignemoy,N )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[h,edges] = hist(lignemoy,N);
figure,
plot(edges, h);
crit=0;
k=0;
w=zeros(1,N);

crit_tmp=zeros(1,N);
for i=1:N
    w(i)=sum(h(1:i))/sum(h);
    crit_tmp(i)=w(i)*(mu(h,N-1,N)-mu(h,i,N))^2 +(1-w(i))*mu(h,i,N)^2;
end

figure,
plot(crit_tmp);

value = max(crit_tmp(1:240));%pour éviter la valeur de 256 si on respecte pas le critère d'otsu 
indices = find( crit_tmp == value );

seuil = indices(ceil(length(indices)/2));


end

