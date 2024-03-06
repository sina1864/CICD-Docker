
# CI/CD-Docker

Sample CI/CD Project - Using GitHub Actions with Docker on Ubuntu 22.04

## Deployment

Steps to deploy this project:

**Step 1 (Genrerate SSH Key):**

Create a secure directory for SSH keys (~/.ssh) and restricts access to the authorized_keys file.
```bash
  mkdir ~/.ssh
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys
```

Generate SSH key:
```bash
  cd ~/.ssh
  ssh-keygen -t rsa -b 4096 -C "test@gmail.com"
```
- assign name and passphrase for the SSH key

Save the public SSH key in the server:
```bash
  cat github-actions.pub >> ~/.ssh/authorized_keys
```

View the private SHH key:
```bash
  nano github-actions
```
- copy and save the private SSH key (which will be used as GitHub secret in the future)

Enable SSH key authentication for the SSH key type:
```bash
  nano /etc/ssh/sshd_config
```
- add this line of command: `PubkeyAcceptedKeyTypes=+ssh-rsa`
- restart the SSH service:
```bash
  sudo systemctl restart ssh
```

**Step 2 (Install Docker):**

Install Docker on server:
```bash
  sudo apt update
  sudo apt install ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io
```

**Step 3 (Create Dockerfile):**

Create a Dockerfile for your project in the root directory (beside the project solution file). Use this project's Dockerfile.

**Step 4 (Define GitHub secrets):**

Define the secrets that will be used in the GitHub Actions YAML file:

```
DOCKERHUB_USERNAME : docker_username
DOCKERHUB_TOKEN : docker_token (from: https://hub.docker.com/settings/security)
SSH_HOST : server_ip
SSH_USERNAME : root
SSH_KEY : private_key
SSH_PASSPHRASE : some_password
```

**Step 5 (Define GitHub actions):**

Define the GitHub Actions YAML file (use this project's YAML file).

**Step 6 (Obtain SSL certificate):**

Connect your domain to the server's IP by using an A record.

Install Certbot as a Snap package, create a symbolic link to make it globally accessible, and then use Certbot to obtain an SSL certificate for the Nginx server:
```bash
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --nginx
```
- add your email address and domain and also accept the rules (Y).

**Step 7 (Re-run the GitHub action):**

Re-run all jobs of your last GitHub push and then go to `https://your_domain/swagger/index.html` to view your website.
