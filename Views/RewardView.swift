import SwiftUI

struct RewardView: View {
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.title3)
                .fontWeight(.semibold)
            Text("Keep going!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow.opacity(0.25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.orange.opacity(0.6), lineWidth: 2)
        )
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
    }
}
