//
//  PetModel.swift
//  visionstyle
//
//  Created by SpatialLaunch Team on 2026/01/30.
//

import SceneKit
import SwiftUI

/// 3D 宠物模型 - 可爱的赛博机器人
class PetModel: SCNNode {
    
    // MARK: - Nodes
    
    private var headNode: SCNNode!
    private var bodyNode: SCNNode!
    private var leftEyeNode: SCNNode!
    private var rightEyeNode: SCNNode!
    private var leftHandNode: SCNNode!
    private var rightHandNode: SCNNode!
    private var antennaNode: SCNNode!
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupGeometry()
        startIdleAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupGeometry() {
        // 1. 材质定义
        let skinMaterial = SCNMaterial()
        skinMaterial.lightingModel = .physicallyBased
        skinMaterial.diffuse.contents = NSColor(calibratedRed: 0.95, green: 0.95, blue: 1.0, alpha: 1.0) // 洁白外壳
        skinMaterial.metalness.contents = 0.1
        skinMaterial.roughness.contents = 0.2
        
        let screenMaterial = SCNMaterial()
        screenMaterial.lightingModel = .physicallyBased
        screenMaterial.diffuse.contents = NSColor.black // 黑色屏幕面部
        screenMaterial.metalness.contents = 0.5
        screenMaterial.roughness.contents = 0.1
        
        let eyeMaterial = SCNMaterial()
        eyeMaterial.lightingModel = .constant
        eyeMaterial.diffuse.contents = NSColor(calibratedRed: 0.0, green: 0.8, blue: 1.0, alpha: 1.0) // 科技蓝眼睛
        eyeMaterial.emission.contents = NSColor(calibratedRed: 0.0, green: 0.8, blue: 1.0, alpha: 1.0)
        
        let metalMaterial = SCNMaterial()
        metalMaterial.lightingModel = .physicallyBased
        metalMaterial.diffuse.contents = NSColor.gray
        metalMaterial.metalness.contents = 0.8
        metalMaterial.roughness.contents = 0.2
        
        // 2. 身体 (Body) - 圆角立方体
        let bodyGeo = SCNBox(width: 1.2, height: 1.4, length: 1.0, chamferRadius: 0.4)
        bodyGeo.materials = [skinMaterial]
        bodyNode = SCNNode(geometry: bodyGeo)
        bodyNode.position = SCNVector3(0, 0, 0)
        addChildNode(bodyNode)
        
        // 肚皮显示屏/核心
        let coreGeo = SCNSphere(radius: 0.3)
        coreGeo.materials = [eyeMaterial]
        let coreNode = SCNNode(geometry: coreGeo)
        coreNode.position = SCNVector3(0, 0, 0.4) // 稍微突出
        coreNode.scale = SCNVector3(1, 1, 0.2) // 压扁
        bodyNode.addChildNode(coreNode)
        
        // 3. 头部 (Head) - 稍大的圆角立方体
        let headGeo = SCNBox(width: 1.4, height: 1.1, length: 1.1, chamferRadius: 0.5)
        headGeo.materials = [skinMaterial]
        headNode = SCNNode(geometry: headGeo)
        headNode.position = SCNVector3(0, 1.3, 0)
        
        // 面部屏幕
        let faceGeo = SCNPlane(width: 1.1, height: 0.8)
        faceGeo.cornerRadius = 0.2
        faceGeo.materials = [screenMaterial]
        let faceNode = SCNNode(geometry: faceGeo)
        faceNode.position = SCNVector3(0, 0, 0.56) // 贴在表面
        headNode.addChildNode(faceNode)
        
        // 左眼
        let eyeGeo = SCNPlane(width: 0.25, height: 0.3) // 椭圆眼
        eyeGeo.cornerRadius = 0.125
        eyeGeo.materials = [eyeMaterial]
        leftEyeNode = SCNNode(geometry: eyeGeo)
        leftEyeNode.position = SCNVector3(-0.25, 0.05, 0.01)
        faceNode.addChildNode(leftEyeNode)
        
        // 右眼
        rightEyeNode = leftEyeNode.clone()
        rightEyeNode.position = SCNVector3(0.25, 0.05, 0.01)
        faceNode.addChildNode(rightEyeNode)
        
        // 天线
        let antennaStemGeo = SCNCylinder(radius: 0.05, height: 0.5)
        antennaStemGeo.materials = [metalMaterial]
        let antennaStem = SCNNode(geometry: antennaStemGeo)
        antennaStem.position = SCNVector3(0, 0.6, 0)
        headNode.addChildNode(antennaStem)
        
        let antennaBallGeo = SCNSphere(radius: 0.1)
        antennaBallGeo.materials = [eyeMaterial]
        antennaNode = SCNNode(geometry: antennaBallGeo)
        antennaNode.position = SCNVector3(0, 0.25, 0)
        antennaStem.addChildNode(antennaNode)
        
        addChildNode(headNode)
        
        // 4. 手臂 (Hands) - 悬浮球体
        let handGeo = SCNSphere(radius: 0.25)
        handGeo.materials = [skinMaterial]
        
        leftHandNode = SCNNode(geometry: handGeo)
        leftHandNode.position = SCNVector3(-0.8, -0.2, 0.2)
        addChildNode(leftHandNode)
        
        rightHandNode = leftHandNode.clone()
        rightHandNode.position = SCNVector3(0.8, -0.2, 0.2)
        addChildNode(rightHandNode)
    }
    
