# LearningDeformation

**###WORK IN PROGRESS###**

Code for my master’s thesis "A Data-driven Method for Real-time Modelling of Brain Tumour Deformation"

ABSTRACT:


This thesis proposes a novel data-based approach to model the deformation of a brain tumour for augmented reality (AR)-based applications in neurosurgery. AR systems have the potential to assist surgeons in the most delicate operations, such as tumour removal, by providing intuitive 3-dimensional visualisations of anatomical structures and targets. One of the major challenges to tackle in order to enhance the clinical impact of this technology is computing and displaying the deformation of the virtual overlay accurately and in real time. This is fundamental to maintain depth perception and thus avoid the degradation of surgical performance. Current soft tissue deform- ation models are characterised by a trade-off between speed and accuracy, or are not apt for patient-specific implementations. The method developed in this thesis employs statistical techniques and machine learning algorithms to derive a model computable in real time. The model is trained on a large set of data (7 × 106 data points) ob- tained through force-driven finite element simulations. Data analysis is carried out to identify the relationship between predictors and output, and to perform feature selection. Three different machine learning algorithms — Artificial Neural Networks, Support Vector Regression, and Gaussian Process Regression — are tested and their performance is evaluated, resulting in real-time predictions of the tumour’s deform- ation with mean errors below 0.4 mm, a value that is considerably lower than the threshold of surgical accuracy and AR’s position uncertainty. The results compare well with the existing literature, providing smaller errors, instantaneous computation, and high patient-specificity. The proposed approach addresses the current needs of image-guided surgical systems, and has the potential to be employed to model the deformation of any type of soft tissue.

![Alt text](https://cloud.githubusercontent.com/assets/18726750/26302760/996d18ce-3ee5-11e7-9002-cde00991016e.png)

Dependencies to create custom meshes:
1) BrainSuite (http://brainsuite.org/) or equivalent software to segment and label the brain
2) ITK-SNAP (http://www.itksnap.org/) or 3D Slicer (https://www.slicer.org/) or equivalent to segment the tumour.
3) MATLAB's iso2mesh toolbox (iso2mesh.sourceforge.net/)

A brain mesh file is provided to test the code.
