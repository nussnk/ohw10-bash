#!/bin/bash

cut -d ' ' -f 7 $1 | sort | uniq -c | sort -nr | head -n 20
