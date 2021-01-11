sensors | grep -e Package\ id -e fan1 \
	| cut -d':' -f2 \
	| tr '\n' ' ' \
	| sed 's|\ (.*).||;s|+||' \
	| awk '{printf "%s %sRPM", $1, $2}'
