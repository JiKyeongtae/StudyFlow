import SwiftUI

struct HomeView: View {

    @State private var remainingAssignments = 0

    @State private var completedAssignments = 0

    @State private var totalAssignments = 0

    @State private var nearestExamName = "시험 없음"

    @State private var nearestExamDday = "-"

    @State private var schedules: [Schedule] = []
    
    @State private var todayClassCount = 0

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

                    VStack(spacing: 24) {

                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {

                            Text(currentMonth())
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text(greeting())
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("오늘도 계획적인 하루를 시작해보세요")
                                .foregroundColor(.gray)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                        HStack(spacing: 16) {

                            StatCard(
                                number: "\(todayClassCount)",
                                title: "오늘 수업",
                                icon: "book.fill"
                            )

                            StatCard(
                                number: "\(remainingAssignments)",
                                title: "남은 과제",
                                icon: "doc.fill"
                            )
                        }

                        SectionCard(
                            title: "과제 진행률"
                        ) {

                            VStack(
                                alignment: .leading,
                                spacing: 12
                            ) {

                                ProgressView(
                                    value: Double(completedAssignments),
                                    total: Double(
                                        max(totalAssignments, 1)
                                    )
                                )

                                Text(
                                    "\(completedAssignments)/\(totalAssignments) 완료"
                                )
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                        }

                        SectionCard(
                            title: "오늘의 일정"
                        ) {

                            if schedules.isEmpty {

                                Text("등록된 일정이 없습니다")
                                    .foregroundColor(.gray)

                            } else {

                                ForEach(
                                    schedules.prefix(3)
                                ) { schedule in

                                    ScheduleHomeRow(
                                        title: schedule.title,
                                        date: schedule.date
                                    )
                                }
                            }
                        }

                        SectionCard(
                            title: "다가오는 시험"
                        ) {

                            ExamRow(
                                title: nearestExamName,
                                dday: nearestExamDday
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("StudyFlow")

            .onAppear {

                let assignments =
                AssignmentStorage.shared.load()

                remainingAssignments =
                assignments.filter {
                    !$0.completed
                }.count

                completedAssignments =
                assignments.filter {
                    $0.completed
                }.count

                totalAssignments =
                assignments.count

                schedules =
                ScheduleStorage.shared.load()

                schedules.sort {
                    $0.date < $1.date
                }
                
                let timetables =
                TimetableStorage.shared.load()

                let weekday =
                Calendar.current.component(
                    .weekday,
                    from: Date()
                )

                let todayDay: String

                switch weekday {

                case 2:
                    todayDay = "월"

                case 3:
                    todayDay = "화"

                case 4:
                    todayDay = "수"

                case 5:
                    todayDay = "목"

                case 6:
                    todayDay = "금"

                default:
                    todayDay = ""
                }

                todayClassCount =
                timetables.filter {
                    $0.day == todayDay
                }.count
                let exams =
                ExamStorage.shared.load()

                if let nearest =
                    exams.sorted(
                        by: { $0.date < $1.date }
                    ).first {

                    let calendar =
                    Calendar.current

                    let start =
                    calendar.startOfDay(
                        for: Date()
                    )

                    let end =
                    calendar.startOfDay(
                        for: nearest.date
                    )

                    let days =
                    calendar
                        .dateComponents(
                            [.day],
                            from: start,
                            to: end
                        )
                        .day ?? 0

                    nearestExamName =
                    nearest.subject

                    nearestExamDday =
                    "D-\(days)"

                } else {

                    nearestExamName =
                    "시험 없음"

                    nearestExamDday =
                    "-"
                }
            }
        }
    }
}

struct StatCard: View {

    let number: String
    let title: String
    let icon: String

    var body: some View {

        VStack(spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)

            Text(number)
                .font(.system(size: 36))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)

        .background(
            LinearGradient(
                colors: [
                    Color(
                        red: 0.29,
                        green: 0.56,
                        blue: 0.89
                    ),
                    Color(
                        red: 0.20,
                        green: 0.45,
                        blue: 0.80
                    )
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )

        .cornerRadius(24)

        .shadow(
            color: .black.opacity(0.12),
            radius: 10,
            x: 0,
            y: 5
        )
    }
}

struct SectionCard<Content: View>: View {

    let title: String
    let content: Content

    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text(title)
                .font(.title3)
                .fontWeight(.bold)

            content
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()

        .background(
            RoundedRectangle(
                cornerRadius: 24
            )
            .fill(Color.white)
        )

        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}

struct ScheduleHomeRow: View {

    let title: String

    let date: Date

    var body: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(title)
                    .fontWeight(.semibold)

                Text(
                    formattedDate(date)
                )
                .font(.caption)
                .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    func formattedDate(
        _ date: Date
    ) -> String {

        let formatter =
        DateFormatter()

        formatter.locale =
        Locale(identifier: "ko_KR")

        formatter.dateFormat =
        "MM/dd HH:mm"

        return formatter.string(
            from: date
        )
    }
}

struct ExamRow: View {

    let title: String
    let dday: String

    var body: some View {

        HStack {

            VStack(alignment: .leading) {

                Text(title)
                    .fontWeight(.semibold)

                Text("가장 가까운 시험")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(dday)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding()
        .background(
            Color.blue.opacity(0.08)
        )
        .cornerRadius(16)
    }
}

func currentMonth() -> String {

    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy년 M월"

    return formatter.string(
        from: Date()
    )
}

func greeting() -> String {

    let hour =
    Calendar.current.component(
        .hour,
        from: Date()
    )

    switch hour {

    case 5..<12:
        return "좋은 아침입니다"

    case 12..<18:
        return "좋은 오후입니다"

    default:
        return "좋은 저녁입니다"
    }
}


#Preview {
    HomeView()
}
