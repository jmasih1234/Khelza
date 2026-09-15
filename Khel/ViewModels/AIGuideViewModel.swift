import Foundation

@Observable
class FreddyViewModel {
    var messages: [ChatMessage] = []
    var inputText: String = ""
    var isTyping: Bool = false
    var suggestedQuestions: [SuggestedQuestion] = FreddyResponses.suggestedQuestions
    var postGameAlerts: [PostGameAlert] = FreddyResponses.recentPostGameAlerts
    var showPostGameAlerts: Bool = false
    var unreadAlertCount: Int = 0
    
    init() {
        unreadAlertCount = postGameAlerts.count
    }
    
    func sendMessage(level: KnowledgeLevel, favoriteLeagueIDs: Set<String> = []) {
        let userMessage = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMessage.isEmpty else { return }
        
        messages.append(ChatMessage(content: userMessage, isUser: true))
        inputText = ""
        isTyping = true
        
        Task { @MainActor in
            // Simulate Freddy "thinking" with variable delay based on complexity
            let delay = detectComplexity(userMessage)
            try? await Task.sleep(for: .seconds(delay))
            
            let (response, category) = FreddyResponses.respond(to: userMessage, level: level)
            messages.append(ChatMessage(content: response, isUser: false, category: category))
            isTyping = false
        }
    }
    
    func askSuggested(_ question: SuggestedQuestion, level: KnowledgeLevel) {
        inputText = question.text
        sendMessage(level: level)
    }
    
    func askAboutPostGameAlert(_ alert: PostGameAlert, level: KnowledgeLevel) {
        inputText = "Tell me about the \(alert.callType.rawValue.lowercased()) in \(alert.matchDescription)"
        sendMessage(level: level)
    }
    
    func markAlertsRead() {
        unreadAlertCount = 0
    }
    
    func clearChat() {
        messages = []
    }
    
    private func detectComplexity(_ query: String) -> Double {
        let complexKeywords = ["why", "explain", "how does", "difference between", "compare", "tactical", "analysis"]
        let isComplex = complexKeywords.contains { query.lowercased().contains($0) }
        return isComplex ? Double.random(in: 1.2...2.0) : Double.random(in: 0.6...1.2)
    }
}

// MARK: - Freddy's Response Engine

struct FreddyResponses {
    
    static func respond(to query: String, level: KnowledgeLevel) -> (String, FreddyCategory) {
        let lower = query.lowercased()
        
        // Post-game calls and controversial decisions
        if matchesPostGame(lower) {
            return (postGameResponse(lower, level: level), .postGame)
        }
        
        // Rules and referee decisions
        if matchesRules(lower) {
            return (rulesResponse(lower, level: level), .rules)
        }
        
        // Tactics
        if matchesTactics(lower) {
            return (tacticsResponse(lower, level: level), .tactics)
        }
        
        // Competitions
        if matchesCompetitions(lower) {
            return (competitionsResponse(lower, level: level), .competitions)
        }
        
        // Transfers and business
        if matchesTransfers(lower) {
            return (transfersResponse(lower, level: level), .transfers)
        }
        
        // History and rivalries
        if matchesHistory(lower) {
            return (historyResponse(lower, level: level), .history)
        }
        
        // Players
        if matchesPlayers(lower) {
            return (playersResponse(lower, level: level), .players)
        }
        
        return (defaultResponse(level: level), .general)
    }
    
    // MARK: - Topic Matchers
    
    private static func matchesPostGame(_ q: String) -> Bool {
        let keywords = ["disallowed", "overturned", "rescinded", "controversy", "wrong call", "bad call",
                        "post-game", "post game", "postgame", "after the match", "decision reversed",
                        "should have been", "shouldn't have", "robbed", "unfair", "var review",
                        "goal ruled out", "called back", "handball", "simulation", "dive"]
        return keywords.contains { q.contains($0) }
    }
    
    private static func matchesRules(_ q: String) -> Bool {
        let keywords = ["offside", "offsides", "foul", "penalty", "free kick", "corner",
                        "throw-in", "var", "video", "red card", "yellow card", "booking",
                        "rule", "regulation", "law", "referee", "ref ", "advantage",
                        "goal kick", "extra time", "stoppage", "added time", "injury time"]
        return keywords.contains { q.contains($0) }
    }
    
