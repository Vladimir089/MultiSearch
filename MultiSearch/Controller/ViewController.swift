//  ViewController.swift
//  MultiSearch
//
//  Created by Владимир on 21.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var searchScroll: UIScrollView!
    var viewArray = [UIView]()
    var selectedView: UIView?
    var arrayImage = [[String]]()
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchScroll.contentSize = CGSize(width: 1000, height: searchScroll.frame.height)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    func searchImage() {
        if let textField = selectedView?.subviews.compactMap({ $0 as? UITextField }).first {
            let a = textField.text!
            arrayImage.removeAll()
            for i in 1...10 {
                guard let url = URL(string: "https://api.unsplash.com/search/photos?page=\(i)&query=\(a)&client_id=hZHcTzzGBOD6feBdH0065YfT_c2z_FUbevdoqkN1SMA") else { return }
                let request = URLRequest(url: url)
                let session = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                    if let data = data {
                        do {
                            let photo = try JSONDecoder().decode(UnsplashResponse.self, from: data)
                            print("Photo decoded successfully")
                            for i in photo.results {
                                arrayImage.append([i.urls.small, i.urls.full])
                            }
                            self.loadImage()
                            DispatchQueue.main.async {
                                
                                self.imageCollectionView.reloadData()
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                            
                        }
                    }
                    
                }
                session.resume()
            }
            
        }
    }
    
    func loadImage() {
        
        if arrayImage.count != 0 {
            for i in 1...arrayImage.count - 1  {
                guard let url = URL(string: arrayImage[i][0]) else { return }
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { [self] data , response , error in
                    if let data = try? Data(contentsOf: url) {
                        imageArray.append(UIImage(data: data)!)
                    }
                    DispatchQueue.main.async {
                        self.imageCollectionView.reloadData()
                    }
                }
                task.resume()
            }
        }
    }
    
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        arrayImage.removeAll()
        imageArray.removeAll()
        let view = UIView()
        view.frame = CGRect(x: searchScroll.contentSize.width - 130, y: 0, width: 130, height: 30)
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.layer.cornerRadius = 7
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        textField.placeholder = "Введите текст"
        textField.borderStyle = .none
        textField.font = UIFont.boldSystemFont(ofSize: 14.0)
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 100, y: 0, width: 30, height: 30)
        closeButton.setTitle("✕", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        viewArray.append(view)
        view.addSubview(textField)
        view.addSubview(closeButton)
        searchScroll.addSubview(view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDoneEditing(_:)), for: .editingDidEndOnExit)
        searchScroll.contentSize.width += 130
        for subview in searchScroll.subviews {
            if subview != view {
                subview.frame.origin.x -= 100
            }
        }
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        guard let selectedView = gesture.view else { return }
        
        if let prevSelectedView = self.selectedView {
            prevSelectedView.backgroundColor = .tertiarySystemGroupedBackground
        }
        
        selectedView.backgroundColor = .systemGreen
        self.selectedView = selectedView
        DispatchQueue.main.async { [self] in
            arrayImage.removeAll()
            imageArray.removeAll()
            imageCollectionView.reloadData()
        }
        searchImage()
    }
    
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        if let view = sender.superview {
            if view == selectedView {
                selectedView = nil
            }
            if view != viewArray.last {
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0.0
                }) { [self] (finished) in
                    if finished {
                        view.removeFromSuperview()
                        
                        for i in viewArray {
                            if i == view && i != viewArray[viewArray.count - 1]{
                                viewDell(idDel: view)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func viewDell(idDel: UIView) {
        var a = 0
        
        for i in viewArray {
            if i != idDel {
                a += 1
            } else if i == idDel {
                break
            }
        }
        
        for i in viewArray[0...a] {
            i.frame = CGRect(x: i.frame.midX + 165, y: 0, width: 130, height: 30)
        }
    }
    
    @objc func textFieldDoneEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let image = UIImageView(image: imageArray[indexPath.row])
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.frame = CGRect(x: 0, y: 0, width: 195, height: 195)
        cell.isUserInteractionEnabled = true
        cell.contentView.addSubview(image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 10.0
        let width = (collectionView.bounds.width - 1 * spacing) / 2
        return CGSize(width: width, height: width)
    }
    
    
}


