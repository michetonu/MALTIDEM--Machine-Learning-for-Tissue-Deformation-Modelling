iterations = load('iterations.mat');
coordinates = load('DATA_coord.mat');
nodes_list = load('nodes_list.mat');
force_nodes = load('force_nodes.mat');

%Force node to test network
force_node_compare = 91;
%Set aside data for testing
force_nodes = force_nodes(force_nodes(:,1)~=force_node_compare,1);
%Number of force steps (from 0 to 1N)
fn = 20;

[nn_input, nn_output, nn_input_compare, nn_output_compare] = load_data(iterations,coordinates,nodes_list,force_nodes,force_node_compare,node_choice);

[aaaa,y,e,e2,performance] = neural_net_magnitude(nn_input,nn_output,nn_input_compare,nn_output_compare,3);
e
estd = std(aaaa)
err = [err e]
performance
