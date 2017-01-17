clear all;
close all;
clc;

%% Initialisation
code_barre=imread('code3.jpg');
epsilon = 0.2;
N=256;


%% Calcul
% Extract edges.


figure;
imshow(code_barre);

lines=detect_zone(code_barre);




for w=1:length(lines)
    for k=1:length(lines)
        
        A=fliplr(ceil((lines(w).point1+lines(w).point2 )/2));
        B=ceil((lines(k).point1+lines(k).point2)/2);
        
        %m�thode qui marche si les lignes sont tri�s dans l'ordre
%       x=[A(1); B(1)];
%       y=[A(2); B(2)];

        %m�thode qui marche en g�n�ral si le code barre est au centre de
        %l'image
        y=[];
        x=[min(min(A,B)) max(max(A,B))];
        if(A(1)==x(1))
          y(1)=A(2);  
        else 
          y(1)=A(1);
        end
        if(B(1)==x(2))
          y(2)=B(2);  
        else 
          y(2)=B(1);
        end
        x=sort(x);
        
        try  
            %detection angle
            angle=detect_angle( code_barre,x,y );  
            if (-angle>=5)
                [code_barre_out, x, y] = rotation_perso( code_barre(:,:,1), -angle, x, y);
                code_barre = code_barre_out;
            end         
            
            %creation de la ligne droite
            if abs(x(2)-x(1))<abs(y(2)-y(1))
                x(2)=x(1);
            else
                y(2)=y(1);
            end
            
            figure,
            imshow(uint8(code_barre));
            %plot la ligne sur l'écran
            hold on,
            line(x,y);
            %selection de la ligne
            ligne_test=code_barre(y(1):y(2),x(1):x(2),1);
            
            %selection de la zone d'intéret Rt
            [ybot, ytop, lignemoy] = zone_interet( code_barre, x,y,ligne_test, epsilon );
            line(x,ybot);
            line(x,ytop);
            
            %seuil otsu, cf fonction otsu
            seuil=otsu(double(lignemoy),N);
            
            % mise en bianire
            vect_bin = lignemoy<=seuil;
            
            %découpage pour detection debut et fin
            x=find(vect_bin);
            vect_bin=not(vect_bin(x(1):x(length(x))));
            figure,
            plot(vect_bin);
            
            A=[1 1 1 0 0 1 0;1 1 0 0 1 1 0;1 1 0 1 1 0 0;1 0 0 0 0 1 0;1 0 1 1 1 0 0;1 0 0 1 1 1 0;1 0 1 0 0 0 0;1 0 0 0 1 0 0;1 0 0 1 0 0 0;1 1 1 0 1 0 0];
            B=[1 0 1 1 0 0 0;1 0 0 1 1 0 0;1 1 0 0 1 0 0;1 0 1 1 1 1 0;1 1 0 0 0 1 0;1 0 0 0 1 1 0;1 1 1 1 0 1 0;1 1 0 1 1 1 0;1 1 1 0 1 1 0;1 1 0 1 0 0 0];
            C=[0 0 0 1 1 0 1;0 0 1 1 0 0 1;0 0 1 0 0 1 1;0 1 1 1 1 0 1;0 1 0 0 0 1 1;0 1 1 0 0 0 1;0 1 0 1 1 1 1;0 1 1 1 0 1 1;0 1 1 0 1 1 1;0 0 0 1 0 1 1];
            D=['A' 'A' 'A' 'A' 'A' 'A'; 'A' 'A' 'B' 'A' 'B' 'B'; 'A' 'A' 'B' 'B' 'A' 'B'; 'A' 'A' 'B' 'B' 'B' 'A'; 'A' 'B' 'A' 'A' 'B' 'B'; 'A' 'B' 'B' 'A' 'A' 'B'; 'A' 'B' 'B' 'B' 'A' 'A'; 'A' 'B' 'A' 'B' 'A' 'B'; 'A' 'B' 'A' 'B' 'B' 'A'; 'A' 'B' 'B' 'A' 'B' 'A'];
            
            u=length(vect_bin)/95;
            
            chiffre=zeros(1,13);
            compteur=2;
            code = ['0' '0' '0' '0' '0' '0' ];
            for k=3*u+1:7*u:6*7*u+3*u %boucle pour les 6 premiers chiffres
                
                vect = vect_bin(floor(k) : floor(k+7*u));
                A_up=zeros(10, length(vect));
                B_up=zeros(10, length(vect));
                C_up=zeros(10, length(vect));
                for i=1:10
                    A_up(i,:) = resize2(A(i,:), length(vect));
                    B_up(i,:) = resize2(B(i,:), length(vect));
                    C_up(i,:) = resize2(C(i,:), length(vect));
                end
                
                c = zeros(1,31);
                for j = 0:length(A_up(:,1))-1
                    c(j*3+1) = corre(A_up(j+1,:), vect);
                    c(j*3+2) = corre(B_up(j+1,:), vect);
                    c(j*3+3) = corre(C_up(j+1,:), vect);
                end
                
                [y, indice] = max(c);
                chiffre(compteur) = floor(indice/3);
                if (mod(indice,3) == 1)
                    code(compteur-1) = 'A';
                end
                if (mod(indice,3) == 2)
                    code(compteur-1) = 'B';
                end
                
                
                compteur=compteur+1;
            end
            [a, indice_code] = ismember(code,D,'rows');
            chiffre(1) = indice_code -1;
            
            for k=3*u+6*7*u+5*u+1:7*u:3*u+6*7*u+5*u+7*6*u %boucle pour les 6 premiers chiffres
                
                vect = vect_bin(floor(k) : floor(k+7*u));
                A_up=zeros(10, length(vect));
                B_up=zeros(10, length(vect));
                C_up=zeros(10, length(vect));
                for i=1:10
                    A_up(i,:) = resize2(A(i,:), length(vect));
                    B_up(i,:) = resize2(B(i,:), length(vect));
                    C_up(i,:) = resize2(C(i,:), length(vect));
                end
                
                c = zeros(1,31);
                for j = 0:length(A_up(:,1))-1
                    c(j*3+1) = corre(A_up(j+1,:), vect);
                    c(j*3+2) = corre(B_up(j+1,:), vect);
                    c(j*3+3) = corre(C_up(j+1,:), vect);
                end
                
                [y, indice] = max(c);
                chiffre(compteur) = floor(indice/3)-1;
                
                
                compteur=compteur+1;
            end
            
            
            %clef de control
            clef_sum = sum(chiffre(1:2:12)) + 3*sum(chiffre(2:2:12));
            clef = 10 - mod(clef_sum, 10);
            
            
            
            
            
            %% Affichage
            if (clef == chiffre(13))
                disp('Code valide');
                chiffre
                return;
            else
                disp('Code non valide')
                chiffre
            end
            
            
        catch
            continue
        end
    end
end