//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 高野 眞奈美 on 2017/01/22.
//  Copyright © 2017年 manami.takano. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AdobeUXImageEditorViewControllerDelegate {    
    
    @IBAction func handleLibraryButton(sender: AnyObject) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    @IBAction func handleCameraButton(sender: AnyObject) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
            }
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // あとでAdobeUXImageEditorを起動する
            // AdobeUXImageEditorで、受け取ったimageを加工できる
            // ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                // AdobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.present(adobeViewController, animated: true, completion:  nil)
            }
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    // フォトライブラリやカメラ起動中にキャンセルされたときに呼ばれるメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // AdobeImageEditorで加工が終わったときに呼ばれるメソッド
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        // 画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
        // 投稿の画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image
        present(postViewController, animated: true, completion: nil)
    }
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }
}
