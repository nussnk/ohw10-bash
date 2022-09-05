#!/bin/bash

awk '{print $9}' $1 | sort | uniq -c | sort -rn
