function set_global_path

if (~isdeployed)
  addpath graphical_model/
  addpath inference/
  addpath learning
  addpath svm-struct-matlab-1.2/
  addpath tools/
  addpath evaluation/

  addpath CAD120/
  
end

end
