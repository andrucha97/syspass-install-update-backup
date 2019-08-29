# syspass-install-update-backup

This Scripts should perform an automatic installation, update or create a backup

## Update Script

This script can be used on productiv system. It will help you using the script from [vmario89](https://github.com/vmario89/sysPass-update)

### How to use

Download:
```
cd /opt
git clone https://github.com/andrucha97/syspass-install-update-backup.git
chmod +x /opt/syspass-install-update-backup/update-pro.sh
```

Your own logo:

You can add your own logo to sysPass. Add your logos in `/opt/syspass-install-update-backup/images/` with your own. Rename your logos to the exact same name as the standard logos. You only need to do this once.

Start Script:
```
./opt/syspass-install-update-backup/update-pro.sh
```

This Script has a expert mode. You can choose your own version of sysPass. It sould only be used by expert users.

## Install Script

:zap: This Script is not finished and sould not be used on productiv system. :zap:

At the moment this Script sould only install sysPass clean.

How to run:

```
cd /opt
git clone https://github.com/andrucha97/syspass-install-update-backup.git
chmod +x /opt/syspass-install-update-backup/install.sh
./opt/syspass-install-update-backup/install.sh
```

Follow the steps the Script is asking for.
