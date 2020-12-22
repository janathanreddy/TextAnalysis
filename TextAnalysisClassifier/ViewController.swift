//
//  ViewController.swift
//  TextAnalysisClassifier
//
//  Created by Janarthan Subburaj on 22/12/20.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {

    @IBOutlet weak var MesageTextView: UITextView?
    @IBOutlet weak var SpamLabel: UILabel?
    @IBOutlet weak var SentimentLabel: UILabel?
    
    @IBAction func SendMessage(sender: UIButton) {
        guard let message = self.MesageTextView?.text else {
            return
        }
        detectSpam(message: message)
        detectSentiment(message: message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func detectSpam(message: String) {
        do {
            let spamDetector = try NLModel(mlModel: SPAMClassifier().model)
            guard let prediction = spamDetector.predictedLabel(for: message) else {
                print("Failed to predict result")
                return
            }
            
            SpamLabel?.text = "spam status: \(prediction == "spam" ? "SPAM" : "NOT SPAM")"
        } catch {
            fatalError("Failed to load Natural Language Model: \(error)")
        }
    }
    
    func detectSentiment(message: String) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = message
        
        let (sentiment, _) = tagger.tag(at: message.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        guard let sentimentScore = sentiment?.rawValue else {
            return
        }
        SentimentLabel?.text = "sentiment score: \(sentimentScore)"
    }

}

