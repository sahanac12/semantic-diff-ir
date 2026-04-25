; ModuleID = 'testcases/tc2_v2.c'
source_filename = "testcases/tc2_v2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @process(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i64 [ 0, %1 ], [ %14, %2 ]
  %4 = phi <4 x i32> [ zeroinitializer, %1 ], [ %12, %2 ]
  %5 = phi <4 x i32> [ zeroinitializer, %1 ], [ %13, %2 ]
  %6 = getelementptr inbounds i32, ptr %0, i64 %3
  %7 = getelementptr inbounds i32, ptr %6, i64 4
  %8 = load <4 x i32>, ptr %6, align 4, !tbaa !5
  %9 = load <4 x i32>, ptr %7, align 4, !tbaa !5
  %10 = tail call <4 x i32> @llvm.smax.v4i32(<4 x i32> %8, <4 x i32> zeroinitializer)
  %11 = tail call <4 x i32> @llvm.smax.v4i32(<4 x i32> %9, <4 x i32> zeroinitializer)
  %12 = add <4 x i32> %10, %4
  %13 = add <4 x i32> %11, %5
  %14 = add nuw i64 %3, 8
  %15 = icmp eq i64 %14, 512
  br i1 %15, label %16, label %2, !llvm.loop !9

16:                                               ; preds = %2
  %17 = add <4 x i32> %13, %12
  %18 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %17)
  ret i32 %18
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x i32> @llvm.smax.v4i32(<4 x i32>, <4 x i32>) #1

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
