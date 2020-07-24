#! /bin/sh

FIRST="yes"
echo '{'
echo '  "data": ['
for s in `timeout 20s bbb-conf --status | cut -f 1 -d : | cut -f 1 -d " "`; do
	if [ "${FIRST}" = "yes" ]; then
		FIRST="no"
	else
		echo ','
	fi
	echo '    {'
	echo '      "{#BBB_SERVICE}": "'${s}'"'
	echo -n '    }'
done
echo ''
echo '  ]'
echo '}'
