#!/bin/bash

# system_monitor.sh
# A Bash script to monitor system resources in a dashboard format.

REFRESH_INTERVAL=2

# Functions for each section
cpu_usage() {
    echo "CPU Usage and Load Average:"
    echo "---------------------------"
    mpstat | awk '/all/ {print "CPU Usage: " 100-$12"%"}'
    uptime | awk -F'load average:' '{ print "Load Avg:" $2 }'
    echo ""
}

memory_usage() {
    echo "Memory Usage:"
    echo "-------------"
    free -h
    echo ""
}

top_processes() {
    echo "Top 10 Processes (CPU & Memory):"
    echo "--------------------------------"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11
    echo ""
}

disk_usage() {
    echo "Disk Usage:"
    echo "-----------"
    df -h | awk '{print $5 " " $6}' | grep -E '[8-9][0-9]%|100%'
    df -h
    echo ""
}

network_usage() {
    echo "Network Monitoring:"
    echo "--------------------"
    netstat -an | grep ESTABLISHED | wc -l | xargs echo "Active Connections:"
    cat /proc/net/dev | awk '/:/ {in+=$2; out+=$10} END {print "Data In: " in/1024/1024 " MB, Data Out: " out/1024/1024 " MB"}'
    netstat -i | awk '/^[a-z]/ {print $1, "Packet Drops:", $5}'
    echo ""
}

service_status() {
    echo "Services Status:"
    echo "----------------"
    for service in ssh nginx apache2 iptables; do
        if systemctl is-active --quiet "$service"; then
            echo "$service: [RUNNING]"
        else
            echo "$service: [STOPPED]"
        fi
    done
    echo ""
}

process_count() {
    echo "Process Monitoring:"
    echo "-------------------"
    ps aux | wc -l | xargs echo "Active Processes:"
    echo ""
}

# Custom dashboard
custom_dashboard() {
    while true; do
        clear
        echo "======== SYSTEM MONITOR DASHBOARD ========"
        cpu_usage
        memory_usage
        top_processes
        disk_usage
        network_usage
        service_status
        process_count
        echo "Press [CTRL+C] to exit. Refreshing every $REFRESH_INTERVAL seconds..."
        sleep $REFRESH_INTERVAL
    done
}

# Main
case "$1" in
    -cpu) cpu_usage ;;
    -memory) memory_usage ;;
    -processes) top_processes ;;
    -disk) disk_usage ;;
    -network) network_usage ;;
    -services) service_status ;;
    -all|*) custom_dashboard ;;
esac
