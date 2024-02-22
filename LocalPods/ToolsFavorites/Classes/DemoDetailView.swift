//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import AVKit
import Photos

class VideoDownloader {
    func downloadVideo(from url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (tempLocalURL, response, error) in
            if let tempLocalURL = tempLocalURL, error == nil {
                // 生成一个独一无二的本地URL，用于保存下载的视频文件
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationURL = documentsURL.appendingPathComponent(UUID().uuidString + ".mp4")
                
                do {
                    // 将临时文件移动到应用的文档目录中
                    try FileManager.default.moveItem(at: tempLocalURL, to: destinationURL)
                    completion(destinationURL, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}

public struct DemoDetailView: View {
    
    
 
    @State private var urlString = ""
    
    let text: String
    
    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        VStack {
            TextField("Enter video URL", text: $urlString)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding()
                       Button("Download") {
                           if let url = URL(string: "https://haokan.baidu.com/v?pd=wisenatural&vid=13346121912086328147") {
                               // 使用示例
                               let videoURL = url
                               let downloader = VideoDownloader()
                               downloader.downloadVideo(from: videoURL) { (localURL, error) in
                                   if let localURL = localURL {
                                       print("视频下载成功，保存在：\(localURL)")
                                   } else {
                                       print("视频下载失败：\(error?.localizedDescription ?? "未知错误")")
                                   }
                               }
                           }
                       }
        }
        .padding()
    }
}


 

