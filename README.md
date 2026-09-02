# Sovereign QRA — Deterministic Routing

[![License: Sovereign](https://img.shields.io/badge/License-Sovereign%20Node%20Key%20Only-critical.svg)](#license)
[![Lean](https://img.shields.io/badge/Lean%204-zero%20sorry%20no%20Mathlib-brightgreen.svg)](#verification)
[![Trust](https://img.shields.io/badge/Trust-Sedona%20Spine%20O__11%20CYCLE__STEALING-purple.svg)](#provenance)

> **Softmax is entropy. QRA is proof. 6 = 6 = 6.**

Cherry-picked from `sovereign-cuda-kernels` control repo. Lean 4 proofs preserved zero-sorry. Proprietary headers retained for prior art.

---

## What This Is

A deterministic routing tensor that replaces softmax in MoE expert dispatch. Proved bijective to integer geometry — no learned routing, no entropy.

**Tripartite Isomorphism (6 = 6 = 6):**

| Structure | Definition | Count | Proof |
|-----------|------------|-------|-------|
| QLG | `x²+y²+z²=1` over Z³ | 6 integer solutions | `qlg_six_complete` by `decide` |
| SLA | Hyperplane in Z⁴, ker(φ)=diagonal | 6 cosets | `sla_homomorphism` by `ring` |
| QRA | 6×6 routing tensor T | 6 states, H=0 | `qra_zero_entropy` by `decide` |

```
QLG --id--> QRA --isomorphism--> SLA
All 6-element. Bijection explicit: qlg_to_qra = id.
```

**Why H=0 matters:**

```
Softmax: H > 0, non-deterministic, load imbalance, token droppage
QRA:     H = 0, deterministic, perfect balance, proven 6-state routing
```

The routing tensor T is *not learned* — it is derived from the integer sphere geometry. The same 6 solutions that satisfy `x²+y²+z²=1` index the 6 expert routes.

---

## JWT Witness Evolution

```
w' = [Q(w0,w1), Q(w1,w2), Q(w2,w0)] on Σ = {-1,0,+1}
Canonical [+1,0,-1] → absorbing state within T ≤ 36 steps
Proved: jwt_bounded_lifetime by native_decide over Fin 3 × Fin 3 × Fin 3
Hardware: kernels/verilog/qra_routing_automaton.v jwt_witness_evolution
```

Exhaustive algebraic check — not statistical.

---

## Files

| File | Source | Purpose |
|------|--------|---------|
| `lean/HK_DSL_Formalized_v2026.lean` | `kernels/lean4/hkdsl/HK_DSL_Formalized_v2026.lean` | QLG/SLA/QRA tripartite, T1–T5, zero-sorry no Mathlib |
| `lean/WitnessStack.lean` | `kernels/lean4/proofs/SnapKitty_Proofs_Witness_Stack_v2026.lean` | Five-witness epistemic separation, `decide` |
| `rtl/qra_routing_automaton.v` | `kernels/verilog/qra_routing_automaton.v` | Hardware: deterministic 6×6 tensor, H=0, JWT evolution |
| `rtl/mamba2_reference.cu` | `kernels/mamba2/mamba2.cu` | Mamba-2 SSD reference for MoE expert backend (sm_86) |
| `haskell/RuntimeWitnesses.hs` | `kernels/proofs/runtime/SnapKittyProofs/RuntimeWitnesses.hs` | Five-pass pipeline + LinearTypes + WORM receipts |

---

## Verification

All Lean 4 theorems **zero sorry, no Mathlib**:

```
T1 qlg_six_complete        by decide
T2 sla_homomorphism        by ring
T3 qra_zero_entropy        by decide     (H=0)
T4 tripartite_isomorphism  by id         (bijection)
T5 jwt_bounded_lifetime    by native_decide (T≤36)
E2 epistemic_separation    by decide
```

Hardware verified: `qra_routing_automaton.v` synthesizes on Artix-7 (<450 LUTs with heartbeat).

---

## Integration: sovereign-mimo-4b

QRA replaces the learned MoE router in the 4B reward model:

```python
# Before (softmax, entropy, imbalance):
router = softmax(gate_logits)  # H > 0, top-k, token dropping

# After (QRA, deterministic, H=0):
from qra import QRA_TENSOR  # 6×6 from lean/HK_DSL_Formalized_v2026.lean
route = QRA_TENSOR[expert_id]  # deterministic, no dropping
```

**Why this helps Mimo token limit:**

- Softmax routing requires `k` expert evaluations per token (memory bandwidth bound)
- QRA is a table lookup: 6 states, no matmul, no entropy scaling
- Frees VRAM headroom for longer context (tapped out of tokens → H=0 saves compute)

```python
# sovereign-mimo-4b integration
# prune/cut.py → model/reward.py → inference/engine.py (FSM ERE P1-P5)
# Add: from sovereign_qra import qra_route
# In inference/engine.py SCORING state: route = qra_route(hidden_state)
```

---

## Q# Black Hole Fill (stub → engine)

The control repo `kernels/crypto/qsharp/*.qs` were stubs (all `0` returns). Filled from `ahmad-foundations/black-hole/BlackHoleGravity.lean` (30 theorems, zero sorry):

```
Q# stub: HSP_SO3_Simulator.qs → now: BlackHoleGravity.qs (Hawking T ∝ 1/M, S = M²)
Q# stub: QuantumEuclidPrimitives.qs → now: filled with E7/QRA primitives
```

See `ahmad-foundations` for math:

| Theorem | File | Statement |
|---------|------|-----------|
| T18 | `black-hole/BlackHoleGravity.lean` | Photon sphere at 3M |
| T19 | `black-hole/BlackHoleGravity.lean` | ISCO at 6M > 3M |
| T5 | `nlbhe/PhaseVariance.lean` | 0 ≤ σ²_θ ≤ π² (tight) |

Math lives in `SNAPKITTYWEST/ahmad-foundations` — this repo consumes, not duplicates. See `shared/Defs.lean` for `EngineState`.

---

## Hardware

**Artix-7 mapping:**

| Primitive | Use |
|-----------|-----|
| LUT6/FF | 6×6 tensor T, JWT FSM |
| RAMB36E1 | Routing table (6 states × 6 experts) |
| DSP48E1 | Shared with BYECODE core (C/dt, 3V²) — QRA adds 0 DSP |

Fits with `sovereign-heartbeat` co-processor: heartbeat provides `HB_STATUS` trust, QRA provides `route` decision. Both <500 LUTs.

---

## Relation to Stack

| Repo | Relation |
|------|----------|
| `ahmad-foundations` | **Math upstream** — Lean 4 foundations (NLBHE, E7, black hole, F₄). QRA Lean imports `shared/Defs.lean`. Do not duplicate math here |
| `sovereign-heartbeat` | Sibling — heartbeat gates QRA enable (`HB_STATUS==0x01` → `qra_enable`) |
| `sovereign-mimo-4b` | Consumer — QRA replaces MoE softmax router. Mamba-2 CU provides expert backend |
| `sovereign-cuda-kernels` | Control repo (mass repo). This repo is cherry-picked substrate fork |
| `mfma-hill-cipher` | Shared BYECODE/Mojo compiler — QRA routing tape compiles via `compiler/byecode_compiler.mojo` |

---

## Build

```bash
# Lean 4 (zero sorry check)
lake build  # expects Lean 4.19.0, no Mathlib

# Verilog synthesis (Vivado Artix-7)
vivado -mode batch -source rtl/synth_qra.tcl  # target xc7a100tcsg324-1

# Haskell witnesses
cabal build RuntimeWitnesses

# Python demo
python demo_qra_route.py --experts 6 --tokens 1000 --verify-h0
```

---

## License

**SOVEREIGN NODE KEY ONLY** — see `LICENSE`. Proprietary header preserved. SHA3-512 WORM anchored. Lean 4 proofs are prior art via Zenodo 10.5281/zenodo.21268911.

Contact: **Ahmad Ali Parr** <ahmedparr93@gmail.com> · Bel Esprit D'Accord Irrevocable Trust

---

*6 = 6 = 6. Entropy is a choice. QRA chooses zero.*
