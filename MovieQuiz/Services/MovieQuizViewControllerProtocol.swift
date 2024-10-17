import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showAnswerResult(isCorrect: Bool)
    func showNetworkError(message: String)
    func changeStateButton(isEnabled: Bool)
    func showAlert(model: AlertModel)
}

