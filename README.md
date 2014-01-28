This is a free & open source software for human activity recognition. If using this code please cite:

*Learning Latent Structure for Activity Recognition.*
*Ninghang Hu, Gwenn Englebienne, Zhongyu Lou, Ben Kröse.*
*International Conference on Robotics and Automation (ICRA), 2014*

    @inproceedings{Hu2014,
      author = {Hu, Ninghang and Englebienne, Gwenn and Lou, Zhongyu and Kr\"{o}se, Ben},
      booktitle = {Proc. IEEE International Conference on Robotics and Automation (ICRA)},
      title = {Learning Latent Structure for Activity Recognition},
      year = {2014}
      }


More information can be found at:

https://sites.google.com/site/ninghanghu/activity_recognition


Prerequisites
-------------

* Ubuntu 12.04 LTS (64bit)
* Matlab 2012a


Matlab Setup
------------

To compile the software, we assume Matlab bin folder can be found in the system path. If not, you can open a terminal and run

    echo "export PATH=/MATLAB_ROOT_FOLDER/bin:$PATH" >> ~/.bashrc
    source ~/.bashrc

Remember to replace MATLAB_ROOT_FOLDER by your Matlab installation path. The default path is '/usr/local/MATLAB/R2012a'. Then you test whether the path is correctly added

    mex -help

You should see the help messages of the mex function if the path is correct.


Compile Software
----------------

Install software dependencies (for libDAI)

    sudo apt-get install g++ make graphviz libboost-dev libboost-graph-dev libboost-program-options-dev libboost-test-dev libgmp-dev

Go to the activity_recognition folder and run

    make

This compiles two required packages: [libDAI](http://staff.science.uva.nl/~jmooij1/libDAI/) and [SVM^Struct](http://www.robots.ox.ac.uk/~vedaldi/code/svm-struct-matlab.html), and generates two mex functions from C/C++ code

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

There are 12 data files because the data is generated using different segmentation methods.


Run DEMO on CAD-120
-------------------

Open Matlab and run `test_sample.m`. You can find more descriptions in the source code.


Run on Other Dataset
--------------------


Super Computers Lisa Users
--------------------------

    module load matlab
    module load mcr
    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
    make mcc

    export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6:$LD_PRELOAD
    matlab -nodisplay

TODO
----

- [ ] reduce for loops
- [ ] check debug options
- [ ] speed up training, remove assert? remove debug flag?
- [ ] added -g for debugging mex functiosn, DO CHANGE IT BACK LATER
- [x] add latent variables DONE.
- [x] RunInference save to files. No disk read/write
- [x] learn latent variables directly from X
- [ ] verbose messages
- [ ] loss function - evaluation criteria

Change log
----------
* added semi-supervised learning
* fixed bugs for computing cccp error

