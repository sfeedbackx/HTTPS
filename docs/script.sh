
#!/bin/bash
C_PATH=${PWD}

FOUND_FILE=$(find $C_PATH -name "*.md")
for ch in $FOUND_FILE ;do
  mv $ch $C_PATH
done
