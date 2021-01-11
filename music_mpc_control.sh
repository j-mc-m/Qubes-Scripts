#!/bin/bash

music_vm=music
seek_interval=10

usage() {
	echo "Usage: (next, prev, stop, toggle forwards, back)"
	exit
}

display_song() {
	song=$(qvm-run --pass-io $music_vm "mpc current | grep -o ': .*' | sed 's|:\ ||'")
	notify-send "Playing '$song'"
}

[ -z $1 ] && usage

case $1 in 
	"next") qvm-run $music_vm "mpc next" && display_song ;;
	"prev") qvm-run $music_vm "mpc prev" && display_song ;;
	"stop") qvm-run $music_vm "mpc stop" ;;
	"toggle") qvm-run $music_vm "mpc toggle" ;;
	"forward") qvm-run $music_vm "mpc seek +$seek_interval" ;;
	"back") qvm-run $music_vm "mpc seek -$seek_interval" ;;
	"current") display_song ;;
	*) echo "Unknown option: '$1'" && usage ;;
esac
