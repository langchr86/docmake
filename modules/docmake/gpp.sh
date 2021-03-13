#!/usr/bin/env bash

# this represents the HTML moder (-H) but without quote character
gpp -U "<#" ">" "\B" "|" ">" "<" ">" "#" "" $@
