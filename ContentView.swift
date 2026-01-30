import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LearningViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.pink.opacity(0.2), Color.blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    header

                    stageCard

                    ProgressSummaryView(
                        strongNumbers: viewModel.masteredNumbers(),
                        learningNumbers: viewModel.learningNumbers()
                    )
                }
                .padding(.vertical)
            }

            if viewModel.showReward {
                VStack {
                    Spacer()
                    RewardView(message: viewModel.rewardMessage)
                    Button("Keep Going") {
                        withAnimation {
                            viewModel.showReward = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                }
                .background(Color.black.opacity(0.15).ignoresSafeArea())
                .transition(.opacity)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Number Adventure")
                .font(.largeTitle.bold())
            Text(viewModel.stageTitle)
                .font(.title3)
                .foregroundColor(.secondary)
            Text(viewModel.stage.instruction)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    private var stageCard: some View {
        VStack(spacing: 16) {
            switch viewModel.stage {
            case .soundSymbol:
                soundSymbolView
            case .recognize:
                recognizeView
            case .match:
                matchView
            case .math:
                mathView
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.85))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
        .padding(.horizontal)
    }

    private var soundSymbolView: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.currentNumber)")
                .font(.system(size: 100, weight: .bold, design: .rounded))

            HStack(spacing: 12) {
                Button("Hear it") {
                    viewModel.speakNumber()
                }
                .buttonStyle(.bordered)

                Button("I know it!") {
                    viewModel.nextSoundSymbol()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var recognizeView: some View {
        VStack(spacing: 16) {
            Text("Listen and tap the number")
                .font(.headline)
            optionGrid
            Button("Repeat instruction") {
                viewModel.speakInstruction()
            }
            .buttonStyle(.bordered)
        }
    }

    private var matchView: some View {
        VStack(spacing: 16) {
            Text("Find the number that matches the word")
                .font(.headline)
            Text(viewModel.currentWord.capitalized)
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.purple)
            optionGrid
        }
    }

    private var mathView: some View {
        VStack(spacing: 16) {
            Text("Solve the math")
                .font(.headline)
            Text("\(viewModel.mathQuestion.left) + \(viewModel.mathQuestion.right) = ?")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.green)
            optionGrid
        }
    }

    private var optionGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.options, id: \.self) { option in
                Button {
                    viewModel.selectOption(option)
                } label: {
                    Text("\(option)")
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.orange.opacity(0.8))
            }
        }
    }
}
