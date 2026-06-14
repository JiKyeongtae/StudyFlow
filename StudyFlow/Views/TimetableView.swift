import SwiftUI

struct TimetableView: View {

    @State private var timetables: [Timetable] = []

    @State private var selectedDay = "월"

    @State private var subject = ""

    @State private var startTime = Date()

    @State private var endTime = Date()

    let days = ["월", "화", "수", "목", "금"]

    var body: some View {

        NavigationStack {

            ZStack {

                Color(
                    red: 0.96,
                    green: 0.97,
                    blue: 0.99
                )
                .ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 20) {

                        Text("시간표")
                            .font(.system(size: 42))
                            .fontWeight(.bold)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )

                        Picker(
                            "요일",
                            selection: $selectedDay
                        ) {

                            ForEach(days, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)

                        TextField(
                            "과목명",
                            text: $subject
                        )
                        .textFieldStyle(.roundedBorder)

                        VStack(spacing: 12) {

                            HStack {

                                Text("시작 시간")

                                Spacer()

                                DatePicker(
                                    "",
                                    selection: $startTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                            }

                            HStack {

                                Text("종료 시간")

                                Spacer()

                                DatePicker(
                                    "",
                                    selection: $endTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(20)

                        Button {

                            guard !subject.isEmpty else {
                                return
                            }

                            let item =
                            Timetable(
                                day: selectedDay,
                                subject: subject,
                                startTime: startTime,
                                endTime: endTime
                            )

                            timetables.append(item)

                            timetables.sort {
                                $0.startTime < $1.startTime
                            }

                            TimetableStorage
                                .shared
                                .save(
                                    timetables: timetables
                                )

                            subject = ""

                        } label: {

                            Text("수업 추가")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)

                        TimetableGridView(
                            timetables: timetables
                        )

                        VStack(
                            alignment: .leading,
                            spacing: 16
                        ) {

                            Text("등록된 수업")
                                .font(.title2)
                                .fontWeight(.bold)

                            ForEach(timetables) { item in

                                HStack {

                                    TimetableCard(
                                        timetable: item
                                    )

                                    Button {

                                        timetables.removeAll {
                                            $0.id == item.id
                                        }

                                        TimetableStorage
                                            .shared
                                            .save(
                                                timetables: timetables
                                            )

                                    } label: {

                                        Image(
                                            systemName: "trash.fill"
                                        )
                                        .foregroundColor(.red)
                                        .font(.title3)
                                    }
                                }
                            }

                            if timetables.isEmpty {

                                Text("등록된 수업이 없습니다")
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    }
                    .padding()
                }
            }

            .onAppear {

                timetables =
                TimetableStorage
                    .shared
                    .load()

                timetables.sort {
                    $0.startTime < $1.startTime
                }
            }
        }
    }
}

struct TimetableCard: View {

    let timetable: Timetable

    var body: some View {

        HStack {

            VStack {

                Text(timetable.day)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("요일")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Divider()

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text(timetable.subject)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(
                    "\(timeString(timetable.startTime)) ~ \(timeString(timetable.endTime))"
                )
                .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(24)
        .shadow(
            color: .black.opacity(0.08),
            radius: 10
        )
    }

    func timeString(
        _ date: Date
    ) -> String {

        let formatter =
        DateFormatter()

        formatter.dateFormat = "HH:mm"

        return formatter.string(
            from: date
        )
    }
}

struct TimetableGridView: View {

    let timetables: [Timetable]

    let days = ["월", "화", "수", "목", "금"]

    let hours = Array(9...18)

    var body: some View {

        VStack(
            alignment: .leading
        ) {

            Text("시간표 미리보기")
                .font(.title2)
                .fontWeight(.bold)

            ScrollView(.horizontal) {

                Grid {

                    GridRow {

                        Text("")

                        ForEach(
                            days,
                            id: \.self
                        ) { day in

                            Text(day)
                                .bold()
                                .frame(width: 70)
                        }
                    }

                    ForEach(
                        hours,
                        id: \.self
                    ) { hour in

                        GridRow {

                            Text("\(hour)")
                                .frame(width: 40)

                            ForEach(
                                days,
                                id: \.self
                            ) { day in

                                cellView(
                                    day: day,
                                    hour: hour
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func cellView(
        day: String,
        hour: Int
    ) -> some View {

        let subject =
        findSubject(
            day: day,
            hour: hour
        )

        RoundedRectangle(
            cornerRadius: 8
        )
        .fill(
            subject == nil
            ? Color.gray.opacity(0.08)
            : Color.blue.opacity(0.25)
        )
        .frame(
            width: 70,
            height: 40
        )
        .overlay {

            Text(subject ?? "")
                .font(.caption2)
        }
    }

    func findSubject(
        day: String,
        hour: Int
    ) -> String? {

        let calendar =
        Calendar.current

        for item in timetables {

            guard item.day == day
            else {
                continue
            }

            let start =
            calendar.component(
                .hour,
                from: item.startTime
            )

            let end =
            calendar.component(
                .hour,
                from: item.endTime
            )

            if hour >= start &&
                hour < end {

                return item.subject
            }
        }

        return nil
    }
}

#Preview {
    TimetableView()
}
