load('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node82/Variables1.mat');
load('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node82/All_Nodes_Iterations_Fn82.mat');
load('/Users/MicTonutti/Dropbox/MRes/Individual Project/Data Analysis/SVM/SVM_output.mat');

load_data = 1;
for itt = 1:30
if load_data
    
%itt = 7;
fono = 20;
itno = fono*itt;
node_choice = 10;

force_node = 148;

displ_plot_x = NaN(1,1);
displ_plot_y = displ_plot_x;
displ_plot_z = displ_plot_x;

displ_plot_x_comp = NaN(1,1);
displ_plot_y_comp = displ_plot_x_comp;
displ_plot_z_comp = displ_plot_x_comp;
force_direction = displ_plot_x_comp;
displ_plot_tot = displ_plot_x_comp;
displ_plot_tot_comp = displ_plot_x_comp;

a = 1;


y_dirr_fin = cell(1,1);
y_magg_fin = cell(1,1);

p=1;
for i = 1:108
    for zz=1:3
y_dirr_fin{p,zz} = y_dirr{i,zz};
    end
y_magg_fin{p} = y_magg{i};
p=p+1;
end
indx_init = [1];
indx = indx_init;
for gg = 1:100
indx = [indx indx_init+10*gg];
end
indx = indx(indx(1,:)<1087);
node_choices = indx;

for oo = 1:size(indx,2)
    i=indx(oo);
for z = 1:11
    if z == 1
    displ_plot_x(a,z) = 0;
    displ_plot_y(a,z) = 0;
    displ_plot_z(a,z) = 0;
    displ_plot_tot(a,z) = 0;
    displ_plot_x_comp(a,z) = 0;
    displ_plot_y_comp(a,z) = 0;
    displ_plot_z_comp(a,z) = 0;
    displ_plot_tot_comp(a,z) = 0; 
    else
    displ_plot_x(a,z) = cos(y_dirr_fin{a,1}((z-1)*2+20*(itt-1)))*y_magg_fin{a}((z-1)*2+20*(itt-1));
    displ_plot_y(a,z) = cos(y_dirr_fin{a,2}((z-1)*2+20*(itt-1)))*y_magg_fin{a}((z-1)*2+20*(itt-1));
    displ_plot_z(a,z) = cos(y_dirr_fin{a,3}((z-1)*2+20*(itt-1)))*y_magg_fin{a}((z-1)*2+20*(itt-1));
    displ_plot_tot(a,z) = y_magg_fin{a}((z-1)*2+20*(itt-1));
    for gg = 1:3
        force_direction(gg,z) = iterations{itt}.force_direction(20,gg)./10*(z-1);
    end
    displ_plot_x_comp(a,z) = iterations{itt}.displ_max_vector{i,(z-1)*2}(1);
    displ_plot_y_comp(a,z) = iterations{itt}.displ_max_vector{i,(z-1)*2}(2);
    displ_plot_z_comp(a,z) = iterations{itt}.displ_max_vector{i,(z-1)*2}(3);
    displ_plot_tot_comp(a,z) = iterations{itt}.displ_tot_plot(i,(z-1)*2); 
    end
end
a=a+1;
end
end
dist2 = [];
mean_dist = [];
aa=1;
for z=1:11;
vec1 = [DATA_coord(nodes_list(node_choices),2,1)+displ_plot_x_comp(:,z),DATA_coord(nodes_list(node_choices),3,1)+displ_plot_y_comp(:,z),DATA_coord(nodes_list(node_choices),4,1)+displ_plot_z_comp(:,z)];
vec2 = [DATA_coord(nodes_list(node_choices),2,1)+displ_plot_x(:,z),DATA_coord(nodes_list(node_choices),3,1)+displ_plot_y(:,z),DATA_coord(nodes_list(node_choices),4,1)+displ_plot_z(:,z)];
for i = 1:size(vec1,1)
dist2(aa) = norm(vec1(i,:)-vec2(i,:));
aa=aa+1;
end
end
mean_err(itt) = mean(abs(dist2));
std_err(itt) = std(abs(dist2));
med_err(itt) = median(abs(dist2));
end
mean_tot = mean(mean_err)
med_tot = mean(med_err)
std_tot = mean(std_err)
figure
histogram(dist2,40)
xlabel('Position Error (mm)')
ylabel('Percentage')
set(gca,'FontSize',16)
xlim([0 3])
alpha 0.5
x=get(gca,'YTickLabel');
x=[0;100;200;300;400;500;600;700;800];
x=x./sum(size(dist2)); 
set(gca,'YTickLabel',num2str(x,2));
