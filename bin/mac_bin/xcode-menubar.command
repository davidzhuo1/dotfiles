#!/bin/bash -e

source /Users/dz/bin/virt_menubar/bin/activate
COMMAND="`which xcode-selector-menubar.command`"
/usr/bin/osascript <<EOF &
tell application "Terminal"
	do shell script "$COMMAND" with administrator privileges
end tell
EOF
disown
/bin/bash -c "sleep 10 && killall Terminal" &
echo "Launched menubar"
