import UIKit

/// Отвечает за загрузку данных по URL
struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}

// Задаем URL для получения списка популярных фильмов
let mostPopularMoviesUrl = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf")!

// Создаем экземпляр NetworkClient
let networkClient = NetworkClient()

// Функция для загрузки данных о популярных фильмах
/*func loadMovie(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
    networkClient.fetch(url: mostPopularMoviesUrl) { result in
        switch result {
        case .success(let data):
            do {
                let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                handler(.success(mostPopularMovies))
            } catch {
                handler(.failure(error))
            }
        case .failure(let error):
            handler(.failure(error))
        }
    }
}
*/
