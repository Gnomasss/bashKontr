#!/bin/bash
unset fl_file
unset file
unset group

for arg in "$@"
do
    if [[ "$arg" == "-f" ]]; then
        fl_file=1
    else
        if [[ "$fl_file" && -z "$file" ]]; then
            file=$arg
        else
            group=$arg
        fi
    fi

done

if [[ -z "$fl_file" ]]; then
    file='/etc/group'
fi

if [[ -n "$fl_file" && -z "$file" ]]; then
    echo "incorrect input" >&2
    exit 2 
fi

if [[ -z "$group" ]]; then
    echo "incorrect input" >&2
    exit 2
fi

str="$( grep -w "^\\$group" "$file" )"

if [[ "$str" == "" ]]; then
    echo "group does not exist" >&2
    exit 1
fi

group=${str##*:}
echo $group

echo `cut -d ',' -f 1 $group`

users=()

