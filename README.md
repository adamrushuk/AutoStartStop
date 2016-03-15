# AutoStartStop
How to automatically start and stop VMs and vAPPs according to a timed schedule

Check VM Metadata checks each VM inside an Org

Check VAPP Metadata checks all VAPP inside an Org

Both Scripts write out and export a CSV file to c:\temp\filename.csv

#AutoPower script
Two scripts (AutoPower and Every5Mins) are used to ensure AutoPower executes every five minutes.  This should be started from a control machine that will not be included in any auto power commands.  Place in c:\temp or change the filepaths to suit.