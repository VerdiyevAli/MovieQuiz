import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showAlert(model: MovieQuiz.AlertModel) {}
    
    func showAnswerResult(isCorrect: Bool) {}
    
    func changeStateButton(isEnabled: Bool) {}
    
    func show(quiz step: QuizStepViewModel) {}
    
    func highlightImageBorder(isCorrect: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showAnswerResult() {}
    
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        // Создаем мок ViewController
        let viewControllerMock = MovieQuizViewControllerMock()
        
        // Создаем презентер
        let sut = MovieQuizPresenter()
        sut.viewController = viewControllerMock // Устанавливаем мок как viewController презентера
        
        // Данные для теста
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        
        // Выполняем конвертацию модели
        let viewModel = sut.convert(model: question)
        
        // Проверяем, что результат конвертации правильный
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
