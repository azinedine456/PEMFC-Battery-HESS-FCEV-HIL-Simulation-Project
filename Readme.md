\# PEMFC–Battery HESS FCEV Emulator  

\*\*Fuel Cell Electric Vehicle Emulation using Buck–Boost DC/DC Converters\*\*



\## Overview



This project presents the modeling, control, simulation, and experimental validation of a \*\*Proton Exchange Membrane Fuel Cell (PEMFC) emulator\*\* integrated into a \*\*Hybrid Energy Storage System (HESS)\*\* for \*\*Fuel Cell Electric Vehicles (FCEV)\*\*.



The objective is to reproduce, at reduced scale, the \*\*electrical behavior of a real PEM fuel cell\*\* without using an actual hydrogen system, while ensuring realistic interaction with a \*\*DC bus whose voltage is imposed by a battery\*\*. The emulator is intended for \*\*research, teaching, and Hardware-in-the-Loop (HIL)\*\* applications.



The complete system is developed under \*\*MATLAB/Simulink (Simscape)\*\* and designed with a strong focus on:

\- Control robustness  

\- Clear functional separation  

\- Compatibility with future real-time and experimental implementation  



---



\## System Architecture



The proposed architecture relies on \*\*two DC/DC converters with decoupled control objectives\*\*:



\### 1. Buck Converter – Fuel Cell Voltage Emulation

\- Operates in \*\*Continuous Conduction Mode (CCM)\*\*

\- Controlled in \*\*voltage mode\*\*

\- Emulates the \*\*PEMFC terminal voltage\*\* based on:

&nbsp; - A predefined PEMFC model (Simscape)

&nbsp; - Or a current–voltage (I–V) characteristic

\- Designed using a \*\*second-order averaged model\*\* to accurately capture disturbance dynamics



\### 2. Boost Converter – Fuel Cell Current Control

\- Operates in \*\*CCM\*\*

\- Controlled in \*\*current mode\*\*

\- Regulates the \*\*current drawn from the fuel cell emulator\*\*

\- Allows direct control of the \*\*fuel cell operating point\*\* and delivered power



The \*\*battery is directly connected to the DC bus\*\*, imposing its voltage and absorbing fast power transients, consistent with \*\*semi-active FCEV architectures\*\*.



---



\## Key Features



\- PEMFC electrical modeling under nominal conditions  

\- Buck–Boost emulator structure with decoupled control loops  

\- Robust PI controller design using:

&nbsp; - Pole–zero cancellation

&nbsp; - Frequency-domain margins (gain \& phase)

\- Validation with:

&nbsp; - Synthetic power profiles

&nbsp; - WLTC driving cycle (normalized)

\- Reduced-scale laboratory implementation (≈ 6 A nominal)

\- Designed for future HIL and real-time extensions



---



\## Simulation Environment



\- \*\*MATLAB / Simulink\*\*

\- \*\*Simscape Electrical\*\*

\- Average-value converter models

\- Discrete-time implementation compatible with real-time execution



A Boolean selector allows switching between:

\- Fictitious step-based profiles

\- WLTC-based current references



---



\## Performance Specifications



\- \*\*Buck (Voltage Control)\*\*

&nbsp; - No overshoot

&nbsp; - \\( T\_{5\\%} \\leq 1 \\, \\text{ms} \\)

&nbsp; - Phase margin > 45°



\- \*\*Boost (Current Control)\*\*

&nbsp; - No overshoot

&nbsp; - \\( T\_{5\\%} \\leq 1 \\, \\text{ms} \\)



\- Controlled current ripple and voltage ripple within predefined limits



---



\## Experimental Implementation



\- Reduced-scale physical emulator

\- Reversible DC power supply used as DC bus

\- Real-time execution using Humusoft interface

\- Experimental results show strong agreement with simulation:

&nbsp; - Correct tracking of voltage and current references

&nbsp; - Robust behavior with properly selected damping resistance

&nbsp; - No unexpected instability during operation



---



\## Repository Structure





