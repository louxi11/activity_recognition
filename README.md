This is a free & open source software for human activity recognition using RGB-D sensors. For any questions/suggestions, please contact the author.

Overview
--------

The software has integrated the work of three publications:

The first paper introduced the graphical model for recognizing a sequence of activities.

    @inproceedings{Hu2014activity,
      author = {Hu, Ninghang and Englebienne, Gwenn and Lou, Zhongyu and Kr\"{o}se, Ben},
      booktitle = {Proc. IEEE International Conference on Robotics and Automation (ICRA)},
      title = {Learning Latent Structure for Activity Recognition},
      year = {2014}
      }

The second paper proposed the idea of *soft labeling*, where the uncertainty of labeling is considered during training.

    @inproceedings{Hu2014softlabeling,
      author = {Hu, Ninghang and Englebienne, Gwenn and Lou, Zhongyu and Kr\"{o}se, Ben},
      booktitle = {Robotics: Science and Systems (RSS)},
      title = {{Learning to Recognize Human Activities from Soft Labeled Data}},
      year = {2014}
      }

The third paper extends the first work for recognizing high-level activities.

    @inproceedings{Hu2014highlevel,
      author = {Hu, Ninghang and Englebienne, Gwenn and Kr\"{o}se, Ben},
      booktitle = {Proceedings of the IEEE International Symposium on Robot and Human Interactive Communication (ROMAN)},
      title = {{A Two-layered Approach to Recognize High-level Human Activities}},
      year = {2014}
      }

The source code is developped and tested based on Ubuntu 12.04 LTS (64bit) platform with Matlab 2012a. Other platforms and Matlab versions may work upon minor changes.


Matlab Setup
------------

To compile the software, we assume Matlab bin folder can be found in the system path. If not, you can open a terminal and run

    echo "export PATH=/MATLAB_ROOT_FOLDER/bin:$PATH" >> ~/.bashrc
    source ~/.bashrc

Remember to replace MATLAB_ROOT_FOLDER by your Matlab installation path. The default path is `/usr/local/MATLAB/R2012a`. Then you test whether the path is correctly added

    mex -help

You should see the help messages of the mex function if the path is correct.


Compile Software
----------------

Install software dependencies (for libDAI)

    sudo apt-get install g++ make graphviz libboost-dev libboost-graph-dev libboost-program-options-dev libboost-test-dev libgmp-dev

Go to the activity_recognition folder and run

    make

This compiles two required packages: [libDAI](http://staff.science.uva.nl/~jmooij1/libDAI/) and [SVM^Struct](http://www.robots.ox.ac.uk/~vedaldi/code/svm-struct-matlab.html), and generates two mex functions from C/C++ code:

* libDAI generates `inference/libdai/doinference.mexa64`. The file is used as the inference engine, which predicts the states of nodes based on a given factor graph.
* SVM^Struct generates `svm-struct-matlab-1.2/svm_struct_learn.mexa64`. The file is used to learn parameters of the graphical model using Structured SVM.


Download CAD120 dataset
-----------------------

Go to the root folder, use the script to download CAD-120 data. This will gnerate two folders: `CAD120/segmentation_lists` and `segmentation_features`. For more details about the data format, see [CAD120 dataset](http://pr.cs.cornell.edu/humanactivities/data.php).

    ./scripts/downloadCAD120.sh

Open Matlab and run

    set_global_path
    parseAllCAD120

This Matlab script will parse the data and then convert the data into the format that is required by SVM^Struct. The data is stored into the file `CAD120.mat`.

To see a list of the generated data, run

    ls CAD120/segmentation_lists/*/CAD120.mat

There are 12 data files in total because the data is generated using different segmentation methods.


Run DEMO on CAD-120
-------------------

Matlab script for a quick testing demo:

    example_test

Demo of learning the model:

    example_training

More description about the arguments can be found in the script `example_training.m`.


Using Other Dataset
-------------------

The script `CAD120/load_CAD120.m` is a interface function that loads data from the CAD-120 dataset and converts the data format in order to be used in the learning framework. The function is called inside the main loop of `activity_recognition_demo.m`. You can replace the infereface `load_CAD120.m` by any customized function that can load your own data. See more detailed description on formatting data in `CAD120/load_CAD120.m`.

The other thing you need to do is to change the value of `numStateY` in the script `learning_CAD120.m`. `numStateY` specifies the total number of activities in your dataset. The default dataset assumes there are 10 activities to be recognized.


Super Computers Users (LISA)
----------------------------

Export Matlab binaries into system path

    module load matlab
    module load mcr

Solve the glic not found problem

    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

Compile Matlab scripts to binary executables to avoid using multiple licenses for running experiments

    make mcc

Run Matlab

    export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6:$LD_PRELOAD
    matlab -nodisplay


TODO
----
- [ ] test
- [ ] add L1-norm
- [ ] add option to save model for every 100 iteration
- [x] check debug options
- [ ] speed up training, remove assert? remove debug flag?
- [x] added -g for debugging mex functiosn, DO CHANGE IT BACK LATER
- [x] add latent variables DONE.
- [x] RunInference save to files. No disk read/write
- [x] learn latent variables directly from X
- [ ] verbose messages
