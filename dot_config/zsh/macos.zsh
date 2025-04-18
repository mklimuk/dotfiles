#!/isr/bin/env zsh
#
function voices() {
  say -v \?
}

function os_voice_pl() {
  osascript -e "say \"$1\" using \"Zosia\" speaking rate 200 pitch 45 modulation 80"
}

# TODO: use https://stackoverflow.com/questions/48856158/change-icon-of-notification-when-using-osascript-e-display-notification to add custom icon
# also https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/SpeakText.html#//apple_ref/doc/uid/TP40016239-CH62-SW1
function os_notification () {
  osascript -e "display notification \"$1\" with title \"$2\" subtitle \"$3\" sound name \"Morse\""
}

function listening_on() {
  lsof -nP -i4TCP:"$1" | grep LISTEN
}

function ssh_terminfo() {
  infocmp -x | ssh $1 -- tic -x -
}

function pfx_to_jks() {
  SRC=$1
  DEST=${SRC/pfx/jks/}
  keytool -importkeystore -srckeystore "$1" -srcstoretype pkcs12 -destkeystore $DEST -deststoretype JKS
}

VPN_IP=94.75.94.6
SATVPN=SatSystem

NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`
FG_GREEN="$(tput setaf 2)"
FG_RED="$(tput setaf 1)"
FG_WHITE="$(tput setaf 7)"

function vpn_disconnected() {
  scutil --nc status $1 | sed -n 1p | grep -qv Connected
}

function vpn_connected() {
  scutil --nc status $1 | sed -n 1p | grep -q Connected
}

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
alias java8='export JAVA_HOME=$JAVA_8_HOME'

function satsys() {
  case $1 in
    vpn)
      networksetup -connectpppoeservice $SATVPN
      SECONDS=0
      until vpn_connected $SATVPN
      do
 
        if (( SECONDS > 60 ))
        then
          os_voice_pl "Nie udało się połączyć, co za pech!"
          echo "${FG_RED}timeout reached${NORM}; giving up..."
          exit 1
        fi

        echo "vpn is not connected yet; waiting..."
        sleep 1
      done
      
      os_voice_pl "VPN połączony. Nie dziękuj." 
      echo "vpn ${FG_WHITE}$SATVPN${NORM} ${FG_GREEN}connected${NORM}"
      CURRENT_IP=$(ifconfig | grep  10.10.6 | awk '{print $2}')
      sudo route add 10.10.15.0/24 $CURRENT_IP
      sudo route add 10.20.4.0/24 $CURRENT_IP
      sudo route add 10.20.1.0/24 $CURRENT_IP
      sudo route add 10.130.3.0/24 $CURRENT_IP
      sudo route add 10.20.5.0/24 $CURRENT_IP
      sudo route add 10.10.8.0/24 $CURRENT_IP
      sudo route add 10.10.16.0/24 $CURRENT_IP
      sudo route add 192.168.13.0/24 $CURRENT_IP
      sudo route add 10.20.6.0/24 $CURRENT_IP
      sudo route add 10.40.254.0/24 $CURRENT_IP
      sudo route add 10.10.6.0/24 $CURRENT_IP
      sudo route add 10.10.17.0/24 $CURRENT_IP
      sudo route add 10.130.25.0/24 $CURRENT_IP
      sudo route add 10.128.15.0/24 $CURRENT_IP
      sudo route add 10.128.46.0/24 $CURRENT_IP
      sudo route add 10.128.45.0/24 $CURRENT_IP
      sudo route add 10.128.29.0/24 $CURRENT_IP
      sudo route add 10.130.90.0/24 $CURRENT_IP
      sudo route add 10.131.24.0/24 $CURRENT_IP
      sudo route add 10.131.29.0/24 $CURRENT_IP
      sudo route add 10.131.32.0/24 $CURRENT_IP
      sudo route add 10.131.27.0/24 $CURRENT_IP
      sudo route add 10.131.5.0/24 $CURRENT_IP
      sudo route add 10.131.15.0/24 $CURRENT_IP
      sudo route add 10.131.31.0/24 $CURRENT_IP
      sudo route add 10.231.240.0/24 $CURRENT_IP
      sudo route add 10.128.78.0/24 $CURRENT_IP
      sudo route add 10.128.75.0/24 $CURRENT_IP
      ;;
    *)
      print "unknown command"
      ;;
  esac
}

console function () {
  osascript -e "tell application \"Arc\"
	tell front window
		activate
		make new tab with properties {URL:\"https://${1}:8080/console/\"}
	end tell
end tell"
}

