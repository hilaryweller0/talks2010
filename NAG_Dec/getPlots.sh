#!/bin/bash -e

pngFiles=(
meshes/latLon/constant/mesh.eps

)

pdfFiles=(
shallowWater/WilliSteady/24x48/constant/mesh_30.eps
shallowWater/WilliSteady/cube12/constant/mesh_30.eps
shallowWater/WilliSteady/bucky4/constant/mesh_30.eps
shallowWater/WilliSteady/tri4/constant/mesh_30.eps
)

for file in ${pngFiles[*]}
do
    f=$FOAM_RUN/$file
    fRoot=`dirname $f`/`basename $f .eps`
    pngFile=$fRoot.png
    fileNew=graphics/`echo $file |sed 's/\//+/g' | sed 's/\./p/g' | sed 's/peps/\.png/g'`

    if [ ! -e $pngFile ]; then
        echo converting $file to png
        eps2png $f
    elif [ `stat -c "%Z" $f` -gt `stat -c "%Z" $pngFile` ]; then
        echo re-converting $file to png
        eps2png $f
#    else
#        echo $pngFile is newer
    fi

    rsync -ut $pngFile $fileNew
done

for file in ${pdfFiles[*]}
do
    f=$FOAM_RUN/$file
    fRoot=`dirname $f`/`basename $f .eps`
    pdfFile=$fRoot.pdf
    fileNew=graphics/`echo $file |sed 's/\//+/g' | sed 's/\./p/g' | sed 's/peps/\.pdf/g'`

    if [ ! -e $pdfFile ]; then
        echo converting $file to pdf
        makebb $f
        epstopdf $f
    elif [ `stat -c "%Z" $f` -gt `stat -c "%Z" $pdfFile` ]; then
        echo re-converting $file to pdf
        makebb $f
        epstopdf $f
#    else
#        echo $pdfFile is newer
    fi

    rsync -ut $pdfFile $fileNew
done
