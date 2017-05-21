# LearningDeformation
WORK IN PROGRESS!

Code for my master’s thesis and the paper "A Machine Learning Approach for Real-Time Modelling of Tissue Deformation in Image-Guided Neurosurgery"

ABSTRACT:

Objectives: Accurate reconstruction and visualisation of soft tissue deformation in real time is crucial in image-guided surgery, particularly in augmented reality (AR) applications. Current deformation models are characterised by a trade-off between accuracy and computational speed. We propose an approach to derive a patient-specific deformation model for brain pathologies by combining the results of pre-computed Finite Element Method (FEM) simulations with machine learning algorithms. The models can be computed instantaneously and offer an accuracy comparable to FEM models.
Method: A brain tumour is used as the subject of the deformation model. Load-driven FEM simulations are performed on a tetrahedral brain mesh afflicted by a tumour. Forces of varying magnitudes, positions, and inclination angles are applied onto the brain’s surface. Two machine learning algorithms — Artificial Neural Networks (ANNs) and Support Vector Regression (SVR) — are employed to derive a model that can predict the resulting deformation for each node in the tumour’s mesh.
Results: The tumour deformation can be predicted in real time given relevant information about the geometry of the anatomy and the load, all of which can be measured instantly during a surgical operation. The models can predict the position of the nodes with errors below 0.3 mm, beyond the general threshold of surgical accuracy and suitable for high fidelity AR systems. The SVR models perform better than the ANN’s, with positional errors for SVR models reaching under 0.2 mm.
Conclusions: The results represent an improvement over existing deformation models for real time applications, providing smaller errors and high patient-specificity. The proposed approach addresses the current needs of image-guided surgical systems and has the potential to be employed to model the deformation of any type of soft tissue.

Pre-requisites:
1) BrainSuite (http://brainsuite.org/) or equivalent software to segment and label the brain
2) ITK-SNAP (http://www.itksnap.org/) or 3D Slicer (https://www.slicer.org/) or equivalent to segment the tumour.
3) MATLAB's iso2mesh toolbox (iso2mesh.sourceforge.net/)
