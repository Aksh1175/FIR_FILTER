# VLSI Design of FIR Filter for DSP Applications

A complete, **verified** (compiled + simulated with Icarus Verilog) 16-tap FIR
low-pass filter, ready to drop into Vivado.

## Files

| File | Purpose |
|---|---|
| `fir_coeff_gen.m` | MATLAB script — designs the filter (`fir1` + Hamming window), quantizes coefficients to Q1.15, and exports `fir_coeffs.vh`, `fir_coeffs.mem`, `fir_input.mem` |
| `fir_filter.v` | Synthesizable RTL — 16-tap direct-form FIR filter (shift register + MAC) |
| `fir_coeffs.vh` | Verilog header with the 16 quantized coefficients (pre-generated, already matches `fir_coeff_gen.m`'s output — no MATLAB required to run the sim) |
| `fir_tb.v` | Testbench — streams a 1 kHz test tone through the filter and writes results to `fir_output.mem` |
| `fir_input.mem` | Pre-generated 50-sample test stimulus (1 kHz tone, Q1.15 hex) |
| `fir_coeffs.mem` | Same coefficients as `fir_coeffs.vh`, in hex (optional, for `$readmemh`-style loading if you prefer that over localparams) |

## Filter specification

- 16 taps, low-pass, Hamming window
- Sample rate Fs = 48 kHz, cutoff Fc = 4 kHz
- 16-bit signed, Q1.15 fixed-point (both data and coefficients)
- 36-bit accumulator (sized for 16×16-bit MAC over 16 taps with margin)
- One-cycle output latency past the last valid input sample

## Step 1 — (Optional) Regenerate coefficients in MATLAB

Run `fir_coeff_gen.m` in MATLAB. It overwrites `fir_coeffs.vh`, `fir_coeffs.mem`,
and `fir_input.mem` with freshly designed/quantized values — useful if you want
to change the cutoff, number of taps, or window function. **You don't need to
run this to simulate** — the provided files already match its output.

## Step 2 — Create the Vivado project

1. Vivado → **Create Project** → RTL Project (do not specify a board unless you plan to implement on real hardware).
2. **Add Sources** → add `fir_filter.v` and `fir_coeffs.vh` as **Design Sources**.
3. **Add Sources** → add `fir_tb.v` as a **Simulation Source**.
4. **Add Sources** → add `fir_input.mem` as a **Simulation Source** (or just copy it into the simulation working directory — Vivado runs `$readmemh`/`$fopen` relative to the simulation's launch directory, usually `<project>.sim/sim_1/behav/xsim/`).
5. In the Sources window, right-click `fir_tb` → **Set as Top** (for simulation).

## Step 3 — Run behavioral simulation

- Flow Navigator → **Run Simulation** → **Run Behavioral Simulation**.
- The waveform viewer opens automatically. Add `data_in`, `data_out`,
  `data_valid_in`, `data_valid_out` to the waveform if not already shown.
- Console will print each output sample as it's produced; `fir_output.mem`
  is written to the simulation directory — compare it against MATLAB's
  `filter(b,1,x)` on the same stimulus to verify bit-accuracy.

> If `fir_input.mem` isn't found at simulation time, copy it manually into
> the xsim working directory shown in the Tcl console, or use Vivado's
> "Simulation Sources" → set the simulation **Working Directory** to the
> project folder containing the `.mem` files (Simulation Settings → Elaboration).

## Step 4 — Synthesis (for area/speed/power comparison)

1. Flow Navigator → **Run Synthesis** (make sure `fir_filter` — not the
   testbench — is set as the top module first: right-click `fir_filter` →
   **Set as Top**).
2. After synthesis: **Open Synthesized Design** → **Report Utilization**
   (area: LUTs, FFs, DSP48 slices) and **Report Timing Summary** (max Fmax).
3. Run **Implementation** → **Report Power** for the power estimate.
4. Repeat for an ASIC-style comparison by swapping the target part, or by
   constraining a different clock period and re-checking timing/area trade-offs.

### Suggested area/speed/power comparison table for your report

| Metric | Value |
|---|---|
| LUTs used | *(from Report Utilization)* |
| Flip-flops used | *(from Report Utilization)* |
| DSP48 slices used | *(from Report Utilization — expect 16, one per multiplier, unless Vivado shares/pipelines them)* |
| Max frequency (Fmax) | *(from Report Timing Summary)* |
| Total on-chip power | *(from Report Power)* |

## Notes on the design

- The MAC stage is fully combinational (a 16-input adder tree) with only the
  input shift register and output register pipelined. This keeps latency low
  (1 cycle) but limits Fmax on larger tap counts. If you need higher Fmax for
  your report's "speed" comparison, mention/implement a pipelined adder tree
  (register the partial sums every 2–4 taps) as a variant to compare against.
- Coefficients are symmetric (linear-phase FIR), so an optional optimization
  worth discussing in your report is a **folded/symmetric structure** that
  pre-adds symmetric input samples before multiplying, halving the multiplier
  count (8 multipliers instead of 16) — a good "area" improvement to show in
  your comparison.
