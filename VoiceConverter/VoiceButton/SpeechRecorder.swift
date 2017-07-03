//
//  AudioRecorder.swift
//  VoiceConverter
//
//  Created by Vivek Jayakumar on 28/6/17.

import UIKit
import Speech


protocol SpeechRecorderDelegate {
    func updateSpeechText(_ text: String)
}


class SpeechRecorder: NSObject, SFSpeechRecognizerDelegate {

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var delegate: SpeechRecorderDelegate?


    /// Initialise speech recogniser
    func setupSpeechRecorder(completion: @escaping (Bool, String) -> Void)   {

        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            switch authStatus {
            case .authorized:
                completion(true, "Initialised")

            case .denied:
                 completion(false, "User denied access to speech recognition")

            case .restricted:
                 completion(false, "Speech recognition restricted on this device")

            case .notDetermined:
                completion(false, "Speech recognition not yet authorized")
            }

        }

    }

    /// Function to start recording and capture speech text
    func startRecording(completion: @escaping (Bool, String) -> Void)  {

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            completion (false, "audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else {
           completion (false, "Audio engine has no input node")
            return

        }

        guard let recognitionRequest = recognitionRequest else {
            completion (false, "Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in

            var isFinal = false

            if result != nil {

                if let speechText = result?.bestTranscription.formattedString {
                self?.delegate?.updateSpeechText(speechText)
                }
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            completion (false, "audioEngine couldn't start because of an error.")
        }

        completion (true, "Initialised")
    }

    func stopRecording() {

        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        audioEngine.inputNode?.removeTap(onBus: 0)
    }

}


