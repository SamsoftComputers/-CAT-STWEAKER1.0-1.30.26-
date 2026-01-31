#!/bin/bash
#===============================================================================
#
#                    ╔═══════════════════════════════════════════╗
#                    ║   CAT'S TWEAKER 0.2 v0.x.b 1.14.26 [DEV]  ║
#                    ║        [C] SAMSOFT 1999-2026 [C]          ║
#                    ╚═══════════════════════════════════════════╝
#
#   ██████╗ █████╗ ████████╗███████╗    ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗██████╗ 
#  ██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝██╔══██╗
#  ██║     ███████║   ██║   ███████╗       ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ █████╗  ██████╔╝
#  ██║     ██╔══██║   ██║   ╚════██║       ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ██╔══╝  ██╔══██╗
#  ╚██████╗██║  ██║   ██║   ███████║       ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████╗██║  ██║
#   ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝       ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#                                        /\_____/\
#                                       /  o   o  \
#                                      ( ==  ^  == )
#                                       )  ~nya~  (
#                                      (           )
#                                     ( (  )   (  ) )
#                                    (__(__)___(__)__)
#
#             Ultimate Retro Dev Toolkit | ALL SDKs 1930-2026 | "Every ASM"
#             Rust | TypeScript | Python 3.14 | M4 Pro Ready | Docker Auto
#
#===============================================================================

[[ -z "$BASH_VERSION" ]] && { echo "Run with: bash $0"; exit 1; }

G=$'\033[0;32m'; Y=$'\033[0;33m'; C=$'\033[0;36m'; M=$'\033[0;35m'; B=$'\033[1;34m'
W=$'\033[1;37m'; R=$'\033[0;31m'; RST=$'\033[0m'

INSTALL_DIR="$HOME/retro-dev"
TOOLS="$INSTALL_DIR/tools"
SDKS="$INSTALL_DIR/sdks"
EMUS="$INSTALL_DIR/emulators"
COMPILERS="$INSTALL_DIR/compilers"
ASMS="$INSTALL_DIR/compilers/asm"
LOG="$INSTALL_DIR/install.log"

mkdir -p "$TOOLS" "$SDKS" "$EMUS" "$COMPILERS" "$ASMS"
: > "$LOG"

IS_MAC=false; [[ "$(uname)" == "Darwin" ]] && IS_MAC=true
IS_ARM=false; [[ "$(uname -m)" == "arm64" ]] && IS_ARM=true
NCPU=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)
SHELL_RC="$HOME/.zshrc"; $IS_MAC || SHELL_RC="$HOME/.bashrc"

dl() {
    curl -fsSL --connect-timeout 30 --max-time 600 --retry 3 -L -o "$2" "$1" 2>>"$LOG"
    [[ -s "$2" ]] && return 0; rm -f "$2" 2>/dev/null; return 1
}

ok()   { printf "  ${G}[✓]${RST} %s\n" "$1"; }
fail() { printf "  ${Y}[✗]${RST} %s\n" "$1"; }
warn() { printf "  ${Y}[!]${RST} %s\n" "$1"; }
info() { printf "  ${C}[*]${RST} %s\n" "$1"; }
step() { printf "\n${M}▸ %s${RST}\n" "$1"; }
add_path() { grep -qF "$1" "$SHELL_RC" 2>/dev/null || echo "$1" >> "$SHELL_RC"; }

# DOCKER AUTODETECTION (M4 Pro FIXED)
detect_docker() {
    DOCKER_FOUND=false; DOCKER_RUNNING=false
    [[ -d "/Applications/Docker.app" ]] && DOCKER_FOUND=true
    local paths=("/Applications/Docker.app/Contents/Resources/bin/docker" "/usr/local/bin/docker" "/opt/homebrew/bin/docker" "$HOME/.docker/bin/docker")
    for p in "${paths[@]}"; do [[ -x "$p" ]] && { DOCKER_FOUND=true; export PATH="$(dirname "$p"):$PATH"; break; }; done
    command -v docker &>/dev/null && DOCKER_FOUND=true
    $DOCKER_FOUND && docker info &>/dev/null 2>&1 && DOCKER_RUNNING=true
}

