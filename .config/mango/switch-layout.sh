#!/usr/bin/env bash
set -euo pipefail

CACHE="${HOME}/.cache/mango-layouts.txt"
mkdir -p "${CACHE%/*}"

########################################
# 1. Load old layout state (if any)
########################################
declare -A old_layouts
if [ -f "$CACHE" ]; then
  while read -r out code; do
    [ -z "$out" ] && continue
    old_layouts["$out"]="$code"
  done < <(awk '{print $1, $NF}' "$CACHE")
fi

########################################
# 2. Switch layout (on whatever monitor Mango decides)
########################################
mmsg -d switch_layout

# tiny delay so mango updates state
sleep 0.05

########################################
# 3. Read new layout state for all outputs
#    Example lines: "DP-2 layout VG"
########################################
declare -A new_layouts
mapfile -t lines < <(mmsg -g -l)

for line in "${lines[@]}"; do
  # Expect: <output> layout <code>
  set -- $line
  [ $# -lt 3 ] && continue
  out="$1"
  code="${!#}"   # last field
  new_layouts["$out"]="$code"
done

########################################
# 4. Find which output actually changed
########################################
changed_output=""
changed_code=""

for out in "${!new_layouts[@]}"; do
  new_code="${new_layouts[$out]}"
  old_code="${old_layouts[$out]:-}"
  if [ "$new_code" != "$old_code" ]; then
    changed_output="$out"
    changed_code="$new_code"
    break
  fi
done

# Fallback: on first run, just pick the first line
if [ -z "$changed_output" ]; then
  if [ "${#new_layouts[@]}" -gt 0 ]; then
    # pick the first key in the assoc array
    for out in "${!new_layouts[@]}"; do
      changed_output="$out"
      changed_code="${new_layouts[$out]}"
      break
    done
  else
    changed_output="unknown"
    changed_code="unknown"
  fi
fi

########################################
# 5. Map layout code -> human-readable name
########################################
code="$changed_code"
case "$code" in
  # base layouts (from mmsg README) 
  S)      name="Scroller" ;;
  T)      name="Tile" ;;
  G)      name="Grid" ;;
  M)      name="Monocle" ;;
  K|D)    name="Deck" ;;
  CT|C)   name="Center Tile" ;;
  VS)     name="Vertical Scroller" ;;
  VT|VK)  name="Vertical Tile" ;;

  # extra layouts from Mango wiki (tagrule layout_name) 
  VG)     name="Vertical Grid" ;;
  RT)     name="Right Tile" ;;
  VD)     name="Vertical Deck" ;;
  VSPI|VSP|VSPIRAL) name="Vertical Spiral" ;; # in case your build abbreviates it

  # fallback: show the raw code
  *)      name="$code" ;;
esac

########################################
# 6. Save new state for next run
########################################
: > "$CACHE"
for out in "${!new_layouts[@]}"; do
  printf '%s %s\n' "$out" "${new_layouts[$out]}" >> "$CACHE"
done

########################################
# 7. Notify (minimal style you asked for)
########################################
notify-send "Layout" "$name"
