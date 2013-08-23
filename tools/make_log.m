function make_log(logfile)

logfile = [logfile,'.log'];

diary off
diary(logfile)
fprintf('logging to file %s\n',logfile)
diary on

end