function yy=lpf_sweep_open(xx, q, fs)
    % adapted from code by Yon Visell, prepared for
    % ECE 130B, Winter 2021, UC Santa Barbara

    % second order (biquad) lowpass digital filter
    % H(s) = (s^2 + s/Q + 1)^(-1)
    % a0 y[n] = b0 x[n] + b1 x[n-1] b2 x[n-2] - a1 y[n-1] - a2 y[n-2]
    % infinite impulse response filter
    % magic is to select the values of the coefficients
    
    filter_start = 0;
    filter_end = 22000;
    sweep = easing(0:length(xx)-1, filter_start, (filter_end-filter_start), length(xx)*1.25);

    yy = zeros(size(xx));
    for n=3:length(yy)
        f0 = sweep(n);
        w0 = 2*pi*(f0/fs); % fundamental freq in rads
        alpha = sin(w0)/(2*q);
        cw = cos(w0); % cut-off freq
        b0 = (1-cw)/2;
        b1 = 2*b0;
        b2 = b0;
        a0 = 1+alpha;
        a1 = -2*cw;
        a2 = 1-alpha;
        
        yy(n) = b0*xx(n) + b1*xx(n-1) + b2*xx(n-2) - a1*yy(n-1) - a2*yy(n-2);
        yy(n) = yy(n)/a0;
    end
    
end





