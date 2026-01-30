import AVFoundation
import SwiftUI

final class LearningViewModel: ObservableObject {
    enum Stage: String, CaseIterable, Identifiable {
        case soundSymbol = "Sound & Symbol"
        case recognize = "Find the Number"
        case match = "Match the Number"
        case math = "Easy Math"

        var id: String { rawValue }
        var instruction: String {
            switch self {
            case .soundSymbol:
                return "Listen and match the sound to the symbol."
            case .recognize:
                return "Can you find the number?"
            case .match:
                return "Pick the matching number."
            case .math:
                return "Solve the math question."
            }
        }
    }

    @Published var stage: Stage = .soundSymbol
    @Published var currentNumber: Int = 1
    @Published var options: [Int] = []
    @Published var rewardMessage: String = ""
    @Published var showReward: Bool = false
    @Published var skillCards: [NumberSkill]
    @Published var mathQuestion: (left: Int, right: Int, answer: Int) = (1, 1, 2)

    private let synthesizer = AVSpeechSynthesizer()
    private var stageCorrectCount = 0

    private let numbers = Array(0...10)
    private let numberWords: [Int: String] = [
        0: "zero",
        1: "one",
        2: "two",
        3: "three",
        4: "four",
        5: "five",
        6: "six",
        7: "seven",
        8: "eight",
        9: "nine",
        10: "ten"
    ]

    init() {
        skillCards = numbers.map { NumberSkill(number: $0, correctCount: 0, incorrectCount: 0) }
        currentNumber = numbers.randomElement() ?? 1
        buildOptions()
        speakInstruction()
    }

    var currentWord: String {
        numberWords[currentNumber, default: ""]
    }

    var stageTitle: String {
        stage.rawValue
    }

    func speakInstruction() {
        let phrase: String
        switch stage {
        case .soundSymbol:
            phrase = "This is \(currentWord)."
        case .recognize:
            phrase = "Can you find the number \(currentWord)?"
        case .match:
            phrase = "Match the number \(currentWord)."
        case .math:
            phrase = "What is \(mathQuestion.left) plus \(mathQuestion.right)?"
        }
        speak(text: phrase)
    }

    func speakNumber() {
        speak(text: currentWord)
    }

    func selectOption(_ number: Int) {
        let isCorrect: Bool
        switch stage {
        case .soundSymbol:
            isCorrect = number == currentNumber
        case .recognize:
            isCorrect = number == currentNumber
        case .match:
            isCorrect = number == currentNumber
        case .math:
            isCorrect = number == mathQuestion.answer
        }

        updateSkill(number: stage == .math ? mathQuestion.answer : currentNumber, correct: isCorrect)
        if isCorrect {
            showPositiveReward()
            stageCorrectCount += 1
        } else {
            rewardMessage = "Nice try! Let's listen again."
            showReward = true
            stageCorrectCount = max(stageCorrectCount - 1, 0)
        }
        advanceAfterAnswer()
    }

    func nextSoundSymbol() {
        updateSkill(number: currentNumber, correct: true)
        showPositiveReward()
        stageCorrectCount += 1
        advanceAfterAnswer()
    }

    func restartStage() {
        stageCorrectCount = 0
        currentNumber = numbers.randomElement() ?? 1
        buildOptions()
        buildMathQuestion()
        speakInstruction()
    }

    func masteredNumbers() -> [Int] {
        skillCards.filter { $0.statusLabel == "Strong" }.map { $0.number }
    }

    func learningNumbers() -> [Int] {
        skillCards.filter { $0.statusLabel != "Strong" }.map { $0.number }
    }

    private func advanceAfterAnswer() {
        currentNumber = numbers.randomElement() ?? 1
        buildOptions()
        buildMathQuestion()
        speakInstruction()
        if stageCorrectCount >= 5 {
            advanceStage()
        }
    }

    private func advanceStage() {
        if let index = Stage.allCases.firstIndex(of: stage), index + 1 < Stage.allCases.count {
            stage = Stage.allCases[index + 1]
            stageCorrectCount = 0
            rewardMessage = "You unlocked \(stage.rawValue)!"
            showReward = true
        } else {
            rewardMessage = "Amazing work! You finished all the activities."
            showReward = true
            stageCorrectCount = 0
        }
    }

    private func buildOptions() {
        let optionCount = 4
        var candidates = Set<Int>()
        candidates.insert(currentNumber)
        while candidates.count < optionCount {
            if let number = numbers.randomElement() {
                candidates.insert(number)
            }
        }
        options = candidates.shuffled()
    }

    private func buildMathQuestion() {
        let left = Int.random(in: 0...5)
        let right = Int.random(in: 0...5)
        mathQuestion = (left: left, right: right, answer: left + right)
        var candidates = Set<Int>()
        candidates.insert(mathQuestion.answer)
        while candidates.count < 4 {
            candidates.insert(Int.random(in: 0...10))
        }
        options = candidates.shuffled()
    }

    private func updateSkill(number: Int, correct: Bool) {
        guard let index = skillCards.firstIndex(where: { $0.number == number }) else { return }
        if correct {
            skillCards[index].correctCount += 1
        } else {
            skillCards[index].incorrectCount += 1
        }
    }

    private func showPositiveReward() {
        let rewards = ["⭐️ Star earned!", "🎈 Great job!", "🌈 You did it!", "🦄 Magical!"]
        rewardMessage = rewards.randomElement() ?? "Great job!"
        showReward = true
    }

    private func speak(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }
}
