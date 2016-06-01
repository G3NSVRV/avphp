##########################################################
##		AVPHP 1.4 creado por G3NSVRV		##
##			Enero/2015			##
##		Actualizado Junio/2016		        ##
##							##
##	Este script tiene como objetivo buscar		##
##	encabezados PHP en busca de spammers		##
##							##
##	Para incluir encabezados se deben agregar	##
##	al archivo include.inc que incluye este		##
##	paquete, el cual funciona como archivo de	##
##	definiciones de virus				##
##							##
##	Para configurar variables, estas deben		##
##	realizarse desde el archivo avphp.conf		##
##########################################################

av_dir="${BASH_SOURCE%/*}"
if [ -z "$av_dir" ]; then av_dir="$PWD"; fi
. "$av_dir/avphp.conf"

fecha=$(`date +%Y%m%d`);
definitions="\( -name \*.jpg -or -name \*.png -or -name \*.jpeg -or -name \*.gif -or -name \*.bmp \) -type f -exec grep -il '<?PHP\|<?php' '{}' \;";

while read in; do
php_func="\( -name \*.php \) -exec grep -il '$in' '{}' \;";
definitions="$definitions , $php_func";
done < $av_dir/include.inc

find_ini="find $search_dir -iname"
find_end="-maxdepth 1 $definitions"
run_avphp="$find_ini "[0-9]*" $find_end";
run_avphp="$run_avphp | $find_ini "[A-D]*" $find_end"
run_avphp="$run_avphp | $find_ini "[E-H]*" $find_end"
run_avphp="$run_avphp | $find_ini "[I-L]*" $find_end"
run_avphp="$run_avphp | $find_ini "[M-P]*" $find_end"
run_avphp="$run_avphp | $find_ini "[Q-T]*" $find_end"
run_avphp="$run_avphp | $find_ini "[U-X]*" $find_end"
run_avphp="$run_avphp | $find_ini "[Y-Z]*" $find_end"

cpulimit --exe=find --limit=$cpu_limit

eval $run_avphp > $log_dir.$ext;
while read in; do
chattr -i "$in";
mv "$in" "$in.infectado";
done < $log_dir.$ext

if ([ -s $log_dir.$ext ]); then
cat $log_dir.$ext >> $log_dir-$fecha.$ext;
mail -s "Reporte de Virus" $mail_to < $log_dir-$fecha.$ext;
fi

rm -f $log_dir.$ext;

################
