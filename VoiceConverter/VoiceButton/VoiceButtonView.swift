//
//  VoiceButtonView.swift
//  VoiceConverter
//
//  Created by Vivek Jayakumar on 1/6/17.


import UIKit

 /// Voice Button Delegate Protocol
protocol VoiceButtonDelegate {
    func updateSpeechText(_ text: String)
    func startedRecording()
    func stoppedRecording()
    func notifyError(_ error: String)
}


@IBDesignable
class VoiceButtonView: UIView {

    // MARK:- Public Properties

    /// Button Background Color
    public var buttonBGColor: UIColor? {
        willSet(newColor) {
            if let image = voiceButton.backgroundImage(for: .normal), let color = newColor {
                let newImage = image.maskWithColor(color: color)
                voiceButton.setBackgroundImage(newImage, for: .normal)
            }
        }
    }

    /// Button Image Color
    public var buttonImageColor: UIColor? {
         willSet(newColor) {
            if let image = voiceButton.image(for: .normal), let color = newColor {
                let newImage = image.maskWithColor(color: color)
                voiceButton.setImage(newImage, for: .normal)
            }
        }
    }

    /// Button foreground Image
    public var buttonImage: UIImage {
        set {
            voiceButton.setImage(newValue, for: .normal)
        }
        get {
            return self.buttonImage
        }
    }

    // MARK:- Private Properties
    @IBOutlet fileprivate weak var buttonContainer: UIView!
    @IBOutlet fileprivate weak var voiceButton: UIButton!
    @IBOutlet fileprivate weak var voiceRangeView: UIView!
    private var isRecording: Bool = false
    private var speechRecorder: SpeechRecorder?
    var voiceButtonDelegate: VoiceButtonDelegate?


    // MARK:- Initialise View
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        backgroundColor = .clear
        buttonContainer = loadViewFromNib()
        buttonContainer.frame = bounds
        // Default Values
        self.buttonBGColor = UIColor(red:0.15, green:0.45, blue:0.66, alpha:1.0) // #2574A9
        self.buttonImageColor = .white
        addSubview(buttonContainer)
        speechRecorder = SpeechRecorder()
        speechRecorder?.delegate = self
        speechRecorder?.setupSpeechRecorder(completion: { [weak self] (returnValue) -> Void in
            if returnValue.0 == false {
                print(returnValue.1)
                self?.voiceButtonDelegate?.notifyError(returnValue.1)
            }
        })

    }

    private func loadViewFromNib() -> UIView! {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        } else {
            return UIView()
        }
    }


//    func scaleView() {
//        UIView.animate(withDuration: 0.6, animations: { [weak self] in
//            self?.voiceRangeView.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
//        }, completion: { [weak self] (finish) in
//            UIView.animate(withDuration: 0.6, animations: {
//               self?.voiceRangeView.transform = CGAffineTransform.identity
//            })
//        })
//     }
//    

    // MARK:- Voice Button Actions
    @IBAction func buttonPressed() {
    if self.isRecording == false {
        if let image = self.voiceButton.backgroundImage(for: .normal) {
            let newImage = image.maskWithColor(color: UIColor(red:0.95, green:0.15, blue:0.07, alpha:1.0)) //F22613
            self.voiceButton.setBackgroundImage(newImage, for: .normal)
        }
       self.voiceButton.setImage(#imageLiteral(resourceName: "stop_icon"), for: .normal)
       speechRecorder?.startRecording(completion: { [weak self] (returnValue) -> Void in
            if returnValue.0 == false {
                print(returnValue.1)
                self?.voiceButtonDelegate?.notifyError(returnValue.1)
            } else {
                self?.voiceButtonDelegate?.startedRecording()
            }
        })

    } else {
        if let image = self.voiceButton.backgroundImage(for: .normal), let color = self.buttonBGColor {
            let newImage = image.maskWithColor(color: color)
            self.voiceButton.setBackgroundImage(newImage, for: .normal)
        }
        self.voiceButton.setImage(#imageLiteral(resourceName: "microphone_icon"), for: .normal)
        if let image = self.voiceButton.image(for: .normal), let color =  self.buttonImageColor {
            let newImage = image.maskWithColor(color: color)
            self.voiceButton.setImage(newImage, for: .normal)
        }
        speechRecorder?.stopRecording()
        voiceButtonDelegate?.stoppedRecording()
     }
     self.isRecording = !self.isRecording
  }
}

extension VoiceButtonView : SpeechRecorderDelegate {
    func updateSpeechText(_ text: String) {
        voiceButtonDelegate?.updateSpeechText(text)
    }

}


