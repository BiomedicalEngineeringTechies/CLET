close all; 
histogram(LatD1S1); 
hold on; 
m = mean(LatD1S1);
plot([m m],[0 50],'b','LineWidth',3);
title('Latency distribution LED Screen S1D1');
xlabel('Latency (s)'); ylabel('Number');
% legend({'Latency distribution', 'Average'}, 'FontSize', 20, 'Orientation','vertical');

% figure;
histogram(LatD2S2,'FaceColor',[1 0.4 0.6]);
hold on;
m2 = mean(LatD2S2);
plot([m2 m2],[0 50],'r','LineWidth',3);
title('Latency distribution VR S2D2');
xlabel('Latency (s)'); ylabel('Number');
legend({'LatS1D1 distribution', 'Average LatS1D1','LatS2D2 distribution','Average LatS2D2'}, ...
    'FontSize',20, 'Orientation','vertical');
