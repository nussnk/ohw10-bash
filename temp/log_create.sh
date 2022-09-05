#!/bin/bash

ayear=`date --date="2 hour ago" +%Y`
amonth=`date --date="2 hour ago" +%b`
aday=`date --date="2 hour ago" +%d`
ahour=`date --date="2 hour ago" +%H`

echo $aday/$amonth/$ayear:$ahour
grep -E "$aday/$amonth/$ayear:$ahour" access.log >> new_access.log
