; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes CHECK,CHECK-LE
; RUN: llc -mtriple=aarch64_be-unknown-linux-gnu < %s | FileCheck %s --check-prefix CHECK-BE
; RUN: llc -mtriple=aarch64-unknown-linux-gnu -global-isel -global-isel -global-isel-abort=2 2>&1 < %s | FileCheck %s --check-prefixes CHECK,CHECK-GI

; CHECK-GI:       warning: Instruction selection used fallback path for test_pmull_high_p8_128
; CHECK-GI-NEXT:  warning: Instruction selection used fallback path for test_pmull_high_p8_64

declare <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16>, <4 x i16>)
declare <4 x i32> @llvm.aarch64.neon.umull.v4i32(<4 x i16>, <4 x i16>)
declare <8 x i8> @llvm.aarch64.neon.sabd.v8i8(<8 x i8>, <8 x i8>)
declare <8 x i8> @llvm.aarch64.neon.uabd.v8i8(<8 x i8>, <8 x i8>)
declare <4 x i32> @llvm.aarch64.neon.sqdmull.v4i32(<4 x i16>, <4 x i16>)
declare <4 x i32> @llvm.aarch64.neon.sqadd.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8>, <8 x i8>)
declare <2 x i64> @llvm.aarch64.neon.umull.v2i64(<2 x i32> %s1, <2 x i32> %s2)

define <4 x i32> @test_smull_high_s16_base(<8 x i16> %a, <8 x i16> %b) #0 {
; CHECK-LABEL: test_smull_high_s16_base:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_base:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcasta1(<2 x i64> %aa, <8 x i16> %b) #0 {
; CHECK-LABEL: test_smull_high_s16_bitcasta1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcasta1:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %a = bitcast <2 x i64> %aa to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcastb1(<8 x i16> %a, <16 x i8> %bb) #0 {
; CHECK-LABEL: test_smull_high_s16_bitcastb1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcastb1:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %b = bitcast <16 x i8> %bb to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcasta2(<2 x i64> %a, <8 x i16> %b) #0 {
; CHECK-LABEL: test_smull_high_s16_bitcasta2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcasta2:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    rev64 v0.4h, v0.4h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %s1a = shufflevector <2 x i64> %a, <2 x i64> undef, <1 x i32> <i32 1>
  %s1 = bitcast <1 x i64> %s1a to <4 x i16>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcastb2(<8 x i16> %a, <16 x i8> %b) #0 {
; CHECK-LABEL: test_smull_high_s16_bitcastb2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull2 v0.4s, v0.8h, v1.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcastb2:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    rev16 v1.8b, v1.8b
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2a = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %s2 = bitcast <8 x i8> %s2a to <4 x i16>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}


define <4 x i32> @test_smull_high_s16_bitcasta1_wrongindex(<2 x i64> %aa, <8 x i16> %b) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_bitcasta1_wrongindex:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    ext v2.16b, v0.16b, v0.16b, #8
; CHECK-LE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-LE-NEXT:    ext v0.8b, v0.8b, v2.8b, #4
; CHECK-LE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcasta1_wrongindex:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #4
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_bitcasta1_wrongindex:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ext v0.16b, v0.16b, v0.16b, #4
; CHECK-GI-NEXT:    mov d1, v1.d[1]
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-GI-NEXT:    ret
entry:
  %a = bitcast <2 x i64> %aa to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcastb1_wrongindex(<8 x i16> %a, <16 x i8> %bb) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_bitcastb1_wrongindex:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    ext v2.16b, v1.16b, v1.16b, #8
; CHECK-LE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-LE-NEXT:    ext v1.8b, v1.8b, v2.8b, #6
; CHECK-LE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcastb1_wrongindex:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #6
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_bitcastb1_wrongindex:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov d0, v0.d[1]
; CHECK-GI-NEXT:    ext v1.16b, v1.16b, v0.16b, #6
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-GI-NEXT:    ret
entry:
  %b = bitcast <16 x i8> %bb to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcasta2_wrongindex(<4 x i32> %a, <8 x i16> %b) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_bitcasta2_wrongindex:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    ext v0.16b, v0.16b, v0.16b, #4
; CHECK-LE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-LE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcasta2_wrongindex:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #4
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    rev32 v0.4h, v0.4h
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_bitcasta2_wrongindex:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ext v0.16b, v0.16b, v0.16b, #4
; CHECK-GI-NEXT:    mov d1, v1.d[1]
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-GI-NEXT:    ret
entry:
  %s1a = shufflevector <4 x i32> %a, <4 x i32> undef, <2 x i32> <i32 1, i32 2>
  %s1 = bitcast <2 x i32> %s1a to <4 x i16>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_bitcastb2_wrongindex(<8 x i16> %a, <16 x i8> %b) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_bitcastb2_wrongindex:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-LE-NEXT:    ext v1.16b, v1.16b, v1.16b, #4
