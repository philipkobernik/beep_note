function y = easing(t, b, c, d, varargin)
%EASING Easing function
%   y = easing(t, b, c, d) interpolates at timepoints t between b and the
%   change in value c with a transition duration of d. By default, a linear
%   interpolation is used.
%
%   easing(..., f) uses interpolation function f, taking the following
%   values:
%       LINEAR
%       - 1     lin     (default)
%       QUADRATIC
%       - 2     quadInOut
%       - 2.1   quadIn
%       - 2.2   quadOut
%       CUBIC
%       - 3     cubicInOut
%       - 3.1   cubicIn
%       - 3.2   cubicOut
%       QUARTIC
%       - 4     quartInOut
%       - 4.1   quartIn
%       - 4.2   quartOut
%       QUINTIC
%       - 5     quintInOut
%       - 5.1   quintIn
%       - 5.2   quintOut
%       SINUSOIDAL
%       - sinInOut
%       - sinIn
%       - sinOut
%       EXPONENTIAL
%       - expInOut
%       - expn
%       - expOut
%       CIRCULAR
%       - circInOut
%       - circIn
%       - circOut
%
%   When specifying the easing function, both strings and numbers are
%   accepted, according to the list above.
%
%   Examples
%       easing(5, 0, 10, 10);           % Linear interpolation between 0 and 10
%       easing(0:100, 1, 1, 100, 5.2);	% QuinticOut interpolation between 1 and 2
    
    % Handle input
    p = inputParser();
    p.addRequired('t');
    p.addRequired('b');
    p.addRequired('c');
    p.addRequired('d');
    p.addOptional('f', 1, @(x)ischar(x)||isnumeric(x));
    p.parse(t, b, c, d, varargin{:});
    p = p.Results;
    
    t = p.t;
    b = p.b;
    c = p.c;
    d = p.d;
    f = p.f;
    
    % Switch between easing functions
    switch lower(f)
        % LINEAR
        case {1 'lin'}
            y = c.*t/d + b;
        % QUADRATIC
        case {2 'quad' 'quadinout'}
            t = t/d*2;
            y = zeros(size(t));
            y(t<1) = c/2.*t(t<1).*t(t<1) + b;
            y(t>=1) = -c/2.*((t(t>=1)-1).*((t(t>=1)-1)-2) - 1) + b;
        case {2.1 'quadin'}
            t = t/d;
            y = c.*t.^2 + b;
        case {2.2 'quadout'}
            t = t/d;
            y = -c.*t.*(t-2) + b;
        % CUBIC
        case {3 'cubic' 'cubicinout'}
            t = t/d*2;
            y = zeros(size(t));
            y(t<1) = c/2.*t(t<1).^3 + b;
            y(t>=1) = c/2.*((t(t>=1)-2).^3 + 2) + b;
        case {3.1 'cubicin'}
            t = t/d;
            y = c.*t.^3 + b;
        case {3.2 'cubicout'}
            t = t/d - 1;
            y = c.*(t.^3 + 1) + b;
        % QUARTIC
        case {4 'quart' 'quartinout'}
            t = t/d*2;
            y = zeros(size(t));
            y(t<1) = c/2.*t(t<1).^4 + b;
            y(t>=1) = -c/2.*((t(t>=1)-2).^4 - 2) + b;
        case {4.1 'quartin'}
            t = t/d;
            y = c.*t.^4 + b;
        case {4.2 'quartout'}
            t = t/d - 1;
            y = -c.*(t.^4 + 1) + b;
        % QUINTIC
        case {5 'quint' 'quintinout'}
            t = t/d*2;
            y = zeros(size(t));
            y(t<1) = c/2.*t(t<1).^5 + b;
            y(t>=1) = c/2.*((t(t>=1)-2).^5 + 2) + b;
        case {5.1 'quintin'}
            t = t/d;
            y = c.*t.^5 + b;
        case {5.2 'quintout'}
            t = t/d - 1;
            y = c.*(t.^5 + 1) + b;
        % SINUSOIDAL
        case {'sin' 'sininout'}
            y = -c/2.*(cos(pi.*t./d) - 1) + c + d;
        case {'sinin'}
            y = -c.*cos(t./d.*(pi/2)) + c + d;
        case {'sinout'}
            y = c.*sin(t./d.*(pi/2)) + d;
        % EXPONENTIAL
        case {'exp' 'expinout'}
            t = t/d*2;
            y = zeros(size(t));
            y(t<1) = c/2.*(2.^(10.*(t(t<1) - 1))) + b;
            y(t>=1) = c/2.*(-2.^(-10.*(t(t>=1) - 1)) + 2) + b;
        case {'expin'}
            y = c.*(2.^(10.*(t./d - 1))) + b;
        case {'expout'}
            y = c.*(-2.^(-10.*(t./d)) + 1) + b;
        % CIRCULAR
        case {'circ' 'circinout'}
            t = t/d*2;
            y = zeros(size(t));
            y(t<1) = -c/2.*(sqrt(1 - t(t<1).^2) - 1) + b;
            y(t>=1) = c/2.*(sqrt(1 - (t(t>=1)-2).^2) + 1) + b;
        case {'circin'}
            t = t/d;
            y = -c.*(sqrt(1 - t.^2) - 1) + b;
        case {'circout'}
            t = t/d - 1;
            y = c.*(sqrt(1 - t.^2)) + b;
    end
end
