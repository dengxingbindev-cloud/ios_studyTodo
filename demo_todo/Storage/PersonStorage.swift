import Foundation

final class PersonStorage {

    private static let documents = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!

    private static let personURL = documents.appendingPathComponent("person.json")
    
    /// 保存
    static func save(_ person: Person) {

        do {

            let data = try JSONEncoder().encode(person)

            try data.write(to: personURL)

        } catch {

            print("保存失败：\(error)")

        }

    }

    /// 读取
    static func load() -> Person {

        do {

            let data = try Data(contentsOf: personURL)

            return try JSONDecoder().decode(
                Person.self,
                from: data
            )

        } catch {

            return Person(
                name: "",
                avatorPath: "",
                about: ""
            )
        }

    }

}