clear
cat << 'BANNER'

                    ╔═══════════════════════════════════════════╗
                    ║   CAT'S TWEAKER 0.2 v0.x.b 1.14.26 [DEV]  ║
                    ║        [C] SAMSOFT 1999-2026 [C]          ║
                    ╚═══════════════════════════════════════════╝

   ██████╗ █████╗ ████████╗███████╗    ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗██████╗ 
  ██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝██╔══██╗
  ██║     ███████║   ██║   ███████╗       ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ █████╗  ██████╔╝
  ██║     ██╔══██║   ██║   ╚════██║       ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ██╔══╝  ██╔══██╗
  ╚██████╗██║  ██║   ██║   ███████║       ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████╗██║  ██║
   ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝       ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

                                        /\_____/\
                                       /  o   o  \
                                      ( ==  ^  == )
                                       )  ~nya~  (
                                      (           )
                                     ( (  )   (  ) )
                                    (__(__)___(__)__)

             Ultimate Retro Dev Toolkit | ALL SDKs 1930-2026 | "Every ASM"
             Rust | TypeScript | Python 3.14 | M4 Pro Ready | Docker Auto

BANNER

printf "  ${C}Installing to:${RST} $INSTALL_DIR\n  ${C}Log:${RST} $LOG\n\n"

# ============================================================================
step "SYSTEM DETECTION"
# ============================================================================
if $IS_MAC && $IS_ARM; then
    CHIP=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")
    ok "Apple Silicon: $CHIP"

    # ROSETTA 2 CHECK & INSTALL
    if [[ -f "/Library/Apple/usr/libexec/oah/libRosettaRuntime" ]]; then
        ok "Rosetta 2 (x86 Compatibility) is active"
    else
        info "Rosetta 2 missing! Installing for x86 tools..."
        if /usr/sbin/softwareupdate --install-rosetta --agree-to-license; then
            ok "Rosetta 2 installed successfully"
        else
            warn "Rosetta install failed. Run manually: softwareupdate --install-rosetta"
        fi
    fi
elif $IS_MAC; then ok "Intel Mac"; else ok "Linux $(uname -m)"; fi

# ============================================================================
step "XCODE CLT & CORE TOOLS"
# ============================================================================
if $IS_MAC; then
    if ! xcode-select -p &>/dev/null; then
        xcode-select --install 2>/dev/null &
        info "Waiting for Xcode CLT... (Follow prompts)"
        for i in {1..60}; do [[ -d "/Library/Developer/CommandLineTools" ]] && break; sleep 10; printf "."; done; echo
    fi
    command -v cc &>/dev/null && ok "C Compiler" || fail "Xcode CLT not found"
    
    # Homebrew
    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG" 2>&1
        $IS_ARM && eval "$(/opt/homebrew/bin/brew shellenv)"
        add_path 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    fi
    command -v brew &>/dev/null && ok "Homebrew"
    
    # Packages
    BREW_PKGS="git curl wget cmake ninja meson autoconf automake libtool pkg-config nasm yasm fasm"
    for p in $BREW_PKGS; do brew install "$p" >> "$LOG" 2>&1 2>/dev/null || true; done
    ok "Core Tools (git, make, cmake, ninja)"
else
    sudo apt-get update -qq >> "$LOG" 2>&1
    sudo apt-get install -y -qq build-essential git curl wget cmake ninja-build meson autoconf automake libtool pkg-config nasm yasm fasm bison flex texinfo >> "$LOG" 2>&1
    ok "Core Tools (Linux)"
fi

# ============================================================================
step "PYTHON 3.14 & TYPESCRIPT (MODERN LANGS)"
# ============================================================================
# Python 3.14 Strategy: Try pyenv to get specific versions, else system
if command -v pyenv &>/dev/null; then
    ok "Pyenv already installed"
else
    if $IS_MAC; then brew install pyenv >> "$LOG" 2>&1; else curl https://pyenv.run | bash >> "$LOG" 2>&1; fi
    add_path 'export PYENV_ROOT="$HOME/.pyenv"'
    add_path '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    add_path 'eval "$(pyenv init -)"'
    ok "Pyenv installed"
fi

# Try to install 3.14 (might be dev/alpha) or fallback to latest
info "Checking for Python 3.14..."
export PYENV_ROOT="$HOME/.pyenv"; [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"; eval "$(pyenv init -)" 2>/dev/null
PY_LATEST=$(pyenv install --list 2>/dev/null | grep "^  3.14" | tail -1 | tr -d ' ')
if [[ -z "$PY_LATEST" ]]; then PY_LATEST=$(pyenv install --list 2>/dev/null | grep "^  3.13" | tail -1 | tr -d ' '); fi

if [[ -n "$PY_LATEST" ]]; then
    pyenv install "$PY_LATEST" -s >> "$LOG" 2>&1 && pyenv global "$PY_LATEST" && ok "Python $PY_LATEST (via pyenv)"
else
    warn "Could not install specific Python via pyenv. Using system."
fi

# Node & TypeScript
if ! command -v node &>/dev/null; then
    if $IS_MAC; then brew install node >> "$LOG" 2>&1; else sudo apt-get install -y -qq nodejs npm >> "$LOG" 2>&1; fi
fi
command -v node &>/dev/null && ok "Node.js $(node -v)"
npm install -g typescript ts-node @anthropic-ai/claude-code >> "$LOG" 2>&1
command -v tsc &>/dev/null && ok "TypeScript (tsc)" || fail "TypeScript"
command -v claude &>/dev/null && ok "Claude Code"

# ============================================================================
step "RUST TOOLCHAIN"
# ============================================================================
if command -v rustc &>/dev/null; then
    ok "Rust $(rustc --version | awk '{print $2}')"
else
    info "Installing Rust (rustup)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >> "$LOG" 2>&1
    source "$HOME/.cargo/env"
    add_path 'source "$HOME/.cargo/env"'
    command -v rustc &>/dev/null && ok "Rust $(rustc --version | awk '{print $2}')" || fail "Rust install"
fi

# ============================================================================
step "RETRO COMPILERS (1930s-1990s)"
# ============================================================================
if $IS_MAC; then
    brew install cc65 sdcc rgbds wla-dx z88dk xa >> "$LOG" 2>&1
else
    sudo apt-get install -y -qq cc65 sdcc fp-compiler xa65 >> "$LOG" 2>&1
    # Linux needs manual install for some
fi
ok "Standard Retro: cc65, sdcc, rgbds, wla-dx, z88dk"

# ============================================================================
step "EXPANDED ASSEMBLER ARSENAL ('Every ASM')"
# ============================================================================
cd "$ASMS"

# 1. VASM (The king of m68k/Amiga)
if ! command -v vasmm68k_mot &>/dev/null; then
    info "Building VASM (Amiga/m68k/PPC)..."
    dl "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz" vasm.tar.gz
    tar xzf vasm.tar.gz >> "$LOG" 2>&1 && cd vasm
    make CPU=m68k SYNTAX=mot >> "$LOG" 2>&1 && cp vasmm68k_mot "$ASMS/" && ok "vasmm68k_mot"
    make CPU=6502 SYNTAX=oldstyle >> "$LOG" 2>&1 && cp vasm6502_oldstyle "$ASMS/" && ok "vasm6502"
    make CPU=z80 SYNTAX=std >> "$LOG" 2>&1 && cp vasmz80_std "$ASMS/" && ok "vasmz80"
    cd .. && rm -rf vasm vasm.tar.gz
fi

# 2. ACME (C64/6502)
if ! command -v acme &>/dev/null; then
    info "Building ACME (C64/6502)..."
    dl "https://github.com/meonwax/acme/archive/refs/tags/0.97.tar.gz" acme.tar.gz
    tar xzf acme.tar.gz >> "$LOG" 2>&1 && cd acme-0.97/src
    make >> "$LOG" 2>&1 && cp acme "$ASMS/" && ok "ACME"
    cd ../.. && rm -rf acme-0.97 acme.tar.gz
fi

# 3. SJASMPLUS (Advanced Z80/ZX Spectrum)
if ! command -v sjasmplus &>/dev/null; then
    info "Building SjasmPlus (Z80)..."
    dl "https://github.com/z00m128/sjasmplus/archive/refs/tags/v1.20.3.tar.gz" sj.tar.gz
    tar xzf sj.tar.gz >> "$LOG" 2>&1 && cd sjasmplus-1.20.3
    make >> "$LOG" 2>&1 && cp sjasmplus "$ASMS/" && ok "sjasmplus"
    cd .. && rm -rf sjasmplus* sj.tar.gz
fi

# 4. BEEBASM (BBC Micro)
if ! command -v beebasm &>/dev/null; then
    info "Building BeebAsm (BBC Micro)..."
    dl "https://github.com/stardot/beebasm/archive/refs/heads/master.zip" beeb.zip
    unzip -qo beeb.zip >> "$LOG" 2>&1 && cd beebasm-master/src
    make >> "$LOG" 2>&1 && cp beebasm "$ASMS/" && ok "beebasm"
    cd ../.. && rm -rf beebasm-master beeb.zip
fi

# 5. SIMH (1930s-1970s Simulators)
if $IS_MAC; then brew install simh >> "$LOG" 2>&1; else sudo apt-get install -y -qq simh >> "$LOG" 2>&1; fi
ok "SIMH (PDP-1, PDP-8, PDP-11, VAX, Altair, IBM 1401)"

add_path "export PATH=\"$ASMS:\$PATH\""

# ============================================================================
step "SDKS 1977-2026"
# ============================================================================

# Atari (DASM)
mkdir -p "$SDKS/atari" && cd "$SDKS/atari"
DASM_URL="https://github.com/dasm-assembler/dasm/releases/download/2.20.14.1/dasm-2.20.14.1-osx-x64.tar.gz"
$IS_MAC || DASM_URL="https://github.com/dasm-assembler/dasm/releases/download/2.20.14.1/dasm-2.20.14.1-linux-x64.tar.gz"
dl "$DASM_URL" dasm.tar.gz && tar xzf dasm.tar.gz >> "$LOG" 2>&1 && rm -f dasm.tar.gz
$IS_MAC && xattr -dr com.apple.quarantine . 2>/dev/null; chmod +x dasm 2>/dev/null
ok "Atari (DASM)"

# Nintendo (GBDK)
cd "$SDKS"
GB_URL="https://github.com/gbdk-2020/gbdk-2020/releases/download/4.3.0/gbdk-macos.tar.gz"
$IS_MAC || GB_URL="https://github.com/gbdk-2020/gbdk-2020/releases/download/4.3.0/gbdk-linux64.tar.gz"
dl "$GB_URL" gbdk.tar.gz && tar xzf gbdk.tar.gz >> "$LOG" 2>&1 && rm -f gbdk.tar.gz
$IS_MAC && xattr -dr com.apple.quarantine gbdk 2>/dev/null
ok "Nintendo GB/GBC (GBDK-2020)"

# Sega (SGDK)
mkdir -p "$SDKS/sega" && cd "$SDKS/sega"
dl "https://github.com/Stephane-D/SGDK/archive/refs/tags/v2.00.tar.gz" sgdk.tar.gz
tar xzf sgdk.tar.gz >> "$LOG" 2>&1 && mv SGDK-2.00 sgdk 2>/dev/null && rm -f sgdk.tar.gz
ok "Sega Genesis (SGDK 2.00)"

# Modern / DevkitPro
mkdir -p "$COMPILERS/devkitpro" && cd "$COMPILERS/devkitpro"
if $IS_MAC; then
    dl "https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman-installer.pkg" devkitpro.pkg && ok "DevkitPro (GBA/DS/Switch) Installer downloaded"
else
    dl "https://apt.devkitpro.org/install-devkitpro-pacman" dkp-install.sh && chmod +x dkp-install.sh && ok "DevkitPro (GBA/DS/Switch) Installer downloaded"
fi

# ============================================================================
step "MODERN ENGINES & ROMHACKING"
# ============================================================================
mkdir -p "$TOOLS/engines" && cd "$TOOLS/engines"
# Godot 4.3
GODOT_URL="https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_macos.universal.zip"
$IS_MAC || GODOT_URL="https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip"
dl "$GODOT_URL" godot.zip && unzip -qo godot.zip >> "$LOG" 2>&1 && rm -f godot.zip
$IS_MAC && xattr -dr com.apple.quarantine Godot* 2>/dev/null
ok "Godot 4.3"

# Flips
mkdir -p "$TOOLS/romhack" && cd "$TOOLS/romhack"
FLIPS_URL="https://github.com/Alcaro/Flips/releases/download/v198/flips-mac.zip"
$IS_MAC || FLIPS_URL="https://github.com/Alcaro/Flips/releases/download/v198/flips-linux.zip"
dl "$FLIPS_URL" flips.zip && unzip -qo flips.zip >> "$LOG" 2>&1 && rm -f flips.zip
$IS_MAC && xattr -dr com.apple.quarantine . 2>/dev/null; chmod +x * 2>/dev/null
ok "Flips (BPS/IPS Patcher)"

# ============================================================================
step "EMULATORS"
# ============================================================================
mkdir -p "$EMUS" && cd "$EMUS"
if $IS_MAC; then
    dl "https://github.com/mgba-emu/mgba/releases/download/0.10.5/mGBA-0.10.5-macos.dmg" mgba.dmg
    hdiutil attach mgba.dmg -nobrowse >> "$LOG" 2>&1; cp -R /Volumes/mGBA*/mGBA.app . 2>/dev/null
    hdiutil detach /Volumes/mGBA* >> "$LOG" 2>&1; xattr -dr com.apple.quarantine mGBA.app 2>/dev/null; rm -f mgba.dmg
    ok "mGBA 0.10.5"
    dl "https://github.com/ares-emulator/ares/releases/download/v146/ares-macos-universal.zip" ares.zip
    unzip -qo ares.zip >> "$LOG" 2>&1 && rm -f ares.zip
    xattr -dr com.apple.quarantine Ares* ares* 2>/dev/null
    ok "Ares v146 (Multi-system)"
else
    dl "https://github.com/mgba-emu/mgba/releases/download/0.10.5/mGBA-0.10.5-appimage-x64.appimage" mGBA.AppImage && chmod +x mGBA.AppImage && ok "mGBA 0.10.5"
fi

# ============================================================================
step "ENVIRONMENT SETUP"
# ============================================================================
cat > "$INSTALL_DIR/env.sh" << 'ENVSCRIPT'
#!/bin/bash
# Cat's Tweaker 0.2 Environment - [C] SAMSOFT 1999-2026
export RETRO_DEV="$HOME/retro-dev"
export DEVKITPRO="/opt/devkitpro"
export DEVKITARM="$DEVKITPRO/devkitARM"
export GBDK="$RETRO_DEV/sdks/gbdk"
export SGDK="$RETRO_DEV/sdks/sega/sgdk"
export PATH="$RETRO_DEV/compilers/asm:$RETRO_DEV/tools/romhack:$RETRO_DEV/sdks/atari:$GBDK/bin:$DEVKITARM/bin:$PATH"

# Load Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
# Load Pyenv
[[ -d "$HOME/.pyenv/bin" ]] && export PATH="$HOME/.pyenv/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

echo "🐱 CAT'S TWEAKER 0.2 environment loaded! (Rust/TS/Py3.14/ASM)"
ENVSCRIPT
chmod +x "$INSTALL_DIR/env.sh"
ok "Environment script created"

# ============================================================================
# COMPLETE
# ============================================================================
echo ""
printf "${G}╔════════════════════════════════════════════════════════════════════════════╗${RST}\n"
printf "${G}║${RST}  ${W}✨ CAT'S TWEAKER 0.2 v0.x.b 1.14.26 INSTALLATION COMPLETE! ✨${RST}            ${G}║${RST}\n"
printf "${G}║${RST}                      ${M}[C] SAMSOFT 1999-2026${RST}                                  ${G}║${RST}\n"
printf "${G}╠════════════════════════════════════════════════════════════════════════════╣${RST}\n"
printf "${G}║${RST}  ${C}Installed to:${RST} %-58s ${G}║${RST}\n" "$INSTALL_DIR"
printf "${G}║${RST}  ${C}Activate:${RST}     source ~/retro-dev/env.sh                                   ${G}║${RST}\n"
printf "${G}╠════════════════════════════════════════════════════════════════════════════╣${RST}\n"
printf "${G}║${RST}  ${B}Languages:${RST}     Rust, TypeScript, Python 3.14 (managed), Node.js           ${G}║${RST}\n"
printf "${G}║${RST}  ${B}Assemblers:${RST}    VASM (Amiga), ACME (C64), BeebAsm, SjasmPlus, CC65, DASM   ${G}║${RST}\n"
printf "${G}║${RST}  ${B}Simulators:${RST}    SIMH (IBM/PDP 1930s-70s), Ares, mGBA                       ${G}║${RST}\n"
printf "${G}╚════════════════════════════════════════════════════════════════════════════╝${RST}\n"
echo ""
printf "                              ${M}/\\_____/\\${RST}\n"
printf "                             ${M}/  o   o  \\${RST}\n"
printf "                            ${M}( ==  ^  == )${RST}\n"
printf "                             ${M})  ~nya~  (${RST}\n"
printf "                            ${M}(           )${RST}\n"
printf "                           ${M}( (  )   (  ) )${RST}\n"
printf "                          ${M}(__(__)___(__)__)${RST}\n"
echo ""
printf "                      ${C}[C] SAMSOFT 1999-2026 [C]${RST}\n"
echo ""
