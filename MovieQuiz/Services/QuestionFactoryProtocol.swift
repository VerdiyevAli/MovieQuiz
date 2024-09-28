import UIKit

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    func setup(delegate: QuestionFactoryDelegate)
}
