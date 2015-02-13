#!/bin/bash

if [[ $1 == "" ]]; then
	echo "Usage:MP4Box output_name"
	exit 3
fi

#mp4_file=$(ls *.mp4)

mp4_file=$(ls *.mp4 | grep '^[0-9][^0-9]*\.mp4')
mp4_file2=$(ls *.mp4 | grep '^[0-9][0-9]\+\.mp4')

MP4Box_opt=
for i in ${mp4_file}
do
	MP4Box_opt+="-cat $i "
done
for i in ${mp4_file2}
do
	MP4Box_opt+="-cat $i "
done

echo "MP4Box ${MP4Box_opt} $1"

MP4Box ${MP4Box_opt} $1
if [[ $? -eq 0 ]]; then
	echo "rm ${mp4_file} ${mp4_file2}"
	rm ${mp4_file} ${mp4_file2}
fi

