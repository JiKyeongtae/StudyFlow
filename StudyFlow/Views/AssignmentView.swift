//
//  AssignmentView.swift
//  StudyFlow
//
//  Created by 지경태 on 6/14/26.
//

import SwiftUI

struct Assignment: Identifiable {

    let id = UUID()

    var title: String

    var completed: Bool
}

struct AssignmentView: View {

    @State private var assignments = [

        Assignment(
            title: "알고리즘 과제",
            completed: false
        ),

        Assignment(
            title: "물리학 보고서",
            completed: false
        )
    ]

    var body: some View {

        NavigationStack {

            List {

                ForEach(assignments.indices,
                        id: \.self) { index in

                    HStack {

                        Image(
                            systemName:
                            assignments[index].completed
                            ? "checkmark.circle.fill"
                            : "circle"
                        )

                        Text(
                            assignments[index].title
                        )
                    }
                    .onTapGesture {

                        assignments[index].completed.toggle()
                    }
                }
            }
            .navigationTitle("과제")
        }
    }
}

#Preview {
    AssignmentView()
}
