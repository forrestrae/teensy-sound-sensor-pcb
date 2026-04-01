#!/usr/bin/env zsh

# Extracting the logic into a reusable function
extract_pcb_component() {
    local ref_designator="$1"
    local output_name="$2"
    local source_pcb="Sound Sensor Teensy Carrier.kicad_pcb"
    local output_dir="output/$output_name"

    echo "Processing $output_name (Ref: $ref_designator)..."

    rm -rf "$output_dir"
    mkdir -p "$output_dir"

    # Using the output directory directly in kikit to avoid manual directory switching
    kikit separate \
        --source "annotation; ref: $ref_designator" \
        "$source_pcb" \
        "$output_dir/$output_name.kicad_pcb"
}

# Process components
# extract_pcb_component "B1" "carrier"
extract_pcb_component "B2" "batt_protector"
#extract_pcb_component "B3" "mic_boom"
#extract_pcb_component "B4" "uv_led_high_power"
# extract_pcb_component "B6" "white_led"
