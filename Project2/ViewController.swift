//
//  ViewController.swift
//  Project2
//
//  Created by othman shahrouri on 8/2/21.
//
import UserNotifications
import UIKit

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var highestLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var questionNum = 0
    var highestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        highestLabel.text = "Highest Score: \(defaults.integer(forKey: "highestScore"))"
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestions()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
       
       // defaults.set(highestScore, forKey: "highestScore")
       scheduleNotifications()
        
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
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
        } completion: { finished in
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            if sender.tag == self.correctAnswer{
                self.title = "Correct"
                self.score += 1
            } else {
                self.title = "Wrong"
                self.score -= 1
                let ac = UIAlertController(title: "Incorrect", message: "Wrong! That’s the flag of \(self.countries[sender.tag])", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.askQuestions))
                self.present(ac,animated: true)
                return
              
            }
        }

        
        
        
        if score > defaults.integer(forKey: "highestScore") {
            highestScore = score
            defaults.set(highestScore, forKey: "highestScore")
            highestLabel.text = "Highest Score: \(defaults.integer(forKey: "highestScore"))"
            let ac = UIAlertController(title: "Congrats", message: "New best score", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
            
            
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
    
    func scheduleNotifications() {
        registerCategories()

        let center = UNUserNotificationCenter.current()
        //create content for notification
        let content = UNMutableNotificationContent()
        content.title = "Play a game"
        content.body = "We've missed you,come play with us"
        //you can attach custom actions by specifying categoryIdentifier
        content.categoryIdentifier = "alarm"
         
        content.sound = .default
        
       
       
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 50
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //interval trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        
       
        //request ties content and trigger together
        //it has unique identifier a string you create
        //it lets you update or remove notifications programmatically
        // for ex :existing notification to be updated with new information, rather than have multiple notifications from the same app over time
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        
        
    }
    
    
     func registerNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
            //request an alert+badge+sound
        center.requestAuthorization(options: [.alert,.badge,.sound]) { granted,error in
            if granted {
                print("yay")
            } else {
                print("shit")
                print(error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        center.removeAllPendingNotificationRequests()
        scheduleNotifications()
        
        
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
}

 

