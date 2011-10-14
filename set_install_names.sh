#!/bin/bash
FILES='*.*.dylib libboost*.dylib'
for f in $FILES
do
  echo $f
  install_name_tool -id $f $f
done

POCOLIBS='libPoco*11.dylib'
for l in $POCOLIBS
do
  for m in $POCOLIBS
  do
    echo $l $m
    install_name_tool -change @loader_path/./$m $m $l
  done
done

OCLIBS='libTK*.*.dylib'
for i in $OCLIBS
do
  for j in $OCLIBS
  do
    install_name_tool -change @loader_path/./$j $j $i
  done
done
