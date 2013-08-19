function make(varargin)

if nargin > 0 && strcmp(varargin{1},'clean')
  
  clc
  
  fprintf('\n***************************************\n')
  
  cd svm-struct-matlab-1.2/
  
  system('make clean');
  
  cd ..
  
  fprintf('\n***************************************\n')
  
  cd inference/libdai/
  
  system('make clean');
  
  
  fprintf('\n***************************************\n');
  
  system('rm -fv ../doinference.mexa64');
  
  cd ../../
  
  fprintf('\n***************************************\n');
  
  fprintf('make clean: all done.\n')

elseif nargin == 0
  
  clc
  
  fprintf('\n***************************************\n');
  
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
  
  system('cp -v build/doinference.mexa64 ../doinference.mexa64');
  cd ../../
  
  fprintf('\n***************************************\n');
  
  fprintf('all done.\n')
  
else
  
  fprintf('\nunknow make option "%s", use "make clean" or "make"\n',varargin{1})
  
end