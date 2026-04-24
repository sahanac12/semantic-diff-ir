target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @compute(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %2, %1
  %3 = phi i64 [ 0, %1 ], [ %33, %2 ]
  %4 = phi <4 x i32> [ zeroinitializer, %1 ], [ %31, %2 ]
  %5 = phi <4 x i32> [ zeroinitializer, %1 ], [ %32, %2 ]
  %6 = getelementptr inbounds i32, ptr %0, i64 %3
  %7 = getelementptr inbounds i32, ptr %6, i64 4
  %8 = load <4 x i32>, ptr %6, align 4
  %9 = load <4 x i32>, ptr %7, align 4
  %10 = add <4 x i32> %8, %4
  %11 = add <4 x i32> %9, %5
  %12 = or disjoint i64 %3, 8
  %13 = getelementptr inbounds i32, ptr %0, i64 %12
  %14 = getelementptr inbounds i32, ptr %13, i64 4
  %15 = load <4 x i32>, ptr %13, align 4
  %16 = load <4 x i32>, ptr %14, align 4
  %17 = add <4 x i32> %15, %10
  %18 = add <4 x i32> %16, %11
  %19 = or disjoint i64 %3, 16
  %20 = getelementptr inbounds i32, ptr %0, i64 %19
  %21 = getelementptr inbounds i32, ptr %20, i64 4
  %22 = load <4 x i32>, ptr %20, align 4
  %23 = load <4 x i32>, ptr %21, align 4
  %24 = add <4 x i32> %22, %17
  %25 = add <4 x i32> %23, %18
  %26 = or disjoint i64 %3, 24
  %27 = getelementptr inbounds i32, ptr %0, i64 %26
  %28 = getelementptr inbounds i32, ptr %27, i64 4
  %29 = load <4 x i32>, ptr %27, align 4
  %30 = load <4 x i32>, ptr %28, align 4
  %31 = add <4 x i32> %29, %24
  %32 = add <4 x i32> %30, %25
  %33 = add nuw nsw i64 %3, 32
  %34 = icmp eq i64 %33, 1024
  br i1 %34, label %35, label %2

35:                                               ; preds = %2
  %36 = add <4 x i32> %32, %31
  %37 = tail call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %36)
  ret i32 %37
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>) #1

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }


