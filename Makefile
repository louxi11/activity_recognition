
DEPS:= graphical_model/*.m inference/*.m learning/*.m tools/*.m evaluation/*.m CAD120/*.m

TARGETS:= activity_recognition_demo

all	:
	cd svm-struct-matlab-1.2/; make
	ln -sf ../svm-struct-matlab-1.2/svm_struct_learn.mexa64 learning/svm_struct_learn.mexa64
	cd inference/libdai; make
	ln -sf libdai/build/doinference.mexa64 inference/doinference.mexa64

clean	:
	rm -f ${TARGETS}
	cd svm-struct-matlab-1.2/; make clean
	cd inference/libdai; make clean
	rm -f inference/doinference.mexa64
	rm -f learning/svm_struct_learn.mexa64

mcc	: all ${TARGETS}

activity_recognition_demo : activity_recognition_demo.m ${DEPS}
	mcc -m activity_recognition_demo.m ${DEPS}
