#!/bin/sh

#set -x

modlist=$(go list -m all)

tmp=$(echo "$modlist" | sed 's/ /@/g')

f(){
    local keyword="$1"

    #echo "s =============> $tmp"

    echo "$tmp" | while IFS= read -r line; do
        #echo "=======================================>Line: $line"
        if test -d "$GOPATH/pkg/mod/$line"; then
            /usr/local/bin/rg --column --line-number --no-heading --color=always -w -i -t go "$keyword" "$GOPATH/pkg/mod/$line" | grep "$keyword"
        else
            # echo "目录不存在"
        fi
    done
}
