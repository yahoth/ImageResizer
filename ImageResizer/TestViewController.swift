////
////  TestViewController.swift
////  ImageResizer
////
////  Created by TAEHYOUNG KIM on 10/5/23.
////
//
//import UIKit
//
//class TestViewController: UIViewController, UIScrollViewDelegate {
//
//    var imageView = UIImageView()
//    var scrollView = UIScrollView()
//    var cropAreaView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 이미지 설정
//        let image = UIImage(named: "image") // 이미지 이름을 변경해주세요.
//        imageView.image = image
//        imageView.contentMode = .scaleAspectFit
//
//        // 스크롤 뷰 설정
//        scrollView.frame = view.bounds
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 3.0
//        scrollView.bouncesZoom = true
//
//        view.addSubview(scrollView)
//
//        // 이미지뷰를 스크롤뷰에 추가합니다.
//        scrollView.addSubview(imageView)
//
//        // 이미지뷰의 크기를 이미지의 크기로 설정합니다.
//        imageView.frame.size.width=image?.size.width ?? 0
//        imageView.frame.size.height=image?.size.height ?? 0
//
//        // 스크롤뷰의 컨텐츠 크기를 이미지 뷰의 크기로 설정합니다.
//        scrollView.contentSize=imageView.frame.size
//
//        // 이미지 뷰가 스크롤 뷰의 중앙에 위치하도록 합니다.
//        imageView.center = CGPoint(x :scrollView.contentSize.width / 2 , y :scrollView.contentSize.height / 2 )
//
//        // 크롭 테두리 설정 (3 : 4 비율)
//        let cropAreaWidth : CGFloat = view.bounds.width - 40
//        let cropAreaHeight : CGFloat = (cropAreaWidth / 3 ) * 4
//
//        cropAreaView.frame.size.width = cropAreaWidth
//        cropAreaView.frame.size.height = cropAreaHeight
//
//        cropAreaView.center = view.center
//
//        // 테두리 색상과 두께 설정
//        cropAreaView.isUserInteractionEnabled=false
//        cropAreaView.layer.borderColor=UIColor.red.cgColor
//        cropAreaView.layer.borderWidth=2.0
//
//        view.addSubview(cropAreaView )
//    }
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
//
//    @IBAction func didTapCropButton(_ sender:Any){
//        UIGraphicsBeginImageContextWithOptions(cropAreaView.bounds.size,false ,1.0 )
//
//        let xRatio = (scrollView.contentOffset.x + (cropAreaView.frame.origin.x - imageView.frame.origin.x )) /   imageView.image!.scale
//
//        let yRatio = (scrollView.contentOffset.y + (cropAreaView.frame.origin.y - imageView.frame.origin.y )) /   imageView.image!.scale
//
//        let widthRatio=cropAreaView.bounds.width /   imageView.image!.scale
//
//        let heightRatio=cropAreaView.bounds.height /   imageView.image!.scale
//
//        if let cgImage=imageView.image?.cgImage?.cropping(to:CGRect(x:xRatio,y:yRatio,width:widthRatio,height:heightRatio)){
//            // croppedImage = UIImage(cgImage : cgImage )
//            dismiss(animated:true , completion:nil )
//        }else{
//            print("Failed to create cropped image.")
//        }
//
//        UIGraphicsEndImageContext()
//    }
//}

import UIKit

class TestViewController: UIViewController, UIScrollViewDelegate {

    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var cropAreaView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 이미지 설정
        let image = UIImage(named: "image") // 이미지 이름을 변경해주세요.
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // 스크롤 뷰 설정
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.bouncesZoom = true

         // 스크롤뷰에 추가합니다.
         view.addSubview(scrollView)
         scrollView.translatesAutoresizingMaskIntoConstraints=false

          // 이미지뷰를 스크롤뷰에 추가합니다.
          scrollView.addSubview(imageView)

           // 스크롤뷰의 제약사항을 설정합니다.
           NSLayoutConstraint.activate([
               scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
               scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
               scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
           ])

            // 이미지 뷰의 제약사항을 설정합니다.
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant:image?.size.width ?? 0 ),
                imageView.heightAnchor.constraint(equalToConstant:image?.size.height ?? 0 ),
                imageView.centerXAnchor.constraint(equalTo:scrollView.centerXAnchor ),
                imageView.centerYAnchor.constraint(equalTo:scrollView.centerYAnchor )
            ])

             // 크롭 테두리 설정 (3 : 4 비율)
             let cropAreaWidth : CGFloat=view.bounds.width - 40
             let cropAreaHeight : CGFloat=(cropAreaWidth / 3 ) * 4

              cropAreaView.frame.size.width=cropAreaWidth
              cropAreaView.frame.size.height=cropAreaHeight

              cropAreaView.center=view.center

               // 테두리 색상과 두께 설정
               cropAreaView.isUserInteractionEnabled=false
               cropAreaView.layer.borderColor=UIColor.red.cgColor
               cropAreaView.layer.borderWidth=2.0

                view.addSubview(cropAreaView )
    }

     func viewForZooming(in scrollView: UIScrollView) -> UIView? {
          return self.imageView
     }

      @IBAction func didTapCropButton(_ sender:Any){
            UIGraphicsBeginImageContextWithOptions(cropAreaView.bounds.size,false ,1.0 )

             let xRatio=(scrollView.contentOffset.x + (cropAreaView.frame.origin.x - imageView.frame.origin.x )) /   imageView.image!.scale

              let yRatio=(scrollView.contentOffset.y + (cropAreaView.frame.origin.y - imageView.frame.origin.y )) /   imageView.image!.scale

               let widthRatio=cropAreaView.bounds.width /   imageView.image!.scale

                let heightRatio=cropAreaView.bounds.height /   imageView.image!.scale

                 if let cgImage=imageView.image?.cgImage?.cropping(to:CGRect(x:xRatio,y:yRatio,width:widthRatio,height:heightRatio)){
                       // croppedImage = UIImage(cgImage : cgImage )
                       dismiss(animated:true , completion:nil )
                 }else{
                      print("Failed to create cropped image.")
                 }

                  UIGraphicsEndImageContext()
      }
}
