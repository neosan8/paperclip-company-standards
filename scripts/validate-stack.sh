#!/bin/bash
# validate-stack.sh — Claude agent kurulumunu makine üzerinde denetler.
#
# NEDEN VAR:
# stack-standard.md her araç için "Validation check" yazıyor, ama bunlar düzyazı —
# birinin elle çalıştırmasını bekliyor. 2026-07-30'da referans makinede ölçüldü:
# standardı tanımlayan makinenin kendisi standardı karşılamıyordu, aylardır, sessizce.
#
#   gstack        standartta ZORUNLU · kurulu değil
#   tokenjuice    standartta ZORUNLU · 2 haftadır kırık (silinmiş node sürümüne bağlıydı)
#   88 skill      4 aydır ölü symlink (hedef dizin silinmiş)
#   healthd ntfy  68 gündür alarm gönderemiyor (sessiz hata)
#
# Ortak nokta: hiçbiri hata vermiyordu. Kurulum "çalışıyor" görünüyordu.
# Düzyazı standart bunu yakalayamaz; çalıştırılabilir denetim yakalar.
#
# KULLANIM:
#   ./scripts/validate-stack.sh          # özet
#   ./scripts/validate-stack.sh -v       # her kontrolün detayı
#
# ÇIKIŞ KODU: 0 = hepsi geçti · 1 = en az bir zorunlu kontrol başarısız

set -uo pipefail

VERBOSE=0
[ "${1:-}" = "-v" ] && VERBOSE=1

