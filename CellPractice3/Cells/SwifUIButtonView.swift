//
//  ContentView.swift
//  SwiftUIMeshTest
//
//  Created by admin63 on 23/12/24.
//

import SwiftUI

struct SwiftUIButtonView: View {
    weak var button: GenerateButton?
    var action: () -> Void
    //@State var myToggle = false
    var body: some View {
        Button(action: {
                    action()                  // SwiftUI action
                    button?.sendActions(for: .touchUpInside) // Forward event to UIButton
                }) {
                HStack {
                    Image(systemName: "sparkles")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Try It")
                }
            }
            .tint(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                AnimatedMeshView()
                    .mask(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 16)
                            .blur(radius: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 3)
                            .blur(radius: 2)
                            .blendMode(.overlay)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 1)
                            .blur(radius: 1)
                            .blendMode(.overlay)
                    )
                )
            .background(.black)
            .cornerRadius(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.5), lineWidth: 1)
            )
    }
}

//#Preview {
//    SwiftUIButtonView()
//}
