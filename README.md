# VoiceButton-Swift

Simple and reusable component that converts user's speech to text. Can be used in XIB file. Written using Swift 3. Uses Siri Speech Framework for voice to text conversion.

  - Handles all Speech Framework initialisation
  - Returns speech in String format.
  - Provides customisable UI button control that can be placed in a View  

# How to Use

  - Drag and drop the folder "VoiceButton" into your XCode Project.
  - Drag and drop a View to your main view in Storyboard. Change the view's owner to VoiceButton
  - Implement delegate methods in your ViewController

```swift
    voiceButton.voiceButtonDelegate = self
    voiceButton.buttonBGColor = .cyan
    voiceButton.buttonImageColor = .lightGray
    voiceButton.buttonImage = #imageLiteral(resourceName: "microphone_icon")
```

  - Refer to ViewController.swift for sample implementation
