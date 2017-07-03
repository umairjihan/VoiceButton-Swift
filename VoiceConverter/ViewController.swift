//
//  ViewController.swift
//  VoiceConverter
//
//  Created by Vivek Jayakumar on 1/6/17.

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var speechTextField: UILabel!
    @IBOutlet fileprivate weak var voiceButton: VoiceButtonView!

    override func viewDidLoad() {
        super.viewDidLoad()
        voiceButton.voiceButtonDelegate = self

        // Customise color and image
        // voiceButton.buttonBGColor = .cyan
        // voiceButton.buttonImageColor = .lightGray
        // voiceButton.buttonImage = #imageLiteral(resourceName: "microphone_icon")
    }

}

// MARK: VoiceButtonDelegate

extension ViewController : VoiceButtonDelegate {

    /// notify on error
    func notifyError(_ error: String) {
        notifyUser("Error", message: error)
    }

    /// callback when recording started
    func startedRecording() {

    }

    /// callback when recording stopped
    func stoppedRecording() {
        speechTextField.text = ""
    }

    /// callback when text is converted from speech
    func updateSpeechText(_ text: String) {
        //display the text in the label
        speechTextField.text = text
    }

}

// MARK: Show Alert

extension UIViewController {

    func notifyUser(_ title: String, message: String) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

