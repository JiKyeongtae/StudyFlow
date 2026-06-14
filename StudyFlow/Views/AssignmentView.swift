import SwiftUI

struct AssignmentView: View {

    @State private var assignments:
    [Assignment] = []

    @State private var title = ""

    @State private var dueDate = Date()

    var body: some View {

        NavigationStack {

            VStack {

                TextField(
                    "과제 입력",
                    text: $title
                )
                .textFieldStyle(.roundedBorder)

                DatePicker(
                    "마감일",
                    selection: $dueDate,
                    displayedComponents: .date
                )

                Button("과제 추가") {

                    guard !title.isEmpty else {
                        return
                    }

                    assignments.append(
                        Assignment(
                            title: title,
                            dueDate: dueDate
                        )
                    )

                    AssignmentStorage
                        .shared
                        .save(
                            assignments: assignments
                        )

                    title = ""
                }
                .buttonStyle(.borderedProminent)

                List {

                    ForEach(assignments) {
                        assignment in

                        HStack {

                            Image(
                                systemName:
                                assignment.completed
                                ? "checkmark.circle.fill"
                                : "circle"
                            )

                            VStack(
                                alignment: .leading
                            ) {

                                Text(
                                    assignment.title
                                )

                                Text(
                                    "D-\(daysUntil(assignment.dueDate))"
                                )
                                .foregroundColor(.blue)
                                .font(.caption)
                            }

                            Spacer()
                        }
                        .contentShape(
                            Rectangle()
                        )
                        .onTapGesture {

                            toggle(
                                assignment
                            )
                        }
                    }
                }
            }
            .padding()

            .navigationTitle("과제")

            .onAppear {

                assignments =
                AssignmentStorage
                    .shared
                    .load()
            }
        }
    }

    func toggle(
        _ assignment: Assignment
    ) {

        guard let index =
        assignments.firstIndex(
            where: {
                $0.id ==
                assignment.id
            }
        )
        else {
            return
        }

        assignments[index]
            .completed
            .toggle()

        AssignmentStorage
            .shared
            .save(
                assignments: assignments
            )
    }

    func daysUntil(
        _ date: Date
    ) -> Int {

        Calendar.current
            .dateComponents(
                [.day],
                from: Date(),
                to: date
            )
            .day ?? 0
    }
}

#Preview {
    AssignmentView()
}
