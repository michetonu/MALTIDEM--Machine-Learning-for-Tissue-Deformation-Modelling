### ONE NODE MANY FORCES ONLY CHANGE Y OR X

from __future__ import division
import os, itertools, subprocess, fileinput, shutil
from math import log10, floor, sqrt

# Folder containing simulation files
root_dir = 

# Define force magnitude
a=1/sqrt(2)
b=1/sqrt(3)
c=1
d=1/sqrt(4)

e=sqrt(2/5)
f=sqrt(1/5)

forcez = [[0,0,-c],[b,b,-b],[a,0,-a],[0,a,-a],[-a,0,-a],[0,-a,-a],[b,-b,-b],[-b,b,-b],[-b,-b,-b],[a,d,-d],[-a,d,-d],[-a,-d,-d],[d,a,-d],[-d,a,-d],[-d,-a,-d],[d,-a,-d],[d,d,-a],[-d,-d,-a],[a,-d,-d],[-d,d,-a],[e,e,-f],[e,-e,-f],[e,f,-e],[e,-f,-e],[-e,-f,-e],[-e,-e,-f],[f,e,-e],[f,-e,-e],[-f,-e,-e],[-f,e,-e]]
forcez = [[-f,e,-e]]

# Define nodes of the mesh at which to apply the forces (as specified by FEBio)
force_nodes = [82,91,101,107,129,140,148,163,174,185]

def run_simulation( force_nodes, forcez ):

	for force_node in force_nodes:
		for force in forcez:

			x = str(round(force[0],1))
			y = str(round(force[1],1))
			z = str(round(force[2],1))
			par_dir = '/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node' + str(force_node) + '_' + x + '_' + y + '_' + z
			if not os.path.exists(par_dir):
				os.makedirs(par_dir)
			out_dir = par_dir + '/Python Output'
			if not os.path.exists(out_dir):
				os.makedirs(out_dir)
				
			os.chdir(par_dir)

			shutil.copy('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node185/Node185_-0.5_-0.5_-0.7/Simulation 1.txt', par_dir)
			shutil.copy('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node185/Node185_-0.5_-0.5_-0.7/Simulation 2.txt', par_dir)
			shutil.copy('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node185/Node185_-0.5_-0.5_-0.7/Simulation 3.txt', par_dir)

			forf = [x/10 for x in force]
			forces = [tuple(forf)]
			for i in range(3,22):
				newforce = [x*i/2 for x in forf]
			 	newforce = tuple(newforce)
			 	forces.append(newforce)


			line = str(force_node)
			ff = open('Force Data.txt','w')
			ff.write('\n'.join('%s %s %s' % x for x in forces))
			ff.flush()

			for i in range(0,len(forces)):
				filename = '0_Insert' + str(i) + '.txt'
				f = open(filename, 'w')
				string_x = '<nodal_load bc="x" lc="1"> <node id="' + str(force_node) + '">' + str(forces[i][0]) + '</node> </nodal_load>\n'
				string_y = '<nodal_load bc="y" lc="1"> <node id="' + str(force_node) + '">' + str(forces[i][1]) + '</node> </nodal_load>\n'
				string_z = '<nodal_load bc="z" lc="1"> <node id="' + str(force_node) + '">' + str(forces[i][2]) + '</node> </nodal_load>\n'
				f.write(string_x + string_y + string_z)
				f.flush()

				filename_2 = '1_Insert' + str(i) + '.txt'
				g = open(filename_2, 'w')
				string_1 = '<logfile>\n <node_data data="x;y;z" file = "coord_data' + str(i) + '.txt" delim=", "> </node_data>\n'
				string_2 = '<node_data data="ux;uy;uz" file = "displacement_data' + str(i) + '.txt" delim=", "> </node_data>\n </logfile>\n'
				g.write(string_1 + string_2)
				g.flush()

				files_list = ['Simulation 1.txt', filename, 'Simulation 2.txt', filename_2, 'Simulation 3.txt']
				output_file = par_dir + '/Python Output/FEBio Simulation Output' + str(i) + '.feb'


				with open(output_file, 'w') as outfile:
					for infile in files_list:
						shutil.copyfileobj(open(infile), outfile)

			for i in range(0,len(forces)):
				febio_filename = par_dir + '/Python Output/FEBio Simulation Output' + str(i) + '.feb'
				run_string = '"/Applications/FEBio2.4.3/bin/FEBio2" ' + '"' + febio_filename + '"'
				print run_string
				subprocess.call([run_string], shell=True)

run_simulation( force_nodes, forcez)