; CHECK-LE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_bitcastb2_wrongindex:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #4
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    rev16 v1.8b, v1.8b
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_bitcastb2_wrongindex:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov d0, v0.d[1]
; CHECK-GI-NEXT:    ext v1.16b, v1.16b, v0.16b, #4
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-GI-NEXT:    ret
entry:
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2a = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
  %s2 = bitcast <8 x i8> %s2a to <4 x i16>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}


define <4 x i32> @test_smull_high_s16_splata1(<2 x i64> %aa, <8 x i16> %b) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_splata1:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    smull2 v0.4s, v1.8h, v0.h[3]
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_splata1:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    smull2 v0.4s, v1.8h, v0.h[3]
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_splata1:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov d1, v1.d[1]
; CHECK-GI-NEXT:    smull v0.4s, v1.4h, v0.h[3]
; CHECK-GI-NEXT:    ret
entry:
  %a = bitcast <2 x i64> %aa to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 3, i32 3, i32 3, i32 3>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_splatb1(<8 x i16> %a, <16 x i8> %bb) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_splatb1:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    smull2 v0.4s, v0.8h, v1.h[3]
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_splatb1:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    smull2 v0.4s, v0.8h, v1.h[3]
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_splatb1:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov d0, v0.d[1]
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.h[3]
; CHECK-GI-NEXT:    ret
entry:
  %b = bitcast <16 x i8> %bb to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 3, i32 3, i32 3, i32 3>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_splata2(<4 x i32> %a, <8 x i16> %b) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_splata2:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    dup v0.2s, v0.s[3]
; CHECK-LE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-LE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_splata2:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    dup v0.2s, v0.s[3]
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    rev32 v0.4h, v0.4h
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_splata2:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    dup v0.2s, v0.s[3]
; CHECK-GI-NEXT:    mov d1, v1.d[1]
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-GI-NEXT:    ret
entry:
  %s1a = shufflevector <4 x i32> %a, <4 x i32> undef, <2 x i32> <i32 3, i32 3>
  %s1 = bitcast <2 x i32> %s1a to <4 x i16>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <4 x i32> @test_smull_high_s16_splatb2(<8 x i16> %a, <16 x i8> %b) #0 {
; CHECK-LE-LABEL: test_smull_high_s16_splatb2:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-LE-NEXT:    dup v1.8b, v1.b[3]
; CHECK-LE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_smull_high_s16_splatb2:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    dup v1.8b, v1.b[3]
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    rev16 v1.8b, v1.8b
; CHECK-BE-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_smull_high_s16_splatb2:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov d0, v0.d[1]
; CHECK-GI-NEXT:    dup v1.8b, v1.b[3]
; CHECK-GI-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-GI-NEXT:    ret
entry:
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2a = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3>
  %s2 = bitcast <8 x i8> %s2a to <4 x i16>
  %r = call <4 x i32> @llvm.aarch64.neon.smull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}



define <4 x i32> @test_umull_high_s16_bitcasta1(<2 x i64> %aa, <8 x i16> %b) #0 {
; CHECK-LABEL: test_umull_high_s16_bitcasta1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umull2 v0.4s, v0.8h, v1.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_umull_high_s16_bitcasta1:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    umull2 v0.4s, v0.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %a = bitcast <2 x i64> %aa to <8 x i16>
  %s1 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %r = call <4 x i32> @llvm.aarch64.neon.umull.v4i32(<4 x i16> %s1, <4 x i16> %s2)
  ret <4 x i32> %r
}

define <8 x i16> @test_vabdl_high_u82(<16 x i8> %a, <8 x i16> %bb) {
; CHECK-LABEL: test_vabdl_high_u82:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uabdl2 v0.8h, v0.16b, v1.16b
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_vabdl_high_u82:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.16b, v0.16b
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    uabdl2 v0.8h, v0.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %b = bitcast <8 x i16> %bb to <16 x i8>
  %shuffle.i.i = shufflevector <16 x i8> %a, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %shuffle.i3.i = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %vabd.i.i.i = tail call <8 x i8> @llvm.aarch64.neon.uabd.v8i8(<8 x i8> %shuffle.i.i, <8 x i8> %shuffle.i3.i)
  %vmovl.i.i.i = zext <8 x i8> %vabd.i.i.i to <8 x i16>
  ret <8 x i16> %vmovl.i.i.i
}

