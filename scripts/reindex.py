import os, subprocess

basename = 'splito'
# Si el directorio de trabajo no es el actual, especificar en 'folder'
folder = './'
files = []

for file_path in sorted(os.listdir(folder)):
    if os.path.isfile(os.path.join(folder, file_path)) and file_path.endswith('.wav'):
        files.append(os.path.join(folder, file_path))

count = 1
for file in files:
    p = subprocess.run(['mv', file, os.path.join(folder, basename + str(count).zfill(3) + '.wav')])
    count += 1