//
//  BottomRightCornerClipShape.swift
//  mymx
//
//  Created by ice on 2024/7/16.
//

import SwiftUI

struct BottomRightCornerClipShape: Shape {
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top-left corner
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Top-right corner
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Bottom-right corner
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: rect.width - cornerRadius, y: rect.height),
                          control: CGPoint(x: rect.width, y: rect.height))
        
        // Bottom-left corner
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        path.closeSubpath()
        
        return path
    }
}
