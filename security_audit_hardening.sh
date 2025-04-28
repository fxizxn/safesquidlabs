#!/bin/bash


REPORT="security_audit_report.txt"
> "$REPORT"

log() {
    echo "$1" | tee -a "$REPORT"
}

## User and Group Audits
user_audit() {
    log "========== User and Group Audit =========="
    cut -d: -f1 /etc/passwd
    cut -d: -f1 /etc/group
    awk -F: '($3 == "0") {print "Non-standard root user: " $1}' /etc/passwd
    awk -F: '($2 == "" || $2 == "*") {print "User with no password: " $1}' /etc/shadow
}

## File and Directory Permissions
file_permission_audit() {
    log "========== File and Directory Permission Audit =========="
    find / -xdev -type f -perm -0002 -print 2>/dev/null
    find /home -name ".ssh" -exec ls -ld {} \; 2>/dev/null
    find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null
}

## Service Audits
service_audit() {
    log "========== Service Audit =========="
    systemctl list-units --type=service --state=running
    ss -tulnp
}

## Firewall and Network Security
firewall_audit() {
    log "========== Firewall and Network Audit =========="
    ufw status verbose || iptables -L
    ss -tuln
    sysctl net.ipv4.ip_forward
}

## IP and Network Configuration
ip_audit() {
    log "========== IP and Network Configuration =========="
    ip addr show
}

##Security Updates
security_updates() {
    log "========== Security Updates =========="
    apt update
    apt list --upgradable | grep security
}

##  Log Monitoring
log_monitoring() {
    log "========== Log Monitoring =========="
    grep "Failed password" /var/log/auth.log
}

## Server Hardening
server_hardening() {
    log "========== Server Hardening =========="
    # SSH Hardening
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    # Disable IPv6
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p

    # Firewall rules (example basic setup)
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw enable

    # Bootloader Password (Manual, needs user action)
    echo "Manually configure GRUB password for full hardening (skipped in automation)"
}

# MAIN
user_audit
file_permission_audit
service_audit
firewall_audit
ip_audit
security_updates
log_monitoring
server_hardening

log "Security Audit and Hardening Completed. See report: $REPORT"
