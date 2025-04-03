import SwiftUI

struct InstructionButton: View {
    @State private var showInstructions = false

    var body: some View {
        Button(action: {
            showInstructions = true
        }) {
            Image(systemName: "info.circle")
                .imageScale(.large) // Makes the icon larger
                .font(.title3) // Slightly bigger than caption
                .frame(width: 35, height: 35) // Bigger button size
                .foregroundColor(.white) // Ensures visibility
        }
        .contentShape(Rectangle()) // Expands tappable area
        .sheet(isPresented: $showInstructions) {
            InstructionView(isPresented: $showInstructions)
        }
    }
}
