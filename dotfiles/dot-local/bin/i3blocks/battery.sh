#!/usr/bin/env bash

#Battery 0: Discharging, 96%, 01:37:29 remaining

acpi | awk '{ 

    status=$3
    percentage=$4
    remaining=$5

	# full text
    printf("%s %.f%% %s\n", status, percentage, remaining)

	# short text
	printf("%.f%%\n", percentage)
}'

