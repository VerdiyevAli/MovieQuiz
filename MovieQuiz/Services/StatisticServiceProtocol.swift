import Foundation


protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    var highestCorrect: Int {get}
    var totalCorrect: Int {get}

    func store(correct count: Int, total amount: Int)
}

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThen(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
