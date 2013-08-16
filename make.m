clc

fprintf('\n***************************************\n')

cd svm-struct-matlab-1.2/
if system('make')
  cd ..
  error('compile structued svm failed, check the error messages\n')
end
cd ..

fprintf('\n***************************************\n')

cd inference/libdai/
if system('make')
  cd ../../
  error('compile libdai failed, check the error messages')
end

fprintf('\n***************************************\n');

fprintf('\ncp build/doinference.mexa64 ../doinference.mexa64\n')
system('cp build/doinference.mexa64 ../doinference.mexa64');
cd ../../

fprintf('\n***************************************\n');

fprintf('all done.\n')