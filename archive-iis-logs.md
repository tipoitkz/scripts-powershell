## About archive-iis-logs.ps1

Makes archives from iis log's files.

What do you have to know about script:
 1. Get current month and year
 2. Test that you have installed 7zip (line 46)
 3. Create directory for storing archives if not exists (line 51)
 4. Get all subdirs in iis log's path (line 55)
 5. Get all files by pattern in subdir. Only by current month (line 61)
 6. Run function Archive-File (line 69)
 7. Archive file if it's not using by another procces (line 36)
 8. Write message to log file if files is using by another procces (line 41)
 
If you don't want to store all logs about script working you can edit lines 36 and 41. 

# Please be careful script deletes source files (iis log file). If you don't want to do it delete option -sdel from line 36.
