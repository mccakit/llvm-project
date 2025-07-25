; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1030 < %s | FileCheck -enable-var-scope --check-prefix=GCN %s

; GCN-LABEL: {{^}}shl_base_atomicrmw_global_atomic_csub_ptr:
; GCN-DAG: v_lshlrev_b64 v[[[LO:[0-9]+]]:[[HI:[0-9]+]]], 2, v[4:5]
; GCN-DAG: v_mov_b32_e32 [[K:v[0-9]+]], 43
; GCN: v_add_co_u32 v[[EXTRA_LO:[0-9]+]], vcc_lo, 0x80, v4
; GCN: v_add_co_ci_u32_e64 v[[EXTRA_HI:[0-9]+]], null, 0, v5, vcc_lo
; GCN: global_atomic_csub v{{[0-9]+}}, v[[[LO]]:[[HI]]], [[K]], off offset:512 glc
; GCN: global_store_dwordx2 v{{\[[0-9]+:[0-9]+\]}}, v[[[EXTRA_LO]]:[[EXTRA_HI]]]
define i32 @shl_base_atomicrmw_global_atomic_csub_ptr(ptr addrspace(1) %out, ptr addrspace(1) %extra.use, ptr addrspace(1) %ptr) #0 {
  %arrayidx0 = getelementptr inbounds [512 x i32], ptr addrspace(1) %ptr, i64 0, i64 32
  %cast = ptrtoint ptr addrspace(1) %arrayidx0 to i64
  %shl = shl i64 %cast, 2
  %castback = inttoptr i64 %shl to ptr addrspace(1)
  %val = call i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) %castback, i32 43)
  store volatile i64 %cast, ptr addrspace(1) %extra.use, align 4
  ret i32 %val
}

declare i32 @llvm.amdgcn.global.atomic.csub.p1(ptr addrspace(1) nocapture, i32) #0

attributes #0 = { argmemonly nounwind }
