# Instructions
1. Add your SSH public key to ssh/authorized_keys
2. Build docker image and push it to wherever (docker hub is free & easy)
3. Run it in cloud run

The URL generated will be an ssh client. Connect to 127.0.0.1 on port 2222. Username Root. Use the private key corresponding to the public key you added to authorzed_keys
