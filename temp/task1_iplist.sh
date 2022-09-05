#!/bin/bash

cut -f 1 -d ' ' $1 | sort | uniq -c | sort -nr | head -n 20

