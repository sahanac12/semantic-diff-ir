; ModuleID = 'testcases/tc5_v2.c'
source_filename = "testcases/tc5_v2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @stride(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %18, %1
  %3 = phi i64 [ 0, %1 ], [ %29, %18 ]
  %4 = phi <4 x i32> [ zeroinitializer, %1 ], [ %27, %18 ]
  %5 = phi <4 x i32> [ zeroinitializer, %1 ], [ %28, %18 ]
  %6 = shl nuw i64 %3, 1
  %7 = or disjoint i64 %6, 8
  %8 = getelementptr inbounds i32, ptr %0, i64 %6
  %9 = getelementptr inbounds i32, ptr %0, i64 %7
  %10 = load <8 x i32>, ptr %8, align 4, !tbaa !5
  %11 = load <8 x i32>, ptr %9, align 4, !tbaa !5
  %12 = shufflevector <8 x i32> %10, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %13 = shufflevector <8 x i32> %11, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %14 = add <4 x i32> %12, %4
  %15 = add <4 x i32> %13, %5
  %16 = or disjoint i64 %3, 8
  %17 = icmp eq i64 %16, 504
  br i1 %17, label %30, label %18, !llvm.loop !9

18:                                               ; preds = %2
  %19 = shl nuw i64 %16, 1
  %20 = or disjoint i64 %19, 8
  %21 = getelementptr inbounds i32, ptr %0, i64 %19
  %22 = getelementptr inbounds i32, ptr %0, i64 %20
  %23 = load <8 x i32>, ptr %21, align 4, !tbaa !5
  %24 = load <8 x i32>, ptr %22, align 4, !tbaa !5
  %25 = shufflevector <8 x i32> %23, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %26 = shufflevector <8 x i32> %24, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %27 = add <4 x i32> %25, %14
  %28 = add <4 x i32> %26, %15
  %29 = add nuw nsw i64 %3, 16
  br label %2

30:                                               ; preds = %2
  %31 = add <4 x i32> %15, %14
  %32 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %31)
  %33 = getelementptr inbounds i32, ptr %0, i64 1008
  %34 = load i32, ptr %33, align 4, !tbaa !5
  %35 = add nsw i32 %34, %32
  %36 = getelementptr inbounds i32, ptr %0, i64 1010
  %37 = load i32, ptr %36, align 4, !tbaa !5
  %38 = add nsw i32 %37, %35
  %39 = getelementptr inbounds i32, ptr %0, i64 1012
  %40 = load i32, ptr %39, align 4, !tbaa !5
  %41 = add nsw i32 %40, %38
  %42 = getelementptr inbounds i32, ptr %0, i64 1014
  %43 = load i32, ptr %42, align 4, !tbaa !5
  %44 = add nsw i32 %43, %41
  %45 = getelementptr inbounds i32, ptr %0, i64 1016
  %46 = load i32, ptr %45, align 4, !tbaa !5
  %47 = add nsw i32 %46, %44
  %48 = getelementptr inbounds i32, ptr %0, i64 1018
  %49 = load i32, ptr %48, align 4, !tbaa !5
  %50 = add nsw i32 %49, %47
  %51 = getelementptr inbounds i32, ptr %0, i64 1020
  %52 = load i32, ptr %51, align 4, !tbaa !5
  %53 = add nsw i32 %52, %50
  %54 = getelementptr inbounds i32, ptr %0, i64 1022
  %55 = load i32, ptr %54, align 4, !tbaa !5
  %56 = add nsw i32 %55, %53
  ret i32 %56
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>) #1

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11, !12}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.isvectorized", i32 1}
!12 = !{!"llvm.loop.unroll.runtime.disable"}
