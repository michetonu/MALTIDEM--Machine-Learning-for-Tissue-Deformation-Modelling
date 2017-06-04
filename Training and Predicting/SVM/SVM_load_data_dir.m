function [nn_input,nn_input_compare,nn_output,nn_output_compare] = SVM_load_data_dir(force_node_compare,node_choice)

iterations = load('iterations.mat');
coordinates = load('data_coord.mat');
nodes_list = load('nodes_list.mat');
force_nodes = load('force_nodes.mat');

%Force node to test network
force_node_compare = 91;
%Set aside data for testing
force_nodes = force_nodes(force_nodes(:,1)~=force_node_compare,1);
%Number of force steps (from 0 to 1N)
fn = 20;

nn_input = NaN;
nn_output = NaN;
%node_choice = 10;
a=1;
err = [];
distance = NaN;
vectemp = NaN;
th = NaN;

for i = 1:size(force_nodes,1)
    force_node = force_nodes(i);
    dir_name = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',num2str(force_node));
    var_filename = strcat(dir_name,'/All_Nodes_Iterations_Fn',num2str(force_node),'.mat');
    load(var_filename);
    for z = 1:30
        for n = node_choice
            for f = 1:fn
                %if iterations{z}.cos_plot(n,f)>0
                nn_input(a,1) = iterations{z}.cos_plot(n,f);
                for g =1:3
                    nn_input(a,g+1) = iterations{z}.force_direction(f,g);
                end
                nn_input(a,5) = iterations{z}.dist_plot(n,f);
                
                for h=1:3
                    th(h) = iterations{z}.force_direction(fn,h)/norm(iterations{z}.force_direction(fn,:));
                    th(h) = acos(th(h));
                    nn_input(a,5+h) = th(h);
                end
                
                for xyz = 1:3
                    vectemp(1,xyz) = DATA_coord(force_node,xyz+1,1);
                    vectemp(2,xyz) = cmbrain(xyz);
                end
                nn_input(a,9) = pdist(vectemp);
                
                r = vrrotvec(DATA_coord(force_node,2:4,1)-DATA_coord(nodes_list(n),2:4,1),iterations{z}.force_direction(fn,:));
                nn_input(a,10) = r(1);
                nn_input(a,11) = r(2);
                nn_input(a,12) = r(3);
                nn_input(a,13) = r(4);
                
                for gg = 1:3
                tho = iterations{z}.displ_max_vector{n,f}(gg)/norm(iterations{z}.displ_max_vector{n,f}(:));
                tho = acos(tho);
                
                nn_output(a,gg) = tho;
            end
                
                a=a+1;
                %end
            end
        end
    end
    a
end


vectemp = NaN;
th = NaN;
nn_input_compare = NaN;
nn_output_compare = NaN;
a=1;
z=1;
dir_name = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',num2str(force_node_compare));

var_filename = strcat(dir_name,'/All_Nodes_Iterations_Fn',num2str(force_node_compare),'.mat');
load(var_filename);
for z = 1:30
for n = node_choice
    for f = 1:fn
        %if iterations{z}.cos_plot(n,f)>0
            nn_input_compare(a,1) = iterations{z}.cos_plot(n,f);
            for g =1:3
            nn_input_compare(a,g+1) = iterations{z}.force_direction(f,g);
            end
            nn_input_compare(a,5) = iterations{z}.dist_plot(n,f);
            
            for h=1:3
            th(h) = iterations{z}.force_direction(fn,h)/norm(iterations{z}.force_direction(fn,:));
            th(h) = acos(th(h));
            nn_input_compare(a,5+h) = th(h);          
            end
            
            for xyz = 1:3
                vectemp(1,xyz) = DATA_coord(force_node_compare,xyz+1,1);
                vectemp(2,xyz) = cmbrain(xyz);
            end
            nn_input_compare(a,9) = pdist(vectemp);
            
            r = vrrotvec(DATA_coord(force_node_compare,2:4,1)-DATA_coord(nodes_list(n),2:4,1),iterations{z}.force_direction(fn,:));
            nn_input_compare(a,10) = r(1);
            nn_input_compare(a,11) = r(2);
            nn_input_compare(a,12) = r(3);
            nn_input_compare(a,13) = r(4);

            
            for gg = 1:3
                tho = iterations{z}.displ_max_vector{n,f}(gg)/norm(iterations{z}.displ_max_vector{n,f}(:));
                tho = acos(tho);
                
                nn_output_compare(a,gg) = tho;
            end
            
            
            a=a+1;
        %end
    end
end
end

end
