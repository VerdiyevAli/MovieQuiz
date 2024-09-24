import UIKit


protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}

weak var delegate: QuestionFactoryDelegate?
