from __future__ import division
import os, itertools, subprocess, fileinput, shutil
from math import log10, floor, sqrt
from numpy import random
from sklearn.preprocessing import normalize

# Folder containing simulation files
root_dir = 'user_defined_folder'
# Folder containing FEBio installation folder
febio_root = 'febio_root'

# Create random normalized force vectors
nforces = 30

forcez = []
for f in range(nforces):
	for xyz in range(3):
		temp = random.rand(3)
	temp = normalize(temp, norm = "l2")
	forcez.append(temp)


# Define nodes of the mesh at which to apply the forces (as specified by FEBio)
force_nodes = [82,91,101,107,129,140,148,163,174,185]

def run_simulation( force_nodes, forcez ):

	for force_node in force_nodes:
		for force in forcez:

			x = str(round(force[0],1))
			y = str(round(force[1],1))
			z = str(round(force[2],1))
			par_dir = os.join.path(root_dir,'Nodewise Simulations','Node' + str(force_node) + '_' + x + '_' + y + '_' + z)
			if not os.path.exists(par_dir):
				os.makedirs(par_dir)
			out_dir = os.join.path(par_dir, 'SimulationOutput')
			if not os.path.exists(out_dir):
				os.makedirs(out_dir)
				
			os.chdir(par_dir)

			forf = [x/10 for x in force]
			forces = [tuple(forf)]
			for i in range(3,22):
				newforce = [x*i/2 for x in forf]
			 	newforce = tuple(newforce)
			 	forces.append(newforce)


			line = str(force_node)
			with open('Force Data.txt','w') as ff:
				ff.write('\n'.join('%s %s %s' % x for x in forces))
			

			for i in range(0,len(forces)):
				filename = '0_Insert' + str(i) + '.txt'
				with open(filename, 'w') as f:
					string_x = '<nodal_load bc="x" lc="1"> <node id="' + str(force_node) + '">' + str(forces[i][0]) + '</node> </nodal_load>\n'
					string_y = '<nodal_load bc="y" lc="1"> <node id="' + str(force_node) + '">' + str(forces[i][1]) + '</node> </nodal_load>\n'
					string_z = '<nodal_load bc="z" lc="1"> <node id="' + str(force_node) + '">' + str(forces[i][2]) + '</node> </nodal_load>\n'
					f.write(string_x + string_y + string_z)
				

				filename_2 = '1_Insert' + str(i) + '.txt'
				with open(filename_2, 'w') as g:
					string_1 = '<logfile>\n <node_data data="x;y;z" file = "coord_data' + str(i) + '.txt" delim=", "> </node_data>\n'
					string_2 = '<node_data data="ux;uy;uz" file = "displacement_data' + str(i) + '.txt" delim=", "> </node_data>\n </logfile>\n'
					g.write(string_1 + string_2)
				

				files_list = ['Simulation 1.txt', filename, 'Simulation 2.txt', filename_2, 'Simulation 3.txt']
				output_file = os.path.join(par_dir,'Python Output','FEBio Simulation Output' + str(i) + '.feb')


				with open(output_file, 'w') as outfile:
					for infile in files_list:
						shutil.copyfileobj(open(infile), outfile)

			for i in range(0,len(forces)):
				febio_filename = os.path.join(par_dir, 'Python Output','FEBio Simulation Output' + str(i) + '.feb')
				run_string = febio_root + '"' + febio_filename + '"'
				print run_string
				subprocess.call([run_string], shell=True)

run_simulation(force_nodes, forcez)
