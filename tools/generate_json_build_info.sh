#!/bin/bash
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"
if [ "$1" ]; then
    echo "Generating .json"
    file_path=$1
    file_name=$(basename "$file_path")
    if [ -f $file_path ]; then
        # only generate for official builds. unless forced with 'export FORCE_JSON=1'
        if [[ $file_name == *"Official"* ]] || [[ $FORCE_JSON == 1 ]]; then
            if [[ $FORCE_JSON == 1 ]]; then
                echo -e "${GREEN}Forced generation of json${NC}"
            fi
            datetime=$(grep ro\.build\.date\.utc $OUT/system/build.prop | cut -d= -f2)
            # id=$(sha256sum $file_path | awk '{ print $1 }')
            # link="https://sourceforge.net/projects/project-awaken/files/${AWAKEN_BUILD}/${file_name}/download"
            echo "{" > $file_path.json
            echo "   \"datetime\": ${datetime}," >> $file_path.json
            echo "   \"filename\": \"${file_name}\"," >> $file_path.json
            # echo "   \"id\": \"${id}\"," >> $file_path.json
            # echo "   \"romtype\": \"Official\"," >> $file_path.json
            # echo "   \"size\": ${file_size}," >> $file_path.json
            # echo "   \"url\": \"${link}\"," >> $file_path.json
            # echo "   \"version\": \"10\"" >> $file_path.json
            echo "}" >> $file_path.json
            echo -e "${GREEN}Done generating ${YELLOW}${file_name}.json${NC}"
        else
            echo -e "${YELLOW}Skipped generating json for a non-official build${NC}"
        fi
    fi
fi
