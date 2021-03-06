#!/usr/bin/env bash
{ set +x; } 2>/dev/null

MIN=2

processes="$(ps -ax -o pid,etime,command | grep -v "\-bash\|grep\|login\| 00:00" | grep bash)"
processes="$([[ -n "$processes" ]] && while IFS= read l; do
    pid="$(echo $l | awk '{print $1}')"
    seconds="$(pid-elapsed "$pid")"
    [[ "$seconds" -gt $MIN ]] && echo "$l"
done <<< "$processes")"
[[ -z "$processes" ]] && exit

count="$(echo "$processes" | wc -l | tr -d ' ')"
echo "<div style='text-align:center;color:white'>bash ($count) long running</div>"
[[ -z "$processes" ]] && exit
echo "<table>"
while IFS= read l; do
    pid="$(echo $l | awk '{print $1}')"
    etime="$(echo $l | awk '{print $2}')"
    command="$(IFS=' ';set $l;shift 2; echo "$@")"
    echo "<tr><td>$pid</td><td>$etime</td><td>$command</td></tr>"
done <<< "$processes"
echo "</table>"
