import Foundation

struct NumberSkill: Identifiable {
    let id = UUID()
    let number: Int
    var correctCount: Int
    var incorrectCount: Int

    var attempts: Int {
        correctCount + incorrectCount
    }

    var accuracy: Double {
        guard attempts > 0 else { return 0 }
        return Double(correctCount) / Double(attempts)
    }

    var statusLabel: String {
        if correctCount >= 3 && accuracy >= 0.8 {
            return "Strong"
        }
        if attempts == 0 {
            return "New"
        }
        return "Learning"
    }
}
