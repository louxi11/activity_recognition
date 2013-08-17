function log_on

logfile = datestr(now);
diary(logfile)
fprintf('log file -> %s',logfile)
diary on

end