//
//  PetView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/01/30.
//

import SwiftUI

struct PetView: View {
    @State private var petManager = PetManager.shared
    @State private var pet3DModel = PetModel() // 3D模型实例
    
    @State private var isHovering = false
    
    var body: some View {
        VStack(spacing: 8) {
            // 顶部留出固定空间专门用于显示气泡，防止被窗口边缘裁切
            Spacer()
                .frame(minHeight: 40)
            
            // 提示气泡 (使用 overlay 或 ZStack 也可以，这里直接放在 VStack 顶部)
            if let msg = petManager.currentMessage {
                Text(msg)
                    .font(.system(size: 13, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 5)
                    .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: .bottom)))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    // 向上偏移一点，避免贴着模型
                    .offset(y: 10)
                    .zIndex(1)
            } else {
                // 占位，保持布局稳定
                Spacer().frame(height: 38)
            }
            
            // 宠物主体 (3D 场景)
            ZStack {
                // 光晕 (增强立体感)
                Circle()
                    .fill(Color.blue.opacity(isHovering ? 0.2 : 0.0))
                    .frame(width: 100, height: 100)
                    .blur(radius: 15)
                    .animation(.spring(), value: isHovering)
                
                // 3D 场景视图
                PetSceneView(petModel: pet3DModel)
                    .frame(width: 150, height: 150)
                    .allowsHitTesting(false) // 防止 SceneKit 吞没点击事件
            }
            .contentShape(Rectangle()) // 确保透明区域也能响应点击
            .onHover { hover in
                withAnimation {
                    isHovering = hover
                }
            }
            .onTapGesture {
                performRandomTapAction()
            }
            .contextMenu {
                Button {
                    perform(.feed)
                } label: {
                    Label(L10n.Pet.feedXP, systemImage: "fork.knife")
                }
                
                Button {
                    perform(.wash)
                } label: {
                    Label(L10n.Pet.washXP, systemImage: "drop.fill")
                }
                
                Button {
                    perform(.play)
                } label: {
                    Label(L10n.Pet.playXP, systemImage: "gamecontroller.fill")
                }
                
                Divider()
                
                Text("\(L10n.Pet.level): LV.\(petManager.level)")
                Text("\(L10n.Pet.xp): \(petManager.experience) / \(petManager.maxExperience)")
            }
            
            // 状态条 (Hover 时显示)
            if isHovering {
                VStack(spacing: 4) {
                    Text("LV.\(petManager.level)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    // 经验条
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.black.opacity(0.3))
                            Capsule()
                                .fill(Color.cyan) // 科技蓝更配机器人
                                .frame(width: geo.size.width * CGFloat(petManager.experience) / CGFloat(petManager.maxExperience))
                        }
                    }
                    .frame(width: 60, height: 4)
                }
                .transition(.opacity)
            }
        }
        .frame(width: 200, height: 260) // 调整窗口大小以适应 3D 模型和气泡
    }
    
    // MARK: - Actions
    
    private func perform(_ action: PetAction) {
        let (success, msg) = petManager.performAction(action)
        petManager.showMessage(msg)
        
        if success {
            // 触发 3D 动画
            switch action {
            case .feed, .wash:
                pet3DModel.performHappyJump()
            case .play:
                pet3DModel.performPlayAction()
            }
        }
    }
    
    private func showStatus() {
        let status = L10n.Pet.statusFormat.localized(with: Int(petManager.hunger), Int(petManager.happiness))
        petManager.showMessage(status)
    }

    private func performRandomTapAction() {
        let actions: [() -> Void] = [
            {
                showStatus()
            },
            {
                petManager.showMessage(L10n.Pet.chatTickle, duration: 3.0)
                pet3DModel.performHappyJump()
            },
            {
                petManager.showMessage(L10n.Pet.chatMissMe, duration: 4.0)
                pet3DModel.performPlayAction()
            }
        ]
        
        let randomAction = actions.randomElement()!
        randomAction()
    }
}
