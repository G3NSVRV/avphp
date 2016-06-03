#!/bin/bash

if [ -z "$(ps aux|grep -w find|grep -v grep)" ]; then
av_dir=$PWD;
. "$av_dir/avphp.conf"
fecha=(`date +%Y%m%d`);
definitions="\( -name \*.jpg -or -name \*.png -or -name \*.jpeg -or -name \*.gif -or -name \*.bmp \) -type f -exec grep -il '<?PHP\|<?php' '{}' \;";

while read in; do
php_func="\( -name \*.php \) -exec grep -il '$in' '{}' \;";
definitions="$definitions , $php_func";
done < $av_dir/virusdb.def

find_ini="find $search_dir -maxdepth 1 -iname";
scan_dir1="$find_ini "'"'"[0-9]*"'"'"|grep -vw $search_dir";
scan_dir2="$find_ini "'"'"[A-D]*"'"'"|grep -vw $search_dir";
scan_dir3="$find_ini "'"'"[E-H]*"'"'"|grep -vw $search_dir";
scan_dir4="$find_ini "'"'"[I-L]*"'"'"|grep -vw $search_dir";
scan_dir5="$find_ini "'"'"[M-P]*"'"'"|grep -vw $search_dir";
scan_dir6="$find_ini "'"'"[Q-T]*"'"'"|grep -vw $search_dir";
scan_dir7="$find_ini "'"'"[U-X]*"'"'"|grep -vw $search_dir";
scan_dir8="$find_ini "'"'"[Y-Z]*"'"'"|grep -vw $search_dir";

let cpu_limit=$cpu_limit/8
cpulimit --exe=find -l $cpu_limit &

for n in `seq 1 8`; do
test=scan_dir$n
eval ${!test} > $temp_dir/scan_dir$n.temp
while read in; do
PzKg4lu7AM="find $in $definitions"
eval $PzKg4lu7AM >> $log_dir.log &
done < $temp_dir/scan_dir$n.temp
done

eval $run_avphp > $log_dir.log;
while read in; do
chattr -i "$in";
mv "$in" "$in.infectado";
done < $log_dir.log

if ([ -s $log_dir.log ]); then
mv $log_dir.log $log_dir-$fecha.log;
mail -s "Reporte de Virus" $mail_to < $log_dir-$fecha.log;
fi
fi