    // MARK: - Animations
    
    /// 待机动画：轻轻上下浮动 + 眨眼
    private func startIdleAnimation() {
        // 1. 身体上下浮动
        let floatUp = SCNAction.moveBy(x: 0, y: 0.1, z: 0, duration: 1.5)
        floatUp.timingMode = .easeInEaseOut
        let floatDown = floatUp.reversed()
        let floatSeq = SCNAction.sequence([floatUp, floatDown])
        let floatLoop = SCNAction.repeatForever(floatSeq)
        self.runAction(floatLoop)
        
        // 2. 手臂摆动 (滞后于身体)
        let armFloatUp = SCNAction.moveBy(x: 0, y: 0.15, z: 0, duration: 1.6) // 稍微慢一点
        armFloatUp.timingMode = .easeInEaseOut
        let armFloatDown = armFloatUp.reversed()
        let armSeq = SCNAction.sequence([armFloatUp, armFloatDown])
        let armLoop = SCNAction.repeatForever(armSeq)
        leftHandNode.runAction(armLoop)
        rightHandNode.runAction(armLoop)
        
        // 3. 眨眼
        startBlinkLoop()
        
        // 4. 天线发光闪烁
        let dim = SCNAction.fadeOpacity(to: 0.5, duration: 2.0)
        let bright = SCNAction.fadeOpacity(to: 1.0, duration: 2.0)
        let glowSeq = SCNAction.sequence([dim, bright])
        antennaNode.runAction(SCNAction.repeatForever(glowSeq))
    }
    
    private func startBlinkLoop() {
        // 随机眨眼间隔
        let wait = SCNAction.wait(duration: Double.random(in: 2.0...5.0))
        let blinkClose = SCNAction.scale(to: 0.1, duration: 0.1) // 压扁 Y 轴
        blinkClose.timingMode = .easeIn
        let blinkOpen = SCNAction.scale(to: 1.0, duration: 0.1)
        blinkOpen.timingMode = .easeOut
        
        // 这里需要分别作用于两个眼睛的 geometry 或者 scale
        // 由于是 Plane，我们可以做 Y 轴缩放
        let blinkAction = SCNAction.run { [weak self] _ in
            self?.leftEyeNode.runAction(SCNAction.sequence([SCNAction.scale(to: 0.1, duration: 0.1), SCNAction.scale(to: 1.0, duration: 0.1)]))
            self?.rightEyeNode.runAction(SCNAction.sequence([SCNAction.scale(to: 0.1, duration: 0.1), SCNAction.scale(to: 1.0, duration: 0.1)]))
        }
        
        let seq = SCNAction.sequence([wait, blinkAction, SCNAction.run { [weak self] _ in self?.startBlinkLoop() }])
        runAction(seq)
    }
    
    // MARK: - Interaction API
    
    /// 开心/兴奋动作 (喂食/洗澡/升级)
    func performHappyJump() {
        // 跳跃
        let jumpUp = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration: 0.3)
        jumpUp.timingMode = .easeOut
        let jumpDown = jumpUp.reversed()
        jumpDown.timingMode = .easeIn
        
        // 空中旋转
        let spin = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 0.6)
        
        let jumpSeq = SCNAction.sequence([jumpUp, jumpDown])
        let group = SCNAction.group([jumpSeq, spin])
        
        // 挤压变形
        let squash = SCNAction.scale(to: 0.8, duration: 0.1)
        let stretch = SCNAction.scale(to: 1.2, duration: 0.1)
        let normal = SCNAction.scale(to: 1.0, duration: 0.1)
        
        self.runAction(SCNAction.sequence([squash, stretch, group, squash, normal]))
    }
    
    /// 玩耍动作 (左右晃动)
    func performPlayAction() {
        let leanLeft = SCNAction.rotateTo(x: 0, y: 0, z: 0.3, duration: 0.2)
        let leanRight = SCNAction.rotateTo(x: 0, y: 0, z: -0.3, duration: 0.4)
        let backCenter = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.2)
        
        let seq = SCNAction.sequence([leanLeft, leanRight, leanLeft, leanRight, backCenter])
        self.runAction(seq)
        
        // 手臂像在打招呼
        let wave = SCNAction.sequence([
            SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 0.2),
            SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 0.2)
        ])
        rightHandNode.runAction(SCNAction.repeat(wave, count: 2))
    }
}
