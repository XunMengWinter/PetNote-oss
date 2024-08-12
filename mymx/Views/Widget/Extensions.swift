//
//  Extensions.swift
//  mymx
//
//  Created by ice on 2024/7/14.
//

import Foundation
import SwiftUI

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        // Use the correct scale factor for the current screen
        let rendererFormat = UIGraphicsImageRendererFormat.default() // 3:1
        rendererFormat.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct DismissKeyboardOnScrollModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        dismissKeyboard()
                    }
            )
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Extension to easily apply the modifier
extension View {
    func dismissKeyboardOnScroll() -> some View {
        withAnimation{
            self.modifier(DismissKeyboardOnScrollModifier())
        }
    }
}

extension AnyTransition {
    static var moveFromTopAndFade: AnyTransition {
        .asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .opacity)
    }
}
