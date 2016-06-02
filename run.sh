##########################################################
##		AVPHP 1.4 creado por G3NSVRV		##
##			Enero/2015			##
##		Actualizado Octubre/2015		##
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
##	realizarse desde el archivo config.conf		##
##########################################################

av_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$av_dir" ]]; then av_dir="$PWD"; fi
. "$av_dir/config.conf"

fecha=(`date +%Y%m%d`);
definitions="\( -name \*.jpg -or -name \*.png -or -name \*.jpeg -or -name \*.gif -or -name \*.bmp \) -type f -exec grep -il '<?PHP\|<?php' '{}' \;";

while read in; do
php_func="\( -name \*.php \) -exec grep -il '$in' '{}' \;";
definitions="$definitions , $php_func";
done < $av_dir/include.inc

run_avphp="find $search_dir $definitions";
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
