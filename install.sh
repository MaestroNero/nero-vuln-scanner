#!/bin/bash
# 🌑 Maestro Nero Scanner
# Phase 1: Check and install required tools

LOG_FILE="setup.log"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee $LOG_FILE
echo "     🔐 Maestro Nero Scanner 🔐" | tee -a $LOG_FILE
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a $LOG_FILE
echo "[+] Checking dependencies..." | tee -a $LOG_FILE

# Function to install tool using apt and verify
install_tool() {
    TOOL_NAME="$1"
    APT_NAME="$2"
    DISPLAY_NAME="$3"
    ADDITIONAL_COMMAND="$4" # This is for any additional commands if needed

    echo -n "  - $DISPLAY_NAME      " | tee -a $LOG_FILE
    if command -v $TOOL_NAME &> /dev/null; then
        echo "[✅ Installed]" | tee -a $LOG_FILE
    else
        echo "[⏳ Installing...]" | tee -a $LOG_FILE
        sudo apt update -y &>> $LOG_FILE
        sudo apt install $APT_NAME -y &>> $LOG_FILE
        
        # If any additional setup is required for the tool (e.g., starting services), we do it here
        if [[ -n "$ADDITIONAL_COMMAND" ]]; then
            eval "$ADDITIONAL_COMMAND" &>> $LOG_FILE
        fi

        if command -v $TOOL_NAME &> /dev/null; then
            echo "...............................................................................................................................[✅ Installed]" | tee -a $LOG_FILE
            echo "  -> $DISPLAY_NAME installed successfully." | tee -a $LOG_FILE
        else
            echo "...............................................................................................................................[❌ Failed]" | tee -a $LOG_FILE
            echo "  -> ❌ Failed to install $DISPLAY_NAME!" | tee -a $LOG_FILE
        fi
    fi
}

# Install required tools
install_tool "nuclei" "nuclei" "Nuclei"
install_tool "nmap" "nmap" "Nmap"
install_tool "msfconsole" "metasploit-framework" "Metasploit Framework"
install_tool "openvas" "openvas" "OpenVAS" "sudo gvm-setup && sudo gvm-start"
install_tool "nikto" "nikto" "Nikto"

echo "[+] All dependencies checked and installed." | tee -a $LOG_FILE
