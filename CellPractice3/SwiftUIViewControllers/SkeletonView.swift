//
//  SkeletonView.swift
//  CellPractice3
//
//  Created by admin63 on 16/11/24.
//
import SwiftUI
import Foundation
import Vision
import AVFoundation

struct SkeletonView: View {
    let points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    let isTpose: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                drawSkeletonLines(in: &path, size: geometry.size)
            }
            .stroke(isTpose ? Color.green : Color.red, lineWidth: 3)
        }
    }
    
    private func drawSkeletonLines(in path: inout Path, size: CGSize) {
        let connections: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
            (.neck, .leftShoulder),
            (.leftShoulder, .leftElbow),
            (.leftElbow, .leftWrist),
            (.neck, .rightShoulder),
            (.rightShoulder, .rightElbow),
            (.rightElbow, .rightWrist),
            (.neck, .root),
            (.root, .leftHip),
            (.leftHip, .leftKnee),
            (.leftKnee, .leftAnkle),
            (.root, .rightHip),
            (.rightHip, .rightKnee),
            (.rightKnee, .rightAnkle)
        ]
        
        for (start, end) in connections {
            guard let startPoint = points[start],
                  let endPoint = points[end] else { continue }
            
            let scaledStart = CGPoint(
                x: startPoint.x * size.width,
                y: startPoint.y * size.height
            )
            let scaledEnd = CGPoint(
                x: endPoint.x * size.width,
                y: endPoint.y * size.height
            )
            
            path.move(to: scaledStart)
            path.addLine(to: scaledEnd)
        }
    }
}
