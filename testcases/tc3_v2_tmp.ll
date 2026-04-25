; ModuleID = 'testcases/tc3_v2.c'
source_filename = "testcases/tc3_v2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local double @multiply(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  br label %3

2:                                                ; preds = %3
  ret double %36

3:                                                ; preds = %3, %1
  %4 = phi i64 [ 0, %1 ], [ %37, %3 ]
  %5 = phi double [ 1.000000e+00, %1 ], [ %36, %3 ]
  %6 = getelementptr inbounds double, ptr %0, i64 %4
  %7 = load double, ptr %6, align 8, !tbaa !5
  %8 = fmul double %5, %7
  %9 = or disjoint i64 %4, 1
  %10 = getelementptr inbounds double, ptr %0, i64 %9
  %11 = load double, ptr %10, align 8, !tbaa !5
  %12 = fmul double %8, %11
  %13 = or disjoint i64 %4, 2
  %14 = getelementptr inbounds double, ptr %0, i64 %13
  %15 = load double, ptr %14, align 8, !tbaa !5
  %16 = fmul double %12, %15
  %17 = or disjoint i64 %4, 3
  %18 = getelementptr inbounds double, ptr %0, i64 %17
  %19 = load double, ptr %18, align 8, !tbaa !5
  %20 = fmul double %16, %19
  %21 = or disjoint i64 %4, 4
  %22 = getelementptr inbounds double, ptr %0, i64 %21
  %23 = load double, ptr %22, align 8, !tbaa !5
  %24 = fmul double %20, %23
  %25 = or disjoint i64 %4, 5
  %26 = getelementptr inbounds double, ptr %0, i64 %25
  %27 = load double, ptr %26, align 8, !tbaa !5
  %28 = fmul double %24, %27
  %29 = or disjoint i64 %4, 6
  %30 = getelementptr inbounds double, ptr %0, i64 %29
  %31 = load double, ptr %30, align 8, !tbaa !5
  %32 = fmul double %28, %31
  %33 = or disjoint i64 %4, 7
  %34 = getelementptr inbounds double, ptr %0, i64 %33
  %35 = load double, ptr %34, align 8, !tbaa !5
  %36 = fmul double %32, %35
  %37 = add nuw nsw i64 %4, 8
  %38 = icmp eq i64 %37, 256
  br i1 %38, label %2, label %3, !llvm.loop !9
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"double", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
