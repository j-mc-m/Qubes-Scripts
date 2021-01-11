#!/bin/bash

qvm-run --no-auto --pass-io sys-mullvad "sudo wg | head -n 1 | cut -d ' ' -f 2" || echo "sys-mullvad not running"
