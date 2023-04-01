function c = blues(m)
%REDBLUE    Shades of red and blue color map
%   REDBLUE(M), is an M-by-3 matrix that defines a colormap.
%   The colors begin with bright blue, range through shades of
%   blue to white, and then through shades of red to bright red.
%   REDBLUE, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(redblue)
%
%   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.

%   Adam Auton, 9th October 2009

if nargin < 1, m = size(get(gcf,'colormap'),1); end

c=imresize([1 1 1; 151/255 227/255 238/255; 62/255 205/255 223/255],[256,3],"bilinear");

% if (mod(m,2) == 0)
%     % [1 1 1] to [0 0 1];
%     m1 = m;
%     r = (0:m1-1)'/max(m1-1,1);
%     g = r;
%     b = ones(m,1);
%     r = flipud(g);
%     g = flipud(g);
% end
% 
% c = [r g b]; 

