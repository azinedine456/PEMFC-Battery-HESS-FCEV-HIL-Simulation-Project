# PEMFC–Battery HESS FCEV Emulator  
This repository was created in the fulfillement of the course "Projet et Synthèse EPRM" at EiCNAM. **(Repository Structure is detailed at the end of the Readme file).** 


## Overview
**(Repository Structure is detailed at the end of the Readme file).**
This project presents the modeling, control, simulation, and experimental validation of a **Proton Exchange Membrane Fuel Cell (PEMFC) emulator** integrated into a **Hybrid Energy Storage System (HESS)** for **Fuel Cell Electric Vehicles (FCEV)**.

The objective is to reproduce, at reduced scale, the **electrical behavior of a real PEM fuel cell** , while ensuring realistic interaction with a **DC bus whose voltage is imposed by a battery**. 

The complete system is developed under **MATLAB/Simulink (Simscape)** and designed with a strong focus on:
- Control robustness  
- Clear functional separation  
- Compatibility with future real-time and experimental implementation  

---

## System Architecture
**(Repository Structure is detailed at the end of the Readme file).**
The proposed architecture relies on **two DC/DC converters with decoupled control objectives**:

### 1. Buck Converter – Fuel Cell Voltage Emulation
- Operates in **Continuous Conduction Mode (CCM)**
- Controlled in **voltage mode**
- Emulates the **PEMFC terminal voltage** based on:
  - A predefined PEMFC model (Simscape)
  - Or a current–voltage (I–V) characteristic
- Designed using a **second-order averaged model** to accurately capture disturbance dynamics

### 2. Boost Converter – Fuel Cell Current Control
**(Repository Structure is detailed at the end of the Readme file).**
- Operates in **CCM**
- Current Controlled 
- Regulates the **current drawn from the fuel cell emulator**
- Allows direct control of the **fuel cell operating point** and delivered power

The **battery is directly connected to the DC bus**, imposing its voltage and absorbing fast power transients, consistent with **semi-active FCEV architectures**.

---

## Simulation Environment
**(Repository Structure is detailed at the end of the Readme file).**
- **MATLAB / Simulink**
- **Simscape Electrical**
- Average-value converter models

A Boolean selector allows switching between:
- Fictitious step-based profiles
- WLTC-based current references

---

## Performance Specifications
**(Repository Structure is detailed at the end of the Readme file).**
- **Buck (Voltage Control)**
  - No overshoot
  -T5%<=1mS
  - Phase margin >= 59°

- **Boost (Current Control)**
  - No overshoot
  - T5%<=1mS

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

<img width="738" height="398" alt="image" src="https://github.com/user-attachments/assets/cfd04a32-e968-4b6b-8bda-2f9c222eb718" />




<img width="894" height="335" alt="image" src="https://github.com/user-attachments/assets/0be9f0f7-532e-4c59-ae29-6ad8cbb2e1af" />

**Yellow Waveform : PEMFC Emulator Output Voltage**

**Blue Waveform : PEMFC Model Output Voltage (Reference for the Buck converter)**

**Red Waveform : Current Referece/setpoint**

**Green Waveform : Measured Current**



<img width="1117" height="322" alt="image" src="https://github.com/user-attachments/assets/5a2d2986-0a37-4640-98b4-c32b67d4ff8f" />



## Repository Structure

### Data and Models
- **RealData/**  
  Contains real driving profiles used as inputs for simulation and real-time tests, including:
  - WLTC driving cycle  
  - Normal drive test cycles  

- **IV_Charac/**  
  Alternative PEMFC modeling approach based on:
  - Static I–V characteristic  + Output filtering  
  - Filter cut-off frequency obtained through an optimization process  (fminsearchbnd -> Nelder Mead)

### Legacy and Early-Stage Work
- **OBSOLETE/**  
  Legacy files kept for traceability. These were used during early debugging and preliminary testing phases and are no longer part of the main workflow.

- **LTSPICEFILES/**  
  LTspice schematics developed during the early stages of the project for preliminary validation and intuition building before moving to Simulink-based models.

---

### Global Simulation (Offline – MATLAB/Simulink)

- **FullSystemPAC_init.m**  
  Main initialization and execution script for the **offline global simulation**.  
  This script sets parameters, launches simulations, and saves the associated results.  
  It relies on the following files:

  - **FullSystem.slx**  
    Simulink model of the complete PEMFC–Battery HESS emulator.

  - **BuckDesign_modinit.m**  
    Design and parameter initialization of the Buck converter and its voltage control loop.

  - **Buck_GM_PM_analysis.m**  
    Gain and phase margin analysis of the Buck converter control loop, including:
    - Second-order averaged model  
    - Robust control design considerations  

  - **BoostDesign_modinit.m**  
    Design and parameter initialization of the Boost converter and its current control loop.

  - **Run_Sim_PAC.m**  
    Script used to execute `FullSystem.slx` once all parameters are initialized.

  - **Plot_Save_PAC.m**  
    Post-processing script to:
    - Plot simulation results  
    - Save figures  
    - Export a `.mat` file containing simulation parameters and results  

  - **plotCSV.m**  
    Utility script used to plot data exported from an oscilloscope (CSV format).

---

### Real-Time / Experimental Implementation

- **MANIP_FULLSYSTEM.m**  
  Main script used to run the **global real-time simulation / experimental setup**.  
  It is associated with the following Simulink real-time models:

  - **MANIP_FINAL_RealData.slx**  
    Final real-time model of the full system using real driving data.

  - **MANIP_BOOST.slx**  
    Dedicated real-time Simulink model for testing and validating the **Boost converter current control** independently.

  - **MANIP_Buck.slx**  
    Dedicated real-time Simulink model for testing and validating the **Buck converter voltage control** independently.