    private static func matchesTactics(_ q: String) -> Bool {
        let keywords = ["formation", "tactic", "strategy", "false nine", "false 9", "pressing",
                        "counter attack", "counterattack", "possession", "tiki-taka", "tiki taka",
                        "wing-back", "wingback", "high line", "low block", "gegenpressing",
                        "build-up", "buildup", "playmaker", "anchor", "pivot", "inverted"]
        return keywords.contains { q.contains($0) }
    }
    
    private static func matchesCompetitions(_ q: String) -> Bool {
        let keywords = ["champions league", "ucl", "europa league", "premier league", "la liga",
                        "serie a", "bundesliga", "ligue 1", "world cup", "euros", "tournament",
                        "qualification", "relegation", "promotion", "table", "standings",
                        "group stage", "knockout", "final"]
        return keywords.contains { q.contains($0) }
    }
    
    private static func matchesTransfers(_ q: String) -> Bool {
        let keywords = ["transfer", "signing", "fee", "contract", "loan", "free agent",
                        "buyout clause", "release clause", "deadline day", "window",
                        "wage", "salary", "sold", "bought", "bid", "offer"]
        return keywords.contains { q.contains($0) }
    }
    
    private static func matchesHistory(_ q: String) -> Bool {
        let keywords = ["history", "historic", "legendary", "classic", "rivalry", "derby",
                        "el clasico", "el clásico", "greatest", "best ever", "all time",
                        "record", "tradition", "origin", "founded", "vintage"]
        return keywords.contains { q.contains($0) }
    }
    
    private static func matchesPlayers(_ q: String) -> Bool {
        let keywords = ["messi", "ronaldo", "haaland", "mbappé", "mbappe", "salah",
                        "player", "striker", "goalkeeper", "defender", "midfielder",
                        "captain", "ballon d'or", "golden boot", "best player",
                        "bellingham", "vinicius", "saka", "pedri", "gavi"]
        return keywords.contains { q.contains($0) }
    }
    
    // MARK: - Response Generators
    
