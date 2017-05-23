//
//  ViewController.swift
//  ImageSearch
//
//  Created by Sergiy Sobol on 19.05.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let animation = LOTAnimationView(name: "trail_loading")
//        animation?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        animation?.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
//        animation?.loopAnimation = true
//        view.addSubview(animation!)
//        animation?.play()
        
        let search = GoogleSearchEngine()
        search.search(s: "cats") { (error, array) in
            self.imageArray = array!
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        var item = imageArray[indexPath.row] 
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        let catPictureURL = URL(string: (item["link"] as? String)!)!
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        DispatchQueue.main.async {
                            cell.imageView.image = UIImage(data: imageData)
                            // Do something with your image.
//                            if let index = collectionView.indexPath(for: cell) {
//                                collectionView.reloadItems(at: [index])
//                            }
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        return cell
        
    }


}

