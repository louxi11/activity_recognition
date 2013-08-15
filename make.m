clc
cd svm-struct-matlab-1.2/
if system('make')
  error('compile structued svm failed, check the error messages\n')
end
cd ..

cd inference/libdai/
if system('make')
  error('compile libdai failed, check the error messages\n')
end

disp('cp build/doinference ../doinference-linux')
system('cp build/doinference ../doinference-linux');
cd ../../

disp('all done.')