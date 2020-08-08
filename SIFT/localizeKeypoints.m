% Calculate the Jacobian and Hessian around each candidate to get the offset (subpixel location).
function [offset, J, H, x, y, s] = localizeKeypoints(D, x, y, s)
    dx = (D(y, x+1, s) - D(y, x-1, s))/2.0;
    dy = (D(y+1, x, s) - D(y-1, x, s))/2.0;
    ds = (D(y, x, s+1) - D(y, x, s-1))/2.0;

    dxx = D(y,x+1,s)-2*D(y,x,s)+D(y,x-1,s); 
    dxy = ((D(y+1,x+1,s)-D(y+1,x-1,s)) - (D(y-1,x+1,s)-D(y-1,x-1,s)))/4.0;
    dxs = ((D(y,x+1,s+1)-D(y,x-1,s+1)) - (D(y,x+1,s-1)-D(y,x-1,s-1)))/4.0;
    dyy = D(y+1,x,s)-2*D(y,x,s)+D(y-1,x,s); 
    dys = ((D(y+1,x,s+1)-D(y-1,x,s+1)) - (D(y+1,x,s-1)-D(y-1,x,s-1)))/4.0;
    dss = D(y,x,s+1)-2*D(y,x,s)+D(y,x,s-1);
    J = [dx dy ds];
    H = [dxx dxy dxs ; dxy dyy dys; dxs dys dss];

    H = - inv(H);
    offset = [dot(H(1,:), J) dot(H(2,:), J) dot(H(3,:), J)];
    H = H(1:2, 1:2);
    return ;
end