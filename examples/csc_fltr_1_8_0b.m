% 6 movable poles, 1 pole at infinity, 1 fixed pole,
% wp = -0.025 to 0.075, 0.05dB elliptic passband
% 100 Monte-Carlo runs; takes a bit of time to run and plot
% lower stop-band loss is around 160dB

p = [-0.45 -0.40 -0.35 -0.30 0.3 0.35 0.4 0.45]; % initial guess at finite loss poles
ni=1; % number of loss poles at infinity
wp = []; ws = [];
wp(1) = -0.22; % lower passband edge
wp(2) = 0.22; % upper passband edge
ws = [-0.49 -0.25 0.25 0.49];
as = [50 50 50 50];
Ap = 0.05; % the passband ripple in dB
px = [];
ONE_STP = 0;
% A positive-pass continuous-time filter with a elliptic pass-band

svSpecs = {p, px, wp, ws};

[p_, px_, wp_, ws_] = shiftSpecs(p, px, wp, ws, 0.25);
H4 = dsgnDigitalFltr(p_, px_, ni, wp_, ws_, as, Ap, 'elliptic');
[ax1, ax2] = plot_drsps(H4, wp_, ws_, 'b', [-0.5 0.5 -200 1]);
cscdFltr1 = mkCscdFltrD(H4, wp_);
cscdFltr1.plotGn(wp_, ws_, -160, 2);
tic
runMcCscd(cscdFltr1, wp_, 2e-5, 0, 10, [-200, 2]);
toc
drawnow;
cscdHndl = gcf;
% print('../examples/Figures/csc_fltr_1_8_0','-dpdf');
print('../examples/Figures/csc_fltr_1_8_0','-dpng');

a=1;