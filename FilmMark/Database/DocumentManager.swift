//
//  DocumentManager.swift
//  FilmMark
//
//  Created by 김정윤 on 10/11/24.
//

import UIKit

final class DocumentManager {
    private init() { }
    static let shared = DocumentManager()
    private let fileManager = FileManager.default
    
    // MARK: 폴더 경로 얻기
    func getFolderPath() -> URL? {
        // 폴더 경로 유효한지 확인
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let folderDirectory = documentDirectory.appendingPathComponent("FilmMark")
        return folderDirectory
    }
    
    // MARK: 폴더 생성
    func createFolder() {
        guard let folderPath = getFolderPath() else { return }
        if !fileManager.fileExists(atPath: folderPath.path) {
            do {
                try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
            } catch {
                print("failed to create folder")
            }
        } else {
            return
        }
    }
    
    // MARK: 이미지 저장
    func saveImage(imageName: String, image: UIImage) {
        guard let folderPath = getFolderPath() else { return }
        createFolder()
        
        // 이미지 데이터 불러오기
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let imageName = "\(imageName).jpg"
        let fileURL = folderPath.appendingPathComponent(imageName, conformingTo: .jpeg)
        
        // 이미지 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("image save error")
        }
    }
    
    // MARK: 이미지 불러오기
    func loadImage(imageName: String) -> UIImage? {
        guard let folderPath = getFolderPath() else {
            return nil
        }
        
        let imageName = "\(imageName).jpg"
        let fileURL = folderPath.appendingPathComponent(imageName, conformingTo: .jpeg)
        
        // 이미지 있을 경우 이미지 보내고 아니면 다 nil
        if fileManager.fileExists(atPath: fileURL.path) {
            guard let result =  UIImage(contentsOfFile: fileURL.path) else {
                return nil
            }
            return result
        } else {
            return nil
        }
    }
    
    // MARK: 이미지 삭제
    func removeImage(imageName: String) {
        guard let folderPath = getFolderPath() else { return }
        
        let imageName = "\(imageName).jpg"
        let fileURL = folderPath.appendingPathComponent(imageName, conformingTo: .jpeg)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path)
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
    }
}
