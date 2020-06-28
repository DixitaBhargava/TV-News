//
//  RemoteImageView.swift
//  TV News
//
//  Created by Dixita Bhargava on 28/06/20.
//  Copyright © 2020 Dixita Bhargava. All rights reserved.
//

import UIKit

class RemoteImageView: UIImageView {

    var url : URL?
    
    func load(_ url: URL) {
        
        //stash the URL away for later checking
        self.url = url

        //create a safe-to-save version of this URL that will be our cache filename
        guard let savedFilename = url.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return }
        
        //append that to the caches directory to get a complete path
        let fullPath = getCachesDirectory().appendingPathComponent(savedFilename)

        //if the cached image exists already
        if FileManager.default.fileExists(atPath: fullPath.path) {
            
            //use it and return
            image = UIImage(contentsOfFile: fullPath.path)
            return
        }

        //still here? push woerk to a bg thread
        DispatchQueue.global(qos: .userInitiated).async {
            
            //download the image data
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            //write it to our cache file
            try? imageData.write(to: fullPath)

            //now the image has downloaded check its still the one we want
            if self.url == url {
                
                //push work back to the main thread
                DispatchQueue.main.async {
                    
                    //update our image
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    func getCachesDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}
