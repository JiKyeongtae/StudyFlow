import SwiftUI

struct ScheduleView: View {

    @State private var schedules: [Schedule] = []

    @State private var newSchedule = ""

    @State private var selectedDate = Date()

    var body: some View {

        NavigationStack {

            ZStack {

                Color(
                    red: 0.96,
                    green: 0.97,
                    blue: 0.99
                )
                .ignoresSafeArea()

                VStack {

                    VStack(spacing: 12) {

                        TextField(
                            "일정 입력",
                            text: $newSchedule
                        )
                        .textFieldStyle(
                            .roundedBorder
                        )

                        DatePicker(
                            "일정 날짜",
                            selection: $selectedDate,
                            displayedComponents: [
                                .date,
                                .hourAndMinute
                            ]
                        )

                        Button("일정 추가") {

                            guard
                                !newSchedule.isEmpty
                            else {
                                return
                            }

                            let schedule =
                            Schedule(
                                title: newSchedule,
                                date: selectedDate
                            )

                            schedules.append(
                                schedule
                            )

                            schedules.sort {
                                $0.date < $1.date
                            }

                            ScheduleStorage
                                .shared
                                .save(
                                    schedules: schedules
                                )

                            newSchedule = ""
                        }
                        .buttonStyle(
                            .borderedProminent
                        )
                    }
                    .padding()

                    List {

                        ForEach(
                            schedules
                        ) { schedule in

                            VStack(
                                alignment: .leading,
                                spacing: 6
                            ) {

                                Text(
                                    schedule.title
                                )
                                .font(.headline)

                                Text(
                                    formattedDate(
                                        schedule.date
                                    )
                                )
                                .font(.caption)
                                .foregroundColor(
                                    .gray
                                )
                            }
                        }

                        .onDelete {
                            indexSet in

                            schedules.remove(
                                atOffsets: indexSet
                            )

                            ScheduleStorage
                                .shared
                                .save(
                                    schedules: schedules
                                )
                        }
                    }
                }
            }

            .navigationTitle("일정")

            .onAppear {

                schedules =
                ScheduleStorage
                    .shared
                    .load()

                schedules.sort {
                    $0.date < $1.date
                }
            }
        }
    }

    func formattedDate(
        _ date: Date
    ) -> String {

        let formatter =
        DateFormatter()

        formatter.locale =
        Locale(
            identifier: "ko_KR"
        )

        formatter.dateFormat =
        "yyyy.MM.dd HH:mm"

        return formatter.string(
            from: date
        )
    }
}

#Preview {
    ScheduleView()
}
