import UIKit

// Переименуем AlertModel, чтобы избежать конфликтов
struct QuizAlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}

// Переименуем AlertPresenter
final class QuizAlertPresenter {
    private weak var viewController: UIViewController?

    // Inject view controller into AlertPresenter
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // Method to show the alert
    func showAlert(model: QuizAlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }

        alertController.addAction(action)

        viewController?.present(alertController, animated: true, completion: nil)
    }
}

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var isAlertPresented = false
    private var questionFactory: QuestionFactoryProtocol? // = QuestionFactory()
    private var alertPresenter: QuizAlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.setup(delegate: self)
        imageView.layer.cornerRadius = 20
        
        alertPresenter = QuizAlertPresenter(viewController: self)
        questionFactory.loadData()
        showCurrent()
        self.questionFactory = questionFactory
    }

    // MARK: - Private Methods
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {}

    private func showNetworkError(message: String) {
        let alert = UIAlertController(title: "Ошибка сети", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func showCurrent() {
        guard let factory = questionFactory else {
            // Обработка случая с nil (например, показать ошибку или состояние загрузки)
            return
        }
        factory.requestNextQuestion()
    }


    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // Сохраняем результаты
            statisticService.store(correct: correctAnswers, total: questionsAmount)

            // Показываем результаты квиза
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            resetBorders() // Сбрасываем обводку перед следующим вопросом
            changeStatusButton(isEnabled: true) // Включаем кнопки
            showCurrent()
        }
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        changeStatusButton(isEnabled: false) // Выключаем кнопки

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func resetBorders() {
        // Сброс границ изображения
        imageView.layer.borderWidth = 0
    }

    private func changeStatusButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }

    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        showCurrent()
        resetBorders()
        changeStatusButton(isEnabled: true)
    }

    private func showQuizResults() {
        let bestGame = statisticService.bestGame
        let gamesPlayed = statisticService.gamesCount
        let accuracy = statisticService.totalAccuracy

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: bestGame.date)

        let message = """
        Количество сыгранных квизов: \(gamesPlayed)
        Ваши правильные ответы: \(correctAnswers) из \(questionsAmount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))
        Средняя точность: \(String(format: "%.2f", accuracy))%
        """

        let alertModel = QuizAlertModel(
            title: "Результаты квиза",
            message: message,
            buttonText: "ОК"
        ) { [weak self] in
            self?.resetGame()
        }

        alertPresenter?.showAlert(model: alertModel)
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)

        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }


    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
}
