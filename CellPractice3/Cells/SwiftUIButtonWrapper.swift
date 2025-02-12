import SwiftUI

class SwiftUIButtonWrapper: UIView {
    init(action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        let swiftUIButton = SwiftUIButtonView(action: action)
        let hostingController = UIHostingController(rootView: swiftUIButton)

        // Ensure the hosting controller's view resizes properly
        let swiftUIView = hostingController.view!
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(swiftUIView)

        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: topAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
