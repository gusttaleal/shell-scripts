#!/bin/bash

#
# Script developed to transcript .md files to .jira files
# To run this script we need to call: $ source script.sh "RELATIVE_PATH_OF_TARGET_FOLDER"
#

# First argument of shell scrit call
SOURCE_PATH=$1

# Colors definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

# Verify if the first argument is void
if [ -z "$SOURCE_PATH" ]; then
  echo -e $RED"Call shell script with folder relative path as argument."
else
  # File extension to search
  EXTENSION=".md"

  # Search for files and store them in an array
  FILES=()
  while IFS= read -r -d '' FILE; do
    FILES+=("$FILE")
  done < <(find "$SOURCE_PATH" -type f -name "*$EXTENSION" -print0)

  # Print the array
  for SOURCE_PATH in "${FILES[@]}"; do
    # Create TEMPORARY and JIRA target file
    current_time=$(date +"%T")
    TMP=$(echo $SOURCE_PATH | cut -d'.' -f1)_${current_time}.tmp
    TARGET=$(echo $SOURCE_PATH | cut -d'.' -f1).jira

    # Copy the file 
    cp $SOURCE_PATH $TMP
    cp $SOURCE_PATH $TARGET
    
    # START TO DEFINE RULES #

    # .md final header line
    LINE=$(grep -n "# NEXT TITLE AFTER HEAD" $TARGET | cut -d: -f1)
    LINE=$((LINE+1))

    # Remove header lines
    sed -i "1,${LINE}d" $TARGET

    # Search for bold md mark (**) and replace for bold jira mark (*)
    sed -i "s/\*\*/\*/g" $TARGET

    # Search for indentation md mark ( -) and replace for indentation jira mark (-- )
    sed -i "s/\ \ \-/\-\-/g" $TARGET

    # Search for title md mark (##) and replace for "Title" mark (-- )
    sed -i "s/## /\*Title\*\:\n/g" $TARGET

    # Search for break line md mark (<br>) and replace for void mark ()
    sed -i "s/<br>//g" $TARGET

    # Search for division md mark (#) and replace for hifen mark (-)
    sed -i "s/#//g" $TARGET

    # Search for LINK md mark ([]()) and replace for LINK jira mark ([|])
    sed -i -E "s/\[([^]]*)]\(([^)]*)\)/[\1|\2]/g" $TARGET

    # Search for Hours (**Hours:** ) and replace for void
    sed -i -E 's/\*\*Hours:\*\* [0-9]+//g' $SOURCE_PATH

    # END OF RULES DEFINITIONS #
  
    # Success message
    echo -e $WHITE" - "$TARGET
  done
fi