//
//  PreferencesView.swift
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedOutput: String
    let outputs: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Audio Output")
                .font(.title2).bold()

            Picker("Select Output:", selection: $selectedOutput) {
                ForEach(outputs, id: \.self, content: Text.init)
            }
            .pickerStyle(.radioGroup)

            Spacer()

            HStack {
                Spacer()
                Button("Close") { dismiss() }
                    .keyboardShortcut(.escape)
            }
        }
        .padding(28)
        .frame(width: 320, height: 180)
    }
}