define <8 x i16> @test_vabdl_high_s82(<16 x i8> %a, <8 x i16> %bb) {
; CHECK-LABEL: test_vabdl_high_s82:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sabdl2 v0.8h, v0.16b, v1.16b
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_vabdl_high_s82:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.16b, v0.16b
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    sabdl2 v0.8h, v0.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %b = bitcast <8 x i16> %bb to <16 x i8>
  %shuffle.i.i = shufflevector <16 x i8> %a, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %shuffle.i3.i = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %vabd.i.i.i = tail call <8 x i8> @llvm.aarch64.neon.sabd.v8i8(<8 x i8> %shuffle.i.i, <8 x i8> %shuffle.i3.i)
  %vmovl.i.i.i = zext <8 x i8> %vabd.i.i.i to <8 x i16>
  ret <8 x i16> %vmovl.i.i.i
}

define <4 x i32> @test_vqdmlal_high_s16_bitcast(<4 x i32> %a, <8 x i16> %b, <16 x i8> %cc) {
; CHECK-LABEL: test_vqdmlal_high_s16_bitcast:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sqdmlal2 v0.4s, v1.8h, v2.8h
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_vqdmlal_high_s16_bitcast:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.8h, v1.8h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    rev64 v2.8h, v2.8h
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v2.16b, v2.16b, v2.16b, #8
; CHECK-BE-NEXT:    sqdmlal2 v0.4s, v1.8h, v2.8h
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %c = bitcast <16 x i8> %cc to <8 x i16>
  %shuffle.i.i = shufflevector <8 x i16> %b, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %shuffle.i3.i = shufflevector <8 x i16> %c, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %vqdmlal2.i.i = tail call <4 x i32> @llvm.aarch64.neon.sqdmull.v4i32(<4 x i16> %shuffle.i.i, <4 x i16> %shuffle.i3.i)
  %vqdmlal4.i.i = tail call <4 x i32> @llvm.aarch64.neon.sqadd.v4i32(<4 x i32> %a, <4 x i32> %vqdmlal2.i.i)
  ret <4 x i32> %vqdmlal4.i.i
}

define <8 x i16> @test_pmull_high_p8_128(i128 %aa, i128 %bb) {
; CHECK-LABEL: test_pmull_high_p8_128:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fmov d0, x3
; CHECK-NEXT:    fmov d1, x1
; CHECK-NEXT:    pmull v0.8h, v1.8b, v0.8b
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_pmull_high_p8_128:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    fmov d0, x3
; CHECK-BE-NEXT:    fmov d1, x1
; CHECK-BE-NEXT:    rev64 v0.8b, v0.8b
; CHECK-BE-NEXT:    rev64 v1.8b, v1.8b
; CHECK-BE-NEXT:    pmull v0.8h, v1.8b, v0.8b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %a = bitcast i128 %aa to <16 x i8>
  %b = bitcast i128 %bb to <16 x i8>
  %shuffle.i.i = shufflevector <16 x i8> %a, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %shuffle.i3.i = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %vmull.i.i = tail call <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8> %shuffle.i.i, <8 x i8> %shuffle.i3.i)
  ret <8 x i16> %vmull.i.i
}

define <8 x i16> @test_pmull_high_p8_64(<2 x i64> %aa, <2 x i64> %bb) {
; CHECK-LABEL: test_pmull_high_p8_64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    pmull2 v0.8h, v0.16b, v1.16b
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_pmull_high_p8_64:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v0.16b, v0.16b
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    pmull2 v0.8h, v0.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
entry:
  %a = bitcast <2 x i64> %aa to <16 x i8>
  %b = bitcast <2 x i64> %bb to <16 x i8>
  %shuffle.i.i = shufflevector <16 x i8> %a, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %shuffle.i3.i = shufflevector <16 x i8> %b, <16 x i8> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %vmull.i.i = tail call <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8> %shuffle.i.i, <8 x i8> %shuffle.i3.i)
  ret <8 x i16> %vmull.i.i
}

