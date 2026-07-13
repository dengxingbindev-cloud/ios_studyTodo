import Foundation

final class TodoStorage {

    /// json文件路径
    private static let fileURL: URL = {

        let document = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        print(document.path)
        
        return document.appendingPathComponent("todos.json")

    }()

    /// 保存
    static func save(_ todos: [Todo]) {

        do {

            let data = try JSONEncoder().encode(todos)

            try data.write(to: fileURL)

        } catch {

            print("保存失败：\(error)")

        }

    }

    /// 读取
    static func load() -> [Todo] {

        do {

            let data = try Data(contentsOf: fileURL)

            return try JSONDecoder().decode(
                [Todo].self,
                from: data
            )

        } catch {

            return []

        }

    }

}
