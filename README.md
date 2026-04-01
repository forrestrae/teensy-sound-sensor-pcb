# Sound Sensor Teensy Carrier

A KiCad 9.0 carrier board for the Teensy 4.x microcontroller, designed for real-time audio sensing with USB-C Power Delivery input, 4S Li-ion battery management, I2S MEMS microphone, and LED lighting outputs.

## Features

- **USB-C Power Delivery** — TPS25751 PD controller with EEPROM configuration; accepts standard 5 V USB or negotiated PD voltages
- **4S Li-ion Battery System** — BQ25798 charger, BQ7791500 multi-cell protection (30 A rated), and Infineon N-channel disconnect FET
- **Regulated Power Rails** — 5 V and 3.3 V via TPS54538 synchronous buck converter
- **I2S MEMS Microphone** — TDK ICS-43434 with direct I2S2 connection to Teensy
- **Dual LED Drivers** — TPS923652 (white, ADIM + PWM) and TPS92200D2 (UV-A 3535, PWM)
- **Multi-board panel** — PCB ships as a panel; individual sub-boards extracted with kikit

## Hardware Overview

### Schematic Architecture

The design uses KiCad hierarchical sheets:

| Page | Sub-sheet | File |
|------|-----------|------|
| 1 | Top level | `Sound Sensor Teensy Carrier.kicad_sch` |
| 2 | USB-C Connector | `usb-c-connector.kicad_sch` |
| 3 | USB-PD Controller | `usb-pd-controller.kicad_sch` |
| 4 | Battery Charger | `battery-charger.kicad_sch` |
| 5 | DC Converters | `dc-converters.kicad_sch` |
| 6 | MCU | `mcu.kicad_sch` |
| 7 | Battery Protector | `battery_protector.kicad_sch` |
| 8 | Mic Boom | `mic_boom.kicad_sch` |
| 9 | WL-SUMW UV LED Board | `wl-sumw_uv_led_board.kicad_sch` |
| 10 | White LED Board | `white_led_board.kicad_sch` |

### Power Architecture

```
USB-C (5 V–20 V PD)
  └─ TPS25751 USB-PD Controller
       └─ VBUS / +5 V rail
            ├─ TPS54538 Buck → +3.3 V (MCU, logic, microphone)
            └─ BQ25798 Charger → 4S Li-ion pack (14.8 V–16.8 V)
                                    └─ BQ7791500 Protection
```

### Key Components

| Function | Part | Manufacturer |
|----------|------|--------------|
| USB-PD Controller | TPS25751DREFR | Texas Instruments |
| PD Config EEPROM | 24LC256-I/SN | Microchip |
| Battery Charger | BQ25798RQMR | Texas Instruments |
| Battery Protector | BQ7791500PWR | Texas Instruments |
| Disconnect FET | IQDH35N03LM5ATMA1 | Infineon |
| NTC Thermistor | 103AT-2 (10 kΩ) | Semitec |
| Buck Converter | TPS54538RQFR | Texas Instruments |
| MEMS Microphone | ICS-43434 | TDK |
| White LED Driver | TPS923652DRRR | Texas Instruments |
| UV LED Driver | TPS92200D2DDCR | Texas Instruments |

### MCU Connections (Teensy 4.x)

| Signal | Teensy Interface | Description |
|--------|-----------------|-------------|
| `I2S.BCLK` / `SD` / `WS` | I2S2 | ICS-43434 microphone |
| `MCU_I2C.SCL/SDA/IRQ` | I2C | Charger + PD controller |
| `LED.ONSET_EN/ADIM` | PWM | White LED onset channel |
| `LED.BEAT1_EN/ADIM` | PWM | White LED beat channel 1 |
| `LED.BEAT2_EN/ADIM` | PWM | White LED beat channel 2 |

## Repository Structure

```
Sound Sensor Teensy Carrier Kicad/
├── Sound Sensor Teensy Carrier.kicad_pro   # Project file
├── Sound Sensor Teensy Carrier.kicad_pcb   # PCB layout (panel)
├── Sound Sensor Teensy Carrier.kicad_sch   # Top-level schematic
├── battery-charger.kicad_sch
├── battery_protector.kicad_sch
├── dc-converters.kicad_sch
├── mcu.kicad_sch
├── mic_boom.kicad_sch
├── usb-c-connector.kicad_sch
├── usb-pd-controller.kicad_sch
├── white_led_board.kicad_sch
├── wl-sumw_uv_led_board.kicad_sch
├── seperate.zsh                            # kikit panel extraction script
├── ibom.config.ini                         # Interactive BOM config
└── freerouting.dsn                         # Freerouting export
```

## Tools & Dependencies

| Tool | Purpose | Install |
|------|---------|---------|
| [KiCad 9.0](https://www.kicad.org/) | EDA (schematic + layout) | kicad.org |
| [kikit](https://github.com/yaqwsx/KiKit) | Panel sub-board extraction | `pip install kikit` |
| [InteractiveHtmlBom](https://github.com/openscopeproject/InteractiveHtmlBom) | BOM generation | KiCad plugin manager |

## Sub-board Extraction

The PCB is laid out as a panel. `seperate.zsh` uses `kikit separate` to extract individual sub-boards by board-array reference designator into `output/<name>/`:

```zsh
./seperate.zsh
```

Edit the script to enable/disable specific boards (B1–B6). Extracted boards are written to `output/<board-name>/<board-name>.kicad_pcb`.

## BOM Generation

Open the project in KiCad and run the **Interactive HTML BOM** plugin. Output lands in `bom/ibom.html` per `ibom.config.ini`. Key BOM fields: Value, Footprint, MPN, Manufacturer, Datasheet, Category.

## Related

The carrier board is designed to work alongside the [teensy_mic_sensor firmware](../../../firmware/) — a PlatformIO project implementing real-time beat and tempo tracking on the Teensy 4.x using the ICS-43434 microphone over I2S.
