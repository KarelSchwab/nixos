#!/usr/bin/env bash

awk '
/^MemTotal:/ {
	mem_total=$2
}
/^MemFree:/ {
	mem_free=$2
}
/^Buffers:/ {
	mem_free+=$2
}
/^Cached:/ {
	mem_free+=$2
}
END {
    free=mem_free/1024/1024
    used=(mem_total-mem_free)/1024/1024
    total=mem_total/1024/1024

	percent=0
	if (total > 0) {
		percent=used/total*100
	}

	# full text
	printf("%.1fG/%.1fG (%.f%%)\n", used, total, percent)

	# short text
	printf("%.f%%\n", percent)
}
' /proc/meminfo
