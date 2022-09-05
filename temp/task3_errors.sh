#!/bin/bash

grep -vP '" 2\d\d ' $1 | awk '{print $9,$1,$4,$5,$6,$7,$8}'
