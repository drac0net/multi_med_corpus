#!/bin/bash
##
# Genera el archivo de entrada (src) y el de validacion (val) a partir de un archivo de texto, para realizar un entrenamiento con openNMT.
# Para ello extrae las ultimas lineas del texto para crear el archivo de validacion (val), y el resto del archivo para el archivo de entrada (src).
#
# preprocess.sh <filename> [nlineas]
#	filename	Nombre del archivo que se va a procesar
#	nlineas		(opcional) Numero de lineas que tendra el archivo de validacion. Default: 5000
##
filename=$1
linesval=5001

if [ -e "$filename" ]
then
	linestotal=$(wc -l < $filename)

	if [ -n "$2" ]
	then
		linesval=$2
		re='^[0-9]+$'
		if ! [[ $linesval =~ $re ]] ; then
			echo "ERROR. El segundo parametro no es un número" >&2; exit 1
		else
			linesval=$((linesval + 1))
		fi
	fi

	linesremain=$((linestotal - linesval + 2))

	if [ "$linesremain" -le 0 ]
	then
		echo "ERROR. No hay suficientes lineas"
		echo "Lineas a extraer = "$linesval" | Lineas totales: "$linestotal
		exit 1
	fi

	#sed -i '/^$/d' $filename
	echo -n "Creando el archivo: "$filename".src... "
	sed "$linesremain,\$d" $filename > $filename".src"
	echo "DONE"
	echo -n "Creando el archivo: "$filename".val... "
	tail -"$linesval" $filename > $filename".val"
	echo "DONE"
else
	echo "Error en archivo: ["$filename"]"
fi