import SwiftUI

struct AIGuideView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = FreddyViewModel()
    @State private var showPostGameAlerts = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.messages.isEmpty {
                    // Freddy welcome state
                    ScrollView {
                        VStack(spacing: 20) {
                            Spacer(minLength: 20)
                            
                            // Freddy avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .mint],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Text("⚽")
                                    .font(.system(size: 40))
                            }
                            
                            VStack(spacing: 6) {
                                Text("Hey, I'm Freddy!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Your personal sports expert")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("I'll adapt to your \(appState.userProfile.knowledgeLevel.rawValue.lowercased()) level")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            
                            // Post-game alerts section
                            if !viewModel.postGameAlerts.isEmpty {
                                postGameAlertsSection
                            }
                            
                            // Suggested questions
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Ask me anything")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 4)
                                
                                ForEach(viewModel.suggestedQuestions) { question in
                                    Button {
                                        viewModel.askSuggested(question, level: appState.userProfile.knowledgeLevel)
                                    } label: {
                                        HStack {
                                            Image(systemName: question.icon)
                                                .foregroundStyle(.green)
                                                .frame(width: 24)
                                            Text(question.text)
                                                .font(.subheadline)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            Text(question.category)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(.systemGray5))
                                                .clipShape(Capsule())
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(12)
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    // Chat messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.messages) { message in
                                    chatBubble(message)
                                        .id(message.id)
                                }
                                
                                if viewModel.isTyping {
                                    typingIndicator
                                }
                            }
                            .padding()
                        }
                        .onChange(of: viewModel.messages.count) {
                            if let last = viewModel.messages.last {
                                withAnimation {
                                    proxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                // Input bar
                inputBar
            }
            .navigationTitle("Freddy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Post-game alerts bell
                    Button {
                        showPostGameAlerts.toggle()
                        viewModel.markAlertsRead()
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                            if viewModel.unreadAlertCount > 0 {
                                Text("\(viewModel.unreadAlertCount)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(3)
                                    .background(.red)
                                    .clipShape(Circle())
                                    .offset(x: 6, y: -6)
                            }
                        }
                    }
                    
                    if !viewModel.messages.isEmpty {
                        Button {
                            viewModel.clearChat()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .sheet(isPresented: $showPostGameAlerts) {
                postGameAlertsSheet
            }
        }
    }
    
    // MARK: - Post-Game Alerts Section (Welcome Screen)
    
    var postGameAlertsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text("Recent Match Calls")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Button("See All") {
                    showPostGameAlerts = true
                    viewModel.markAlertsRead()
                }
                .font(.caption)
            }
            .padding(.horizontal, 4)
            
            ForEach(viewModel.postGameAlerts.prefix(2)) { alert in
                Button {
                    viewModel.askAboutPostGameAlert(alert, level: appState.userProfile.knowledgeLevel)
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: alert.callType.icon)
                            .foregroundStyle(.orange)
                            .frame(width: 20)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(alert.headline)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                            Text(alert.matchDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(Color.orange.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Post-Game Alerts Sheet
    
    var postGameAlertsSheet: some View {
        NavigationStack {
            List(viewModel.postGameAlerts) { alert in
                Button {
                    showPostGameAlerts = false
                    viewModel.askAboutPostGameAlert(alert, level: appState.userProfile.knowledgeLevel)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: alert.callType.icon)
                                .foregroundStyle(.orange)
                            Text(alert.callType.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.orange)
                            Spacer()
                            Text(alert.timestamp, style: .relative)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(alert.headline)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        Text(alert.matchDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(alert.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Match Calls")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showPostGameAlerts = false }
                }
            }
        }
    }
    
    // MARK: - Chat Bubble
    
    func chatBubble(_ message: ChatMessage) -> some View {
        HStack(alignment: .top) {
            if message.isUser { Spacer(minLength: 60) }
            
            if !message.isUser {
                // Freddy avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                    
                    Text("⚽")
                        .font(.system(size: 14))
                }
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.isUser, let category = message.category {
                    Text(category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }
                
                Text(LocalizedStringKey(message.content))
                    .font(.subheadline)
                    .padding(12)
                    .background(message.isUser ? .green : Color(.systemGray5))
                    .foregroundStyle(message.isUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            if !message.isUser { Spacer(minLength: 40) }
        }
    }
    
    var typingIndicator: some View {
        HStack(alignment: .top) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Text("⚽")
                    .font(.system(size: 14))
            }
            
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 6, height: 6)
                        .opacity(0.5)
                }
            }
            .padding(12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
        }
    }
    
    var inputBar: some View {
        HStack(spacing: 8) {
            TextField("Ask Freddy anything...", text: $viewModel.inputText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    viewModel.sendMessage(level: appState.userProfile.knowledgeLevel)
                }
            
            Button {
                viewModel.sendMessage(level: appState.userProfile.knowledgeLevel)
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.green)
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

#Preview {
    AIGuideView()
        .environment(AppState())
}
