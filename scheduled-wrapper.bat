move /Y STDERR.log STDERR.1.log 
move /Y STDOUT.log STDOUT.1.log
main-run.bat > STDOUT.log 2>STDERR.log