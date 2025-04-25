#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Spinner function
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\\'
  while [ -d /proc/$pid ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%$temp}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Title
clear
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "     🔐 Maestro Nero Scanner 🔐"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Ask for input
echo -ne "[+] Enter target IP or URL: \n"
read target

# Tool Check Function
check_tool() {
  command -v $1 > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "[✅ $1 is installed]"
  else
    echo -e "[❌ $1 is not installed. Please install it first.]"
    exit 1
  fi
}

# Check required tools
echo -e "[+] Checking required tools..."
check_tool nmap
check_tool nuclei
check_tool msfconsole

# Nuclei templates check
echo -e "[+] Checking if nuclei templates are installed..."
if [ ! -d "$HOME/nuclei-templates" ]; then
  echo -e "[❌ Templates directory not found. Creating the directory...]"
  echo -e "[+] Downloading Nuclei templates..."
  nuclei -update -ut -ud $HOME/nuclei-templates &> /dev/null &
  spinner $!
else
  echo -e "[✅ Templates directory found. Updating... ]"
  nuclei -update -ut -ud $HOME/nuclei-templates &> /dev/null &
  spinner $!
fi

# Save output to variable
OUTPUT=""

# Nmap Scan
echo -e "[+] Starting Nmap Scan..."
NMAP_RESULT=$(nmap $target)
OUTPUT+="\n[+] Open Ports and Services:\n$NMAP_RESULT\n"

# Nuclei Scan
echo -e "[+] Starting Vulnerability Scan..."
NUCLEI_RESULT=$(nuclei -target $target -ud $HOME/nuclei-templates)
OUTPUT+="\n[+] Vulnerability Findings:\n$NUCLEI_RESULT\n"

# Metasploit Headers Scan
echo -e "[+] Running HTTP Headers Check..."
HEADERS_RESULT=$(timeout 120s msfconsole -q -x "use auxiliary/scanner/http/headers; set RHOSTS $target; run; exit" 2>/dev/null)
if [[ "$HEADERS_RESULT" == *"Failed to load module"* ]]; then
  echo -e "[❌ Module failed to load. Attempting to reload... ]"
  msfconsole -q -x "reload_all; exit"
  sleep 5
  HEADERS_RESULT=$(timeout 120s msfconsole -q -x "use auxiliary/scanner/http/headers; set RHOSTS $target; run; exit" 2>/dev/null)
fi
if [[ "$HEADERS_RESULT" == *"Unknown command: run"* ]]; then
  HEADERS_RESULT="[-] Module execution failed due to unknown command."
fi
OUTPUT+="\n[+] HTTP Headers Information:\n$HEADERS_RESULT\n"

# Show results cleanly
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Results of the scan for target: $target"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n$OUTPUT"

# Ask to save
echo -ne "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -ne "\nDo you want to save the results to a text file? (y/n): "
read save_choice
if [[ "$save_choice" == "y" || "$save_choice" == "Y" ]]; then
  filename="scan_results_$(date +%Y%m%d_%H%M%S).txt"
  echo -e "$OUTPUT" > "$filename"
  echo -e "[✅ Results saved to $filename]"
else
  echo -e "[+] Results were not saved."
fi

echo -e "[+] Scanning completed. Thank you for using Maestro Nero Scanner!"
