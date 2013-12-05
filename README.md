activity_recognition
====================

Platform
--------

* Ubuntu 12.04
* Matlab 2012a TODO
* add MATLAB bin to $PATH

Compile Software
----------------

    make

Install libDAI Dependencies (TODO)
----------------------------------

    sudo apt-get install g++ make doxygen graphviz libboost-dev libboost-graph-dev libboost-program-options-dev libboost-test-dev libgmp-dev

Download CAD120 dataset
-----------------------

Go to the root folder

    ./scripts/downloadCAD120.sh

open Matlab

    parseAllCAD

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

