clc
cd svm-struct-matlab-1.2/
if system('make')
  disp('\nError: compile failed, check the error message\n')
else
  fprintf('\n Compilation is finished...\n')
end
cd ..