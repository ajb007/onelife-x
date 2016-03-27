//
//  OLServerConnection.swift
//  onelife
//
//  Created by Andy Bartlett on 19/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit

class OLSocketServerConnection: NSObject, NSStreamDelegate {
    
    static let instance = OLSocketServerConnection()
    
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    var message : String?
    
    func getMessage() -> String? {
        return message
    }
    
    private override init() {
        // no need to init anything at this stage
        super.init()
    }
    
    func initNetworkCommunication() {
        
        var readStream : NSInputStream?
        var writeStream : NSOutputStream?
        
        let addr = "127.0.0.1"
        let port = 80
        //var host: NSHost = NSHost(address: addr)
        
        NSStream.getStreamsToHostWithName(addr, port:port, inputStream:&readStream, outputStream:&writeStream)
        
        inputStream = readStream!
        outputStream = writeStream!
        
        inputStream?.delegate = self
        outputStream?.delegate = self
        
        inputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        
        inputStream?.open()
        
        switch (inputStream!.streamStatus) {
        case NSStreamStatus.NotOpen:
            NSLog("inputStream - NotOpen")
        case NSStreamStatus.Opening:
            NSLog("inputStream - Opening")
        case NSStreamStatus.Open:
            NSLog("inputStream - Open")
        case NSStreamStatus.Reading:
            NSLog("inputStream - Reading")
        case NSStreamStatus.Writing:
            NSLog("inputStream - Writing")
        case NSStreamStatus.AtEnd:
            NSLog("inputStream - AtEnd")
        case NSStreamStatus.Closed:
            NSLog("inputStream - Closed")
        case NSStreamStatus.Error:
            NSLog("inputStream - Error")
        }
        
        outputStream?.open()
        
    }
    
    // Send data back to the server
    func sendData(var data: String) {
        if data == "" {
            data = "tmp"
        }
        var buffer: [UInt8] = Array(data.utf8)
        outputStream!.write(&buffer, maxLength: buffer.count)
    }
    
    // Stream the data back into the client
    func stream(theStream: NSStream, handleEvent streamEvent: NSStreamEvent) {
        switch (streamEvent) {
            //case NSStreamEvent.NSStreamEventNone:
            //    NSLog("No event has occurred")
        case NSStreamEvent.OpenCompleted:
            NSLog("The open has completed successfully")
            
        case NSStreamEvent.HasBytesAvailable:
            var buffer: [UInt8] = [64]
            var output: NSString
            var outStr: String = ""
            NSLog("The stream has bytes to be read")
            while inputStream!.hasBytesAvailable {
                let bytesRead = inputStream!.read(&buffer, maxLength: 64)
                if bytesRead > 0 {
                    output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)!
                    outStr = outStr + String(output)
                }
                
            }
            message = outStr
            
        case NSStreamEvent.HasSpaceAvailable:
            NSLog("The stream can accept bytes for writing")
            
        case NSStreamEvent.ErrorOccurred:
            NSLog("An error has occurred on the stream")
            
        case NSStreamEvent.EndEncountered:
            NSLog("The end of the stream has been reached")
            
        default:
            NSLog("Unknown action")
        }
        
    }
    
}
