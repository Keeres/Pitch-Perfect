//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Steven Chen on 8/18/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scales image according to resolution
        recordButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        stopRecordingButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit

        // disable stop button
        stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    @IBAction func recordAudio(sender: AnyObject) {
        print("recording button pressed")
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.enabled = true
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        audioRecorder.delegate = self
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Audio Recorder Delegate Functions
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if flag {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else{
            print("Saving of recording failed")
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC =  segue.destinationViewController as! PlaySoundsViewController
            let recorderAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recorderAudioURL
        }
    }
}

