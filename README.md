# sudoRUN
sudoRUN allows users to run programs or scripts with the security privileges of the root user without having to enter sudo and the password itself.

#### You should never use sensitive tools or scripts outside the protected root area, where changes to scripts or the replacement or renaming of a tool can lead to security vulnerabilities.

#### The creation of the start script always takes place under the specified path and tool or script name with the appended ending "-sudo", e.g."/usr/bin/tool" is entered, then the start script name is "/usr/bin/tool-sudo". Since this is a script which contains a start condition which intrinsically contains the rights, it can be renamed without losing the rights or start conditions.

### INSTALL a sudo RUN
    sudo sh sudoRUN.sh USER-NAME /usr/bin/TOOL-NAME 

### UNINSTALL a sudo RUN
#### For the sudo release, the required data is entered at the end of /etc/sudoers. So if you delete the start script you should also remove the corresponding entry in /etc/sudoers. When deleting the start script, it is important to note if the start script has been renamed e.g. from tool-sudo to toolxyz, so that you can rode which value the share has here (if you have created more than one) and you don't lose the overview, you should read the start script before deleting it with e.g. "# cat toolxyz" to display the path and name.

### LOOK OUT 
#### I do not accept any liability for any damage caused by the use or incorrect use of sudoRUN, or as a result thereof.


## 1.) Example (UPDATE system)
### I use e.g. sudoRUN for the UPDATE function of my Arch Linux. For this, a pacman-run (script) with the following content should be created beforehand:
### /usr/bin/pacman-run
    #!/bin/bash
    sudo /usr/bin/pacman -Syyu --noconfirm
    exit
### Make executable with:
    chmod +x /usr/bin/pacman-run

### Create a new script that calls the previous one so that only this script has the sudo rights and not pacman has full access (important to avoid unauthorised uninstallations)! We use this call script e.g. "update".
### /usr/bin/update
    #!/bin/bash
    sudo /usr/bin/pacman-run $@
    exit
    
### Make executable with:
    chmod +x /usr/bin/update

### Now this UPDATE script can be passed to sudoRUN for the system entry with:
    sudo sh sudoRUN.sh [USERNAME] /usr/bin/update
    
### If you now call "update", the following command is executed in the background with sudo rights:
    sudo /usr/bin/pacman -Syyu --noconfirm
### You no longer need to enter the password for an UPDATE!

## 2.) Example (Script or Tool)
### If a script or tool requires sudo rights, which e.g. changes the keyboard illumination or releases a port (e.g. USB for Arduino), which is harmless to security and is always released by you anyway, you can of course also enter it for release with sudoRUN!
    sudo sh sudoRUN.sh [USERNAME] /usr/bin/[Script- or Toolname]
