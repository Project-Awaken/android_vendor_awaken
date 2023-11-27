#!/bin/sh
if [ "$1" ]
then
  file_path=$1
  file_name=$(basename "$file_path")
  if [ -f $file_path ]; then
    file_size=$(stat --printf="%s" "$file_path")
    md5=$(cat "$file_path.md5sum" | cut -d' ' -f1)
    datetime=$(grep ro\.build\.date\.utc $OUT/system/build.prop | cut -d= -f2);
    id=$(sha256sum $file_path | awk '{ print $1 }');
    echo "{\n   \"file_name\": \"$file_name\",\n   \"file_size\": $file_size,\n   \"datetime\": $datetime,\n   \"id\": \"$id\",\n   \"md5\": \"$md5\"\n}" > $file_path.json
  fi
fi
