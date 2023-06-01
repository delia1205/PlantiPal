//
//  QuizPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 31/05/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse
import Foundation

struct UserAnswerPoints {
    var aloePoints: Int
    var snakePoints: Int
    var spiderPoints: Int
    var lilyPoints: Int
    var photosPoints: Int
    var figPoints: Int
    var zzPoints: Int
    var ivyPoints: Int
    var fernPoints: Int
    var jadePoints: Int
    
    func findMaxValue() -> Int {
        return max(aloePoints, snakePoints, spiderPoints, lilyPoints, photosPoints, figPoints, zzPoints, ivyPoints, fernPoints, jadePoints)
    }
    
    func findMaxVar() -> String {
        let maxVal = findMaxValue()
        if aloePoints == maxVal {
            return "Aloe Vera"
        }
        else if snakePoints == maxVal {
            return "Snake Plant (Sansevieria)"
        }
        else if spiderPoints == maxVal {
            return "Spider Plant (Chlorophytum comosum)"
        }
        else if lilyPoints == maxVal {
            return "Peace Lily (Spathiphyllum)"
        }
        else if photosPoints == maxVal {
            return "Pothos (Epipremnum aureum)"
        }
        else if figPoints == maxVal {
            return "Fiddle Leaf Fig (Ficus lyrata)"
        }
        else if zzPoints == maxVal {
            return "ZZ Plant (Zamioculcas zamiifolia)"
        }
        else if ivyPoints == maxVal {
            return "English Ivy (Hedera helix)"
        }
        else if fernPoints == maxVal {
            return "Boston Fern (Nephrolepis exaltata)"
        }
        else {
            return "Jade Plant (Crassula ovata)"
        }
    }
    
    func isValid() -> Bool{
        let maxVal = findMaxValue()
        if maxVal >= 3 {
            return true
        }
        return false
    }
}

class QuizPageViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    
    var currentQuestionIndex = 0
    var userAnswers = [String]()
    var userAnswerPoints = UserAnswerPoints(aloePoints: 0,snakePoints: 0,spiderPoints: 0,lilyPoints: 0,photosPoints: 0,figPoints: 0,zzPoints: 0,ivyPoints: 0,fernPoints: 0,jadePoints: 0)
    
    let questions = [
        "How much natural light does your living space receive?",
        "How often are you willing to water your plant?",
        "How much space do you have available for a plant?",
        "Are you looking for a plant that requires minimal maintenance?",
        "Do you have any pets that may interact with the plant?",
        "How humid is your living space?",
        "How frequently do you fertilize plants?",
        "Are you interested in plants that have colorful flowers?",
        "Do you have any specific plant allergies?",
        "How long do you plan to keep the house plant?"
    ]

    let answers = [
        ["Plenty of direct sunlight", "Bright indirect light", "Low light or shade"],
        ["Daily", "Every few days", "Once a week or less"],
        ["Large floor space", "Medium-sized tabletop or shelf", "Small windowsill or hanging spot"],
        ["Yes, I prefer low-maintenance plants", "I'm willing to put in moderate effort", "I enjoy spending time taking care of plants"],
        ["No pets or pets that ignore plants", "Pets that occasionally sniff or play with plants", "Pets that may chew or damage plants"],
        ["Very humid, like a tropical environment", "Moderate humidity", "Dry air, especially during winter months"],
        ["Regularly, every month", "Occasionally, every few months", "Rarely or never"],
        ["Yes, I want vibrant flowers", "I prefer foliage plants with interesting leaves", "I'm not particularly focused on flowers or foliage"],
        ["No plant allergies", "Mild allergies to certain plants", "Severe allergies to many types of plants"],
        ["Short-term, less than a year", "Medium-term, 1-3 years", "Long-term, more than 3 years"]
    ]

    let plantResults = [
        "Aloe Vera",
        "Snake Plant (Sansevieria)",
        "Spider Plant (Chlorophytum comosum)",
        "Peace Lily (Spathiphyllum)",
        "Pothos (Epipremnum aureum)",
        "Fiddle Leaf Fig (Ficus lyrata)",
        "ZZ Plant (Zamioculcas zamiifolia)",
        "English Ivy (Hedera helix)",
        "Boston Fern (Nephrolepis exaltata)",
        "Jade Plant (Crassula ovata)"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        displayQuestion()
    }

    func displayQuestion() {
        questionField.text = questions[currentQuestionIndex]
        option1.setTitle(answers[currentQuestionIndex][0], for: .normal)
        option2.setTitle(answers[currentQuestionIndex][1], for: .normal)
        option3.setTitle(answers[currentQuestionIndex][2], for: .normal)
    }

    @IBAction func optionButtonTapped(_ sender: UIButton) {
        let answer = sender.currentTitle
        userAnswers.append(answer!)
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            displayQuestion()
        } else {
            displayResult()
        }
    }
    
    func displayResult() {
        
        if userAnswers[0] == "Bright indirect light" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        else if userAnswers[0] == "Low light or shade" {
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
        }
        else if userAnswers[0] == "Plenty of direct sunlight" {
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
        }
        
        if userAnswers[1] == "Once a week or less" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
        }
        else if userAnswers[1] == "Every few days" {
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
        }
        
        if userAnswers[2] == "Medium-sized tabletop or shelf" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
        }
        else if userAnswers[2] == "Large floor space" {
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
        }
        else if userAnswers[2] == "Small windowsill or hanging spot" {
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        
        if (userAnswers[3] == "Yes, I prefer low-maintenance plants") {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        
        if userAnswers[4] == "No pets or pets that ignore plants" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        
        if userAnswers[5] == "Moderate humidity" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        else if userAnswers[5] == "Very humid, like a tropical environment" {
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
        }
        
        if userAnswers[6] == "Rarely or never" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        
        if userAnswers[7] == "I'm not particularly focused on flowers or foliage" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        else if userAnswers[7] == "Yes, I want vibrant flowers"  {
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
        }
        else if userAnswers[7] == "I prefer foliage plants with interesting leaves" {
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
        }
        
        if userAnswers[8] == "No plant allergies" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        
        if userAnswers[9] == "Medium-term, 1-3 years" {
            userAnswerPoints.aloePoints = userAnswerPoints.aloePoints + 1
            userAnswerPoints.spiderPoints = userAnswerPoints.spiderPoints + 1
            userAnswerPoints.snakePoints = userAnswerPoints.snakePoints + 1
            userAnswerPoints.zzPoints = userAnswerPoints.zzPoints + 1
            userAnswerPoints.lilyPoints = userAnswerPoints.lilyPoints + 1
            userAnswerPoints.fernPoints = userAnswerPoints.fernPoints + 1
            userAnswerPoints.figPoints = userAnswerPoints.figPoints + 1
            userAnswerPoints.photosPoints = userAnswerPoints.photosPoints + 1
            userAnswerPoints.jadePoints = userAnswerPoints.jadePoints + 1
            userAnswerPoints.ivyPoints = userAnswerPoints.ivyPoints + 1
        }
        
        if userAnswerPoints.isValid() {
            let maxVal = userAnswerPoints.findMaxValue()
            print(maxVal)
            let result = userAnswerPoints.findMaxVar()
            print(result)
            resultsLabel.text = "Based on your answers, the recommended plant for you is: \(result)"
        }
        else {
            resultsLabel.text = "Unable to determine a recommended plant based on your answers. Maybe you could change your environment conditions and come back when you're ready to give more of your time and resources to your house plant!"
        }
    }
    
}
