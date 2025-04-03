//
//  UIKitInstructionButton.swift
//  CellPractice3
//
//  Created by admin29 on 03/04/25.
//

import SwiftUI


final class UIKitInstructionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        setImage(UIImage(systemName: "info.circle"), for: .normal)
        tintColor = .white
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        frame.size = CGSize(width: 25, height: 25) // Force size
    }
}
