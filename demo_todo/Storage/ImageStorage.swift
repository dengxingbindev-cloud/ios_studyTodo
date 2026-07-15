import Foundation
import UIKit

final class ImageStorage {

    private static let documents = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!

    private static let imagesDirectory = documents.appendingPathComponent("images")

    /// 保存图片
    static func save(_ image: UIImage) -> String? {

        // 如果 images 文件夹不存在，就创建
        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            try? FileManager.default.createDirectory(
                at: imagesDirectory,
                withIntermediateDirectories: true
            )
        }

        let uniName = UUID().uuidString + ".png"
        let imageURL = imagesDirectory.appendingPathComponent(uniName)

        guard let data = image.pngData() else {
            return nil
        }

        do {
            try data.write(to: imageURL)

            // 返回相对路径，保存到 Person
            return "images/\(uniName)"
        } catch {
            print(error)
            return nil
        }
    }

    /// 读取图片
    static func load(path: String) -> UIImage? {

        let url = documents.appendingPathComponent(path)

        return UIImage(contentsOfFile: url.path)
    }
}
