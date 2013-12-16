function start_matlabpool(numCores)

if numCores > 1
  matlabpool('open',numCores)
  fprintf('Using %d cores\n',matlabpool('size'));
end

end