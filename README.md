add latent variables DONE.
RunInference save to files. No disk read/write DONE.
learn latent variables directly from X TODO
learn latent variables from data TODO
speed up training, remove assert? remove debug flag?

* use the negative portion of exponential function
* verbose messages
* loss function - evaluation criteria

*** added -g for debugging mex functiosn, DO CHANGE IT BACK LATER DONE.

What are support vectors? if there is only 1 training example, why multiple support vectors??

= Platform =

Ubuntu 12.04
Matlab 2012a

Change log
 added semi-supervised learning
 fixed bugs for computing cccp error

Install libDAI Dependencies (TODO)
===========================

  sudo apt-get install g++ make doxygen graphviz libboost-dev libboost-graph-dev libboost-program-options-dev libboost-test-dev libgmp-dev cimg-dev

Download CAD120 dataset
=======================

   ./scripts/downloadCAD120.sh