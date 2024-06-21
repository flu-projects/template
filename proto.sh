#!/bin/bash

pbdir="./lib/proto/"
if [ ! -d "$pbdir" ]; then
        mkdir -p $pbdir
fi
function delete_all_file()
{
	for file in `ls $1`  
    do  
		rm -rf $1$file
    done  
}
delete_all_file $pbdir
temp="./proto/temp/"
if [ ! -d "$temp" ]; then
        mkdir -p $temp
fi

traversal_proto(){  
    for file in `ls $1`  
    do  
		cp $1$file $temp$file
    done  
}  
source="./proto/src/"
traversal_proto $source  
python3 ./proto/proto.py source_path=$source temp_path=$temp
translate_proto(){  
    for file in `ls $1`  
    do  
		protoc --proto_path=$temp --plugin=protoc-gen-dart=$PUB_CACHE/bin/protoc-gen-dart --proto_path=$pbdir --dart_out=$pbdir $file
		echo $file convert to $file.dart success
    done  
}  
translate_proto $temp
rm -rf $temp/

dart format ./lib/network/src/websocket/esport_api.dart
dart format ./lib/network/src/websocket/dispatcher/payload_dispatcher_initializater.dart
dart format ./lib/network/src/websocket/dispatcher/payload_helper.dart
dart format ./lib/events/src/event_helper.dart
dart format ./lib/events/src/event_handle.dart
# dart format ./lib/proto/
