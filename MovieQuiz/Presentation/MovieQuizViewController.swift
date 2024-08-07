import UIKit

final class MovieQuizViewController: UIViewController {
   private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(
                    image: "The Godfather",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "The Dark Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "Kill Bill",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "The Avengers",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "Deadpool",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "The Green Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "Old",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
                QuizQuestion(
                    image: "The Ice Age Adventures of Buck Wild",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
                QuizQuestion(
                    image: "Tesla",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
                QuizQuestion(
                    image: "Vivarium",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false)
            ]

    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var isAlertPresented = false

    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func showCurrent() {
        let currentQuestion = questions[currentQuestionIndex]
        let currentView = convert(model: currentQuestion)
        show(quiz: currentView)
    }

    private func showNextQuestionOrResult() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor

        if currentQuestionIndex == questions.count - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            showCurrent()
        }
    }
    private func showResults() {
        if isAlertPresented { return }

        isAlertPresented = true

        let alert = UIAlertController(
            title: "Quiz Finished",
            message: "You got \(correctAnswers) out of \(questions.count) correct!",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.isAlertPresented = false
            self.resetGame()
        }

        alert.addAction(action)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
       
        imageView.layer.cornerRadius = imageView.bounds.height / 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
            
        }
    }

    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        showCurrent()
        
    }


    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var questionLablel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrent()
        
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
//
//
//
//
