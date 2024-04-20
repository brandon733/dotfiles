#!/bin/sh
# https://stackoverflow.com/a/43627833
#sed $'s,\x1B\[[0-9;]*[a-zA-Z],,g'
sed -E "s/"$'\E'"\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"
