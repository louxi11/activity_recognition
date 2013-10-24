
DEPS:= graphical_model/*.m inference/*.m learning/*.m svm-struct-matlab-1.2/*.m tools/*.m evaluation/*.m test_data/*.m test_data/CAD120/*.m

TARGETS:= semi_supervised_template

all	:
	cd svm-struct-matlab-1.2/; make
	cd inference/libdai; make
	ln -sf libdai/build/doinference.mexa64 inference/doinference.mexa64

clean	:
	rm -f ${TARGETS}
	cd svm-struct-matlab-1.2/; make clean
	cd inference/libdai; make clean
	rm -f inference/doinference.mexa64

mcc	: all ${TARGETS}

semi_supervised_template : semi_supervised_template.m ${DEPS}
	mcc -m semi_supervised_template.m ${DEPS}
