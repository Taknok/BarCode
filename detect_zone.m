function [ lines ] = detect_zone( code_barre )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
BW = edge(uint8(code_barre(:,:,1)),'canny');
figure;
imshow(BW);
rect = strel('rectangle',[30 30]); 
tyjoin1 = imclose(BW,rect);
figure; imshow(tyjoin1);
figure,
imcontour(tyjoin1);


BW = edge(tyjoin1,'canny');
[H,T,R] = hough(BW);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',30);


       
figure, imshow(tyjoin1), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

%  affiche le deb et fin de ligne
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

%   Determine la fin du la plus grande ligne
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end



end

