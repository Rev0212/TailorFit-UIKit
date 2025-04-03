//
//  InstructionView.swift
//  CellPractice3
//
//  Created by admin29 on 26/03/25.
//


import SwiftUI

struct InstructionView: View {
    @Binding var isPresented: Bool
    
    private let sectionHeadings = ["BEFORE YOU START", "DURING MEASUREMENT"]
    private let instructions = [
        [
            (title: "Wear Fitting Clothes", icon: "person.fill", description: "Wear close-fitting clothes for accurate measurements"),
            (title: "Good Lighting", icon: "lightbulb", description: "Ensure you're in a well-lit area"),
            (title: "Distance", icon: "ruler", description: "Stand 2-3 meters away from the camera"),
            (title: "Clear Space", icon: "person.fill.viewfinder", description: "Make sure no other people are in the frame")
        ],
        [
            (title: "Stand Straight", icon: "figure.stand", description: "Keep your arms slightly away from your body"),
            (title: "Stay Still", icon: "pause.circle", description: "Remain still until the scan is complete")
        ]
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<sectionHeadings.count, id: \.self) { section in
                    Section(header: Text(sectionHeadings[section])) {
                        ForEach(instructions[section], id: \.title) { instruction in
                            HStack {
                                Image(systemName: instruction.icon)
                                    .frame(width: 30)
                                VStack(alignment: .leading) {
                                    Text(instruction.title)
                                        .font(.headline)
                                    Text(instruction.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Instructions")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}
