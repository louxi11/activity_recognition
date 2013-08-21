function make_log(timeStr)

logfile = [timeStr,'.log'];

diary off
diary(logfile)
fprintf('logging to file %s\n',logfile)
diary on

end