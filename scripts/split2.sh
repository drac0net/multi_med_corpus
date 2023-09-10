#!/bin/bash

# Divide el archivo con numero de secuencia <num_secuencia> en dos, 
# partiéndolo por <num_segundos>
# ./split2.sh <num_secuencia> <num_segundos>

# Si el directorio de trabajo no es el actual, especificar en 'folder'
folder=""

sox ${folder}split$1.wav ${folder}split$1a.wav trim 0 $2
sox ${folder}split$1.wav ${folder}split$1b.wav trim $2
rm ${folder}split$1.wav