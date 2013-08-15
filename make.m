clc

fprintf('\n***************************************\n')

cd svm-struct-matlab-1.2/
if system('make')
  error('compile structued svm failed, check the error messages\n')
end
cd ..

fprintf('\n***************************************\n')

cd inference/libdai/
if system('make')
  error('compile libdai failed, check the error messages\n')
end

fprintf('\n***************************************\n');

fprintf('\ncp build/doinference ../doinference-linux\n')
system('cp build/doinference ../doinference-linux');
cd ../../

fprintf('\n***************************************\n');

fprintf('all done.\n')