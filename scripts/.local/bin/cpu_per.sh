#!/usr/bin/sh

# top -bn1 - id gives % of idle CPU hence we subtract it from the 100
top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}'
