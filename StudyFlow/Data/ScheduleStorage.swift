import Foundation

final class ScheduleStorage {

    static let shared = ScheduleStorage()

    private let key = "studyflow_schedules"

    func save(
        schedules: [Schedule]
    ) {

        guard let data =
                try? JSONEncoder()
            .encode(schedules)
        else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: key
        )
    }

    func load() -> [Schedule] {

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
                    [Schedule].self,
                    from: data
                )
        ) ?? []
    }
}
