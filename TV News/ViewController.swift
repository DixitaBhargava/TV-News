//
//  ViewController.swift
//  TV News
//
//  Created by Dixita Bhargava on 28/06/20.
//  Copyright © 2020 Dixita Bhargava. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController,UISearchResultsUpdating {
    
    var apiKey = "51a70bc8-939c-40a4-a049-2ef871b0d786"
    var articles = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let title = title else {
            return
        }
        guard let url = URL(string: "https://content.guardianapis.com/\(title.lowercased())?api-key=\(apiKey)&show-fields=thumbnail,headline,standfirst,body") else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? NewsCell else { fatalError("Couldn't dequeue a cell")}
        
        let newsItem = articles[indexPath.row]
        let title = newsItem["fields"]["headline"].stringValue
        let thumbnail = newsItem["fields"]["thumbnail"].stringValue
        
        newsCell.textLabel.text = title
        if let imageURL = URL(string: thumbnail) {
            newsCell.imageView.load(imageURL)
        }
        
        return newsCell
    }
    
    func fetch(_ url: URL) {
        
        //atempt to download the contents of this url
        if let data = try? Data(contentsOf: url) {
            
            //convert that to JSON and pull out the array we care about
            articles = JSON(data)["response"]["results"].arrayValue
            
            //reload the collection view on the main thread
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }else {
            //something went wrong
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reader = storyboard?.instantiateViewController(identifier: "Reader") as? ReaderViewController else {return}
        reader.article = articles[indexPath.row]
        present(reader,animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.isEmpty {
            articles = [JSON]()
            collectionView?.reloadData()
        } else {
            guard let url = URL(string: "https://content.guardianapis.com/search?api-key=\(apiKey)&q=\(text)&show-fields=thumbnail,headline,standfirst,body") else { return }
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.fetch(url)
            }
        }
    }
    
    
}


