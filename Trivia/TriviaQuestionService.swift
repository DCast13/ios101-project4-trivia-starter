//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Dakota Castilleja on 2/25/25.
//

import Foundation

struct TriviaAPIResponse: Decodable {
    let results: [TriviaAPIQuestion]
}

struct TriviaAPIQuestion: Decodable {
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

class TriviaQuestionService {
    func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=10"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                let triviaQuestions = decodedResponse.results.map { apiQuestion in
                    TriviaQuestion(
                        category: apiQuestion.category,
                        question: apiQuestion.question,
                        correctAnswer: apiQuestion.correct_answer,
                        incorrectAnswers: apiQuestion.incorrect_answers
                    )
                }
                DispatchQueue.main.async {
                    completion(triviaQuestions)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
