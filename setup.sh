#!/bin/bash
#

rm -f /etc/avphp/
mkdir /etc/avphp/
cp ./* /etc/avphp/
if (cat /var/spool/cron/root | grep avphp); then sed -i 's/^.*.avphp.*/0 18 \* \* 1,3,5 sh \/etc\/avphp\/run.sh/g' /var/spool/cron/root; else echo "0 18 * * 1,3,5 sh /etc/avphp/run.sh" >> /var/spool/cron/root; fi
