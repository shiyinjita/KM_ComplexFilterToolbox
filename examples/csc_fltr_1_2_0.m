p = [-0.25  0.25]; % initial guess at moveable finite loss poles
px = []; % fixed poles, this poles will be at dc after frequency shift of specs and poles
ni=1; % number of loss poles at infinity
wp(1) = -0.0125; % lower passband edge
wp(2) = 0.0125; % upper passband edge
ws = [-0.024 0.024]; % lower and upper stopband frequencies
as = [20 20];

Ap = 0.1; % the passband ripple in dB
ONE_STP = 0; % treat both stop-bands as a single stop-band

% frequency shift specs so pass band is at positive frequencies
% from 0.0125 to 0.0375
[p_, px_, wp_, ws_] = shiftSpecs(p, px, wp, ws, 0.025); 

% top level function for designed digital filter based on bilinear-z transform
H = dsgnDigitalFltr(p_, px_, ni, wp_, ws_, as, Ap, 'elliptic');
% plot resulting transfer function
[ax1, ax2] = plot_drsps(H, wp_, ws_, 'b', [-0.5 0.5 -60 1]);

% order and group poles and zeros into a cascade filter
cscdFltr = mkCscdFltrD(H, wp_);

% plot cascade filter using object function
cscdFltr.plotGn(wp_, ws_, -60, 2);
tic
% simulate cascade filter 100 times with SS matrix elements
% varying by 0.01%
runMcCscd(cscdFltr, wp_, 2e-5, 0, 100, [-60 2]);
toc
drawnow;
cscdHndl = gcf;
% print('../examples/Figures/csc_fltr_1_2_0','-dpdf');
print('../examples/Figures/csc_fltr_1_2_0','-dpng');

a=1;