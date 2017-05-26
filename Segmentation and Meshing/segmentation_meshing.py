import matlab.engine, subprocess, sys

## Open a GUI to select an MRI file
from Tkinter import Tk, Button
from tkFileDialog import askopenfilename
import tkMessageBox


## File selection for labelling

top = Tk()
top.withdraw() # Keep the root window from appearing
top.update()

def mri_select():
    top.wm_attributes('-topmost', True)
    filename = askopenfilename(initialdir="/Applications/BrainSuite15c/bin/MRIs",title='Please select an MRI file for brain labelling') # show an "Open" dialog box and return the path to the selected file
    return filename

okcanc_mri = tkMessageBox.askokcancel(title="MRI", message="Please select an MRI file for labelling")

if okcanc_mri == 1:
    filename = mri_select()
else:
    tkMessageBox.showerror("No file selected. The program will stop.")
    sys.exit()

## Options selection

top = Tk()
top.withdraw() # Keep the root window from appearing
top.update()

def tum_select():
    top.wm_attributes('-topmost', True)
    tumourname = askopenfilename(initialdir="/Applications/BrainSuite15c/bin/MRIs",title='Please select an MRI file for tumour labelling') # show an "Open" dialog box and return the path to the selected file
    return tumourname

yesno_tum = tkMessageBox.askyesno(title="Tumour", message="Is there a tumour you would like to segment?")

if yesno_tum == 1:
    okcanc_tum = tkMessageBox.askokcancel(title="Tumour", message="Please select an MRI file for tumour segmentation")
    tumour = True
    if okcanc_tum == 1:
        tumourname = tum_select()
    else:
        tkMessageBox.showerror("No file selected. The program will stop.")
        sys.exit()
else:
    tumour = False

#top.mainloop()

yesno_vent = tkMessageBox.askyesno(title="Ventricles", message="Do you want to include ventricles in the final mesh?")
if yesno_vent == 1:
    ventricles = True
else:
    ventricles = False

if tumour:
    #Opens ITK Snap
    try:
    	subprocess.call(['/Applications/ITK-SNAP.app/Contents/MacOS/ITK-SNAP', tumourname])
    except subprocess.CalledProcessError as e:
    	tkMessageBox.showerror("ITK-Snap needs to be installed for this example. The program will quit.")
    	sys.exit()

## Run BrainSuite segmentation/labelling and places the output in the same folder
try:
	subprocess.call(['/Applications/BrainSuite15c/bin/cortical_extraction.sh', filename, '-o', 'SkullStripped.nii.gz'])
except OSError:
    tkMessageBox.showerror("BrainSuite needs to be installed for this example. The program will quit.")
    sys.exit()

def files_matlab_select():
    top.wm_attributes('-topmost', True)
    labelledname = askopenfilename(initialdir="/Applications/BrainSuite15c/bin/MRIs") # show an "Open" dialog box and return the path to the selected file
    return labelledname

def tumour_matlab_select():
    tumoursegmname = askopenfilename(initialdir="/Applications/BrainSuite15c/bin/MRIs") # show an "Open" dialog box and return the path to the selected file
    return tumoursegmname

okcanc_matlab = tkMessageBox.askokcancel(title="MATLAB", message="Please select a Nifti (.nii) file of the labelled brain")

if okcanc_matlab == 1:
    matlab_brain_input = files_matlab_select()
    if tumour:
        okcanc_tum_matlab = tkMessageBox.askokcancel(title="Tumour", message="Please select a Nifti (.nii) file of the segmented tumour")
        if okcanc_tum_matlab == 1:
            tumour_brain_input = tum_select()
        else:
            tkMessageBox.showerror("No file selected. The program will stop.")
            sys.exit()
else:
    tkMessageBox.showerror("No file selected. The program will stop.")
    sys.exit()


## Call the MATLAB function to create an STL mesh
#MeshGen(brain_input,tumour_input,ventricles,folder)

try:
	eng = matlab.engine.start_matlab()
	eng.MeshGen(matlab_brain_input,tumour_brain_input,ventricles,'/Users/MicTonutti/Dropbox/MRes/Individual Project/Python', nargout=0)
except OSError:
    tkMessageBox.showerror("MATLAB needs to be installed for this example. The program will quit.")
    sys.exit()

tkMessageBox.showinfo(title="Process completed.", message = "The mesh was successfully generated.")
