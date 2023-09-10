#!/bin/bash
##
# Genera dos archivos paralelos (uno en cada idioma) a partir de un archivo de tmx.
#
# tmx2src.sh <tmx_filename> <src_lang> <tgt_lang> [label]
#	filename	Nombre del archivo que se va a procesar
#	src_lang	Idioma de origen (Ej: es)
#	tgt_lang	Idioma de destino (Ej: en)
#	label		(opcional) Etiqueta que contiene el texto. Default: seg
##
filename=$1
src=$2
tgt=$3
olabel="<seg>"
clabel="</seg>"

if [ -n "$4" ]
then
	olabel="<"$4">"
	clabel="</"$4">"
fi

if [ -e "$filename" ]
then
	echo "Dividiendo archivo "$filename
	gcommand="(?<=$olabel).*(?=$clabel)"
	grep -oP $gcommand $filename > tmp.tmp			# Imprimir lo que hay dentro de la etiqueta
	echo "Creando el archivo "$filename"."$src
	sed 'n; d' tmp.tmp > $filename"."$src			# Imprime las líneas impares
	echo "Creando el archivo "$filename"."$tgt
	sed '1d; n; d' tmp.tmp > $filename"."$tgt		# Imprime las líneas pares
	rm tmp.tmp
else
	echo "Error en archivo: ["$filename"]"
fi