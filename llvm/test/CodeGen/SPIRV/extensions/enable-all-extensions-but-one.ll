; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv32-unknown-unknown --spirv-ext=all,-SPV_INTEL_arbitrary_precision_integers %s -o - | FileCheck %s
; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv32-unknown-unknown --spirv-ext=KHR %s -o - | FileCheck %s
; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv32-unknown-unknown --spirv-ext=khr %s -o - | FileCheck %s

define i6 @foo() {
  %call = tail call i32 @llvm.bitreverse.i32(i32 42)
  ret i6 2
}

; CHECK-NOT: OpExtension "SPV_INTEL_arbitrary_precision_integers"
; CHECK-DAG: OpExtension "SPV_KHR_bit_instructions"
