#! /bin/sh

PW=$(xmlstarlet sel -t -m 'configuration/settings/param[@name="password"]' -v @value /opt/freeswitch/etc/freeswitch/autoload_configs/event_socket.conf.xml 2> /dev/null)
if [ ! -z "${PW}" ]; then PW="-p ${PW}"; fi
UPTIME=$(/opt/freeswitch/bin/fs_cli -x 'uptime' ${PW})
STATUS=$(/opt/freeswitch/bin/fs_cli -x 'show status' ${PW})
SOFIA_FAILED_PROFILES=$(/opt/freeswitch/bin/fs_cli -x 'sofia status' ${PW} | grep -e '\sprofile\s' | grep -v RUNNING | wc -l)

echo uptime:$UPTIME
echo sofia_failed_profiles:${SOFIA_FAILED_PROFILES}
echo $STATUS | sed -r 's/^.* ([[:digit:]]+) session\(s\) - peak.*$/sessions:\1/'
echo $STATUS | sed -r 's/^.*per Sec out of max ([[:digit:]]+), peak ([[:digit:]]+).*$/sessions_per_seconds_max:\1\nsessions_per_seconds_peak:\2/'
echo $STATUS | sed -r 's/^.* ([[:digit:]]+) session.s. max.*$/sessions_max:\1\n/'