    private static func postGameResponse(_ q: String, level: KnowledgeLevel) -> String {
        if q.contains("disallowed") || q.contains("goal ruled out") || q.contains("called back") {
            switch level {
            case .beginner:
                return "⚽ Great question! Goals can be 'disallowed' (cancelled) for a few reasons:\n\n• **Offside** — the scorer or assisting player was ahead of the last defender\n• **Foul** — someone pushed, tripped, or fouled a defender before the goal\n• **Handball** — the ball touched the scorer's arm/hand\n\nVAR (Video Assistant Referee) reviews goals to check for any of these. It can feel frustrating when a goal is taken away, but it's meant to keep things fair! I'll always alert you when a big call happens after a match. 🔔"
            case .intermediate:
                return "⚽ Disallowed goals are one of the most debated parts of modern soccer. VAR checks every goal for:\n\n• **Offside** — even millimeters count with semi-automated offside tech\n• **Fouls in the build-up** — any infringement in the attacking sequence\n• **Handball** — the rules changed in 2021: accidental handball by a goal-scorer always disallows the goal\n• **Goalkeeper interference** — blocking the keeper's line of sight while offside\n\nThe controversial part? The 'build-up' window is subjective — how far back does the referee check? Some disallowed goals involve fouls 30+ seconds before the ball hit the net."
            case .advanced:
                return "⚽ Disallowed goals highlight the tension between technology and the spirit of the game. Key nuances:\n\n• **Semi-automated offside** uses limb-tracking at 50fps — but the 'point of contact' for the pass is still a human judgment call\n• **IFAB's handball law** (Law 12) has been rewritten 3 times since 2019. Currently: any goal scored directly from the scorer's hand/arm is disallowed, regardless of intent\n• **Build-up phase fouls**: referees have discretion on how far back to review. The 'new attacking phase' concept is not precisely defined\n• **Subjective interference**: was the offside player 'clearly' impacting the defender's ability to play? Different refs, different calls\n\nPost-match analysis often reveals these margins. I'll flag any controversial calls from your followed teams right away."
            }
        }
        
        if q.contains("handball") || q.contains("hands") {
            switch level {
            case .beginner:
                return "✋ Handball rules can be confusing! Here's the simple version:\n\n• If a player **deliberately** touches the ball with their hand/arm → it's a foul\n• If a player's arm is in an **unnatural position** (like raised up) and the ball hits it → also a foul\n• If the ball goes off the hand/arm directly into the goal → always disallowed, even if accidental\n\nThe tricky part: what counts as 'unnatural position' is often debated. Even referees disagree!"
            case .intermediate:
                return "✋ The handball rule has been one of soccer's most contentious areas. Current IFAB guidelines:\n\n• **Deliberate handling** — always an offense\n• **Making yourself bigger** — extending arm/hand beyond natural body silhouette\n• **Goal-scoring** — any handball by attacker immediately before a goal = no goal\n• **Shirt sleeve boundary** — the offense zone extends to the bottom of the armpit\n\nThe 'T-shirt sleeve' line was introduced to create a clearer boundary, but in practice, marginal calls still divide opinion."
            case .advanced:
                return "✋ The handball law is arguably the most revised section of the Laws of the Game. The current framework:\n\n• IFAB 2024-25 guidance emphasizes **deliberate action** over ball-to-hand incidents\n• The previous automatic 'accidental handball before goal' was softened — now there must be an 'immediate' connection\n• **Defending** players: handball in the box only penalized if deliberate or 'unnaturally bigger'\n• **Attacking** players: held to a stricter standard in the immediate build-up\n\nThe philosophical debate: should the law protect the 'spirit of the game' (no hand involvement at all) or accept that some ball-to-hand contact is inevitable at close range?"
            }
        }
        
        if q.contains("var") || q.contains("wrong call") || q.contains("bad call") || q.contains("controversy") {
            return "📺 VAR controversies are a big part of modern soccer discourse! Here's how the post-match review process works:\n\n• **During the match**: VAR checks goals, penalties, red cards, and mistaken identity\n• **After the match**: referee committees review all major decisions\n• **Consequences**: refs can be dropped from future matches, but decisions stand — they're never reversed retroactively\n\nCommon controversies:\n• ❌ Disallowed goals for marginal offside\n• ⚠️ Penalty decisions where contact is debatable\n• 🟥 Red cards deemed too harsh or too lenient\n• 📐 The 'clear and obvious error' threshold — what qualifies?\n\nI'll always update you when major calls from your followed matches get discussed post-game!"
        }
        
        return "⚽ Post-game decisions often generate as much discussion as the match itself! Referees, pundits, and fans all weigh in after controversial calls. I can help break down:\n\n• **Disallowed goals** — why they were ruled out\n• **Penalty decisions** — was it the right call?\n• **Card reviews** — too harsh or too lenient?\n• **VAR interventions** — did technology get it right?\n\nJust ask me about a specific incident and I'll explain the ruling and the debate around it!"
    }
    
