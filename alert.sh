#!/bin/bash

cat /etc/crontab > /var/scripts/cpy
DIFF=$(diff cpy tmp)
if [ "$DIFF" != "" ]; then
        echo "Une modification du fichier crontab a ete effectuer." | mail -s "Alerte modification!" root
        rm -rf /var/scripts/tmp
        cp /var/scripts/cpy /var/scripts/tmp
fi
