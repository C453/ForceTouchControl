//
//  ViewController.swift
//  ForceTouchVolumeControl
//
//  Created by Case Wright on 9/21/15.
//  Copyright © 2015 C453. All rights reserved.
//

import Cocoa
import AudioToolbox
import AppKit
class ViewController: NSViewController {

    var defaultOutputDeviceID = AudioDeviceID(0)
    
    
    @IBOutlet weak var ForceButtonCell: NSButtonCell!
    @IBOutlet weak var ForceButton: NSButton!
    @IBOutlet weak var shortcutView: MASShortcutView!
    
    let kPreferenceGlobalShortcut = "GlobalShortcut";
    
    override func viewDidLoad() {
        self.shortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
        ForceButtonCell.backgroundColor = NSColor.blackColor()
        self.view.window?.alphaValue = 0.8
        view.alphaValue = 0.8
        getVolumeDevice()
    MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey("GlobalShortcut") { () -> Void in
        CGDisplayMoveCursorToPoint(0, CGPoint(x: CGDisplayPixelsWide(0) / 2, y: CGDisplayPixelsHigh(0) / 2))
            //self.view.window?.makeKeyAndOrderFront(self)
        }
        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            NSApplication.sharedApplication().windows.last!.close()
        }*/
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func mouseExited(theEvent: NSEvent) {
        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            NSApplication.sharedApplication().windows.last!.close()
        }*/
        print("exit")
    }
        
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func flagsChanged(theEvent: NSEvent) {
        print(theEvent)
    }

    @IBAction func volumeButtonClicked(sender: NSButton) {
        if(sender.doubleValue == 0) { return }
        setBrightness(Float(sender.doubleValue * 0.2))
        //setVolume(Float(sender.doubleValue - 1)) // 0.0 ... 1.0
    }
    
    func setVolume(var level:Float) {
        let volumeSize = UInt32(sizeofValue(level))
        
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwareServiceDeviceProperty_VirtualMasterVolume),
            mScope: AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        AudioHardwareServiceSetPropertyData(
            defaultOutputDeviceID,
            &volumePropertyAddress,
            0,
            nil,
            volumeSize,
            &level)
    }
    
    func setBrightness(level:Float) {
        var iterator:io_iterator_t = 0
        let result:kern_return_t = IOServiceGetMatchingServices(kIOMasterPortDefault,
            IOServiceMatching("IODisplayConnect"),
            &iterator);
        
        if(result != kIOReturnSuccess) { return }
        
        var service: io_object_t = 1
        
        for ;; {
            service = IOIteratorNext(iterator)
            
            if service == 0 {
                break
            }
            
            IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey, level)
            IOObjectRelease(service)
        }
    }
    
    func getVolumeDevice() {
        var defaultOutputDeviceIDSize = UInt32(sizeofValue(defaultOutputDeviceID))
        
        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &getDefaultOutputDevicePropertyAddress,
            0,
            nil,
            &defaultOutputDeviceIDSize,
            &defaultOutputDeviceID)
    }
}

