//
//  PetSceneView.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/01/30.
//

import SwiftUI
import SceneKit

/// 3D 宠物的 SceneKit 容器视图
struct PetSceneView: NSViewRepresentable {
    let petModel: PetModel
    
    func makeNSView(context: Context) -> SCNView {
        let scnView = SCNView()
        
        // 1. 创建场景
        let scene = SCNScene()
        scnView.scene = scene
        
        // 2. 设置透明背景
        scnView.backgroundColor = .clear
        scene.background.contents = NSColor.clear
        
        // 3. 添加相机
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 1.0, 5) // 位于前方 5 单位
        scene.rootNode.addChildNode(cameraNode)
        
        // 4. 添加灯光
        // 主光源 (暖色)
        let omniLight = SCNNode()
        omniLight.light = SCNLight()
        omniLight.light?.type = .omni
        omniLight.light?.color = NSColor(calibratedRed: 1.0, green: 0.95, blue: 0.9, alpha: 1.0)
        omniLight.position = SCNVector3(5, 5, 10)
        scene.rootNode.addChildNode(omniLight)
        
        // 补光 (冷色)
        let fillLight = SCNNode()
        fillLight.light = SCNLight()
        fillLight.light?.type = .omni
        fillLight.light?.color = NSColor(calibratedRed: 0.9, green: 0.9, blue: 1.0, alpha: 0.6)
        fillLight.position = SCNVector3(-5, 5, 10)
        scene.rootNode.addChildNode(fillLight)
        
        // 环境光 (提亮阴影)
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = NSColor(white: 0.4, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // 5. 添加宠物模型
        scene.rootNode.addChildNode(petModel)
        
        // 6. 配置视图选项
        scnView.allowsCameraControl = false // 禁止用户随意旋转相机
        scnView.autoenablesDefaultLighting = false
        scnView.antialiasingMode = .multisampling4X
        
        return scnView
    }
    
    func updateNSView(_ nsView: SCNView, context: Context) {
        // 视图更新逻辑 (如果有)
    }
}
