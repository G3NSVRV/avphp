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
av_dir1="$find_ini "'"'"[0-9]*"'"'"";
av_dir2="$find_ini "'"'"[A-D]*"'"'"";
av_dir3="$find_ini "'"'"[E-H]*"'"'"";
av_dir4="$find_ini "'"'"[I-L]*"'"'"";
av_dir5="$find_ini "'"'"[M-P]*"'"'"";
av_dir6="$find_ini "'"'"[Q-T]*"'"'"";
av_dir7="$find_ini "'"'"[U-X]*"'"'"";
av_dir8="$find_ini "'"'"[Y-Z]*"'"'"";

for n in `seq 1 8`; do
eval $av_dir$n > $temp_dir/av_dir$n.temp;
while read in; do
#find $in $definitions;
echo -e "$in\t$n"
done < $temp_dir/av_dir$n.temp &
done

#run_avphp="find $av_dir1 $definitions";
#run_avphp="$run_avphp & find $av_dir2 $definitions";
#run_avphp="$run_avphp & find $av_dir3 $definitions";
#run_avphp="$run_avphp & find $av_dir4 $definitions";
#run_avphp="$run_avphp & find $av_dir5 $definitions";
#run_avphp="$run_avphp & find $av_dir6 $definitions";
#run_avphp="$run_avphp & find $av_dir7 $definitions";
#run_avphp="$run_avphp & find $av_dir8 $definitions";

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