PASS=0; FAIL=0; WARN=0
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ok()   { PASS=$((PASS+1)); printf '  ✅ %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '  ❌ %s\n' "$1"; [ -n "${2:-}" ] && printf '       → %s\n' "$2"; }
warn() { WARN=$((WARN+1)); printf '  ⚠️  %s\n' "$1"; [ -n "${2:-}" ] && printf '       → %s\n' "$2"; }
head_() { printf '\n\033[1m%s\033[0m\n' "$1"; }

printf '\033[1mClaude Agent Stack — denetim\033[0m\n'
printf 'makine: %s · kullanıcı: %s · %s\n' "$(hostname -s)" "$(whoami)" "$(date '+%Y-%m-%d %H:%M')"

# ─────────────────────────────────────────────────────────────
head_ "1. Zorunlu araçlar (çalışıyor mu — sadece var mı değil)"
# Her araç GERÇEKTEN çalıştırılır. "Dosya var" yetmez: tokenjuice vakasında
# hook'un işaret ettiği yol vardı sanılıyordu, binary yoktu.

check_cli() {
  local name="$1" probe="$2" required="$3"
  local path
  if ! path=$(command -v "$name" 2>/dev/null); then
    if [ "$required" = "required" ]; then
      bad "$name — kurulu değil" "standartta zorunlu"
    else
      warn "$name — kurulu değil" "opsiyonel"
    fi
    return
  fi
  if eval "$probe" >/dev/null 2>&1; then
    ok "$name → $path"
  else
    bad "$name — kurulu ama çalışmıyor" "$path (probe başarısız: $probe)"
  fi
}

check_cli gbrain    "gbrain --help"     required
check_cli graphify  "graphify --help"   required
check_cli tokenjuice "tokenjuice --version" required
check_cli git       "git --version"     required
check_cli gh        "gh --version"      required

# gstack CLI diye bir şey YOK ve hiç olmadı — README'si "all slash commands, all
# Markdown" diyor. gstack bir skill koleksiyonu + bin/gstack-* yardımcılarıdır.
# İlk sürümde `gstack --help` aradım ve kalıcı bir yanlış hata ürettim: standardın
# metnine bakıp aracın ne olduğunu doğrulamadım. Doğru kontrol, skill'lerinin
# yüklü ve tarayıcı aracının çalışır olmasıdır.
if [ -d "$HOME/.claude/skills/gstack" ]; then
  n=0
  for s in browse qa ship investigate autoplan; do
    [ -e "$HOME/.claude/skills/$s" ] && n=$((n+1))
  done
  if [ "$n" -ge 4 ]; then
    ok "gstack — $n/5 çekirdek skill yüklü"
  else
    bad "gstack — yalnız $n/5 çekirdek skill" "repo var ama skill'ler kayıp; setup çalıştırılmamış olabilir"
  fi
  # browse gerçek tarayıcı QA'sını sağlar; Playwright'ın chromium'u yoksa çalışmaz.
  # Probe olarak `status` kullanılıyor — `--version` GEÇERLİ BİR KOMUT DEĞİL ve ilk
  # sürümde onu kullanıp aracı sağlamken "bozuk" raporlamıştım. Aracın kendi komut
  # listesine bakmadan CLI geleneği varsaymak, bugünün tekrar eden hatası.
  #
  # Ayrıca: browse çalıştığı dizine `.gstack/` yaratıyor. Denetleyici salt-okunur
  # bir cwd'den çalışırsa (healthd zamanlanmış işi `/` içinden çalıştırıyor) probe
  # `EROFS: read-only file system, mkdir '/.gstack'` ile düşüyor ve sağlam bir aracı
  # bozuk raporluyor — aynı yanlış-negatifin ikinci hâli. Yan etki olarak, denetleyici
  # hangi repodan çalıştırılırsa oraya `.gstack/` bırakıyordu.
  # Çözüm: probe'u geçici, yazılabilir bir dizinden çalıştır ve arkasını topla.
  BROWSE="$HOME/.claude/skills/gstack/browse/dist/browse"
  if [ -x "$BROWSE" ]; then
    _probe_dir="$(mktemp -d)"
    if (cd "$_probe_dir" && timeout 30 "$BROWSE" status 2>&1) | grep -q 'Status: healthy'; then
      ok "gstack browse — tarayıcı sağlıklı"
    else
      bad "gstack browse — tarayıcı ayağa kalkmıyor" "chromium eksikse: npx playwright install chromium-headless-shell"
    fi
    rm -rf "$_probe_dir"
  else
    bad "gstack browse — binary yok" "$BROWSE"
  fi
else
  bad "gstack — kurulu değil" "standartta zorunlu"
fi

# ─────────────────────────────────────────────────────────────
head_ "2. Hook bütünlüğü"
# Bugünün asıl dersi: settings.json bir komuta işaret ediyordu, komut yoktu,
# ve her Bash çağrısında sessizce boşa gidiyordu. Hiçbir yerde hata görünmüyordu.

SETTINGS="$HOME/.claude/settings.json"
if [ ! -f "$SETTINGS" ]; then
  warn "settings.json yok" "$SETTINGS"
else
  if ! jq -e . "$SETTINGS" >/dev/null 2>&1; then
    bad "settings.json geçersiz JSON" "$SETTINGS"
  else
    hook_cmds=$(jq -r '[.hooks // {} | .[]? | .[]? | .hooks[]? | .command] | .[]?' "$SETTINGS" 2>/dev/null)
    if [ -z "$hook_cmds" ]; then
      ok "hook tanımlı değil (sorun değil)"
    else
      while IFS= read -r cmd; do
        [ -z "$cmd" ] && continue
        # komutun ilk kelimesi = çalıştırılabilir yol
        bin=$(printf '%s' "$cmd" | awk '{print $1}')
        # $HOME gibi değişkenleri çöz
        bin_resolved=$(eval printf '%s' "$bin" 2>/dev/null || printf '%s' "$bin")
        if [ -x "$bin_resolved" ] || command -v "$bin_resolved" >/dev/null 2>&1; then
          ok "hook → $(basename "$bin_resolved")"
        else
          bad "hook kırık: $(basename "$bin_resolved")" "$bin_resolved bulunamadı — her tetiklenmede boşa gidiyor"
        fi
      done <<< "$hook_cmds"
    fi
  fi
fi

# ─────────────────────────────────────────────────────────────
head_ "3. Ölü skill bağlantıları"
# 88 skill 4 ay boyunca ölü symlink'ti: hedef dizin (başka bir aracın çalışma alanı)
# silinmişti. Skill'ler listede görünüyor, açılmıyordu.

SKILLS_DIR="$HOME/.claude/skills"
if [ ! -d "$SKILLS_DIR" ]; then
  warn "skills dizini yok" "$SKILLS_DIR"
else
  total=$(find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 2>/dev/null | wc -l | tr -d ' ')
  dead=$(find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l | tr -d ' ')
  if [ "$dead" -eq 0 ]; then
    ok "$total skill · ölü bağlantı yok"
  else
    bad "$dead / $total skill ölü symlink" "hedefleri silinmiş — listede görünür, açılmaz"
    if [ "$VERBOSE" -eq 1 ]; then
      find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null \
        | head -10 | sed 's|^|       · |'
    fi
  fi
fi

# ─────────────────────────────────────────────────────────────
head_ "4. Bilgi tabanı erişimi"
# Standart vault'u zorunlu kılıyor ama yolun gerçekten açıldığını kimse doğrulamıyordu.

VAULT="$HOME/Docs/paperclipcompanies/_knowledge-base"
if [ -d "$VAULT" ]; then
  n=$(find "$VAULT" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" -gt 0 ]; then
    ok "vault erişilebilir · $n not"
  else
    warn "vault var ama boş" "$VAULT"
  fi
else
  bad "vault bulunamadı" "$VAULT"
fi

# ─────────────────────────────────────────────────────────────
head_ "5. Karpathy disiplini yüklü mü"
# Davranış kuralı — dosya olarak mevcut mu diye bakılır, içeriği değil.

if grep -rqi 'karpathy' "$HOME/CLAUDE.md" "$HOME/.claude/CLAUDE.md" 2>/dev/null; then
  ok "Karpathy disiplini CLAUDE.md'de tanımlı"
else
  warn "Karpathy disiplini CLAUDE.md'de bulunamadı" "davranış kuralları yüklenmemiş olabilir"
fi

# ─────────────────────────────────────────────────────────────
printf '\n\033[1m─── SONUÇ ───\033[0m\n'
printf 'geçti: %d · başarısız: %d · uyarı: %d\n' "$PASS" "$FAIL" "$WARN"

if [ "$FAIL" -gt 0 ]; then
  printf '\n\033[31mStandart karşılanmıyor.\033[0m Yukarıdaki ❌ maddeleri düzeltilmeli.\n'
  printf 'Not: bunların hiçbiri kendiliğinden hata vermez — bu yüzden düzenli çalıştırılmalı.\n'
  exit 1
fi
printf '\n\033[32mStandart karşılanıyor.\033[0m\n'
exit 0
