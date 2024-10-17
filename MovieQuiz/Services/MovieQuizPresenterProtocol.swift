import UIKit

protocol MovieQuizPresenterProtocol{
    
    func restartGame()
    func convert(model: QuizQuestion) -> QuizStepViewModel
    func isLastQuestion() -> Bool
    func switchToNextQuestion()
    func yesButtonClicked()
    func noButtonClicked()
    func showAnswerResult(isCorrect: Bool)
    func showNextQuestionOrResults()
}
