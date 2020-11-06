//
//  ViewController.swift
//  VisionKitTest
//
//  Created by Thong Hao Yi on 06/11/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit
import VisionKit
import PDFKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate  {
    @IBOutlet weak var displayView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func scanButton() {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func checkButton() {
        
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(pdfView)
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
        
        if FileManager.default.fileExists(atPath: docURL.path){
            displayView.navigationDelegate = self
            displayView.load(URLRequest(url: URL(fileURLWithPath: docURL.path)))
        }
        
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate{
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Found \(scan.pageCount)")

        let pdfDocument = PDFDocument()
        
        for i in 0 ..< scan.pageCount {
            let image = scan.imageOfPage(at: i)
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: i)
        }
        
        let data = pdfDocument.dataRepresentation()
                    
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
        let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
                    
        do{
          try data?.write(to: docURL)
        }catch(let error){
           print("error is \(error.localizedDescription)")
        }
    }
}

