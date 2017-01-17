function [ ytop, ybot, lignemoy ] = zone_interet( image, x,y,ligne_test, epsilon )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
somme = sum(ligne_test);

ytop = [y(1) - 1, y(2) - 1];
ybot = [y(1) + 1, y(2) + 1];

somtop = sum(image(ytop(1):ytop(2),x(1):x(2),1));
%vers le haut
while(abs(somtop / somme) < 1 + epsilon && abs(somtop / somme) > 1 - epsilon && ytop(1) > 1)
    lignetop =  image(ytop(1):ytop(2),x(1):x(2),1);
    somtop = sum(lignetop);
    ytop = [ytop(1)-1, ytop(2)-1];
end

sombot = sum(image(ybot(1):ybot(2),x(1):x(2),1));
%vers le bas
while(abs(sombot / somme) < 1 + epsilon && abs(sombot / somme) > 1 - epsilon && ybot(1) < length(image(:,1,1)))
    lignebot = image(ybot(1):ybot(2),x(1):x(2),1);
    sombot = sum(lignebot);
    ybot = [ybot(1)+1, ybot(2)+1];
end

recut = image(ytop(1):ybot(1),x(1):x(2),1);
lignemoy = cast(mean(recut),'like',ligne_test);



