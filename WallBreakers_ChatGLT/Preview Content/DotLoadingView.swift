//
//  DotLoadingView.swift
//  WallBreakers
//
//  Created by ftsmobileteam on 16/04/2024.
//

import SwiftUI

struct DotLoadingView: View {
    let count: Int = 3
    let animationDuration: Double = 0.9
    let dotSize: CGFloat = 10
    let color: Color

    @State private var currentIndex: Int = 0

    var body: some View {
        HStack(spacing: 7) {
            Spacer()
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .frame(width: dotSize, height: dotSize)
                    .foregroundColor(color)
                    .scaleEffect(currentIndex == index ? 1.5 : 1)
                    .opacity(currentIndex == index ? 1 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: animationDuration / 2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * animationDuration / Double(count)),
                        value: currentIndex
                    )
            }
            Spacer()
        }
        .onAppear {
            currentIndex = 1
            // Using a repeating timer to change currentIndex

            Timer.scheduledTimer(
                withTimeInterval: animationDuration * Double(count) / Double(count + 1),
                repeats: true
            ) { _ in
                currentIndex = (currentIndex + 1) % count
            }
        }
    }
}


#Preview {
    DotLoadingView(color: .blue)
}
