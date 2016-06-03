#!/bin/bash
if [ -n "$(ps aux|grep find)" ]; then 
av_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$av_dir" ]]; then av_dir="$PWD"; fi
. "$av_dir/config.conf"

fecha=(`date +%Y%m%d`);
definitions="\( -name \*.jpg -or -name \*.png -or -name \*.jpeg -or -name \*.gif -or -name \*.bmp \) -type f -exec grep -il '<?PHP\|<?php' '{}' \;";

while read in; do
php_func="\( -name \*.php \) -exec grep -il '$in' '{}' \;";
definitions="$definitions , $php_func";
done < $av_dir/include.inc

cpulimit --exe=find -l 4 &
run_avphp="find $search_dir $definitions";
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