    private static func rulesResponse(_ q: String, level: KnowledgeLevel) -> String {
        if q.contains("offside") || q.contains("offsides") {
            switch level {
            case .beginner:
                return "🚩 Think of it like this: when a teammate passes the ball to you, you need at least two opponents (usually the goalkeeper counts as one) between you and the goal. If you're closer to the goal than the second-to-last defender when the ball is kicked, you're offside.\n\nIt prevents players from just standing near the goal waiting for a pass. The key moment is when the ball is **played**, not when you receive it!"
            case .intermediate:
                return "🚩 Offside is judged at the moment the ball is played, not received. The key nuance is 'interfering with play' — being in an offside position alone isn't an offense. You must:\n\n• Touch the ball\n• Challenge for it\n• Interfere with an opponent\n\nHigh defensive lines use the offside trap as a tactical weapon. Teams like Man City push their line to the halfway line to compress space."
            case .advanced:
                return "🚩 The offside rule has evolved significantly with technology. Semi-automated offside uses Hawk-Eye cameras at 50fps to track 29 body points per player.\n\nTactically, the rule shapes entire systems:\n• **High line** teams (City, Arsenal) use the offside trap as an attacking weapon\n• **Deep block** teams (Atlético) make offside irrelevant\n• The 'daylight' rule proposal would add tolerance for tight margins\n\nKey edge case: deflections vs deliberate plays — a deflection does NOT reset the offside phase, but a deliberate save or clearance does."
            }
        }
        
        if q.contains("penalty") || q.contains("pen ") {
            return "⚽ A penalty kick is awarded when a foul occurs inside the penalty box (the large rectangle near the goal). The ball is placed on the penalty spot (12 yards/11 meters from goal) and only the kicker and goalkeeper are involved.\n\nKey rules:\n• Goalkeeper must stay on the goal line until the kick\n• The kicker must kick forward\n• Other players must be outside the box until the kick\n• If the keeper comes off the line early, the penalty can be retaken (VAR now checks this!)"
        }
        
        if q.contains("var") || q.contains("video") {
            return "📺 VAR (Video Assistant Referee) is soccer's video review system. It checks four types of decisions:\n\n1. **Goals** — was there an offside, foul, or handball in the build-up?\n2. **Penalties** — should one be awarded or was it wrongly given?\n3. **Direct red cards** — did the ref miss a violent act or get it wrong?\n4. **Mistaken identity** — did the ref punish the wrong player?\n\nThe on-field ref can go to the pitchside monitor for a 'Recommended Review', or the VAR can confirm/overturn directly for factual decisions like offside."
        }
        
        if q.contains("red card") || q.contains("yellow card") || q.contains("booking") {
            return "🟨🟥 Cards are the referee's disciplinary tools:\n\n**Yellow card (caution):**\n• Persistent fouling, time-wasting, dissent\n• Two yellows = automatic red\n• Accumulate across matches (5 yellows = 1-match ban in most leagues)\n\n**Red card (sending off):**\n• Violent conduct, serious foul play, denying a clear goal-scoring opportunity\n• Player must leave immediately, team plays with 10 men\n• Usually a 1-3 match suspension depending on severity"
        }
        
        return "📋 Soccer's rules (officially called the 'Laws of the Game') are maintained by IFAB (International Football Association Board). There are 17 laws covering everything from the field dimensions to how throw-ins work.\n\nAsk me about any specific rule — offside, penalties, cards, VAR, fouls, advantage rule, or anything else!"
    }
    
    private static func tacticsResponse(_ q: String, level: KnowledgeLevel) -> String {
        if q.contains("false nine") || q.contains("false 9") {
            switch level {
            case .beginner:
                return "🎯 Normally, a striker (the #9) stays high up near the goal. A 'false nine' drops back into midfield instead. This confuses defenders because they don't know whether to follow or stay put.\n\nIf they follow → space opens behind them for other attackers\nIf they stay → the false nine has time to turn and create plays\n\nMessi at Barcelona was the most famous false nine!"
            case .intermediate:
                return "🎯 The false nine drops deep to receive in the half-space between defense and midfield, creating a dilemma for centre-backs. Classic examples: Messi (Barca 2009-12), Firmino (Liverpool), and modern practitioners like Griezmann.\n\nIt works best with wide players who can exploit the space in behind, and late-arriving midfielders who can fill the box."
            case .advanced:
                return "🎯 The false nine disrupts the opponent's defensive reference points. Modern evolution:\n\n• **Classic** (Guardiola's 2009 Barca): Messi vacating for Eto'o/Henry to cut inside\n• **Modern** (City 2023): fluid rotation where the 'false nine' role passes between Grealish, Foden, and De Bruyne\n• **Hybrid** (Arsenal): Havertz as a false nine who transitions into a traditional #9 in the final third\n\nThe counter-tactic: a screening midfielder who tracks the dropping striker rather than leaving it to centre-backs."
            }
        }
        
        if q.contains("formation") {
            return "📐 A formation describes the team shape using numbers from defense to attack (excluding the keeper).\n\nPopular formations:\n• **4-3-3** — balanced, used by Barcelona, Liverpool\n• **4-2-3-1** — strong midfield control\n• **3-5-2** — wing-backs provide width\n• **4-4-2** — classic, simple, still effective\n\nBut formations are fluid — a 4-3-3 in possession might become a 4-4-2 or 4-5-1 when defending. The numbers are just a starting shape!"
        }
        
        if q.contains("pressing") || q.contains("gegenpressing") {
            return "⚡ Pressing is when a team actively chases the ball instead of falling back to defend.\n\n• **High press**: win the ball near the opponent's goal (Klopp's 'gegenpressing')\n• **Mid-block**: compact shape in the middle third, press triggers when ball enters zones\n• **Low block**: sit deep, absorb pressure, hit on the counter (Mourinho, Simeone)\n\nGegenpress (counter-pressing) specifically means pressing immediately after losing the ball — within 5 seconds — before the opponent can organize."
        }
        
        return "⚽ Tactics are what make soccer endlessly fascinating! From formations to pressing triggers to set-piece routines, there's a whole chess match happening. Ask me about specific concepts like the false nine, gegenpressing, inverted full-backs, or any system you're curious about!"
    }
    
