//
//  QuizAlertModel.swift
//  MovieQuiz
//
//  Created by Ali Verdiyev on 27.08.24.
//

import Foundation




struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}	
