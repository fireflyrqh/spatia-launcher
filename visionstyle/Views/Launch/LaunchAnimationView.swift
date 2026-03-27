//
//  LaunchAnimationView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2025/12/28.
//

import SwiftUI

/// 启动动画视图 - VisionOS 风格的入场动画
struct LaunchAnimationView: View {
    @State private var showLogo = false
    @State private var showRing1 = false
    @State private var showRing2 = false
    @State private var showRing3 = false
    @State private var showTitle = false
    @State private var ringRotation: Double = 0
    @State private var isCompleted = false
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // 背景渐变
            RadialGradient(
                colors: [
                    Color(hex: "1a1a2e"),
                    Color(hex: "16213e"),
                    Color(hex: "0f0c29")
                ],
                center: .center,
                startRadius: 0,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            // 动态光晕背景
            animatedBackground
            
            // 中心内容
            VStack(spacing: 30) {
                // Logo 与环形动画
                ZStack {
                    // 外环 3
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [.purple.opacity(0.3), .blue.opacity(0.5), .cyan.opacity(0.3), .purple.opacity(0.3)],
                                center: .center
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(ringRotation))
                        .scaleEffect(showRing3 ? 1 : 0.5)
                        .opacity(showRing3 ? 1 : 0)
                    
                    // 外环 2
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [.blue.opacity(0.4), .purple.opacity(0.6), .pink.opacity(0.4), .blue.opacity(0.4)],
                                center: .center
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-ringRotation * 1.5))
                        .scaleEffect(showRing2 ? 1 : 0.5)
                        .opacity(showRing2 ? 1 : 0)
                    
                    // 内环 1
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [.cyan.opacity(0.5), .blue.opacity(0.7), .purple.opacity(0.5), .cyan.opacity(0.5)],
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(ringRotation * 2))
                        .scaleEffect(showRing1 ? 1 : 0.5)
                        .opacity(showRing1 ? 1 : 0)
                    
                    // 中心 Logo
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 20)
                        .scaleEffect(showLogo ? 1 : 0)
                        .opacity(showLogo ? 1 : 0)
                }
                
                // 标题
                VStack(spacing: 8) {
                    Text("SpatialLaunch")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("VisionOS 风格应用启动器")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                .offset(y: showTitle ? 0 : 20)
                .opacity(showTitle ? 1 : 0)
            }
        }
        .opacity(isCompleted ? 0 : 1)
        .onAppear {
            startAnimation()
        }
    }
    
    /// 动态背景
    private var animatedBackground: some View {
        ZStack {
            // 光晕 1
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.purple.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)
                .offset(x: -200, y: -150)
                .blur(radius: 60)
            
            // 光晕 2
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.blue.opacity(0.2), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 250
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: 200, y: 200)
                .blur(radius: 50)
        }
    }
    
    /// 启动动画序列
    private func startAnimation() {
        // Logo 出现
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
            showLogo = true
        }
        
        // 环 1 出现
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) {
            showRing1 = true
        }
        
        // 环 2 出现
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.6)) {
            showRing2 = true
        }
        
        // 环 3 出现
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.8)) {
            showRing3 = true
        }
        
        // 标题出现
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0)) {
            showTitle = true
        }
        
        // 环旋转动画
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            ringRotation = 360
        }
        
        // 完成动画后淡出
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                isCompleted = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onComplete()
            }
        }
    }
}

#Preview {
    LaunchAnimationView(onComplete: {})
        .frame(width: 800, height: 600)
}
