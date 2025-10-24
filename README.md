# Oberlab Workstations

> Ansible playbook for provisioning workstations used at Oberlab for courses and for general use by members and guests.

This playbook is intended to run against Linux Mint 22.04 workstations. Upon first run, it will configure a cron job executing ansible-pull to keep the workstation up to date.

## Machine Types
Different configurations and software packages are required for different applications. This tool defines several machine types (groups) to choose from. Each machine can be a member of one or more groups. The following groups are available:

- General Purpose (`base`)
- 2D Graphics (`2d-graphics`)
- 3D Printing (`3d-printing`)
- Arduino Microcontrollers (`arduino`)

The list of groups a workstation belongs to can be set in different ways, the default being set in `host_vars/localhost.yaml`.

## First Time Setup
1. Install Linux Mint 22.04 on the workstation.
2. Connect the workstation to the internet.
3. Install the vault password file (get it from one of the co-admins):
   ```bash
   sudo cp /path/to/vault_password_file /etc/pull-vault-pass.txt
   sudo chmod 644 /etc/pull-vault-pass.txt
   ```
4. Install required packages:
   ```bash
   sudo apt update
   sudo apt install -y git ansible
   ```
5. Clone this repository:
   ```bash
   git clone https://github.com/oberlab/ansible-workstations.git
   ```
6. Navigate to the cloned directory and run the initial setup playbook:
   ```bash
   cd ansible-workstations
   # When the script prompts for the "BECOME" password, enter your sudo password.
   ./setup.sh
   ```

## Regular Updates
The playbook will set up unattended-upgrades to keep the system updated with security patches.

Furthermore, a cron job will be created to run ansible-pull every hour to ensure the workstation stays in sync with the latest configurations and software installations defined in this repository.

## Playbook Details

### Add/Remove Software (Groups)
Define sofware groups and packages in `vars/software.yaml`. Read the file to understand the structure.

The groups to be installed on a specific machine can be overridden via the usual means provided by ansible. Defaults for localhost are set in `host_vars/localhost.yaml`.

### Desktop Configuration
Desktop configuration parameters can be set in `vars/config.yaml`. The file contains a list of dconf settings to be applied to the workstation.

### Secrets Management
Sensitive information such as Wi-Fi passwords and user credentials are managed using [Ansible Vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html). It allows us to add Secrets to our playbooks without exposing them in plain text. The vault is encrypted using a password stored in a gitignored `.vault_pass` file. Never add the password file to version control! Obtain The vault password file from one of the co-admins and keep it gitignored.

**WARNING: Never decrypt the vault!** It might end up in version control in its decrypted form. Instead, edit the vault file and re-encrypt it using:

```bash
ansible-vault edit vars/vault.yaml
```
