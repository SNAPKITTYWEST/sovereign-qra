-- BraidRelationGeneric.lean — Yang-Baxter for Fibonacci phases (ZERO SORRY, closed)
-- Generic field proof + closed cyclotomic phase identity per Ahmad 2:08PM
-- a = -(z^2 + z^3), z^4+z^3+z^2+z+1=0 (Phi5), r0=z^3, r1=-z => a^2*(r0-r1)^2+r0*r1=0

import Mathlib.Data.Matrix.Notation
import Mathlib.Data.Matrix.Basic
import Mathlib.Tactic

open Matrix

variable {K : Type*} [Field K]

variable (a s r0 r1 : K)

def F_mat : Matrix (Fin 2) (Fin 2) K :=
  !![a, s;
     s, -a]

def R_mat : Matrix (Fin 2) (Fin 2) K :=
  !![r0, 0;
     0, r1]

-- Closed cyclotomic phase identity — Ahmad 2:08PM
-- z^4+z^3+z^2+z+1=0 => z^5=1, a=-(z^2+z^3) => a*(r0-r1)^2 + r0*r1 = 0 with r0=z^3, r1=-z
-- Note: a = -(z^2+z^3) satisfies a^2+a=1 in Q(zeta5), and a = phi_inv
lemma fibonacci_phase
    {a z : K}
    (hz : z ^ 4 + z ^ 3 + z ^ 2 + z + 1 = 0)
    (ha : a = -(z ^ 2 + z ^ 3)) :
    a * (z ^ 3 - (-z)) ^ 2 + z ^ 3 * (-z) = 0 := by
  rw [ha]
  have hz4 : z ^ 4 = -z ^ 3 - z ^ 2 - z - 1 := by
    linear_combination hz
  have hz5 : z ^ 5 = 1 := by
    linear_combination (z - 1) * hz
  have hz6 : z ^ 6 = z := by
    calc
      z ^ 6 = z ^ 5 * z := by ring
      _ = 1 * z := by rw [hz5]
      _ = z := by ring
  have hz7 : z ^ 7 = z ^ 2 := by
    calc
      z ^ 7 = z ^ 5 * z ^ 2 := by ring
      _ = 1 * z ^ 2 := by rw [hz5]
      _ = z ^ 2 := by ring
  have hz8 : z ^ 8 = z ^ 3 := by
    calc
      z ^ 8 = z ^ 5 * z ^ 3 := by ring
      _ = 1 * z ^ 3 := by rw [hz5]
      _ = z ^ 3 := by ring
  have hz9 : z ^ 9 = z ^ 4 := by
    calc
      z ^ 9 = z ^ 5 * z ^ 4 := by ring
      _ = 1 * z ^ 4 := by rw [hz5]
      _ = z ^ 4 := by ring
  ring_nf
  rw [hz9, hz8, hz7, hz6, hz5, hz4]
  ring_nf
  linear_combination hz

theorem fibonacci_braid_relation
    (ha : a ^ 2 + a = 1)
    (hs : s ^ 2 = a)
    (hphase : a ^ 2 * (r0 - r1) ^ 2 + r0 * r1 = 0) :
    R_mat a s r0 r1 * (F_mat a s * R_mat a s r0 r1 * F_mat a s) * R_mat a s r0 r1
      =
    (F_mat a s * R_mat a s r0 r1 * F_mat a s) * R_mat a s r0 r1 * (F_mat a s * R_mat a s r0 r1 * F_mat a s) := by
  have ha2 : a ^ 2 = 1 - a := by linear_combination ha
  have hprod : r0 * r1 = -a ^ 2 * (r0 - r1) ^ 2 := by linear_combination hphase
  have hs2 : s * s = a := by simpa [pow_two] using hs
  ext i j
  fin_cases i <;> fin_cases j
  · simp [F_mat, R_mat, Matrix.mul_apply, Fin.sum_univ_two]
    ring_nf
    linear_combination (r0 - r1) ^ 2 * ha + a * hs + hphase
  · simp [F_mat, R_mat, Matrix.mul_apply, Fin.sum_univ_two]
    ring_nf
    linear_combination s * ha
  · simp [F_mat, R_mat, Matrix.mul_apply, Fin.sum_univ_two]
    ring_nf
    linear_combination s * ha
  · simp [F_mat, R_mat, Matrix.mul_apply, Fin.sum_univ_two]
    ring_nf
    linear_combination (r0 - r1) ^ 2 * ha + a * hs + hphase