    private static func competitionsResponse(_ q: String, level: KnowledgeLevel) -> String {
        if q.contains("champions league") || q.contains("ucl") {
            return "🏆 The UEFA Champions League is the biggest club competition in world soccer.\n\n**How it works (new format from 2024-25):**\n• 36 teams in a single league phase (each plays 8 matches)\n• Top 8 advance directly to Round of 16\n• Teams ranked 9-24 play a knockout playoff\n• Then standard knockout: R16 → QF → SF → Final\n\n**Most wins**: Real Madrid (15), AC Milan (7), Liverpool & Bayern (6 each)\n\nWinning it is considered the absolute pinnacle of club soccer!"
        }
        
        if q.contains("premier league") {
            return "🏴󠁧󠁢󠁥󠁮󠁧󠁿 The Premier League is the top tier of English soccer and the most-watched league in the world.\n\n• **20 teams** play 38 matches each (home & away vs every other team)\n• Bottom 3 are **relegated** to the Championship\n• Top 4 qualify for the Champions League\n• 5th/6th get Europa League/Conference League spots\n\n**Most titles**: Manchester United (13), Manchester City (9), Chelsea (5), Arsenal (3)"
        }
        
        return "🏆 European soccer has a rich competition structure! The big 5 leagues are:\n\n1. 🏴󠁧󠁢󠁥󠁮󠁧󠁿 **Premier League** (England)\n2. 🇪🇸 **La Liga** (Spain)\n3. 🇮🇹 **Serie A** (Italy)\n4. 🇩🇪 **Bundesliga** (Germany)\n5. 🇫🇷 **Ligue 1** (France)\n\nPlus continental competitions like the Champions League, Europa League, and Conference League. Ask about any specific competition!"
    }
    
    private static func transfersResponse(_ q: String, level: KnowledgeLevel) -> String {
        return "💰 Transfers happen during specific windows (summer: June-August, winter: January).\n\n**How it works:**\n• Club A pays a **transfer fee** to Club B for the player's contract\n• The player then negotiates **personal terms** (salary, bonuses, length)\n• **Free agents**: players whose contracts expired — no fee, but often higher wages\n• **Loans**: temporary moves, sometimes with an option/obligation to buy\n\n**Record fees:**\n• Neymar to PSG (2017): €222M\n• Mbappé to Real Madrid (2024): Free agent (but huge signing bonus)\n\nThe market keeps inflating — what was a record fee 5 years ago is now mid-range!"
    }
    
    private static func historyResponse(_ q: String, level: KnowledgeLevel) -> String {
        if q.contains("rivalry") || q.contains("derby") || q.contains("clasico") || q.contains("clásico") {
            return "🔥 Soccer rivalries run incredibly deep — they're about identity, culture, and history!\n\n**Biggest rivalries:**\n• ⚔️ **El Clásico** (Real Madrid vs Barcelona) — Spanish politics and identity\n• 🔴 **North London Derby** (Arsenal vs Tottenham) — local bragging rights\n• 🇮🇹 **Derby della Madonnina** (AC Milan vs Inter) — same city, opposite identities\n• 🇩🇪 **Der Klassiker** (Bayern vs Dortmund) — Germany's biggest clash\n• 🏴󠁧󠁢󠁥󠁮󠁧󠁿 **Manchester Derby** (City vs United) — old money vs new\n\nDerby days are the matches every fan circles on the calendar!"
        }
        
        return "📚 Soccer has over 150 years of incredible history, from its codification in England in 1863 to the global phenomenon it is today. Ask me about specific eras, legendary matches, historical rivalries, or how the sport evolved!"
    }
    
