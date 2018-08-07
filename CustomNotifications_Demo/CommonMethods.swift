//
//  CommonMethods.swift
//  CustomNotifications_Demo
//
//  Created by sai anand on 03/08/18.
//  Copyright © 2018 sai anand. All rights reserved.
//

import UIKit

public class CommonMethods: NSObject {
    
    /// Download image from url passed as string and save to document direct under samsung
    ///
    /// - Parameters:
    ///   - link: image url as string
    ///   - name: downloaded image will be save using this name
    static func downloadImageFrom(link: String, saveAs name: String) {
        guard let url = URL(string: link) else {
            print("Could not form URL")
            return
        }
        downloadImageFrom(url: url, saveAs: name)
    }
    
    // MARK: - Async Image Download
    
    /// Download image from url and save to document direct under samsung
    ///
    /// - Parameters:
    ///   - url: image url
    ///   - name: downloaded image will be save using this name
    static func downloadImageFrom(url: URL, saveAs name: String) {
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                        return
                }
                
                do {
                    let documentsDirectoryURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let dirPath = documentsDirectoryURL.appendingPathComponent("samsung/")
                    let fileURL = dirPath.appendingPathComponent(name)
                    try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
                    try UIImagePNGRepresentation(image)!.write(to: fileURL, options: .atomic)
                } catch {
                    print(error)
                }
                
                }.resume()
        }
    }
}