define <8 x i16> @foov8i16(<16 x i8> %a1, <2 x i64> %b1) {
; CHECK-LE-LABEL: foov8i16:
; CHECK-LE:       // %bb.0:
; CHECK-LE-NEXT:    shrn v0.4h, v0.4s, #5
; CHECK-LE-NEXT:    shrn2 v0.8h, v1.4s, #5
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: foov8i16:
; CHECK-BE:       // %bb.0:
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    rev64 v1.4s, v1.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    shrn v0.4h, v0.4s, #5
; CHECK-BE-NEXT:    shrn2 v0.8h, v1.4s, #5
; CHECK-BE-NEXT:    rev64 v0.8h, v0.8h
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: foov8i16:
; CHECK-GI:       // %bb.0:
; CHECK-GI-NEXT:    shrn v1.4h, v1.4s, #5
; CHECK-GI-NEXT:    shrn v0.4h, v0.4s, #5
; CHECK-GI-NEXT:    fmov x8, d1
; CHECK-GI-NEXT:    mov v0.d[1], x8
; CHECK-GI-NEXT:    ret
  %a0 = bitcast <16 x i8> %a1 to <4 x i32>
  %b0 = bitcast <2 x i64> %b1 to <4 x i32>
  %vshrn_low_shift = lshr <4 x i32> %a0, <i32 5, i32 5, i32 5, i32 5>
  %vshrn_low = trunc <4 x i32> %vshrn_low_shift to <4 x i16>
  %vshrn_high_shift = lshr <4 x i32> %b0, <i32 5, i32 5, i32 5, i32 5>
  %vshrn_high = trunc <4 x i32> %vshrn_high_shift to <4 x i16>
  %1 = bitcast <4 x i16> %vshrn_low to <1 x i64>
  %2 = bitcast <4 x i16> %vshrn_high to <1 x i64>
  %shuffle.i = shufflevector <1 x i64> %1, <1 x i64> %2, <2 x i32> <i32 0, i32 1>
  %3 = bitcast <2 x i64> %shuffle.i to <8 x i16>
  ret <8 x i16> %3
}

define <2 x i64> @hadd32_zext_asr(<16 x i8> %src1a) {
; CHECK-LE-LABEL: hadd32_zext_asr:
; CHECK-LE:       // %bb.0:
; CHECK-LE-NEXT:    ushll2 v0.2d, v0.4s, #1
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: hadd32_zext_asr:
; CHECK-BE:       // %bb.0:
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ushll2 v0.2d, v0.4s, #1
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: hadd32_zext_asr:
; CHECK-GI:       // %bb.0:
; CHECK-GI-NEXT:    mov d0, v0.d[1]
; CHECK-GI-NEXT:    ushll v0.2d, v0.2s, #1
; CHECK-GI-NEXT:    ret
  %src1 = bitcast <16 x i8> %src1a to <4 x i32>
  %s1 = shufflevector <4 x i32> %src1, <4 x i32> undef, <2 x i32> <i32 2, i32 3>
  %zextsrc1 = zext <2 x i32> %s1 to <2 x i64>
  %resulti32 = shl <2 x i64> %zextsrc1, <i64 1, i64 1>
  ret <2 x i64> %resulti32
}

define <2 x i64> @test_umull_high_s16_splata1(<2 x i64> %aa, <4 x i32> %b) #0 {
; CHECK-LE-LABEL: test_umull_high_s16_splata1:
; CHECK-LE:       // %bb.0: // %entry
; CHECK-LE-NEXT:    umull2 v0.2d, v1.4s, v0.s[1]
; CHECK-LE-NEXT:    ret
;
; CHECK-BE-LABEL: test_umull_high_s16_splata1:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    rev64 v1.4s, v1.4s
; CHECK-BE-NEXT:    rev64 v0.4s, v0.4s
; CHECK-BE-NEXT:    ext v1.16b, v1.16b, v1.16b, #8
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    umull2 v0.2d, v1.4s, v0.s[1]
; CHECK-BE-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-BE-NEXT:    ret
;
; CHECK-GI-LABEL: test_umull_high_s16_splata1:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov d1, v1.d[1]
; CHECK-GI-NEXT:    umull v0.2d, v1.2s, v0.s[1]
; CHECK-GI-NEXT:    ret
entry:
  %a = bitcast <2 x i64> %aa to <4 x i32>
  %s1 = shufflevector <4 x i32> %a, <4 x i32> undef, <2 x i32> <i32 1, i32 1>
  %s2 = shufflevector <4 x i32> %b, <4 x i32> undef, <2 x i32> <i32 2, i32 3>
  %r = call <2 x i64> @llvm.aarch64.neon.umull.v2i64(<2 x i32> %s1, <2 x i32> %s2)
  ret <2 x i64> %r
}
