# System Monitor and Security Audit Scripts

## Files
- `system_monitor.sh` : Monitor CPU, Memory, Disk, Network, Services in real-time.
- `security_audit_hardening.sh` : Audit server security and apply basic hardening.

## How to Setup and Run on AWS EC2 (Ubuntu Instance)

1. **Launch EC2 Instance**
   - Choose Ubuntu 20.04 AMI (or similar minimal server)
   - Open ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)

2. **Connect to your EC2 Instance**
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

3. **Install Dependencies**
```bash
sudo apt update
sudo apt install sysstat net-tools ufw -y
```

4. **Upload Scripts**
You can either use `scp` or create scripts manually inside the instance.

Example using `scp`:
```bash
scp -i your-key.pem system_monitor.sh ubuntu@your-ec2-ip:~/
scp -i your-key.pem security_audit_hardening.sh ubuntu@your-ec2-ip:~/
```

5. **Make Scripts Executable**
```bash
chmod +x system_monitor.sh
chmod +x security_audit_hardening.sh
```

6. **Run the System Monitor**
```bash
./system_monitor.sh
```
You can also run with specific sections:
```bash
./system_monitor.sh -cpu
./system_monitor.sh -memory
./system_monitor.sh -network
```

7. **Run Security Audit and Hardening**
```bash
sudo ./security_audit_hardening.sh
```

## Notes
- Some hardening steps like bootloader password need manual intervention.
- Always backup server configuration before running hardening scripts.
- Ensure security groups/firewalls allow SSH after modifying firewall rules.

---

Happy Monitoring & Hardening 🚀
