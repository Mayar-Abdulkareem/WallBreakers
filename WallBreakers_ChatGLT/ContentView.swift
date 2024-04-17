//
//  ContentView.swift
//  WallBreakers
//
//  Created by ftsmobileteam on 16/04/2024.
//

import SwiftUI

struct ContentView: View {

    @State var newMessageText: String = ""
    @State var messages: [MessageModel] = [MessageModel(
        id: UUID().uuidString,
        message: "Hello, I'm a chatbot. How can I help you?",
        isBotMessage: true,
        date: Date()
    )]
    @State var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            headerView
            chatView
            textFieldView
        }
    }

    var headerView: some View {
        VStack {
            Text("Chatbot")
                .font(.largeTitle)
                .fontWeight(.bold)
            Divider()
        }
    }

    var chatView: some View {
        ScrollViewReader { proxy in
            Group {
                if messages.isEmpty {
                    Text("No messages yet")
                        .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(messages) { message in
                            MessageCell(model: message)
                                .id(message.id)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                        
                        if isLoading {
                            DotLoadingView(color: .theme)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onChange(of: messages.count) { _ in
                        DispatchQueue.main.async {
                            if let lastMessage = messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }

    var textFieldView: some View {
        VStack {
            Divider()

            HStack {
                TextField("Enter your message", text: $newMessageText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Button(action: {
                    sendNewMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .padding(.all, 10)
                        .background(
                            Color.theme.opacity(
                                isLoading || newMessageText.isEmpty ? 0.5 : 1
                            )
                        )
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                .disabled(isLoading || newMessageText.isEmpty)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
    }

    func MessageCell(model: MessageModel) -> some View {
        HStack {
            if !model.isBotMessage {
                Spacer()
            }

            VStack(alignment: !model.isBotMessage ? .trailing : .leading) {
                Text(model.message)
                    .padding(10)
                    .background(
                        !model.isBotMessage ? Color.theme.opacity(0.8) : Color.gray.opacity(0.2)
                    )
                    .foregroundStyle(
                        !model.isBotMessage ? Color.white : Color.black
                    )
                    .font(.body)
                    .cornerRadius(15)

                Text(model.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)

            if model.isBotMessage {
                Spacer()
            }
        }
    }
}

// MARK: - Functionality
extension ContentView {
    func sendNewMessage() {
        guard isLoading == false,
        !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        messages.append(
            MessageModel(
                id: UUID().uuidString,
                message: newMessageText,
                isBotMessage: false,
                date: Date()
            )
        )
        
        Task {
            do {
                var receivedMessage = try await NetworkManager.askQuestion(message: newMessageText)
                if let range = receivedMessage?.answer.range(of: "Answer: ") {
                    receivedMessage?.answer.removeSubrange(range)
                }

                let trimmedString = receivedMessage?.answer.trimmingCharacters(in: .whitespaces)
                messages.append(
                    MessageModel(
                        id: UUID().uuidString,
                        message: trimmedString ?? "--",
                        isBotMessage: true,
                        date: Date()
                    )
                )
                
                newMessageText = ""
                isLoading = false
            } catch {
                print(error.localizedDescription)
                messages.append(
                    MessageModel(
                        id: UUID().uuidString,
                        message: "Please try again later",
                        isBotMessage: true,
                        date: Date()
                    )
                )
                isLoading = false
            }
        }
        
        isLoading = true
    }
}

#Preview {
    ContentView()
}
