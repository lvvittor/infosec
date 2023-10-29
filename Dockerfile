FROM kalilinux/kali-rolling

# Update the package list and install dependencies
RUN apt-get update && apt-get install -y \
    metasploit-framework \
    net-tools \
    nmap \
    && apt-get clean

CMD ["bash"]
