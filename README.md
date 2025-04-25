![GitHub stars](https://img.shields.io/github/stars/MaestroNero/nero-vuln-scanner?style=social)

# 🛡️ Nero Vuln Scanner

![Tool Preview](https://i.imgur.com/uKaE9C9.png)

A powerful Linux-based vulnerability scanning tool built using Bash scripting. Designed to automate basic reconnaissance and scanning tasks using tools like `nmap`, `whois`, and `nuclei`.

---

## ⚙️ Installation (Kali Linux)

Use the following steps to install the tool on Kali Linux:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git curl nmap whois -y

git clone https://github.com/MaestroNero/nero-vuln-scanner.git
cd nero-vuln-scanner
chmod +x install.sh
sudo ./install.sh
```

---

## ✅ Post-Installation Steps

After installation is complete, run the following command to download the official `nuclei` templates (required for running nuclei scans):

```bash
cd /root
git clone https://github.com/projectdiscovery/nuclei-templates.git
mv /root/nuclei-templates/* $HOME/nuclei-templates/
```

> ⚠️ Make sure you are running as root when executing the above command, or use `sudo` if necessary.

---

## 📂 Directory Structure

```
nero-vuln-scanner/
├── install.sh         → Main installation script
├── scan.sh            → Scanning script
├── output/            → Directory to store scan results
└── README.md
```

---

## 🧠 Legal Disclaimer

This tool is intended for **educational and authorized testing purposes only**. Any misuse of this tool for attacking targets without prior mutual consent is strictly prohibited and against the law.

---

## 👨‍💻 Author

- Developer: **Maestro Nero**
- GitHub: [MaestroNero](https://github.com/MaestroNero)
- Telegram: [@CYBER_Nero](https://t.me/CYBER_Nero)
