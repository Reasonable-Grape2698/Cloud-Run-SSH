rc-service sshd start && echo $PUBLIC_KEY > ~/.ssh/authorized_hosts && rc-service sshd restart && wssh --address=0.0.0.0 --port=8080
