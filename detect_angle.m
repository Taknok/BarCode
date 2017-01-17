function [ angle ] = detect_angle( code_barre ,x,y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
angle_limits=atan((y(2)-y(1))/(x(2)-x(1)))*180/pi  ;
BW = edge(uint8(code_barre(:,:,1)),'canny');
[H,theta,rho] = hough(BW,'RhoResolution',0.5,'Theta', -(abs(angle_limits)+20):0.5:abs(angle_limits)+20);

figure,
imagesc(H,'xdata', theta,'ydata', rho);
xlabel('angle en degré');

P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
angle = lines(1).theta;

end

