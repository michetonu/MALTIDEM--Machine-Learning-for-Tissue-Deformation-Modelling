%% Create a brain mesh from a DFS file, as exctracted from e.g. BrainSuite

% Path to segmented brain and tumour files
brain_file = "path_to_brain.dfs";
tumour_file = "path_to_tumout.nii";

main_brain_dfs = readdfs(brain_file);
tumour = load_nii(tumour_file);

% Number of vertices and faces
no = main_brain_dfs.vertices;
el = main_brain_dfs.faces;

% Optional simplification: ignore fluid-filled cavities
main_brain.img(main_brain.img ~= 0) = 1;

% Meshing parameters
clear opt;
opt.keepratio=0.01; 
opt.radbound=10; 
opt.distbound = 10;
opt.side='lower'; 

%Surface + volume:

[no,el] = meshresample(no,el,0.5);

[no2,el2,regions2,holes2]=vol2surf(tumour.img,1:size(tumour.img,1),1:size(tumour.img,2),1:size(tumour.img,3),opt,1);
[no2,el2] = meshresample(no2,el2,0.5);

no3 = [no; no2];
m = max(el);
el3 = [el; el2+max(m)];

[node,elem,face] = surf2mesh(no3,el3,[0 0 0],[size(main_brain.img,1) size(main_brain.img,2) size(main_brain.img,3)],1,700,[100 100 100],[],0);
new_elem = elem(elem(:,5)==0 | elem(:,5)==1,:);

% Visualise mesh
plotmesh(node,face,elem,'x>60'); 

% Save mesh to file
writeMESH('BrainIsoMESH2.mesh',node,new_elem,face);