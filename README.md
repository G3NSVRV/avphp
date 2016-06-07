# AvPHP 1.0
Basic php malware detection tool

This script was maded for webhost server to detect and do actions with infected php or image files.
If you know a better way to search, please commit, I will really apreciate.

Thanks
-G3NSVRV

#Installation
version=1.5;wget -O $version.zip https://github.com/G3NSVRV/avphp/archive/$version.zip;test=$(unzip $version.zip|tail -n 1|awk '{print $2}'|cut -d '/' -f1);rm -f $version.zip;rm -rf /etc/avphp;mv $test /etc/avphp


Enero/2015

Este script tiene como objetivo buscar encabezados PHP en busca de spammers. Para incluir encabezados se deben agregar al archivo database.def que incluye este paquete, el cual funciona como archivo de definiciones de virus. Para configurar variables, estas deben realizarse desde el archivo avphp.conf
