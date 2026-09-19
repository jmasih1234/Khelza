import SwiftUI

/// Educational explanation card shown when the user taps "Explain This" on a match event.
/// Adapts content to the user's knowledge level.
/// After reading, the user can optionally take a contextual quiz.
struct ExplainThisView: View {
    let event: MatchEvent
    let knowledgeLevel: KnowledgeLevel
    let onDismiss: () -> Void
    let onTakeQuiz: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: event.icon)
                    .font(.title3)
                    .foregroundStyle(Color(hex: event.type.accentColorHex))
                
                Text(headerTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color(hex: event.type.accentColorHex).opacity(0.1))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // What happened
                    VStack(alignment: .leading, spacing: 6) {
                        Text("What happened")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(event.description)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    // Why it happened — adapted to knowledge level
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Why?")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(knowledgeLevel.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray5))
                                .clipShape(Capsule())
                        }
                        
                        Text(explanation)
                            .font(.subheadline)
                            .lineSpacing(4)
                    }
                    
                    // Key fact highlight
                    if let keyFact = keyFact {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.yellow)
                            
                            Text(keyFact)
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineSpacing(2)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.yellow.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Divider()
                    
                    // Quiz CTA
                    VStack(spacing: 10) {
                        Text("Test your knowledge")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Button {
                            onTakeQuiz()
                        } label: {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                Text("Take a quick quiz")
                                Spacer()
                                Text("+\(XPEngine.liveQuizCorrectXP) XP")
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.right")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
    }
    
    // MARK: - Content adapted to event type and knowledge level
    
    private var headerTitle: String {
        switch event.type {
        case .goalDisallowed:
            return "Why was that goal disallowed?"
        case .redCard, .secondYellow:
            return "What does a red card mean?"
        case .varCheck, .varDecision:
            return "What is VAR checking?"
        case .penaltyAwarded:
            return "Why was a penalty given?"
        case .penaltyOverturned:
            return "Why was the penalty overturned?"
        case .offside:
            return "What is offside?"
        case .tacticalChange:
            return "Why change tactics?"
        case .substitution:
            return "What does this substitution mean?"
        default:
            return "Explain this"
        }
    }
    
    private var explanation: String {
        switch event.type {
        case .goalDisallowed, .offside:
            return offsideExplanation
        case .redCard, .secondYellow:
            return redCardExplanation
        case .varCheck, .varDecision:
            return varExplanation
        case .penaltyAwarded:
            return penaltyExplanation
        case .substitution:
            return substitutionExplanation
        case .tacticalChange:
            return tacticalExplanation
        default:
            return event.educationalNote
        }
    }
    
    private var keyFact: String? {
        switch event.type {
        case .goalDisallowed, .offside:
            return "Semi-automated offside technology uses 29 tracking points per player at 50 frames per second — even a shoulder being offside by millimeters can disallow a goal."
        case .redCard:
            return "A team that goes down to 10 players concedes on average 0.5 more goals per match. Managers must immediately adjust their tactical approach."
        case .varCheck, .varDecision:
            return "VAR can only intervene on four types of decisions: goals, penalty decisions, direct red cards, and mistaken identity."
        default:
            return nil
        }
    }
    
    // MARK: - Knowledge-level adapted explanations
    
    private var offsideExplanation: String {
        switch knowledgeLevel {
        case .beginner:
            return "The goal was disallowed because the scorer (or the player who assisted) was in an offside position when the ball was played.\n\nThe offside rule is simple: when a teammate passes you the ball, you must have at least two opponents (usually the goalkeeper plus one defender) between you and the goal line.\n\nIf you're even slightly past that second-to-last defender when the ball is kicked, you're offside — and any goal scored doesn't count."
        case .intermediate:
            return "VAR determined the attacker was offside at the moment the ball was played. Offside is judged at the exact frame of the pass, not when the ball is received.\n\nKey nuances:\n- Only the parts of the body you can score with matter (head, torso, legs — not arms)\n- Being level with the defender is NOT offside\n- Deflections don't reset the offside phase, but deliberate plays do\n- The attacker must also be 'interfering with play' — simply being offside isn't enough"
        case .advanced:
            return "The semi-automated offside system detected the attacker's position was beyond the second-last defender at the moment of the pass. The technology tracks 29 body points per player at 50fps using 12 dedicated cameras.\n\nThe debate: while the technology is precise, the 'point of contact' for the pass — when the ball leaves the passer's foot — remains a human judgment call by the VAR operator. This single frame selection can shift the offside line by centimeters.\n\nTactically, this goal being disallowed rewards the defensive team's high line. Modern managers deliberately push their backline to exploit tight offside margins."
        }
    }
    
    private var redCardExplanation: String {
        switch knowledgeLevel {
        case .beginner:
            return "A red card means the player must leave the field immediately and cannot be replaced. Their team plays with 10 players for the rest of the match.\n\nRed cards are given for serious offenses like violent conduct, dangerous tackles, or denying a clear goal-scoring opportunity."
        case .intermediate:
            return "A straight red card (as opposed to two yellows) is given for serious foul play, violent conduct, or denying an obvious goal-scoring opportunity.\n\nPlaying with 10 men forces the manager into immediate tactical decisions — typically withdrawing an attacker for a more defensive shape. The 4-3-2 or 4-4-1 are common 10-man formations."
        case .advanced:
            return "The red card fundamentally changes the match's tactical landscape. The team going down to 10 must decide between compactness (sitting deep in a low block) or maintaining their structure with one fewer player.\n\nStatistically, teams with 10 players win only 9% of matches versus 45% for 11v11. Expected goals (xG) typically drops by 0.8-1.0 for the reduced team. Modern managers have adapted by using strategic fouling near the halfway line to prevent transitions."
        }
    }
    
    private var varExplanation: String {
        switch knowledgeLevel {
        case .beginner:
            return "VAR stands for Video Assistant Referee. A team of officials watches every angle on video screens to check important decisions.\n\nVAR reviews: goals, penalties, red cards, and cases of mistaken identity. If the review finds a 'clear and obvious error', the decision can be changed."
        case .intermediate:
            return "The VAR process follows a strict protocol: the Video Match Official reviews the incident, communicates with the on-field referee, and either confirms the decision or recommends an 'On-Field Review' at the pitchside monitor.\n\nFor factual decisions (like offside), VAR can overturn directly. For subjective decisions (like the severity of a foul), the referee is typically sent to the monitor."
        case .advanced:
            return "VAR operates within the 'minimum interference, maximum benefit' principle. The threshold for intervention is a 'clear and obvious error' or a 'serious missed incident'.\n\nThe controversy lies in interpretation: what constitutes 'clear and obvious' is itself subjective. Different competition implementations (Premier League vs Serie A vs Bundesliga) show marked differences in intervention rates and pitchside monitor usage."
        }
    }
    
    private var penaltyExplanation: String {
        return "A penalty is awarded when a foul is committed by the defending team inside their own penalty area (the large box near the goal). The fouled team gets a direct shot from the penalty spot, 12 yards from goal.\n\nPenalties are converted roughly 75-80% of the time at the professional level."
    }
    
    private var substitutionExplanation: String {
        return "Managers make substitutions to change tactics, bring in fresh energy, or respond to injuries. Teams are allowed 5 substitutions per match.\n\nA common pattern is bringing on faster attackers late in the match to exploit tired defenders, or adding defensive players to protect a lead."
    }
    
    private var tacticalExplanation: String {
        return "A tactical change means the manager has altered the team's formation or playing style during the match. This often happens in response to going behind, having a player sent off, or needing to change the game's momentum.\n\nFor example, switching from a 4-3-3 to a 3-5-2 adds an extra midfielder for more control in the center of the pitch."
    }
}
