#!/bin/bash -e

pngFiles=(
vSlice/hill_2D_ico/withRefinement/icoFoam/2160/pU.eps

shallowWater/WilliSteadyMeshAdapt/48x96_2/refinedBox/linear_f/save/A_quad/345600/hUdiff.eps
shallowWater/WilliSteadyMeshAdapt/48x96_2/refinedBox/linear_f/save/reconMidPoint_C/345600/hUdiff.eps
shallowWater/WilliSteadyMeshAdapt/48x96_V/save/reconLin/345600/hUdiff.eps
shallowWater/WilliSteadyMeshAdapt/48x96_V/save/TRSK/345600/hUdiff.eps

shallowWater/WilliSteadyMeshAdapt/Voronoi_f/save/A_quad/0/hU.eps
shallowWater/WilliSteadyMeshAdapt/Voronoi_f/save/A_quad/345600/hUdiff.eps
shallowWater/WilliSteadyMeshAdapt/Voronoi_f/save/reconMidPoint_C/345600/hUdiff.eps
shallowWater/WilliSteadyMeshAdapt/Voronoi_f/save/reconLin/345600/hUdiff.eps
shallowWater/WilliSteadyMeshAdapt/Voronoi_f/save/TRSK/345600/hUdiff.eps

)

pdfFiles=(
meshes/latLon/constant/mesh.eps
shallowWater/WilliSteadyMeshAdapt/48x96_V/save/reconLin/0/meshWithOverlay.eps
shallowWater/WilliSteadyMeshAdapt/Voronoi_f/constant/meshWithOverlay.eps
shallowWater/WilliSteadyMeshAdapt/Voronoi_f/save/energy.eps

shallowWater/WilliSteadyMeshAdapt/48x96_V/save/reconLin/0/hUzoom.eps
shallowWater/WilliSteadyMeshAdapt/48x96_V/save/TRSK/0/hUzoom.eps
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
