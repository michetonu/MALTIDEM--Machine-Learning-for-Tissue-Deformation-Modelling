z = 20;
errr = NaN;
z_init = 20;
x = NaN;
y1 = NaN;
y2 = NaN;
imax = size(nn_input_compare,1)/z_init;
for i = 1:imax
x(i,1) = nn_input_compare(z,1);
y1(i,1) = nn_output_compare(z,1);
y2(i,1) = gpr_fit(z);
errr(i,1) = gpr_err_list(z);
z=z+z_init;
end
figure
scatter(x,y1,50,'blue','+');
hold on;
scatter(x,y2,50,'red','filled');
title(strcat('Predicted and Observed Displacement'));
xlabel('Cos(theta)');
ylabel('Displacement (mm)');
legend('Observed','Predicted');
set(gca,'FontSize',14);
%c = num2str((:,a));
%h = text(x+0.0005,y2+0.0005,c);


dim = [.2 .6 .3 .3];
str = sprintf('Average error = %f',mean(errr));
h = annotation('textbox',dim,'String',str,'FitBoxToText','on');
set(h,'FontSize',14);
dim2 = [.2 .55 .3 .3];
str2 = {strcat('Node = ',num2str(node_choice)),strcat('Force Node = ',num2str(force_node_compare))};
g = annotation('textbox',dim2,'String',str2,'FitBoxToText','on');
set(g,'FontSize',14);