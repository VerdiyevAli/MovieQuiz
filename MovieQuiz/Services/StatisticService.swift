import Foundation

final class StatisticService: StatisticServiceProtocol{
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        public enum BestGame: String {
            case date
            case correct
            case total
        }
        case gamesCount
        case highestCorrect
        case totalCorrect
    }
    // Games count
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // Total
    var totalCorrect: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrect.rawValue)
        }
    }
    // Best game
    var bestGame: GameResult {
        get {
            let date = storage.object(forKey: Keys.BestGame.date.rawValue) as? Date ?? Date()
            let correct = storage.integer(forKey: Keys.BestGame.correct.rawValue)
            let total = storage.integer(forKey: Keys.BestGame.total.rawValue)
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.date, forKey: Keys.BestGame.date.rawValue)
            storage.set(newValue.correct, forKey: Keys.BestGame.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.BestGame.total.rawValue)
        }
    }
    // Highest result
    var highestCorrect: Int {
        get {
            return storage.integer(forKey: Keys.highestCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.highestCorrect.rawValue)
        }
    }
    // отношение всех правильных ответов от общего числа вопросов
    
    var totalAccuracy: Double {
        get {
            let totalCorrect = self.totalCorrect
            let totalQuestions = gamesCount * 10
            return totalQuestions != 0 ? 100 * Double(totalCorrect)/Double(totalQuestions): 0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let date = Date()
        
        self.gamesCount += 1
        self.totalCorrect += count
        if count > highestCorrect {
            highestCorrect = count
        }
        
        let gameResult = GameResult(correct: count, total: amount, date: date)
        if gameResult .isBetterThen(bestGame) {
            bestGame = gameResult
        }
    }
    func bestGameMessage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: bestGame.date)
        
        return """
        Лучший результат:
        Правильных ответов: \(bestGame.correct)
        Всего вопросов: \(bestGame.total)
        Дата: \(formattedDate)
        """
    }
}


