import Foundation

final class TodoNetwork {

    //private static let baseURL = "http://localhost:3000"
    
    private static let baseURL = "http://192.168.3.184:3000"

    /// 获取Todo列表
    static func load(
        completion: @escaping ([Todo]) -> Void
    ) {

        guard let url = URL(
            string: "\(baseURL)/todos"
        ) else {

            return

        }

        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in

            guard let data = data else {

                DispatchQueue.main.async {

                    return

                }

                return

            }

            do {

                let todos = try JSONDecoder().decode(
                    [Todo].self,
                    from: data
                )

                DispatchQueue.main.async {

                    completion(todos)

                }

            } catch {

                DispatchQueue.main.async {

                    return

                }

            }

        }.resume()

    }

    /// 新增Todo
    static func save(_ todo: Todo) {

        guard let url = URL(
            string: "\(baseURL)/todos"
        ) else {

            return

        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        do {

            request.httpBody =
                try JSONEncoder().encode(todo)

        } catch {

            return

        }

        URLSession.shared.dataTask(with: request)
        { _, _, _ in

            print("上传完成")

        }.resume()

    }
    
    /// 更新Todo
    static func update(_ todo: Todo) {

        guard let url = URL(
            string: "\(baseURL)/todos/\(todo.id.uuidString)"
        ) else {

            return

        }

        var request = URLRequest(url: url)

        request.httpMethod = "PUT"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        do {

            request.httpBody = try JSONEncoder().encode(todo)

        } catch {

            print("编码失败：\(error)")

            return

        }

        URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in

            if let error = error {

                print("更新失败：\(error)")

                return

            }

            print("更新成功")

        }.resume()

    }
    
    /// 删除Todo
    static func delete(_ todo: Todo) {

        guard let url = URL(
            string: "\(baseURL)/todos/\(todo.id.uuidString)"
        ) else {

            return

        }

        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in

            if let error = error {

                print("删除失败：\(error)")

                return

            }

            print("删除成功")

        }.resume()

    }
    
    

}
