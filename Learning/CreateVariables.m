function CreateVariables(force_node)

%force_node = 107; %F-node = node where force is applied
dir_name_orig = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',' ', num2str(force_node),'/');
dir_name = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',' ', num2str(force_node),'/');
folders = dir(dir_name);
folders = folders([folders.isdir]);

nodes_tum = GetNodesInfo('/Users/MicTonutti/Dropbox/MRes/Individual Project/Segmentation + Mesh/BrainSphericalTumour.txt');

%Only use tumour nodes
nodes_list = nodes_tum;

nodes_number = size(nodes_list,1); %Number of tumour nodes

data_model = cell(nodes_number,1);


load('/Users/MicTonutti/Dropbox/MRes/Individual Project/Modelling_New/Mesh_Variables.mat');

cmbrain = centerOfMass(main_brain.img);
%cmtumour = centerOfMass(tumour.img);

for a = 3:size(folders,1)
    %numbers = 148;
    %[82;91;101;107;129;140;148;163;174;185]
    fold_name = strcat(dir_name,folders(a).name);
    
    %Obtain force vectors from txt file
    force_direction = dlmread(strcat(fold_name, '/Force Data.txt'));
    fn = size(force_direction,1); %Number of forces used
    
    %Create empty arrays
    DATA_displ = cell(fn,1);
    DATA_coord = cell(1,1);
    force_vector = NaN(fn,3);
    distance = NaN(nodes_number,1);
    X = distance;
    X2 = X;
    anglez = distance;
    angle2 = anglez;
    angle_cm = anglez;
    distance_plot = NaN(nodes_number,fn,4);
    displacement_x_max = NaN(nodes_number,fn,1);
    displacement_y_max = NaN(nodes_number,fn,1);
    displacement_z_max = NaN(nodes_number,fn,1);
    displacement_max_vector = cell(nodes_number,fn);
    displacement_tot_max = NaN(nodes_number,fn,1);
    force_max_mag = NaN(fn,1);
    displacement_tot_direction = NaN(nodes_number,fn,1);

    
    %% Read data from log files
      
    % Nodal Coordinates
    coord_file_displ = strcat(fold_name,'/Python Output/coord_data0.txt');
    [TIME2, coord_temp, temp_label_coord]=importFEBio_logfile(coord_file_displ);
    DATA_coord = coord_temp;
    
    %Loop over all forces
    for i = 1:fn
        
        % Nodal Displacement
        log_file_displ = strcat(fold_name, '/Python Output/displacement_data', num2str(i-1), '.txt');
        [TIME, displ_temp, temp_label_displ]=importFEBio_logfile(log_file_displ);
        DATA_displ{i} = displ_temp;

        %Create vector of direction of the force
        % Coordinated of the node where force is applied + direction of the
        % force
        force_vector(i,1) = force_direction(i,1);
        force_vector(i,2) = force_direction(i,2);
        force_vector(i,3) = force_direction(i,3);
        %Magnitude of the force, take the norm of the above
        force_max_mag(i,1) = norm(force_direction(i,1:3));
        
    end
    
    %% Data Processing
    
    %Loop over all nodes on tumour
    for node = 1:nodes_number
        % Calculate distance between each node and F-node:
        % Coordinates of node - coordinates of F-node
        X(node,1) = DATA_coord(nodes_list(node,1),2,1)-DATA_coord(force_node,2,1);
        X(node,2) = DATA_coord(nodes_list(node,1),3,1)-DATA_coord(force_node,3,1);
        X(node,3) = DATA_coord(nodes_list(node,1),4,1)-DATA_coord(force_node,4,1);
        
        X2(node,1) = DATA_coord(nodes_list(node,1),2,1)-cmbrain(1);
        X2(node,2) = DATA_coord(nodes_list(node,1),3,1)-cmbrain(2);
        X2(node,3) = DATA_coord(nodes_list(node,1),4,1)-cmbrain(3);
        %distance(node,1) = norm(X(node));
        
        %Loop over all forces
        for i = 1:fn
            angle_cm(node,i) = atan2(norm(cross(force_vector(i,:),X2(node,:))),dot(force_vector(i,:),X2(node,:)));
        end
        %distance(node,1) = norm(X(node));
        vectemp = NaN(2,3);
        for xyz = 1:3
            vectemp(1,xyz) = DATA_coord(nodes_list(node,1),xyz+1,1);
            vectemp(2,xyz) = DATA_coord(force_node,xyz+1,1);
        end
        distance(node,1) = pdist(vectemp);
        %Loop over all forces
        for i = 1:fn
            %Calculate angle in 3D. Only outputs angles < 180º (I think)
            anglez(node,i) = atan2(norm(cross(force_vector(i,:),X(node,:))),dot(force_vector(i,:),X(node,:)));
            %Make sure all cosines are positive (maybe this is a problem?)
            %if angle(node,i) > pi/2
            %    angle(node,i) = pi - angle(node,i);
            %end
            
            %Create an array with everything we need to plot
            distance_plot(node,i,1) = nodes_list(node,1);
            distance_plot(node,i,2) = distance(node,1);
            distance_plot(node,i,3) = cos(anglez(node,i));
            distance_plot(node,i,4) = force_max_mag(i);
            
            % Calculate displacements
            
            displacement_z_max(node,i) = DATA_displ{i}(nodes_list(node,1),4,10);
            displacement_y_max(node,i) = DATA_displ{i}(nodes_list(node,1),3,10);
            displacement_x_max(node,i) = DATA_displ{i}(nodes_list(node,1),2,10);
            
            displacement_max_vector{node,i} = [displacement_x_max(node,i),displacement_y_max(node,i),displacement_z_max(node,i)];
            angle2(node,i) = atan2(norm(cross(force_vector(i,:),displacement_max_vector{node,i})),dot(force_vector(i,:),displacement_max_vector{node,i}));

            displacement_tot_max(node,i,1) = norm(displacement_max_vector{node,i});
            displacement_tot_direction(node,i,1) = displacement_tot_max(node,i,1)*cos(angle2(node,i));

        end
        
        %Create matrix for data to be plotted
        data_model{node} = cat(3,distance_plot(node,:,:),displacement_tot_max(node,:),displacement_tot_direction(node,:));
        
    end
    %clearvars -except dirname DATA_coord DATA_displ data_plot force_direction force_node main_brain tumour nodes_list data_model a pardirname numname
    save(strcat(dir_name_orig, '/Variables', num2str(a-2), '.mat'),'DATA_coord', 'DATA_displ', 'force_direction', 'nodes_list', 'data_model','angle_cm','anglez','displacement_max_vector');
end
end