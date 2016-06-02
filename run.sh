#!/bin/bash
##########################################################
##              AVPHP 1.5 creado por G3NSVRV            ##
##                      Enero/2015                      ##
##              Actualizado Junio/2016                  ##
##                                                      ##
##      Este script tiene como objetivo buscar          ##
##      encabezados PHP en busca de spammers            ##
##                                                      ##
##      Para incluir encabezados se deben agregar       ##
##      al archivo database.def que incluye este        ##
##      paquete, el cual funciona como archivo de       ##
##      definiciones de virus                           ##
##                                                      ##
##      Para configurar variables, estas deben          ##
##      realizarse desde el archivo avphp.conf          ##
##########################################################

if [ -n "$(ps aux|grep find)" ]; then 
av_dir=$PWD;
. "$av_dir/avphp.conf"
fecha=(`date +%Y%m%d`);
definitions="\( -name \*.jpg -or -name \*.png -or -name \*.jpeg -or -name \*.gif -or -name \*.bmp \) -type f -exec grep -il '<?PHP\|<?php' '{}' \;";

while read in; do
php_func="\( -name \*.php \) -exec grep -il '$in' '{}' \;";
definitions="$definitions , $php_func";
done < $av_dir/database.def

find_ini="find $search_dir -maxdepth 1 -iname";
run_avphp="$find_ini "'"'"[0-9]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[A-D]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[E-H]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[I-L]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[M-P]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[Q-T]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[U-X]*"'"'" $definitions";
run_avphp="$run_avphp & $find_ini "'"'"[Y-Z]*"'"'" $definitions";

cpulimit --exe=find -l $cpu_limit &

eval $run_avphp > $log_dir.log;
while read in; do
chattr -i "$in";
mv "$in" "$in.infectado";
done < $log_dir.log

if ([ -s $log_dir.log ]); then
cat $log_dir.log >> $log_dir-$fecha.log;
mail -s "Reporte de Virus" $mail_to < $log_dir-$fecha.log;
fi

rm -f $log_dir.log;
fi
################
