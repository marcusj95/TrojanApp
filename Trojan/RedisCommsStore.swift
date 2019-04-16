//
//  RedisCommsStore.swift
//  ChartTest
//
//  Created by Marcus Jackson on 3/9/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation

/**
 The comms store will act as the app's central location on where to route data. At startup, it will attempt to pair with a Pi. If the connection is successful, the user is able to send data to the store as well as subscribe for incoming messages
 */
class RedisCommsStore {
    //MARK: Variables
    private var commsPub: RedisInterface?
    private var commsSub: RedisInterface?
    private var commsChannel: String?
    public var delegate: RedisCommsStoreDelegate?
    public var hostName: String?
    public var portNum: UInt32?
    public var authStr: String?
    public static var store: RedisCommsStore?
    private static var connected = true

    
    private init(host: String, port: UInt32, auth: String) {
        RedisCommsStore.store = self
        
        hostName = host
        portNum = port
        authStr = auth
        
        commsPub = RedisInterface(host: host, port: port, auth: auth)
        commsSub = RedisInterface(host: host, port: port, auth: auth)
        commsChannel = "gamecube"
        
        commsSub?.connect()
        commsSub?.subscribe("nintendo", completionHandler: { (success, key, response, cmd) in
            if success {
                if let del = self.delegate, let dataArr = response?.arrayVal, let data = dataArr[2].dataVal {
                    del.didReceiveRedisResponse(data: data)
                }
            }
        })
        commsPub?.connect()
    }
    
    //MARK: Testing functions
    
    ///this is a testing function until we decide what to do with roll_call
    public static func setUp(host: String, port: UInt32, auth: String) {
        guard connected else {
            print("In disconnected mode")
            return
        }
        
        store = RedisCommsStore(host: host, port: port, auth: auth)
    }
    
    ///debug function just to test UI without the app trying to reach out to redis
    public static func disconnect() {
        connected = true
    }
    
    ///writes message accross Redis network to Pi
    public func publish(message: String) -> Bool {
        guard RedisCommsStore.connected else {
            return false
        }
        var retVal = false
        commsPub?.publish(commsChannel!, value: message, completionHandler: { (success, _, _, _) in
            retVal = success
        })
        return retVal
    }
    
    public func get(key: String, object: RedisDataGetter) {
        guard let host = hostName,
            let port = portNum,
            let auth = authStr else { return }
        
        let getterInterface = RedisInterface(host: host, port: port, auth: auth)
        
        getterInterface.connect()
        
        getterInterface.getValueForKey(key, completionHandler: { (success, key, response, command) in
            if success, let data = response?.dataVal{
                object.hasGottenData(data)
            }
        })
    }
}
