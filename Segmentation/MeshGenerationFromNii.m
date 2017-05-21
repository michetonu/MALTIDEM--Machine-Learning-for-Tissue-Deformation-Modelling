%% Create a brain mesh from a nii file

% Path to segmented brain and tumour files
brain_file = "path_to_brain.nii";
tumour_file = "path_to_tumour.nii";

main_brain = load_nii(brain_file);
tumour = load_nii(tumour_file);

% Optional simplification: ignore fluid-filled cavities
main_brain.img(main_brain.img ~= 0) = 1;

% Meshing parameters
clear opt;
opt.keepratio=0.01; 
opt.radbound=10; 
opt.distbound = 10;
opt.side='lower'; 

% Create volumetric mesh of the brain
[no,el,regions,holes]=vol2surf(main_brain.img,1:size(main_brain.img,1),1:size(main_brain.img,2),1:size(main_brain.img,3),opt,1);
[no,el] = meshresample(no,el,0.5);

% Create spherical/ellipsioid tumour with the same centre of mass as the segmented tumour 
com = centerOfMass(tumour.img);

% Dimensions of the ellipsoid. If a=b=c, it will create a sphere
a=12;
b=12;
c=12;

for x = 1:size(tumour.img,1)
    for y = 1:size(tumour.img,2)
        for z = 1:size(tumour.img,3)
            if ((x-com(1))^2/a^2 + (y-com(2))^2/b^2 + (z-com(2))^2/c^2) <= 1
                tumour.img(x,y,z) = 1;
            else
                tumour.img(x,y,z) = 0;
            end
        end
    end
end

% Parameters for tumour meshing
clear opt;
opt.keepratio=0.01; 
opt.radbound=1; 
opt.distbound = 1;
opt.side='lower'; 

% Create a volumetric mesh of the tumour
[no2,el2,regions2,holes2]=vol2surf(tumour.img,1:size(tumour.img,1),1:size(tumour.img,2),1:size(tumour.img,3),opt,1);
[no2,el2] = meshresample(no2,el2,0.5);

% Combine meshes of tumour and brain
no3 = [no; no2];
m = max(el);
el3 = [el; el2+max(m)];

% Compute final mesh
[node,elem,face] = surf2mesh(no3,el3,[0 0 0],[size(main_brain.img,1) size(main_brain.img,2) size(main_brain.img,3)],1,100,[100 100 100],[],0);
new_elem = elem(elem(:,5)==0 | elem(:,5)==1,:);
plotmesh(node,face,elem,'x>60'); 

% Save mesh
writeMESH('BrainIsoMESH2.mesh',node,new_elem,face);
