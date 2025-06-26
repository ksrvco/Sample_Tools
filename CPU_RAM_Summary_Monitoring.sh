#!/bin/bash
INTERVAL=30       
DURATION=$((20 * 60 * 60))  
END=$((SECONDS + DURATION))
LOGFILE="system_usage_log.txt"
SUMMARYFILE="system_usage_summary.txt"

> "$LOGFILE"
> "$SUMMARYFILE"

echo "Monitoring started... Duration: 20 hours, Interval: 30 seconds"
echo "Start time: $(date)" >> "$LOGFILE"

while [ $SECONDS -lt $END ]; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))
    MEM_USED_PERCENT=$((100 * MEM_USED / MEM_TOTAL))

    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' -v prefix="$prefix" '{split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); print v}')
    CPU_USAGE=$(echo "scale=2; 100 - $CPU_IDLE" | bc)

    echo "$TIMESTAMP | CPU Usage: $CPU_USAGE% | RAM Usage: $MEM_USED_PERCENT% ($((MEM_USED / 1024))MB / $((MEM_TOTAL / 1024))MB)" >> "$LOGFILE"

    sleep $INTERVAL
done

echo "Monitoring ended: $(date)" >> "$LOGFILE"

echo -e "\n--- Summary (Generated on $(date)) ---" >> "$SUMMARYFILE"

AVG_CPU=$(awk -F'CPU Usage: ' '{if(NF>1) print $2}' "$LOGFILE" | awk -F'%' '{sum+=$1; count++} END {if(count>0) printf("%.2f", sum/count)}')
AVG_RAM=$(awk -F'RAM Usage: ' '{if(NF>1) print $2}' "$LOGFILE" | awk -F'%' '{sum+=$1; count++} END {if(count>0) printf("%.2f", sum/count)}')

echo "Average CPU Usage: $AVG_CPU%" >> "$SUMMARYFILE"
echo "Average RAM Usage: $AVG_RAM%" >> "$SUMMARYFILE"
echo "Log file: $LOGFILE" >> "$SUMMARYFILE"

echo -e "\n Monitoring completed. Summary written to $SUMMARYFILE"
