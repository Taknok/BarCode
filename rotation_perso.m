function [ image_out, x_out, y_out ] = rotation_perso( image_perso, angle, x, y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%conversion en rad
angle_rad = angle * pi / 180;

%cast
image_perso = double(image_perso);

%creation de la mat de rot
mat_rot = [cos(angle_rad) -sin(angle_rad); sin(angle_rad) cos(angle_rad)];

[hauteur, largeur] = size(image_perso);
midy=(hauteur+1)/2;
midx=(largeur+1)/2;

%calcul des position des coins
A_rot = mat_rot * [1 ; 1];
B_rot = mat_rot * [largeur ; 1];
C_rot = mat_rot * [1 ; hauteur];
D_rot = mat_rot * [largeur ; hauteur];


X_corner_rot = [A_rot(1) B_rot(1) C_rot(1) D_rot(1)];
Y_corner_rot = [A_rot(2) B_rot(2) C_rot(2) D_rot(2)];

%calcul de la dimention de l'image tourn�e
x_min_rot = floor(min(X_corner_rot));
x_max_rot = ceil(max(X_corner_rot));
y_min_rot = floor(min(Y_corner_rot));
y_max_rot = ceil(max(Y_corner_rot));

hauteur_rot = x_max_rot - x_min_rot +1;
largeur_rot = y_max_rot - y_min_rot +1;


[X1, Y1] = meshgrid((1:largeur),(1:hauteur));
[X2, Y2] = meshgrid((x_min_rot:x_max_rot),(y_min_rot:y_max_rot));



%calcul la rot des points
B = mat_rot * [x(1) ; y(1)];
x_out(1) = floor(B(1) + midx);
y_out(1) = floor(B(2));

B = mat_rot * [x(2) ; y(2)];
x_out(2) = floor(B(1) + midx);
y_out(2) = floor(B(2));


%calcul rotation
XY2 = inv(mat_rot) * [X2(:)' ; Y2(:)']; %on centre pour faire la rotation de  maniere centrée
XY2 = XY2';



X2 = reshape(XY2(:,1), [largeur_rot, hauteur_rot]);
Y2 = reshape(XY2(:,2), [largeur_rot, hauteur_rot]);

image_out = interp2(X1, Y1, image_perso, X2, Y2);

image_out(isnan(image_out)) = 255 ; %met les valeurs non calculée a 255

end

