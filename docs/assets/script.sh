#!/bin/bash
C_PATH=${PWD}
P_PATH=${PWD%/*}

FOUND_FILE=$(find $P_PATH -name "*.png")
for ch in $FOUND_FILE ;do
  mv $ch $C_PATH
done
