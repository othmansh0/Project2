//
//  ViewController.swift
//  Project2
//
//  Created by othman shahrouri on 8/2/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var questionNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestions()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    func askQuestions(action: UIAlertAction! = nil){
        
        countries.shuffle()
        button1.setImage(UIImage(named:countries[0]), for: .normal)
        button2.setImage(UIImage(named:countries[1]), for: .normal)
        button3.setImage(UIImage(named:countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
      
        title = countries[correctAnswer].uppercased() + " " + String(score)
        if(questionNum == 10){
            let ac = UIAlertController(title: "Results", message: "You have answered 10 quesions with score: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Finish", style: .default, handler: {_ in
                self.score = 0
                self.questionNum = 0
                self.correctAnswer = Int.random(in: 0...2)
                self.title = self.countries[self.correctAnswer].uppercased() + " " + String(self.score)
            }))
            present(ac,animated: true)
        }
        questionNum += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: "Incorrect", message: "Wrong! That’s the flag of \(countries[sender.tag])", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
            present(ac,animated: true)
            return
          
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestions))
        present(ac, animated: true)
        
    }
    
    
    @objc func shareTapped(){
        let item = [String(score)]
        let vc = UIActivityViewController(activityItems: item, applicationActivities: [])
        present(vc,animated: true)
    }
    
}

 
