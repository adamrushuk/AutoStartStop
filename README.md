# Automatically Start & Stop VMs
These scripts are examples of how you can make use of VMWare PowerCLI to set up a timed schedule for automatically starting and stopping vApps or VMs in vCloud Director.

These examples are fully documented in [Blueprint uck-gen-339](https://portal.skyscapecloud.com/support/knowledge_centre/7212f4f1-32b8-4cdd-998f-2cdc95f31bcd) in the UKCloud Knowledge Centre available through the Portal.

These example scripts have been written to leverage the use of metadata properties that can be set against either a vApp, or each individual VM. There are two sets of scripts provided to demonstrate this functionality.

### Report Current Metadata settings
The CheckVAPPMetadata.ps1 and CheckVMMetadata.ps1 scripts will generate a report of your vApps / VMs respectively, writing out a CSV file containing the currently set Metadata properties. You can use these two scripts to show which VMs are configured to be automatically started and stopped.

### Starting and Stopping VMs
The AutoPowerVAPP.ps1 and AutoPowerVM.ps1 scripts will use the metadata properties reported on in the above Check scripts to automatically start and stop vApps / VMs respectively. To gain the most benefit from these scripts, you will want to run them regularly throughout the day, probably by setting up a windows scheduled task to run them hourly or more regularly.

License
-------
Copyright 2017 UKCloud Ltd

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