    private static func playersResponse(_ q: String, level: KnowledgeLevel) -> String {
        if q.contains("messi") {
            return "🐐 Lionel Messi — widely considered the greatest soccer player of all time.\n\n• 8x Ballon d'Or winner\n• 2022 World Cup champion with Argentina\n• 672 goals for Barcelona (all-time club record)\n• Spent 2023-present at Inter Miami (MLS)\n\nHis dribbling, vision, and ability to decide matches at the highest level for nearly two decades is unprecedented."
        }
        
        if q.contains("haaland") {
            return "⚡ Erling Haaland — the most prolific striker in modern soccer.\n\n• Scored 36 Premier League goals in his debut season (2022-23) — a record\n• Won the Treble with Manchester City in 2023\n• Norwegian international, son of former player Alfie Haaland\n• Known for his extraordinary pace, power, and clinical finishing\n\nAt his current trajectory, he could break virtually every scoring record in the game."
        }
        
        return "⚽ Soccer has produced incredible players across every era! From Pelé and Maradona to Messi and Ronaldo, from Zidane to Haaland. Ask me about any player — current or historical — and I'll give you the full breakdown!"
    }
    
    private static func defaultResponse(level: KnowledgeLevel) -> String {
        let responses = [
            "Great question! I'm Freddy, your soccer expert 🎙️ I can help with rules, tactics, match calls, player info, transfers, and more. What are you curious about?",
            "I'm all ears! Whether it's a controversial call from last night's match, a tactical concept, or the history of the game — ask away and I'll break it down for your level.",
            "Soccer is endlessly fascinating! I can explain rules, break down tactics, discuss post-game controversies, or chat about players and transfers. What's on your mind?",
            "Hey there! I'm Freddy — think of me as your sports-savvy friend who actually knows the rules 😄 Ask me anything about the beautiful game!"
        ]
        return responses.randomElement()!
    }
    
    // MARK: - Suggested Questions
    
    static let suggestedQuestions: [SuggestedQuestion] = [
        SuggestedQuestion(text: "Why was that goal disallowed?", icon: "xmark.circle.fill", category: "Post-Game"),
        SuggestedQuestion(text: "What is the offside rule?", icon: "flag.fill", category: "Rules"),
        SuggestedQuestion(text: "Explain the handball rule", icon: "hand.raised.fill", category: "Rules"),
        SuggestedQuestion(text: "What does a false nine do?", icon: "person.fill.questionmark", category: "Tactics"),
        SuggestedQuestion(text: "How does the Champions League work?", icon: "trophy.fill", category: "Competitions"),
        SuggestedQuestion(text: "What is VAR and how does it work?", icon: "tv.fill", category: "Rules"),
        SuggestedQuestion(text: "What makes El Clásico special?", icon: "flame.fill", category: "History"),
        SuggestedQuestion(text: "How do transfers work?", icon: "arrow.left.arrow.right", category: "Transfers"),
        SuggestedQuestion(text: "Tell me about Erling Haaland", icon: "bolt.fill", category: "Players"),
        SuggestedQuestion(text: "What is gegenpressing?", icon: "sportscourt.fill", category: "Tactics"),
    ]
    
    // MARK: - Post-Game Alerts (simulated recent calls)
    
    static let recentPostGameAlerts: [PostGameAlert] = [
        PostGameAlert(
            matchDescription: "Arsenal vs Manchester United",
            callType: .disallowedGoal,
            headline: "Saka goal ruled out for offside",
            detail: "Bukayo Saka's 67th-minute equalizer was disallowed after VAR found Martin Ødegaard was marginally offside in the build-up. The semi-automated offside technology showed Ødegaard's shoulder was 1.2cm past the last defender when the pass was played. Arsenal went on to lose 1-0.",
            timestamp: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!
        ),
        PostGameAlert(
            matchDescription: "Barcelona vs Real Madrid",
            callType: .varControversy,
            headline: "Penalty controversy in El Clásico stoppage time",
            detail: "A 92nd-minute penalty was awarded to Real Madrid after Araújo appeared to clip Vinícius Jr in the box. Replays showed minimal contact and Barcelona argued Vinícius was already going down. The referee did not go to the monitor. Real Madrid converted to win 2-1.",
            timestamp: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!
        ),
        PostGameAlert(
            matchDescription: "Bayern Munich vs Borussia Dortmund",
            callType: .redCardRescinded,
            headline: "Musiala red card overturned post-match",
            detail: "Jamal Musiala's 55th-minute red card for a tackle on Schlotterbeck has been rescinded after DFB review determined it was a yellow card offense. Musiala will be available for Bayern's next match.",
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        ),
    ]
}
