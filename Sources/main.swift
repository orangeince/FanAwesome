//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
let token = "222037732:AAGvTmwhQ2c_TRELTWbC2fJjkzM9t_VGuPc"

// Initialize base-level services
PerfectServer.initializeServices()

// Create our webroot
// This will serve all static content by default
let webRoot = "./webroot"
try Dir(webRoot).create()

// Add our routes and such
// Register your own routes and handlers
Routing.Routes[.Post, "/"] = {
    request, response in
    print("received message!!!")
    let update = ZEGDecoder.decodeUpdate(jsonString: request.postBodyString)
    if let message = update?.message, text = message.text {
        switch text.uppercased() {
           case "FOO":
		print("Yes! received: \(text)")
                ZEGResponse.sendMessage(to: message.chat, text: "", parse_mode: nil, disable_web_page_preview: nil, disable_notification: nil)
           default:
		print("Yes! received: \(text)")
               break;
        }
    }
    
    //response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
    response.requestCompleted()
}

Routing.Routes[.Post, "/fanplan"] = {    
    request, response in     
    print("received beary's post!")    
    if let postJson = try? request.postBodyString.zegJsonDecode() {
        print("postJson: \(postJson)")        
	if let postJson = postJson as? [String : Any] {
		if let text = postJson["text"] as? String {
		    response.appendBody(string: "{text: \"received: \(text)\"}")
	    }
	}
    } else {
	print("post json invaild!")
        response.appendBody(string: "post params invaild!")
    }
    response.requestCompleted()
}


do {
    
    // Launch the HTTP server on port 8181
    try HTTPServer(documentRoot: webRoot).start(port: 8181)
    
} catch PerfectError.NetworkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
