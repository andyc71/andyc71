import SwiftUI

struct ProgressSummaryView: View {
    let strongNumbers: [Int]
    let learningNumbers: [Int]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress Tracker")
                .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
                Text("Great with:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(listString(from: strongNumbers, fallback: "Keep practicing to build mastery."))
                    .fontWeight(.semibold)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Still learning:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(listString(from: learningNumbers, fallback: "You know all the numbers!"))
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }

    private func listString(from numbers: [Int], fallback: String) -> String {
        guard !numbers.isEmpty else { return fallback }
        return numbers.map(String.init).joined(separator: ", ")
    }
}
