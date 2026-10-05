# 32-Bit ALU --- RTL to GDSII ASIC Implementation

![ASIC Flow](https://img.shields.io/badge/Flow-RTL%20to%20GDSII-blue)
![Technology](https://img.shields.io/badge/Technology-SKY130-orange)
![Verification](https://img.shields.io/badge/DRC-PASS-success)
![Verification](https://img.shields.io/badge/LVS-PASS-success)
![HDL](https://img.shields.io/badge/HDL-SystemVerilog%2FVerilog-purple)

## 📌 Project Overview

This project implements a **32-bit Arithmetic Logic Unit (ALU)** from
**RTL all the way to a physical GDSII layout**, providing hands-on
exposure to the complete digital ASIC implementation flow.

The objective was not only to design an ALU, but to understand how a
synthesizable RTL design is progressively transformed into:

**RTL → Simulation → Logic Synthesis → Floorplanning → Placement → CTS →
Routing → Physical Verification → GDSII**

The design was implemented using the **SkyWater SKY130 standard-cell
technology** and an open-source ASIC flow.

### What I learned

-   Writing and structuring synthesizable RTL
-   Functional verification using simulation and waveform analysis
-   Logic synthesis and standard-cell mapping
-   Timing constraints and clock definition
-   Floorplanning and core utilization
-   Standard-cell placement
-   Clock Tree Synthesis (CTS)
-   Global/detailed routing
-   Timing analysis across PVT corners
-   Physical DRC verification
-   Layout-vs-Schematic (LVS) verification
-   GDSII generation and layout inspection in KLayout
-   Reading PPA, timing, utilization and routing reports
-   Debugging issues encountered during RTL-to-GDSII implementation

------------------------------------------------------------------------

# 🧩 Design Architecture

The 32-bit ALU accepts two 32-bit operands and a 4-bit operation code.

``` text
                  ┌─────────────────────┐
        A[31:0] ─►│                     │
                  │   Arithmetic Unit   │
        B[31:0] ─►│                     │
                  └──────────┬──────────┘
                             │
                             │
                  ┌──────────▼──────────┐
        A[31:0] ─►│                     │
        B[31:0] ─►│    Logic Unit       │
                  │                     │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │    Shift Unit       │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │ Comparator / MUX    │
                  │   Result Selection  │
                  └──────────┬──────────┘
                             │
                             ▼
                       ALU_OUT[31:0]

             OP[3:0] ─────► Operation Select
             CLK ─────────► Sequential Control
             RST ─────────► Reset
```

## Supported Operations

The ALU is organized into arithmetic, logical, comparison and shift
operations.

Typical operations implemented include:

  Category     Operations
  ------------ -----------------------------------------
  Arithmetic   ADD, SUB
  Logic        AND, OR, XOR, NOT
  Shift        Logical Left Shift, Logical Right Shift
  Comparison   Comparison-related result generation
  Status       Carry, overflow, zero and related flags

The exact operation encoding is defined in the RTL source.

------------------------------------------------------------------------

# 📁 Project Structure

``` text
alu32/
│
├── src/
│   ├── adder32.v
│   ├── comparator.v
│   ├── logic_unit32.v
│   ├── shift_unit32.v
│   └── alu32.v
│
├── tb/
│   └── alu32_tb.v
│
├── config/
│   └── clock_configuration.json
│
├── runs/
│   └── <OpenLane run directories>
│
├── results/
│   ├── synthesis/
│   ├── placement/
│   ├── routing/
│   ├── timing/
│   └── final/
│
├── screenshots/
│   ├── waveform.png
│   ├── synthesis.png
│   ├── sta.png
│   ├── drc_lvs.png
│   └── gdsii.png
│
└── README.md
```

------------------------------------------------------------------------

# 🔄 Complete RTL-to-GDSII Flow

The complete implementation flow used in this project can be summarized
as:

``` text
                ┌─────────────────┐
                │   RTL Design    │
                │  Verilog/HDL    │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Functional      │
                │ Simulation      │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Logic Synthesis │
                │ Yosys           │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Floorplanning   │
                │ Core / I/O      │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Placement       │
                │ Global + Legal  │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ CTS             │
                │ Clock Tree      │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Routing         │
                │ Global + Detail │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ STA / Signoff   │
                │ Timing Checks   │
                └────────┬────────┘
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
       ┌─────────────┐       ┌─────────────┐
       │ DRC         │       │ LVS         │
       │ Physical    │       │ Netlist     │
       │ Verification│       │ Comparison  │
       └──────┬──────┘       └──────┬──────┘
              └──────────┬──────────┘
                         ▼
                ┌─────────────────┐
                │   Final GDSII   │
                │   Tapeout Data  │
                └─────────────────┘
```

------------------------------------------------------------------------

# 1. RTL Design

The ALU was first described at RTL using synthesizable Verilog.

The design was divided into smaller functional blocks rather than
implementing everything inside a single large module.

### Main RTL blocks

-   `adder32`
-   `comparator`
-   `logic_unit32`
-   `shift_unit32`
-   `alu32`

This modular structure makes the design easier to:

-   verify
-   synthesize
-   debug
-   optimize
-   understand during physical implementation

The top-level module is:

``` text
alu32
```

------------------------------------------------------------------------

# 2. Functional Simulation

Before synthesis, the RTL was verified using a testbench.

Simulation was used to check:

-   Arithmetic operations
-   Logic operations
-   Shift operations
-   Comparison behavior
-   Carry generation
-   Overflow behavior
-   Zero detection
-   Reset behavior
-   Clocked behavior
-   Different operand combinations

### Waveform verification

The simulation waveform was inspected using **GTKWave**.

Important internal signals were observed, including:

``` text
a_in
b_in
op
a_reg
b_reg
arith_res
logic_res
shift_res
comp_res
alu_out
carry_flag
overflow_flag
zero_flag
```

This step established functional confidence before physical
implementation.

------------------------------------------------------------------------

# 3. Logic Synthesis

The RTL was synthesized into a gate-level netlist using the **SKY130
standard-cell library**.

### Technology

``` text
Technology : SkyWater SKY130
Library    : sky130_fd_sc_hd
Flow       : OpenLane
Synthesis  : Yosys
```

Synthesis performs:

``` text
RTL
 ↓
Elaboration
 ↓
Optimization
 ↓
Boolean Mapping
 ↓
Standard-cell Netlist
```

The synthesis report showed approximately:

-   **3,727 design instances**
-   **53.06% standard-cell utilization**
-   **0 macros**
-   **\~14.52% of synthesized cell area associated with sequential
    elements**

The mapped design contains standard cells such as:

``` text
INV
MUX
NAND
NOR
OR
XOR
XNOR
AOI/OAI
```

This stage was important for understanding how RTL operators become
actual library cells.

------------------------------------------------------------------------

# 4. Timing Constraint / Clock Configuration

A clock was defined for the synchronous design.

``` json
{
    "DESIGN_NAME": "alu32",
    "CLOCK_PORT": "clk",
    "CLOCK_PERIOD": 20.0
}
```

Therefore:

``` text
Clock Period = 20 ns
Target Frequency = 1 / 20 ns
                 = 50 MHz
```

The clock constraint allows the physical implementation tools to
optimize the design against a real timing requirement.

Additional implementation parameters included:

``` text
FP_CORE_UTIL              = 40
FP_ASPECT_RATIO           = 1.0
PL_TARGET_DENSITY_PCT     = 45
SYNTH_STRATEGY             = AREA 0
SYNTH_MAX_FANOUT           = 12
```

Timing optimization was enabled during placement/global placement.

------------------------------------------------------------------------

# 5. Floorplanning

Floorplanning defines the physical structure of the chip before cells
are placed.

The major objectives were:

-   Define core dimensions
-   Define die dimensions
-   Set aspect ratio
-   Set target utilization
-   Reserve routing resources
-   Create placement rows
-   Prepare the design for power and signal routing

The reported final physical design had approximately:

``` text
Core bounding box:
~5.52 × 10.88 to ~189.64 × 204.00
```

The floorplan was then passed to placement.

------------------------------------------------------------------------

# 6. Placement

Placement determines the physical location of standard cells inside the
core.

The placement process includes:

``` text
Global Placement
       ↓
Placement Optimization
       ↓
Legalization
       ↓
Timing / Congestion Optimization
```

The major objectives are:

-   Reduce wirelength
-   Reduce congestion
-   Improve timing
-   Maintain legal cell locations
-   Control density

The project achieved approximately:

``` text
Standard-cell utilization ≈ 53.06%
```

------------------------------------------------------------------------

# 7. Clock Tree Synthesis --- CTS

Clock Tree Synthesis creates a physical clock distribution network.

Without CTS, a single ideal clock source would unrealistically reach all
sequential elements at the same time.

CTS addresses:

-   Clock skew
-   Clock insertion delay
-   Clock buffering
-   Clock fanout
-   Slew constraints

Conceptually:

``` text
                 CLK
                  │
              Clock Root
              /    |    \
             /     |     \
          BUF     BUF     BUF
          / \      |      / \
        FF  FF    FF    FF  FF
```

CTS therefore converts the logical clock into a physically distributed
clock network.

------------------------------------------------------------------------

# 8. Routing

After placement and CTS, the design was routed.

Routing consists broadly of:

``` text
Global Routing
      ↓
Detailed Routing
      ↓
Design Rule Checks
```

The router connects:

-   Data nets
-   Clock nets
-   Control signals
-   Power-related connections

Routing must satisfy technology-specific design rules while keeping:

-   Wirelength low
-   Congestion manageable
-   Delay acceptable
-   Slew within limits
-   Capacitance within limits

The final metrics reported:

``` text
Final Route DRC Errors = 0
Antenna Violating Nets = 0
Antenna Violating Pins = 0
```

------------------------------------------------------------------------

# 9. Static Timing Analysis --- STA

STA was performed to verify whether the physical implementation
satisfies the clock constraint.

The project used a:

``` text
Clock period = 20 ns
Target frequency = 50 MHz
```

### Worst-case reported timing

  Metric                     Result
  -------------------- ------------
  Worst Hold Slack       \~0.109 ns
  Hold TNS                        0
  Hold Violations                 0
  Worst Setup Slack      \~6.486 ns
  Setup TNS                       0
  Setup Violations                0
  Max Cap Violations              0

The positive setup slack indicates that the design meets the specified
20 ns clock period under the reported analysis.

### Timing margin

For the overall reported result:

``` text
Setup Slack ≈ 6.486 ns

Available timing margin:
20 ns - critical path delay
≈ 6.486 ns slack
```

The design also showed positive hold slack.

### Important observation

The STA report also showed **max-slew violations in some corners**.
These should not be ignored in a production signoff flow. They are a
useful optimization target for further buffering, fanout control, cell
sizing, or routing optimization.

------------------------------------------------------------------------

# 10. Multi-Corner Timing Analysis

Timing was evaluated across multiple process-voltage-temperature
corners.

Representative corners included:

``` text
nom_tt_025C_1v80
nom_ss_100C_1v60
nom_ff_n40C_1v95
min_tt_025C_1v80
min_ss_100C_1v60
min_ff_n40C_1v95
max_tt_025C_1v80
max_ss_100C_1v60
max_ff_n40C_1v95
```

This is important because an ASIC cannot be considered timing-safe based
on only one nominal condition.

The reported setup and hold slacks remained positive across the
displayed corners.

------------------------------------------------------------------------

# 11. Physical Design Metrics

The final reported metrics included approximately:

``` text
Design instances             : 3727
Standard-cell utilization    : 53.06%
Macros                       : 0
Antenna violations           : 0
Final route DRC errors       : 0
```

Reported timing:

``` text
Worst setup slack             : ~6.486 ns
Worst hold slack              : ~0.109 ns
Setup TNS                     : 0
Hold TNS                      : 0
Max capacitance violations    : 0
```

The synthesis report also showed a synthesized chip-area estimate of
approximately:

``` text
15084.47
```

while the later physical-design metrics reported approximately:

``` text
19891.6
```

These numbers come from different stages/area definitions and should not
be treated as directly identical. Synthesis estimates and
post-placement/post-routing physical area are measured differently.

------------------------------------------------------------------------

# 12. DRC --- Design Rule Check

DRC verifies whether the physical layout follows the manufacturing rules
of the selected technology.

Examples include:

-   Minimum spacing
-   Minimum width
-   Enclosure
-   Via rules
-   Metal spacing
-   Poly rules
-   Diffusion rules
-   Density-related rules

### Result

``` text
DRC COUNT = 0
```

This means the reported final layout passed the DRC check.

------------------------------------------------------------------------

# 13. LVS --- Layout Versus Schematic

LVS verifies that the physical layout represents the intended
circuit/netlist.

It checks:

``` text
Layout Netlist
      vs.
Reference Netlist
```

The final LVS result reported:

``` text
Cell pin lists are equivalent.

Device classes alu32 and alu32 are equivalent.

Final result:
Circuits match uniquely.
```

Therefore:

``` text
LVS = PASS
```

This is one of the most important physical verification results because
it confirms that the extracted layout connectivity matches the intended
design.

------------------------------------------------------------------------

# 14. GDSII Generation

After physical implementation and verification, the final layout was
exported as:

``` text
alu32.gds
```

GDSII is the standard layout data format used to represent the physical
geometry of an integrated circuit.

The generated GDSII was inspected using **KLayout**.

The layout contains physical layers corresponding to:

``` text
Diffusion
Polysilicon
Metal layers
Contacts
Vias
Well structures
Standard-cell geometry
Routing
```

### Final physical flow

``` text
RTL
 ↓
Synthesized Netlist
 ↓
Floorplan
 ↓
Placement
 ↓
CTS
 ↓
Routing
 ↓
DRC
 ↓
LVS
 ↓
GDSII
```

------------------------------------------------------------------------

# 🧪 Verification Summary

  Verification Stage    Result
  --------------------- -----------------------
  RTL Simulation        PASS
  Functional Waveform   PASS
  Logic Synthesis       PASS
  Placement             PASS
  CTS                   PASS
  Routing               PASS
  Setup Timing          PASS
  Hold Timing           PASS
  DRC                   PASS --- 0 errors
  LVS                   PASS --- unique match
  GDSII Generation      PASS
  KLayout Inspection    PASS

> Note: The reported STA data includes max-slew violations in some
> conditions. The design has positive setup/hold slack and zero
> setup/hold TNS, but slew optimization would be the next step before
> claiming production-level timing signoff.

------------------------------------------------------------------------

# 🛠️ Tools Used

  Tool                    Purpose
  ----------------------- ---------------------------------------
  Verilog/SystemVerilog   RTL design
  Yosys                   Logic synthesis
  OpenLane                RTL-to-GDSII implementation flow
  OpenROAD                Floorplan, placement, CTS and routing
  OpenSTA                 Static timing analysis
  Magic                   Physical verification / layout checks
  Netgen                  LVS
  KLayout                 GDSII visualization and inspection
  GTKWave                 RTL simulation waveform analysis
  SKY130 PDK              Standard-cell technology

------------------------------------------------------------------------

# 📊 Key Project Results

``` text
Technology                 : SKY130
Design                     : 32-bit ALU
Top Module                 : alu32
Clock Period               : 20 ns
Target Frequency           : 50 MHz

Synthesis Instances        : ~3,727
Standard-cell Utilization  : ~53.06%
Macros                     : 0

Worst Setup Slack          : ~6.486 ns
Worst Hold Slack           : ~0.109 ns
Setup TNS                  : 0
Hold TNS                   : 0
Max Cap Violations         : 0

Final Route DRC Errors     : 0
Antenna Violating Nets     : 0
Antenna Violating Pins     : 0

LVS                        : Unique Match
GDSII                      : Generated
```

------------------------------------------------------------------------

# 💡 What This Project Demonstrates

This project demonstrates practical understanding of the complete **ASIC
RTL-to-GDSII flow**, rather than only RTL coding.

### RTL / Front-End

-   Synthesizable RTL design
-   Modular digital architecture
-   Functional verification
-   Testbench development
-   Waveform debugging
-   Logic synthesis
-   Standard-cell mapping

### Physical Design / Back-End

-   Timing constraints
-   Floorplanning
-   Utilization and aspect ratio
-   Placement
-   Congestion awareness
-   Clock Tree Synthesis
-   Routing
-   Timing closure concepts
-   PVT corner analysis
-   DRC
-   LVS
-   GDSII generation

### Signoff Understanding

The project helped connect the relationship between:

``` text
RTL
 ↓
Logic
 ↓
Standard Cells
 ↓
Physical Geometry
 ↓
Parasitics / Interconnect
 ↓
Timing
 ↓
Manufacturing Rules
 ↓
Final Layout
```

------------------------------------------------------------------------

# 🔍 Important ASIC Concepts Learned

## Setup Timing

Data must arrive at the destination flip-flop sufficiently before the
active clock edge.

``` text
Setup Slack = Required Time - Arrival Time
```

Positive setup slack means the path satisfies the setup requirement.

## Hold Timing

Data must remain stable for a required interval after the active clock
edge.

``` text
Hold Slack = Arrival Time - Required Time
```

Positive hold slack means the path satisfies the hold requirement.

## PVT Corners

Circuit behavior changes with:

``` text
Process
Voltage
Temperature
```

Therefore timing must be checked across multiple corners.

## DRC vs LVS

### DRC

Answers:

> "Does the physical layout obey the manufacturing rules?"

### LVS

Answers:

> "Does the physical layout electrically represent the intended
> circuit?"

Both are required for reliable physical verification.

------------------------------------------------------------------------

# 🚀 Possible Future Improvements

The current implementation can be further optimized by:

-   Reducing maximum slew violations
-   Optimizing high-fanout nets
-   Improving critical-path delay
-   Exploring different synthesis strategies
-   Comparing different placement densities
-   Optimizing cell sizing
-   Reducing routing congestion
-   Performing detailed power optimization
-   Comparing area/timing/power trade-offs
-   Running more detailed post-route timing analysis
-   Exploring alternative clock periods
-   Comparing different SKY130 standard-cell libraries
-   Performing more comprehensive signoff checks

A useful optimization experiment would be to create multiple
implementations and compare:

``` text
             ┌──────────────┐
             │ RTL Design   │
             └──────┬───────┘
                    │
       ┌────────────┼────────────┐
       ▼            ▼            ▼
   Utilization A  Utilization B  Utilization C
       │            │            │
       ▼            ▼            ▼
     PPA-A        PPA-B        PPA-C

                ↓
       Best PPA Trade-off
```

------------------------------------------------------------------------

# 📚 Key Takeaway

The main goal of this project was to understand **how an RTL description
becomes a manufacturable physical layout**.

The project provided hands-on exposure to the complete chain:

> **RTL → Simulation → Synthesis → Floorplan → Placement → CTS → Routing
> → STA → DRC → LVS → GDSII**

This project strengthened my understanding of **ASIC Design, RTL Design,
Physical Design, Static Timing Analysis and VLSI implementation**, and
gave me practical experience with an industry-relevant open-source
RTL-to-GDSII flow.

------------------------------------------------------------------------

# 👨‍💻 Author

**Saurabh Swami**

B.Tech --- Electronics & Communication Engineering\
IIIT Nagpur

### Areas of Interest

-   Physical Design
-   ASIC Design
-   RTL Design
-   Static Timing Analysis
-   Analog / Mixed-Signal IC Design
-   Analog Layout
-   Design Verification
-   VLSI / Semiconductor Engineering

### GitHub

**GitHub:** [github.com/saurabhs84](https://github.com/saurabhs84)

### LinkedIn

**LinkedIn:**
[linkedin.com/in/saurabh-swami](https://linkedin.com/in/saurabh-swami)

------------------------------------------------------------------------

## ⭐ If you found this project useful

Feel free to explore the RTL, simulation results, synthesis reports,
physical-design reports and final GDSII generated as part of this ASIC
implementation.
