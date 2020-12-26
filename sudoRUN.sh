#!/bin/bash

username=$(whoami)

if [ $1  ] || [ $2 ]
 then
  if [ $1 == "-h" ] || [ $1 == "--help" ]
  then
  printf  "\n––– sudoRUN ––– 2020 by Marc-André Tragé\n\n"
  printf  "  sudoRUN allows users to run programs or scripts with the security
  privileges of the root user without having to enter sudo and the password itself.\n"
  printf  "\n  You should never use sensitive tools or scripts outside the protected
  root area, where changes to scripts or the replacement or renaming of a tool
  can lead to security vulnerabilities.\n\n"
  printf  "  The creation of the start script always takes place under the specified path
  and tool or script name with the appended ending \"-sudo\", e.g. \"/usr/bin/tool\"
  is entered, then the start script name is \"/usr/bin/tool-sudo\". Since this is a
  script which contains a start condition which intrinsically contains the rights,
  it can be renamed without losing the rights or start conditions.\n\n"
  printf  "  [ INSTALL ]\n  Run # sudo sh sudoRUN.sh USER-NAME /usr/bin/TOOL-NAME \n\n"
  printf  "  [ UNINSTALL ]\n  For the sudo release, the required data is entered at the end of /etc/sudoers.
  So if you delete the start script you should also remove the corresponding
  entry in /etc/sudoers. When deleting the start script, it is important to
  note if the start script has been renamed e.g. from tool-sudo to toolxyz,
  so that you can rode which value the share has here (if you have created
  more than one) and you don't lose the overview, you should read the start script
  before deleting it with e.g. \"# cat toolxyz\" to display the path and name.\n\n"
  printf  "  [ LOOK OUT ]\n  I do not accept any liability for any damage caused
  by the use or incorrect use of sudoRUN, or as a result thereof.\n\n"
  exit 1
  fi
fi

if [ $username != "root" ]
 then
  printf  "\n ––– sudoRUN –––\n  Hello $username, please use\n
      # sudo sh sudoRUN.sh\n
  With -h or --help you can get more information for sudoRUN.\n\n"
  exit 1
fi

if [ ! $1 ] || [ ! $2 ]
 then
  printf  "\n ––– sudoRUN –––\n  Hello $username,\n  please enter a tool path e.g.:\n
      # sudo sh sudoRUN.sh USERNAME /usr/bin/toolname\n
  With -h or --help you can get more information for sudoRUN.\n\n"
  exit 1
fi

sudoRUN="$2-run"
sudoSudo="$2-sudo"
sudoersStrg="$1 ALL=(ALL) NOPASSWD: $sudoRUN"

echo >> /etc/sudoers
echo "#--- sudoRUN" >> /etc/sudoers
echo "     $sudoersStrg" >> /etc/sudoers
echo "#---" >> /etc/sudoers

echo "#!/bin/bash" > $sudoRUN
echo "sudo $2" '$@' >> $sudoRUN
echo "exit" >> $sudoRUN
chmod +x $sudoRUN

echo "#!/bin/bash" > $sudoSudo
echo "sudo $sudoRUN" '$@' >> $sudoSudo
echo "exit" >> $sudoSudo
chmod +x $sudoSudo

printf "\n ––– sudoRUN –––\n  you can now use\n     $sudoSudo \n  without having to enter sudo\n\n"

echo $sudoRUN >> /etc/sudoRUN.log
echo $sudoSudo >> /etc/sudoRUN.log

exit
