# PEMFC–Battery HESS FCEV Emulator  
This repository was created in the fulfillement of the course "Projet et Synthèse EPRM" at EiCNAM.  


## Overview

This project presents the modeling, control, simulation, and experimental validation of a **Proton Exchange Membrane Fuel Cell (PEMFC) emulator** integrated into a **Hybrid Energy Storage System (HESS)** for **Fuel Cell Electric Vehicles (FCEV)**.

The objective is to reproduce, at reduced scale, the **electrical behavior of a real PEM fuel cell** , while ensuring realistic interaction with a **DC bus whose voltage is imposed by a battery**. 

The complete system is developed under **MATLAB/Simulink (Simscape)** and designed with a strong focus on:
- Control robustness  
- Clear functional separation  
- Compatibility with future real-time and experimental implementation  

---

## System Architecture

The proposed architecture relies on **two DC/DC converters with decoupled control objectives**:

### 1. Buck Converter – Fuel Cell Voltage Emulation
- Operates in **Continuous Conduction Mode (CCM)**
- Controlled in **voltage mode**
- Emulates the **PEMFC terminal voltage** based on:
  - A predefined PEMFC model (Simscape)
  - Or a current–voltage (I–V) characteristic
- Designed using a **second-order averaged model** to accurately capture disturbance dynamics

### 2. Boost Converter – Fuel Cell Current Control
- Operates in **CCM**
- Current Controlled 
- Regulates the **current drawn from the fuel cell emulator**
- Allows direct control of the **fuel cell operating point** and delivered power

The **battery is directly connected to the DC bus**, imposing its voltage and absorbing fast power transients, consistent with **semi-active FCEV architectures**.

---

## Simulation Environment

- **MATLAB / Simulink**
- **Simscape Electrical**
- Average-value converter models

A Boolean selector allows switching between:
- Fictitious step-based profiles
- WLTC-based current references

---

## Performance Specifications

- **Buck (Voltage Control)**
  - No overshoot
  - \( T_{5\%} \leq 1 \, \text{ms} \)
  - Phase margin >= 59°

- **Boost (Current Control)**
  - No overshoot
  - \( T_{5\%} \leq 1 \, \text{ms} \)

- Controlled current ripple and voltage ripple within predefined limits

---

## Experimental Implementation

- Reduced-scale physical emulator
- Reversible DC power supply used as DC bus
- Real-time execution using Humusoft interface
- Experimental results show strong agreement with simulation:
  - Correct tracking of voltage and current references
  - Robust behavior with properly selected damping resistance
  - No unexpected instability during operation


<img width="894" height="335" alt="image" src="https://github.com/user-attachments/assets/0be9f0f7-532e-4c59-ae29-6ad8cbb2e1af" />

**Yellow Waveform : PEMFC Emulator Output Voltage**

**Blue Waveform : PEMFC Model Output Voltage (Reference for the Buck converter)**

**Red Waveform : Current Referece/setpoint**

**Green Waveform : Measured Current**



<img width="1117" height="322" alt="image" src="https://github.com/user-attachments/assets/5a2d2986-0a37-4640-98b4-c32b67d4ff8f" />


