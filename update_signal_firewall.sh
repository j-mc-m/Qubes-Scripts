vm=signal

# Change '.config/Signal\ Beta/logs/app.log' to '.config/Signal/logs/app.log' if you use regular Signal, not Signal Beta like me.
ips=$(qvm-run --pass-io $vm "cat .config/Signal\ Beta/logs/app.log | grep -o 'EHOSTUNREACH\s[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | uniq | sed 's|EHOSTUNREACH\s||g'")
ips=$(echo $ips | tr ' ' ';')

# Convert from string to to array, using ';' as delimiter.
IFS=';' read -ra ips <<< "$ips"

# Delete drop rule, placed at end.
qvm-firewall $vm del --rule-no=$(qvm-firewall $vm | tail -n 1 | awk '{print $1}')

for ip in "${ips[@]}"; do
	# Check if $ip already exists
	if [[ $ip == $(qvm-firewall $vm | grep $ip | head -n 1 | awk '{print $3}' | sed 's|/32||') ]]; then
		echo $ip already exists in firewall, skipping...
	else
		echo Adding $ip...
		qvm-firewall $vm add action=accept dsthost=$(echo $ip) proto=tcp dstports=443
	fi

done

# Add back drop rule, keeps firewall enforcement.
qvm-firewall $vm add action=drop
