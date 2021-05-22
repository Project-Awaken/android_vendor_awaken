#!/bin/bash
CL_RED="\033[31m"
CL_GRN="\033[1;32m"
CL_BLU="\033[34m"
CL_CYN="\033[1;36m"
CL_RST="\033[0m"
CL_YLW="\033[1;33m"
CL_NC="\033[0m"
if [ "$1" ]; then
    echo "Generating .json"
    file_path=$1
    file_name=$(basename "$file_path")
    DEVICE=$(echo $TARGET_PRODUCT | sed 's/awaken_//g')
    if [ -f $file_path ]; then
        # only generate for official builds. unless forced with 'export FORCE_JSON=1'
        if [[ $file_name == *"OFFICIAL"* ]] || [[ $FORCE_JSON == 1 ]]; then
            if [[ $FORCE_JSON == 1 ]]; then
                echo -e "${CL_GRN}Forced generation of json${CL_NC}"
            fi
            file_size=$(stat -c%s $file_path)
            md5=$(cat "$file_path.md5sum" | cut -d' ' -f1)
            datetime=$(grep -m1 ro\.build\.date\.utc ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
            id=$(sha256sum $file_path | awk '{ print $1 }');
            build_type=$(grep -m1 ro\.awaken\.build\.type ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
            base_version=$(grep -m1 ro\.awaken\.base\.version ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
            link="https://sourceforge.net/projects/project-awaken/files/${DEVICE}/${file_name}/download"
            echo "{" > $file_path.json
            echo "  \"response\": [" >> $file_path.json
            echo "    {" >> $file_path.json
            echo "      \"datetime\": ${datetime}," >> $file_path.json
            echo "      \"size\": ${file_size}," >> $file_path.json
            echo "      \"filehash\": "${md5}"," >> $file_path.json
            echo "      \"filename\": \"${file_name}\"," >> $file_path.json
            echo "      \"id\": "${id}"," >> $file_path.json
            echo "      \"romtype\": "${build_type}"," >> $file_path.json
            echo "      \"version\": \"${base_version}\"," >> $file_path.json
            echo "      \"url\": \"${link}\"" >> $file_path.json
            echo "    }" >> $file_path.json
            echo "  ]" >> $file_path.json
            echo "}" >> $file_path.json
            mv "${file_path}.json" "./out/target/product/$DEVICE/${DEVICE}.json"
            echo -e "${CL_GRN}Done generating ${CL_RED}${DEVICE}.json${CL_NC}"
        else
            echo -e "${CL_YLW}Skipped generating json for a non-official build${CL_NC}"
        fi
    fi
fi
