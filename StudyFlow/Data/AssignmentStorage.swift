import Foundation

final class AssignmentStorage {

    static let shared = AssignmentStorage()

    private let key =
    "studyflow_assignments"

    func save(
        assignments: [Assignment]
    ) {

        guard let data =
        try? JSONEncoder()
            .encode(assignments)
        else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: key
        )
    }

    func load() -> [Assignment] {

        guard let data =
        UserDefaults.standard.data(
            forKey: key
        )
        else {
            return []
        }

        return (
            try?
            JSONDecoder()
                .decode(
                    [Assignment].self,
                    from: data
                )
        ) ?? []
    }
}
