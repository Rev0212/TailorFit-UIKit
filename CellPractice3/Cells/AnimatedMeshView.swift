import SwiftUI

struct AnimatedMeshView: View {
    @State var appear = false
    @State var appear2 = false
    
    var body: some View {
        MeshGradient(width: 3,
                     height: 3,
                     points: [
                        CGPoint(x: 0, y: 0), CGPoint(x: appear2 ? 0.5 : 1, y: 0), CGPoint(x: 1, y: 0),
                        CGPoint(x: 0, y: 0.5), CGPoint(x: appear ? 0.1 : 0.8, y: appear ? 0.5 : 0.2), CGPoint(x: 1, y: -0.5),
                        CGPoint(x: 0, y: 1), CGPoint(x: appear2 ? 2 : 0, y: 1), CGPoint(x: 1, y: 1)
                     ], colors: [
                        appear2 ? .red : .mint, appear2 ? .yellow : .cyan, .orange,
                        appear ? .blue : .red, appear ? .cyan : .white, appear ? .red : .purple,
                        appear ? .red : .cyan, appear ? .mint : .blue, appear2 ? .red : .blue
                     ])
        .onAppear {
            withAnimation(
                .easeOut(duration: 5)
                .repeatForever(autoreverses: true)
            ) { appear.toggle() }
            withAnimation(
                .easeOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) { appear2.toggle() }
        }
    }
}

#Preview {
    AnimatedMeshView().ignoresSafeArea()
}