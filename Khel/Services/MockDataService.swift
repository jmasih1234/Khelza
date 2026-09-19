import Foundation

struct MockDataService {
    
    // MARK: - Leagues
    
    static let leagues: [League] = [premierLeague, laLiga, serieA, bundesliga, ligue1]
    
    static let premierLeague = League(
        id: "premier-league", name: "Premier League", country: "England",
        flagEmoji: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", primaryColorHex: "3D195B",
        clubs: [
            Club(id: "arsenal", name: "Arsenal", shortName: "ARS", leagueID: "premier-league",
                 primaryColorHex: "EF0107", secondaryColorHex: "FFFFFF", stadium: "Emirates Stadium",
                 founded: 1886, city: "London", players: [
                    Player(id: "saka", name: "Bukayo Saka", position: .forward, nationality: "England", clubID: "arsenal", shirtNumber: 7),
                    Player(id: "odegaard", name: "Martin Ødegaard", position: .midfielder, nationality: "Norway", clubID: "arsenal", shirtNumber: 8),
                    Player(id: "saliba", name: "William Saliba", position: .defender, nationality: "France", clubID: "arsenal", shirtNumber: 2),
                    Player(id: "rice", name: "Declan Rice", position: .midfielder, nationality: "England", clubID: "arsenal", shirtNumber: 41),
                 ]),
            Club(id: "man-city", name: "Manchester City", shortName: "MCI", leagueID: "premier-league",
                 primaryColorHex: "6CABDD", secondaryColorHex: "1C2C5B", stadium: "Etihad Stadium",
                 founded: 1880, city: "Manchester", players: [
                    Player(id: "haaland", name: "Erling Haaland", position: .forward, nationality: "Norway", clubID: "man-city", shirtNumber: 9),
                    Player(id: "debruyne", name: "Kevin De Bruyne", position: .midfielder, nationality: "Belgium", clubID: "man-city", shirtNumber: 17),
                    Player(id: "rodri", name: "Rodri", position: .midfielder, nationality: "Spain", clubID: "man-city", shirtNumber: 16),
                    Player(id: "foden", name: "Phil Foden", position: .forward, nationality: "England", clubID: "man-city", shirtNumber: 47),
                 ]),
            Club(id: "liverpool", name: "Liverpool", shortName: "LIV", leagueID: "premier-league",
                 primaryColorHex: "C8102E", secondaryColorHex: "00B2A9", stadium: "Anfield",
                 founded: 1892, city: "Liverpool", players: [
                    Player(id: "salah", name: "Mohamed Salah", position: .forward, nationality: "Egypt", clubID: "liverpool", shirtNumber: 11),
                    Player(id: "virgil", name: "Virgil van Dijk", position: .defender, nationality: "Netherlands", clubID: "liverpool", shirtNumber: 4),
                    Player(id: "mac-allister", name: "Alexis Mac Allister", position: .midfielder, nationality: "Argentina", clubID: "liverpool", shirtNumber: 10),
                    Player(id: "diaz", name: "Luis Díaz", position: .forward, nationality: "Colombia", clubID: "liverpool", shirtNumber: 7),
                 ]),
            Club(id: "chelsea", name: "Chelsea", shortName: "CHE", leagueID: "premier-league",
                 primaryColorHex: "034694", secondaryColorHex: "DBA111", stadium: "Stamford Bridge",
                 founded: 1905, city: "London", players: [
                    Player(id: "palmer", name: "Cole Palmer", position: .forward, nationality: "England", clubID: "chelsea", shirtNumber: 20),
                    Player(id: "caicedo", name: "Moisés Caicedo", position: .midfielder, nationality: "Ecuador", clubID: "chelsea", shirtNumber: 25),
                    Player(id: "jackson", name: "Nicolas Jackson", position: .forward, nationality: "Senegal", clubID: "chelsea", shirtNumber: 15),
                 ]),
            Club(id: "man-utd", name: "Manchester United", shortName: "MUN", leagueID: "premier-league",
                 primaryColorHex: "DA291C", secondaryColorHex: "FBE122", stadium: "Old Trafford",
                 founded: 1878, city: "Manchester", players: [
                    Player(id: "bruno", name: "Bruno Fernandes", position: .midfielder, nationality: "Portugal", clubID: "man-utd", shirtNumber: 8),
                    Player(id: "rashford", name: "Marcus Rashford", position: .forward, nationality: "England", clubID: "man-utd", shirtNumber: 10),
                    Player(id: "mainoo", name: "Kobbie Mainoo", position: .midfielder, nationality: "England", clubID: "man-utd", shirtNumber: 37),
                 ]),
            Club(id: "tottenham", name: "Tottenham Hotspur", shortName: "TOT", leagueID: "premier-league",
                 primaryColorHex: "132257", secondaryColorHex: "FFFFFF", stadium: "Tottenham Hotspur Stadium",
                 founded: 1882, city: "London", players: [
                    Player(id: "son", name: "Son Heung-min", position: .forward, nationality: "South Korea", clubID: "tottenham", shirtNumber: 7),
                    Player(id: "maddison", name: "James Maddison", position: .midfielder, nationality: "England", clubID: "tottenham", shirtNumber: 10),
                    Player(id: "romero", name: "Cristian Romero", position: .defender, nationality: "Argentina", clubID: "tottenham", shirtNumber: 17),
                 ]),
            Club(id: "newcastle", name: "Newcastle United", shortName: "NEW", leagueID: "premier-league",
                 primaryColorHex: "241F20", secondaryColorHex: "FFFFFF", stadium: "St. James' Park",
                 founded: 1892, city: "Newcastle", players: [
                    Player(id: "isak", name: "Alexander Isak", position: .forward, nationality: "Sweden", clubID: "newcastle", shirtNumber: 14),
                    Player(id: "gordon", name: "Anthony Gordon", position: .forward, nationality: "England", clubID: "newcastle", shirtNumber: 10),
                    Player(id: "guimaraes", name: "Bruno Guimarães", position: .midfielder, nationality: "Brazil", clubID: "newcastle", shirtNumber: 39),
                 ]),
            Club(id: "aston-villa", name: "Aston Villa", shortName: "AVL", leagueID: "premier-league",
                 primaryColorHex: "670E36", secondaryColorHex: "95BFE5", stadium: "Villa Park",
                 founded: 1874, city: "Birmingham", players: [
                    Player(id: "watkins", name: "Ollie Watkins", position: .forward, nationality: "England", clubID: "aston-villa", shirtNumber: 11),
                    Player(id: "martinez-emi", name: "Emiliano Martínez", position: .goalkeeper, nationality: "Argentina", clubID: "aston-villa", shirtNumber: 1),
                 ]),
            Club(id: "brighton", name: "Brighton & Hove Albion", shortName: "BHA", leagueID: "premier-league",
                 primaryColorHex: "0057B8", secondaryColorHex: "FFFFFF", stadium: "Amex Stadium",
                 founded: 1901, city: "Brighton", players: [
                    Player(id: "mitoma", name: "Kaoru Mitoma", position: .forward, nationality: "Japan", clubID: "brighton", shirtNumber: 22),
                 ]),
            Club(id: "west-ham", name: "West Ham United", shortName: "WHU", leagueID: "premier-league",
                 primaryColorHex: "7A263A", secondaryColorHex: "1BB1E7", stadium: "London Stadium",
                 founded: 1895, city: "London", players: [
                    Player(id: "paqueta", name: "Lucas Paquetá", position: .midfielder, nationality: "Brazil", clubID: "west-ham", shirtNumber: 11),
                 ]),
        ]
    )
    
    static let laLiga = League(
        id: "la-liga", name: "La Liga", country: "Spain",
        flagEmoji: "🇪🇸", primaryColorHex: "EE8707",
        clubs: [
            Club(id: "real-madrid", name: "Real Madrid", shortName: "RMA", leagueID: "la-liga",
                 primaryColorHex: "FFFFFF", secondaryColorHex: "FEBE10", stadium: "Santiago Bernabéu",
                 founded: 1902, city: "Madrid", players: [
                    Player(id: "vinicius", name: "Vinícius Júnior", position: .forward, nationality: "Brazil", clubID: "real-madrid", shirtNumber: 7),
                    Player(id: "bellingham", name: "Jude Bellingham", position: .midfielder, nationality: "England", clubID: "real-madrid", shirtNumber: 5),
                    Player(id: "mbappe", name: "Kylian Mbappé", position: .forward, nationality: "France", clubID: "real-madrid", shirtNumber: 9),
                    Player(id: "valverde", name: "Federico Valverde", position: .midfielder, nationality: "Uruguay", clubID: "real-madrid", shirtNumber: 8),
                 ]),
            Club(id: "barcelona", name: "FC Barcelona", shortName: "BAR", leagueID: "la-liga",
                 primaryColorHex: "A50044", secondaryColorHex: "004D98", stadium: "Spotify Camp Nou",
                 founded: 1899, city: "Barcelona", players: [
                    Player(id: "yamal", name: "Lamine Yamal", position: .forward, nationality: "Spain", clubID: "barcelona", shirtNumber: 19),
                    Player(id: "pedri", name: "Pedri", position: .midfielder, nationality: "Spain", clubID: "barcelona", shirtNumber: 8),
                    Player(id: "raphinha", name: "Raphinha", position: .forward, nationality: "Brazil", clubID: "barcelona", shirtNumber: 11),
                    Player(id: "gavi", name: "Gavi", position: .midfielder, nationality: "Spain", clubID: "barcelona", shirtNumber: 6),
                 ]),
            Club(id: "atletico-madrid", name: "Atlético Madrid", shortName: "ATM", leagueID: "la-liga",
                 primaryColorHex: "272E61", secondaryColorHex: "CE1126", stadium: "Metropolitano",
                 founded: 1903, city: "Madrid", players: [
                    Player(id: "griezmann", name: "Antoine Griezmann", position: .forward, nationality: "France", clubID: "atletico-madrid", shirtNumber: 7),
                    Player(id: "alvarez", name: "Julián Álvarez", position: .forward, nationality: "Argentina", clubID: "atletico-madrid", shirtNumber: 19),
                 ]),
            Club(id: "real-sociedad", name: "Real Sociedad", shortName: "RSO", leagueID: "la-liga",
                 primaryColorHex: "0067B1", secondaryColorHex: "FFFFFF", stadium: "Reale Arena",
                 founded: 1909, city: "San Sebastián", players: [
                    Player(id: "oyarzabal", name: "Mikel Oyarzabal", position: .forward, nationality: "Spain", clubID: "real-sociedad", shirtNumber: 10),
                 ]),
            Club(id: "athletic-bilbao", name: "Athletic Bilbao", shortName: "ATH", leagueID: "la-liga",
                 primaryColorHex: "EE2523", secondaryColorHex: "FFFFFF", stadium: "San Mamés",
                 founded: 1898, city: "Bilbao", players: [
                    Player(id: "n-williams", name: "Nico Williams", position: .forward, nationality: "Spain", clubID: "athletic-bilbao", shirtNumber: 11),
                 ]),
            Club(id: "villarreal", name: "Villarreal CF", shortName: "VIL", leagueID: "la-liga",
                 primaryColorHex: "FFE114", secondaryColorHex: "005DAA", stadium: "Estadio de la Cerámica",
                 founded: 1923, city: "Villarreal", players: [
                    Player(id: "sorloth", name: "Alexander Sørloth", position: .forward, nationality: "Norway", clubID: "villarreal", shirtNumber: 9),
                 ]),
            Club(id: "real-betis", name: "Real Betis", shortName: "BET", leagueID: "la-liga",
                 primaryColorHex: "00954C", secondaryColorHex: "FFFFFF", stadium: "Benito Villamarín",
                 founded: 1907, city: "Seville", players: [
                    Player(id: "isco", name: "Isco", position: .midfielder, nationality: "Spain", clubID: "real-betis", shirtNumber: 22),
                 ]),
            Club(id: "sevilla", name: "Sevilla FC", shortName: "SEV", leagueID: "la-liga",
                 primaryColorHex: "D71920", secondaryColorHex: "FFFFFF", stadium: "Ramón Sánchez Pizjuán",
                 founded: 1890, city: "Seville", players: [
                    Player(id: "lukebakio", name: "Dodi Lukébakio", position: .forward, nationality: "Belgium", clubID: "sevilla", shirtNumber: 28),
                 ]),
        ]
    )
    
    static let serieA = League(
        id: "serie-a", name: "Serie A", country: "Italy",
        flagEmoji: "🇮🇹", primaryColorHex: "008FD7",
        clubs: [
            Club(id: "inter-milan", name: "Inter Milan", shortName: "INT", leagueID: "serie-a",
                 primaryColorHex: "009FE3", secondaryColorHex: "010101", stadium: "San Siro",
                 founded: 1908, city: "Milan", players: [
                    Player(id: "lautaro", name: "Lautaro Martínez", position: .forward, nationality: "Argentina", clubID: "inter-milan", shirtNumber: 10),
                    Player(id: "barella", name: "Nicolò Barella", position: .midfielder, nationality: "Italy", clubID: "inter-milan", shirtNumber: 23),
                    Player(id: "thuram", name: "Marcus Thuram", position: .forward, nationality: "France", clubID: "inter-milan", shirtNumber: 9),
                 ]),
            Club(id: "ac-milan", name: "AC Milan", shortName: "ACM", leagueID: "serie-a",
                 primaryColorHex: "FB090B", secondaryColorHex: "000000", stadium: "San Siro",
                 founded: 1899, city: "Milan", players: [
                    Player(id: "leao", name: "Rafael Leão", position: .forward, nationality: "Portugal", clubID: "ac-milan", shirtNumber: 10),
                    Player(id: "pulisic", name: "Christian Pulisic", position: .forward, nationality: "USA", clubID: "ac-milan", shirtNumber: 11),
                 ]),
            Club(id: "juventus", name: "Juventus", shortName: "JUV", leagueID: "serie-a",
                 primaryColorHex: "000000", secondaryColorHex: "FFFFFF", stadium: "Allianz Stadium",
                 founded: 1897, city: "Turin", players: [
                    Player(id: "vlahovic", name: "Dušan Vlahović", position: .forward, nationality: "Serbia", clubID: "juventus", shirtNumber: 9),
                    Player(id: "chiesa", name: "Federico Chiesa", position: .forward, nationality: "Italy", clubID: "juventus", shirtNumber: 7),
                 ]),
            Club(id: "napoli", name: "SSC Napoli", shortName: "NAP", leagueID: "serie-a",
                 primaryColorHex: "12A0D7", secondaryColorHex: "FFFFFF", stadium: "Stadio Diego Armando Maradona",
                 founded: 1926, city: "Naples", players: [
                    Player(id: "osimhen", name: "Victor Osimhen", position: .forward, nationality: "Nigeria", clubID: "napoli", shirtNumber: 9),
                    Player(id: "kvara", name: "Khvicha Kvaratskhelia", position: .forward, nationality: "Georgia", clubID: "napoli", shirtNumber: 77),
                 ]),
            Club(id: "atalanta", name: "Atalanta BC", shortName: "ATA", leagueID: "serie-a",
                 primaryColorHex: "1E71B8", secondaryColorHex: "000000", stadium: "Gewiss Stadium",
                 founded: 1907, city: "Bergamo", players: [
                    Player(id: "lookman", name: "Ademola Lookman", position: .forward, nationality: "Nigeria", clubID: "atalanta", shirtNumber: 11),
                 ]),
            Club(id: "roma", name: "AS Roma", shortName: "ROM", leagueID: "serie-a",
                 primaryColorHex: "8E1F2F", secondaryColorHex: "F0BC42", stadium: "Stadio Olimpico",
                 founded: 1927, city: "Rome", players: [
                    Player(id: "dybala", name: "Paulo Dybala", position: .forward, nationality: "Argentina", clubID: "roma", shirtNumber: 21),
                 ]),
            Club(id: "lazio", name: "SS Lazio", shortName: "LAZ", leagueID: "serie-a",
                 primaryColorHex: "87D8F7", secondaryColorHex: "FFFFFF", stadium: "Stadio Olimpico",
                 founded: 1900, city: "Rome", players: [
                    Player(id: "immobile", name: "Ciro Immobile", position: .forward, nationality: "Italy", clubID: "lazio", shirtNumber: 17),
                 ]),
        ]
    )
    
    static let bundesliga = League(
        id: "bundesliga", name: "Bundesliga", country: "Germany",
        flagEmoji: "🇩🇪", primaryColorHex: "D20515",
        clubs: [
            Club(id: "bayern", name: "Bayern Munich", shortName: "BAY", leagueID: "bundesliga",
                 primaryColorHex: "DC052D", secondaryColorHex: "0066B2", stadium: "Allianz Arena",
                 founded: 1900, city: "Munich", players: [
                    Player(id: "kane", name: "Harry Kane", position: .forward, nationality: "England", clubID: "bayern", shirtNumber: 9),
                    Player(id: "musiala", name: "Jamal Musiala", position: .midfielder, nationality: "Germany", clubID: "bayern", shirtNumber: 42),
                    Player(id: "sane", name: "Leroy Sané", position: .forward, nationality: "Germany", clubID: "bayern", shirtNumber: 10),
                    Player(id: "kimmich", name: "Joshua Kimmich", position: .midfielder, nationality: "Germany", clubID: "bayern", shirtNumber: 6),
                 ]),
            Club(id: "dortmund", name: "Borussia Dortmund", shortName: "BVB", leagueID: "bundesliga",
                 primaryColorHex: "FDE100", secondaryColorHex: "000000", stadium: "Signal Iduna Park",
                 founded: 1909, city: "Dortmund", players: [
                    Player(id: "brandt", name: "Julian Brandt", position: .midfielder, nationality: "Germany", clubID: "dortmund", shirtNumber: 10),
                    Player(id: "adeyemi", name: "Karim Adeyemi", position: .forward, nationality: "Germany", clubID: "dortmund", shirtNumber: 27),
                 ]),
            Club(id: "rb-leipzig", name: "RB Leipzig", shortName: "RBL", leagueID: "bundesliga",
                 primaryColorHex: "DD0741", secondaryColorHex: "001F47", stadium: "Red Bull Arena",
                 founded: 2009, city: "Leipzig", players: [
                    Player(id: "xavi-simons", name: "Xavi Simons", position: .forward, nationality: "Netherlands", clubID: "rb-leipzig", shirtNumber: 7),
                    Player(id: "openda", name: "Loïs Openda", position: .forward, nationality: "Belgium", clubID: "rb-leipzig", shirtNumber: 17),
                 ]),
            Club(id: "leverkusen", name: "Bayer Leverkusen", shortName: "B04", leagueID: "bundesliga",
                 primaryColorHex: "E32221", secondaryColorHex: "000000", stadium: "BayArena",
                 founded: 1904, city: "Leverkusen", players: [
                    Player(id: "wirtz", name: "Florian Wirtz", position: .midfielder, nationality: "Germany", clubID: "leverkusen", shirtNumber: 10),
                    Player(id: "grimaldo", name: "Alejandro Grimaldo", position: .defender, nationality: "Spain", clubID: "leverkusen", shirtNumber: 20),
                 ]),
            Club(id: "frankfurt", name: "Eintracht Frankfurt", shortName: "SGE", leagueID: "bundesliga",
                 primaryColorHex: "000000", secondaryColorHex: "E1000F", stadium: "Deutsche Bank Park",
                 founded: 1899, city: "Frankfurt", players: [
                    Player(id: "ekitike", name: "Hugo Ekitiké", position: .forward, nationality: "France", clubID: "frankfurt", shirtNumber: 11),
                 ]),
            Club(id: "stuttgart", name: "VfB Stuttgart", shortName: "VFB", leagueID: "bundesliga",
                 primaryColorHex: "E32219", secondaryColorHex: "FFFFFF", stadium: "MHPArena",
                 founded: 1893, city: "Stuttgart", players: [
                    Player(id: "undav", name: "Deniz Undav", position: .forward, nationality: "Germany", clubID: "stuttgart", shirtNumber: 18),
                 ]),
        ]
    )
    
    static let ligue1 = League(
        id: "ligue-1", name: "Ligue 1", country: "France",
        flagEmoji: "🇫🇷", primaryColorHex: "091C3E",
        clubs: [
            Club(id: "psg", name: "Paris Saint-Germain", shortName: "PSG", leagueID: "ligue-1",
                 primaryColorHex: "004170", secondaryColorHex: "DA291C", stadium: "Parc des Princes",
                 founded: 1970, city: "Paris", players: [
                    Player(id: "dembele", name: "Ousmane Dembélé", position: .forward, nationality: "France", clubID: "psg", shirtNumber: 10),
                    Player(id: "marquinhos", name: "Marquinhos", position: .defender, nationality: "Brazil", clubID: "psg", shirtNumber: 5),
                    Player(id: "hakimi", name: "Achraf Hakimi", position: .defender, nationality: "Morocco", clubID: "psg", shirtNumber: 2),
                 ]),
            Club(id: "marseille", name: "Olympique de Marseille", shortName: "OM", leagueID: "ligue-1",
                 primaryColorHex: "2FAEE0", secondaryColorHex: "FFFFFF", stadium: "Vélodrome",
                 founded: 1899, city: "Marseille", players: [
                    Player(id: "greenwood", name: "Mason Greenwood", position: .forward, nationality: "England", clubID: "marseille", shirtNumber: 10),
                 ]),
            Club(id: "monaco", name: "AS Monaco", shortName: "MON", leagueID: "ligue-1",
                 primaryColorHex: "E7192C", secondaryColorHex: "FFFFFF", stadium: "Stade Louis II",
                 founded: 1924, city: "Monaco", players: [
                    Player(id: "embolo", name: "Breel Embolo", position: .forward, nationality: "Switzerland", clubID: "monaco", shirtNumber: 36),
                 ]),
            Club(id: "lyon", name: "Olympique Lyonnais", shortName: "OL", leagueID: "ligue-1",
                 primaryColorHex: "1B3E93", secondaryColorHex: "DA291C", stadium: "Groupama Stadium",
                 founded: 1950, city: "Lyon", players: [
                    Player(id: "lacazette", name: "Alexandre Lacazette", position: .forward, nationality: "France", clubID: "lyon", shirtNumber: 10),
                 ]),
            Club(id: "lille", name: "LOSC Lille", shortName: "LIL", leagueID: "ligue-1",
                 primaryColorHex: "DA291C", secondaryColorHex: "FFFFFF", stadium: "Stade Pierre-Mauroy",
                 founded: 1944, city: "Lille", players: [
                    Player(id: "david", name: "Jonathan David", position: .forward, nationality: "Canada", clubID: "lille", shirtNumber: 9),
                 ]),
            Club(id: "nice", name: "OGC Nice", shortName: "NIC", leagueID: "ligue-1",
                 primaryColorHex: "CE1126", secondaryColorHex: "000000", stadium: "Allianz Riviera",
                 founded: 1904, city: "Nice", players: [
                    Player(id: "laborde", name: "Gaëtan Laborde", position: .forward, nationality: "France", clubID: "nice", shirtNumber: 20),
                 ]),
        ]
    )
    
    // MARK: - All Clubs (flattened)
    
    static var allClubs: [Club] {
        leagues.flatMap(\.clubs)
    }
    
    // MARK: - All Players (flattened)
    
    static var allPlayers: [Player] {
        allClubs.flatMap(\.players)
    }
    
    // MARK: - Club/League/Player Lookup
    
    static func club(byID id: String) -> Club? {
        allClubs.first { $0.id == id }
    }
    
    static func league(byID id: String) -> League? {
        leagues.first { $0.id == id }
    }
    
    static func player(byID id: String) -> Player? {
        allPlayers.first { $0.id == id }
    }
    
    static func clubs(forLeague leagueID: String) -> [Club] {
        leagues.first { $0.id == leagueID }?.clubs ?? []
    }
    
    // MARK: - Mock Matches
    
    static func generateUpcomingMatches(for leagueIDs: [String], count: Int = 10) -> [Match] {
        var matches: [Match] = []
        let calendar = Calendar.current
        
        for leagueID in leagueIDs {
            let clubs = clubs(forLeague: leagueID)
            guard clubs.count >= 2 else { continue }
            
            for i in 0..<min(count / leagueIDs.count + 1, clubs.count / 2) {
                let homeIndex = i * 2
                let awayIndex = i * 2 + 1
                guard awayIndex < clubs.count else { break }
                
                let daysFromNow = Int.random(in: 1...14)
                let hour = [12, 14, 15, 17, 19, 20].randomElement()!
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                dateComponents.day! += daysFromNow
                dateComponents.hour = hour
                dateComponents.minute = [0, 30].randomElement()!
                let kickoff = calendar.date(from: dateComponents) ?? Date()
                
                matches.append(Match(
                    id: UUID(),
                    homeClubID: clubs[homeIndex].id,
                    awayClubID: clubs[awayIndex].id,
                    leagueID: leagueID,
                    status: .scheduled,
                    homeScore: 0,
                    awayScore: 0,
                    kickoffDate: kickoff,
                    matchDay: Int.random(in: 1...38),
                    currentMinute: 0,
                    events: [],
                    stats: .empty
                ))
            }
        }
        
        return matches.sorted { $0.kickoffDate < $1.kickoffDate }
    }
    
    static func generateLiveMatch(leagueID: String = "premier-league") -> Match {
        let clubs = clubs(forLeague: leagueID)
        let home = clubs[0]
        let away = clubs[1]
        let minute = Int.random(in: 15...75)
        let homeScore = Int.random(in: 0...3)
        let awayScore = Int.random(in: 0...2)
        
        var events: [MatchEvent] = [
            MatchEvent(
                id: UUID(), minute: 1, type: .kickoff,
                playerName: "", clubID: home.id,
                description: "Kick off! The match is underway.",
                educationalNote: "Every match begins with a kickoff from the center circle. The team that wins the coin toss gets to choose which end to attack."
            )
        ]
        
        if homeScore > 0 {
            let scorerIndex = min(0, home.players.count - 1)
            let scorer = home.players.isEmpty ? "Home Player" : home.players[scorerIndex].name
            events.append(MatchEvent(
                id: UUID(), minute: Int.random(in: 5...minute),
                type: .goal, playerName: scorer, clubID: home.id,
                description: "\(scorer) scores for \(home.name)!",
                educationalNote: "A goal is scored when the entire ball crosses the goal line between the goalposts and under the crossbar. VAR can review goals for offside, fouls, or handball in the build-up."
            ))
        }
        
        if awayScore > 0 {
            let scorerIndex = min(0, away.players.count - 1)
            let scorer = away.players.isEmpty ? "Away Player" : away.players[scorerIndex].name
            events.append(MatchEvent(
                id: UUID(), minute: Int.random(in: 5...minute),
                type: .goal, playerName: scorer, clubID: away.id,
                description: "\(scorer) scores for \(away.name)!",
                educationalNote: "Goals can come from open play, set pieces (free kicks, corners), or penalties. Each type requires different tactical awareness."
            ))
        }
        
        if minute > 30 {
            events.append(MatchEvent(
                id: UUID(), minute: Int.random(in: 20...min(minute, 44)),
                type: .yellowCard, playerName: away.players.last?.name ?? "Player",
                clubID: away.id,
                description: "Yellow card shown!",
                educationalNote: "A yellow card is a caution. Two yellow cards in the same match result in a red card and the player is sent off. Players on a yellow must be especially careful with their challenges."
            ))
        }
        
        events.sort { $0.minute < $1.minute }
        
        return Match(
            id: UUID(),
            homeClubID: home.id,
            awayClubID: away.id,
            leagueID: leagueID,
            status: minute > 45 ? .halftime : .live,
            homeScore: homeScore,
            awayScore: awayScore,
            kickoffDate: Date().addingTimeInterval(-Double(minute * 60)),
            matchDay: 12,
            currentMinute: minute,
            events: events,
            stats: MatchStats(
                possessionHome: Int.random(in: 40...65),
                possessionAway: 100 - Int.random(in: 40...65),
                shotsHome: Int.random(in: 3...12),
                shotsAway: Int.random(in: 2...10),
                shotsOnTargetHome: Int.random(in: 1...6),
                shotsOnTargetAway: Int.random(in: 0...5),
                cornersHome: Int.random(in: 1...8),
                cornersAway: Int.random(in: 0...6),
                foulsHome: Int.random(in: 3...12),
                foulsAway: Int.random(in: 3...14),
                passAccuracyHome: Int.random(in: 75...92),
                passAccuracyAway: Int.random(in: 72...90)
            )
        )
    }
    
    static func generateFinishedMatch(leagueID: String = "premier-league") -> Match {
        var match = generateLiveMatch(leagueID: leagueID)
        match.status = .finished
        match.currentMinute = 90
        match.kickoffDate = Date().addingTimeInterval(-Double(Int.random(in: 1...5) * 86400))
        
        match.events.append(MatchEvent(
            id: UUID(), minute: 45, type: .halfTime,
            playerName: "", clubID: match.homeClubID,
            description: "Half time.",
            educationalNote: "Each half is 45 minutes. The referee adds 'stoppage time' for delays. Half time is a 15-minute break where managers can make tactical adjustments."
        ))
        
        match.events.append(MatchEvent(
            id: UUID(), minute: 65, type: .substitution,
            playerName: "Substitution",
            clubID: match.homeClubID,
            description: "Tactical substitution made.",
            educationalNote: "Substitutions allow managers to bring fresh legs, change tactics, or manage injuries. Timing is key—too early can waste an option, too late may miss the impact window."
        ))
        
        match.events.append(MatchEvent(
            id: UUID(), minute: 90, type: .fullTime,
            playerName: "", clubID: match.homeClubID,
            description: "Full time!",
            educationalNote: "The match ends after 90 minutes plus stoppage time. Three points for a win, one for a draw, none for a loss."
        ))
        
        match.events.sort { $0.minute < $1.minute }
        
        return match
    }
    
    // MARK: - Simulated Live Events
    
    static func generateNextEvent(match: Match) -> MatchEvent {
        let minute = match.currentMinute + Int.random(in: 2...8)
        let isHome = Bool.random()
        let clubID = isHome ? match.homeClubID : match.awayClubID
        let club = club(byID: clubID)
        let playerName = club?.players.randomElement()?.name ?? "Player"
        
        let eventTypes: [(MatchEventType, Int)] = [
            (.goal, 15),
            (.yellowCard, 20),
            (.substitution, 25),
            (.tacticalChange, 10),
            (.varCheck, 8),
            (.penaltyAwarded, 5),
            (.injury, 7),
        ]
        
        let totalWeight = eventTypes.reduce(0) { $0 + $1.1 }
        var random = Int.random(in: 0..<totalWeight)
        var selectedType: MatchEventType = .substitution
        for (type, weight) in eventTypes {
            random -= weight
            if random < 0 {
                selectedType = type
                break
            }
        }
        
        let (description, educational) = eventDescription(type: selectedType, playerName: playerName, clubName: club?.name ?? "Team")
        
        return MatchEvent(
            id: UUID(),
            minute: min(minute, 90),
            type: selectedType,
            playerName: playerName,
            clubID: clubID,
            description: description,
            educationalNote: educational
        )
    }
    
    private static func eventDescription(type: MatchEventType, playerName: String, clubName: String) -> (String, String) {
        switch type {
        case .goal:
            return (
                "GOAL! \(playerName) scores for \(clubName)!",
                "Goals change everything in soccer. Unlike basketball or football, goals are rare—averaging about 2.7 per match in the Premier League. This scarcity is what makes each one so electrifying."
            )
        case .yellowCard:
            return (
                "Yellow card for \(playerName) (\(clubName))",
                "Yellow cards are cautions for reckless play, dissent, or tactical fouls. A 'tactical foul' is when a player deliberately fouls to stop a counter-attack—it's controversial but common in modern soccer."
            )
        case .substitution:
            return (
                "Substitution for \(clubName): \(playerName) comes off",
                "Teams can make 5 substitutions per match in most competitions. Managers must decide between bringing on fresh legs, changing tactics, or protecting players from injury. It's one of the most impactful decisions in a match."
            )
        case .tacticalChange:
            return (
                "\(clubName) changes formation",
                "Changing formation mid-match is like calling a new play in football. A switch from 4-3-3 to 3-5-2 means moving a defender forward to midfield, creating numerical superiority in the middle but potentially exposing the defense."
            )
        case .varCheck:
            return (
                "VAR reviewing a decision for \(clubName)",
                "VAR checks happen for goals, penalties, red cards, and mistaken identity. The on-field referee can be asked to review the monitor ('On Field Review') for subjective decisions, making it soccer's version of instant replay."
            )
        case .penaltyAwarded:
            return (
                "Penalty awarded to \(clubName)! Foul on \(playerName)",
                "A penalty is awarded when a foul occurs inside the 18-yard box. The conversion rate is about 75-80%. The mental battle between the penalty taker and goalkeeper is one of sport's most intense moments."
            )
        case .injury:
            return (
                "\(playerName) (\(clubName)) is receiving treatment",
                "When a player is injured, the referee can stop play. The player must leave the field before returning, and if carried off on a stretcher, can only return with the referee's permission."
            )
        default:
            return (
                "Play continues",
                "Soccer is unique among major sports for its continuous flow. Unlike football or basketball, there are no timeouts or commercial breaks during play."
            )
        }
    }
    
    // MARK: - Lesson Tracks
    
    static let lessonTracks: [LessonTrack] = [
        rulesTrack, tacticsTrack, historyTrack, playersTrack, statsTrack
    ]
    
    static let rulesTrack = LessonTrack(
        id: "rules", topic: .rules, title: "Rules of the Game",
        description: "Master the laws that govern soccer",
        lessons: [
            Lesson(id: "rules-basics", trackID: "rules", title: "The Basics",
                   subtitle: "Field, players, and match structure", estimatedMinutes: 5, xpReward: 25,
                   cards: [
                    LessonCard(id: UUID(), title: "The Pitch", content: "A soccer field (called a 'pitch') is 100-110 meters long and 64-75 meters wide. The center circle, penalty areas, and goal areas are marked with white lines. Each end has a goal that is 7.32 meters wide and 2.44 meters tall.", highlightFact: "The penalty spot is exactly 12 yards (11 meters) from the goal line!", iconName: "sportscourt"),
                    LessonCard(id: UUID(), title: "The Teams", content: "Each team has 11 players on the pitch: 1 goalkeeper and 10 outfield players. The goalkeeper is the only player allowed to use their hands, and only inside the penalty area. Teams can have up to 7-9 substitutes on the bench depending on the competition.", highlightFact: "If a team has fewer than 7 players, the match cannot continue.", iconName: "person.3.fill"),
                    LessonCard(id: UUID(), title: "Match Duration", content: "A standard match has two 45-minute halves with a 15-minute half-time break. The referee adds 'stoppage time' (also called 'injury time' or 'added time') at the end of each half to account for delays like injuries, substitutions, and time-wasting.", highlightFact: "In the 2022 World Cup, some matches had over 10 minutes of added time!", iconName: "clock"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "How many players does each team have on the pitch?", options: ["9", "10", "11", "12"], correctIndex: 2, explanation: "Each team plays with 11 players—1 goalkeeper and 10 outfield players.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "How long is a standard match?", options: ["60 minutes", "80 minutes", "90 minutes", "120 minutes"], correctIndex: 2, explanation: "A match is 90 minutes: two halves of 45 minutes each, plus stoppage time.", xpValue: 10),
                   ],
                   difficulty: .beginner, relatedLeagueIDs: [], relatedClubIDs: []),
            
            Lesson(id: "rules-offside", trackID: "rules", title: "The Offside Rule",
                   subtitle: "Soccer's most debated law", estimatedMinutes: 7, xpReward: 30,
                   cards: [
                    LessonCard(id: UUID(), title: "What is Offside?", content: "A player is in an offside position if they are closer to the opponent's goal line than both the ball AND the second-to-last defender when the ball is played to them. Being offside isn't an offense by itself—the player must also be involved in active play.", highlightFact: "The goalkeeper counts as one of the two defenders, so usually offside is judged against the last outfield defender.", iconName: "figure.run"),
                    LessonCard(id: UUID(), title: "When is it NOT Offside?", content: "You cannot be offside from a goal kick, throw-in, or corner kick. You also can't be offside if you're in your own half. The rule is designed to prevent 'goal-hanging'—standing near the opponent's goal waiting for a long pass.", highlightFact: "VAR now uses semi-automated offside technology with cameras and AI to make millimeter-precise decisions.", iconName: "checkmark.circle"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "Can you be offside from a corner kick?", options: ["Yes", "No", "Only in the box", "Only in extra time"], correctIndex: 1, explanation: "You cannot be offside directly from a corner kick, goal kick, or throw-in.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "Who determines the offside line?", options: ["The goalkeeper", "The last defender", "The second-to-last defender", "The halfway line"], correctIndex: 2, explanation: "Offside is judged relative to the second-to-last defender (which usually includes the goalkeeper).", xpValue: 10),
                   ],
                   difficulty: .beginner, relatedLeagueIDs: [], relatedClubIDs: []),
            
            Lesson(id: "rules-fouls", trackID: "rules", title: "Fouls & Free Kicks",
                   subtitle: "What you can and can't do", estimatedMinutes: 6, xpReward: 25,
                   cards: [
                    LessonCard(id: UUID(), title: "Direct Free Kicks", content: "A direct free kick is awarded for physical fouls: kicking, tripping, pushing, charging, striking, or tackling an opponent. From a direct free kick, a goal can be scored directly without another player touching the ball.", highlightFact: "Professional players can bend free kicks at speeds over 80 mph with incredible precision!", iconName: "arrow.up.right"),
                    LessonCard(id: UUID(), title: "Indirect Free Kicks", content: "An indirect free kick is awarded for non-contact offenses: offside, obstruction, dangerous play, or goalkeeper handling errors. The ball must touch another player before a goal can be scored.", highlightFact: "The referee signals an indirect free kick by raising their arm above their head.", iconName: "hand.raised"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "Can you score directly from an indirect free kick?", options: ["Yes", "No", "Only from outside the box", "Only the captain can"], correctIndex: 1, explanation: "An indirect free kick must touch another player before entering the goal. If kicked directly in, the opposing team gets a goal kick.", xpValue: 10),
                   ],
                   difficulty: .beginner, relatedLeagueIDs: [], relatedClubIDs: []),
        ],
        difficulty: .beginner
    )
    
    static let tacticsTrack = LessonTrack(
        id: "tactics", topic: .tactics, title: "Tactics & Strategy",
        description: "Understand how teams play and why",
        lessons: [
            Lesson(id: "tactics-formations", trackID: "tactics", title: "Formations 101",
                   subtitle: "How teams organize on the pitch", estimatedMinutes: 8, xpReward: 30,
                   cards: [
                    LessonCard(id: UUID(), title: "What is a Formation?", content: "A formation describes how a team's outfield players are arranged on the pitch, expressed as numbers from defense to attack. For example, 4-3-3 means 4 defenders, 3 midfielders, and 3 forwards. The goalkeeper is never included in the formation number.", highlightFact: "The formation doesn't dictate exactly where players stand—it's more of a general shape that shifts during the match.", iconName: "sportscourt"),
                    LessonCard(id: UUID(), title: "Popular Formations", content: "• 4-3-3: Balanced with width in attack. Used by Barcelona, Liverpool.\n• 4-4-2: Classic and solid. Two strikers provide a focal point.\n• 3-5-2: Extra midfielder for control, wing-backs provide width.\n• 4-2-3-1: Defensive stability with a creative #10 behind the striker.", highlightFact: "Pep Guardiola's Manchester City often morphs between 4-3-3, 3-2-4-1, and even 2-3-5 during a single match!", iconName: "rectangle.3.group"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "In a 4-3-3 formation, how many forwards are there?", options: ["2", "3", "4", "1"], correctIndex: 1, explanation: "4-3-3 means 4 defenders, 3 midfielders, and 3 forwards.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "Is the goalkeeper included in the formation number?", options: ["Yes", "No", "Sometimes", "Only in defensive formations"], correctIndex: 1, explanation: "The goalkeeper is never included. '4-3-3' accounts for 10 outfield players plus the goalkeeper = 11 total.", xpValue: 10),
                   ],
                   difficulty: .beginner, relatedLeagueIDs: [], relatedClubIDs: ["man-city", "barcelona", "liverpool"]),
            
            Lesson(id: "tactics-pressing", trackID: "tactics", title: "High Press vs Low Block",
                   subtitle: "Defensive strategies explained", estimatedMinutes: 7, xpReward: 30,
                   cards: [
                    LessonCard(id: UUID(), title: "High Pressing", content: "A high press means a team aggressively pressures the opponent high up the pitch, near the opponent's goal. The idea is to win the ball back quickly in dangerous areas. It requires incredible fitness, coordination, and bravery—if one player doesn't press, gaps appear.", highlightFact: "Jürgen Klopp's Liverpool became famous for their 'gegenpressing'—immediately pressing after losing the ball.", iconName: "arrow.up.forward"),
                    LessonCard(id: UUID(), title: "Low Block Defense", content: "A low block means sitting deep with most players behind the ball, near your own goal. Teams use this to absorb pressure and hit on the counter-attack. It's often seen as 'defensive' but can be highly effective against stronger teams.", highlightFact: "Atlético Madrid under Diego Simeone perfected the low block, winning La Liga in 2014 against Real Madrid and Barcelona.", iconName: "shield.fill"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "What does 'high press' mean?", options: ["Defending near your own goal", "Pressing the opponent high up the pitch", "Playing with high passes", "Using tall players"], correctIndex: 1, explanation: "High pressing means aggressively closing down opponents near their goal to win the ball back in dangerous positions.", xpValue: 10),
                   ],
                   difficulty: .intermediate, relatedLeagueIDs: ["premier-league", "la-liga"], relatedClubIDs: ["liverpool", "atletico-madrid"]),
        ],
        difficulty: .intermediate
    )
    
    static let historyTrack = LessonTrack(
        id: "history", topic: .history, title: "History & Heritage",
        description: "The stories behind the beautiful game",
        lessons: [
            Lesson(id: "history-european-leagues", trackID: "history", title: "The Big Five Leagues",
                   subtitle: "How Europe's top leagues came to be", estimatedMinutes: 10, xpReward: 35,
                   cards: [
                    LessonCard(id: UUID(), title: "Premier League", content: "The English Premier League was founded in 1992 when the First Division clubs broke away from the Football League. It quickly became the world's most-watched league due to massive TV deals, global marketing, and competitive balance. Unlike many leagues, England has no dominant single club—multiple teams have won the title.", highlightFact: "The Premier League is broadcast in 212 territories, reaching 4.7 billion people worldwide.", iconName: "globe"),
                    LessonCard(id: UUID(), title: "La Liga", content: "Spain's La Liga has historically been dominated by Real Madrid and FC Barcelona—the two most successful clubs in European history. Their rivalry, 'El Clásico,' is the biggest match in club soccer. La Liga is known for technical, possession-based play and has produced some of the greatest players ever.", highlightFact: "Between 2004-2020, only Atlético Madrid (2014) broke the Real Madrid/Barcelona duopoly on the title.", iconName: "star.fill"),
                    LessonCard(id: UUID(), title: "Serie A", content: "Italy's Serie A was once considered the world's best league in the 1990s, with Juventus, AC Milan, and Inter Milan attracting the biggest stars. Italian soccer is known for tactical sophistication—the concept of 'catenaccio' (defensive lock) was born here.", highlightFact: "Juventus won 9 consecutive Serie A titles from 2012-2020, the longest streak in Europe's top five leagues.", iconName: "building.columns.fill"),
                    LessonCard(id: UUID(), title: "Bundesliga & Ligue 1", content: "Germany's Bundesliga is known for the best atmosphere in world soccer—standing sections, affordable tickets, and the 50+1 ownership rule that keeps fans in control. France's Ligue 1 is a world-class talent factory, producing players like Mbappé, Henry, Zidane, and Platini.", highlightFact: "Borussia Dortmund's Yellow Wall (Südtribüne) holds 25,000 standing fans—the largest terrace in European soccer.", iconName: "person.3.sequence.fill"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "When was the Premier League founded?", options: ["1888", "1992", "1966", "2000"], correctIndex: 1, explanation: "The Premier League was created in 1992 when First Division clubs broke away from the Football League.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "What is the biggest match in club soccer called?", options: ["The Derby", "El Clásico", "The Superclásico", "Der Klassiker"], correctIndex: 1, explanation: "El Clásico is the name for matches between Real Madrid and FC Barcelona.", xpValue: 10),
                   ],
                   difficulty: .beginner, relatedLeagueIDs: ["premier-league", "la-liga", "serie-a", "bundesliga", "ligue-1"], relatedClubIDs: []),
        ],
        difficulty: .beginner
    )
    
    static let playersTrack = LessonTrack(
        id: "players", topic: .players, title: "Players & Positions",
        description: "Know the roles that make teams tick",
        lessons: [
            Lesson(id: "players-positions", trackID: "players", title: "Player Positions Explained",
                   subtitle: "From goalkeeper to striker", estimatedMinutes: 8, xpReward: 30,
                   cards: [
                    LessonCard(id: UUID(), title: "Goalkeeper (GK)", content: "The last line of defense. Goalkeepers wear a different colored jersey and are the only players who can use their hands—but only inside the 18-yard penalty area. Modern goalkeepers must also be good with their feet, often acting as an extra defender in build-up play.", highlightFact: "Manuel Neuer of Bayern Munich pioneered the 'sweeper-keeper' role, coming far off his line to act as an outfield player.", iconName: "hand.raised.fill"),
                    LessonCard(id: UUID(), title: "Defenders (DEF)", content: "Defenders protect the goal. Centre-backs are the backbone of defense, while full-backs (left-back and right-back) play on the flanks and must balance defending with joining attacks. Wing-backs are full-backs who play higher up, almost like wingers.", highlightFact: "Virgil van Dijk transformed Liverpool's defense so dramatically that they went from conceding 42 goals to winning the Champions League.", iconName: "shield.fill"),
                    LessonCard(id: UUID(), title: "Midfielders (MID)", content: "Midfielders are the engine room. Defensive midfielders (DMs) protect the defense and recycle possession. Central midfielders (CMs) link defense to attack. Attacking midfielders (AMs or #10s) create chances and are often the most creative players.", highlightFact: "Kevin De Bruyne of Manchester City is considered one of the best creative midfielders ever, known for his vision and passing range.", iconName: "figure.run"),
                    LessonCard(id: UUID(), title: "Forwards (FWD)", content: "Forwards score goals. Strikers (#9) lead the line. Wingers play wide and cut inside or deliver crosses. A 'false nine' is a striker who drops deep into midfield to create overloads—a revolutionary tactic popularized by Pep Guardiola with Messi at Barcelona.", highlightFact: "Erling Haaland scored 36 Premier League goals in his first season at Manchester City—a record.", iconName: "flame.fill"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "What is a 'false nine'?", options: ["A defensive midfielder", "A striker who drops deep into midfield", "The ninth player on the team", "A backup goalkeeper"], correctIndex: 1, explanation: "A false nine is a striker who drops into midfield to create space and confuse defenders, rather than staying high up the pitch.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "Where can a goalkeeper use their hands?", options: ["Anywhere on the pitch", "Only inside the 6-yard box", "Only inside the 18-yard box", "Only during set pieces"], correctIndex: 2, explanation: "Goalkeepers can only handle the ball inside their own 18-yard penalty area.", xpValue: 10),
                   ],
                   difficulty: .beginner, relatedLeagueIDs: [], relatedClubIDs: ["bayern", "liverpool", "man-city", "barcelona"]),
        ],
        difficulty: .beginner
    )
    
    static let statsTrack = LessonTrack(
        id: "stats", topic: .stats, title: "Stats & Analytics",
        description: "Decode the numbers behind the game",
        lessons: [
            Lesson(id: "stats-basics", trackID: "stats", title: "Key Stats Explained",
                   subtitle: "What the numbers actually mean", estimatedMinutes: 7, xpReward: 30,
                   cards: [
                    LessonCard(id: UUID(), title: "Possession", content: "Possession measures what percentage of the match each team has the ball. While high possession was once seen as essential, modern soccer shows that less possession with effective counter-attacking can be equally successful.", highlightFact: "Leicester City won the 2015-16 Premier League title averaging just 42.6% possession—proving you don't need the ball to win.", iconName: "chart.pie.fill"),
                    LessonCard(id: UUID(), title: "Expected Goals (xG)", content: "xG is a metric that measures the quality of a chance by calculating the probability it results in a goal. A penalty might be worth 0.76 xG, while a shot from 30 yards might be 0.03 xG. If a team's actual goals exceed their xG, they're 'overperforming'.", highlightFact: "xG has become so important that managers use it to evaluate performance regardless of actual results.", iconName: "target"),
                    LessonCard(id: UUID(), title: "Pass Accuracy & Key Passes", content: "Pass accuracy shows what percentage of passes find a teammate. But raw accuracy can be misleading—safe sideways passes boost the number, while risky through-balls that create chances lower it. 'Key passes' are those that directly lead to a shot.", highlightFact: "Barcelona under Guardiola regularly exceeded 90% pass accuracy by using short, precise passing patterns called 'tiki-taka'.", iconName: "arrow.right.arrow.left"),
                   ],
                   quiz: [
                    QuizQuestion(id: UUID(), question: "What does xG measure?", options: ["Extra goals scored", "The quality/probability of scoring chances", "Goals from outside the box", "Goals per game"], correctIndex: 1, explanation: "Expected Goals (xG) calculates the probability that a given chance results in a goal, based on factors like shot location, angle, and type.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "Does higher possession always mean a team is better?", options: ["Yes, always", "No, effective counter-attacking can win with less possession", "Only in European leagues", "Only when combined with more shots"], correctIndex: 1, explanation: "Leicester City's 2015-16 Premier League title proved that effective counter-attacking with low possession can beat high-possession teams.", xpValue: 10),
                   ],
                   difficulty: .intermediate, relatedLeagueIDs: ["premier-league"], relatedClubIDs: ["man-city", "barcelona"]),
        ],
        difficulty: .intermediate
    )
    
    // MARK: - Badges
    
    static let allBadges: [Badge] = [
        // Learning
        Badge(id: "first-steps", name: "First Steps", description: "Complete your first lesson", iconName: "figure.walk", category: .learning, requiredValue: 1),
        Badge(id: "scholar", name: "Scholar", description: "Complete 10 lessons", iconName: "book.fill", category: .learning, requiredValue: 10),
        Badge(id: "professor", name: "Professor", description: "Complete all lessons in a track", iconName: "graduationcap.fill", category: .learning, requiredValue: 1),
        Badge(id: "polymath", name: "Polymath", description: "Complete all lesson tracks", iconName: "brain.fill", category: .learning, requiredValue: 5),
        // Streak
        Badge(id: "on-fire", name: "On Fire", description: "Maintain a 3-day streak", iconName: "flame.fill", category: .streak, requiredValue: 3),
        Badge(id: "dedicated", name: "Dedicated", description: "Maintain a 7-day streak", iconName: "flame.circle.fill", category: .streak, requiredValue: 7),
        Badge(id: "unstoppable", name: "Unstoppable", description: "Maintain a 30-day streak", iconName: "bolt.fill", category: .streak, requiredValue: 30),
        Badge(id: "legend", name: "Legend", description: "Maintain a 100-day streak", iconName: "crown.fill", category: .streak, requiredValue: 100),
        // Quiz
        Badge(id: "quick-thinker", name: "Quick Thinker", description: "Complete your first quiz", iconName: "questionmark.circle.fill", category: .quiz, requiredValue: 1),
        Badge(id: "perfect-score", name: "Perfect Score", description: "Get 100% on any quiz", iconName: "star.fill", category: .quiz, requiredValue: 1),
        Badge(id: "quiz-master", name: "Quiz Master", description: "Complete 50 quizzes", iconName: "rosette", category: .quiz, requiredValue: 50),
        // Prediction
        Badge(id: "oracle", name: "Oracle", description: "Get your first correct prediction", iconName: "eye.fill", category: .prediction, requiredValue: 1),
        Badge(id: "nostradamus", name: "Nostradamus", description: "Get 5 exact score predictions", iconName: "sparkles", category: .prediction, requiredValue: 5),
        // Milestone
        Badge(id: "welcome", name: "Welcome", description: "Complete the onboarding", iconName: "hand.wave.fill", category: .milestone, requiredValue: 1),
        Badge(id: "level-10", name: "Rising Star", description: "Reach Level 10", iconName: "star.circle.fill", category: .milestone, requiredValue: 10),
        Badge(id: "level-25", name: "Expert", description: "Reach Level 25", iconName: "medal.fill", category: .milestone, requiredValue: 25),
        Badge(id: "level-50", name: "Master", description: "Reach Level 50", iconName: "trophy.fill", category: .milestone, requiredValue: 50),
        Badge(id: "all-leagues", name: "Globe Trotter", description: "Follow all 5 leagues", iconName: "globe.europe.africa.fill", category: .milestone, requiredValue: 5),
        Badge(id: "super-fan", name: "Super Fan", description: "Follow 5+ clubs", iconName: "heart.fill", category: .milestone, requiredValue: 5),
    ]
    
    // MARK: - Daily Challenges
    
    static func generateDailyChallenge() -> DailyChallenge {
        let challenges = [
            DailyChallenge(
                id: UUID(), date: Date(), title: "Premier League Trivia",
                description: "Answer 5 questions about the Premier League",
                type: .trivia, xpReward: 50,
                quizQuestions: [
                    QuizQuestion(id: UUID(), question: "Which club has won the most Premier League titles?", options: ["Liverpool", "Arsenal", "Manchester United", "Chelsea"], correctIndex: 2, explanation: "Manchester United have won 13 Premier League titles (20 total English league titles).", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "How many teams are in the Premier League?", options: ["18", "20", "22", "24"], correctIndex: 1, explanation: "The Premier League has 20 teams. The bottom 3 are relegated each season.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "Who holds the record for most Premier League goals in a season?", options: ["Mohamed Salah", "Erling Haaland", "Alan Shearer", "Thierry Henry"], correctIndex: 1, explanation: "Erling Haaland scored 36 Premier League goals in the 2022-23 season.", xpValue: 10),
                ]
            ),
            DailyChallenge(
                id: UUID(), date: Date(), title: "Tactical Thinker",
                description: "Test your knowledge of soccer tactics",
                type: .trivia, xpReward: 50,
                quizQuestions: [
                    QuizQuestion(id: UUID(), question: "What formation uses wing-backs?", options: ["4-4-2", "4-3-3", "3-5-2", "4-2-3-1"], correctIndex: 2, explanation: "The 3-5-2 formation uses wing-backs who play the full length of the flank, combining defensive and attacking duties.", xpValue: 10),
                    QuizQuestion(id: UUID(), question: "What is 'tiki-taka'?", options: ["A type of foul", "A short-passing playing style", "A formation", "A training drill"], correctIndex: 1, explanation: "Tiki-taka is a style of play involving short, quick passes and constant movement, perfected by Barcelona under Guardiola.", xpValue: 10),
                ]
            ),
        ]
        return challenges.randomElement()!
    }
    
    // MARK: - Leaderboard
    
    static let mockLeaderboard: [LeaderboardEntry] = [
        LeaderboardEntry(id: UUID(), userName: "SoccerGuru99", xp: 15200, level: 23, rank: 1, avatarEmoji: "⚽"),
        LeaderboardEntry(id: UUID(), userName: "TacticsNerd", xp: 12800, level: 20, rank: 2, avatarEmoji: "🧠"),
        LeaderboardEntry(id: UUID(), userName: "GoalMachine", xp: 11500, level: 19, rank: 3, avatarEmoji: "🔥"),
        LeaderboardEntry(id: UUID(), userName: "PitchPerfect", xp: 9800, level: 17, rank: 4, avatarEmoji: "⭐"),
        LeaderboardEntry(id: UUID(), userName: "DefensiveWall", xp: 8200, level: 15, rank: 5, avatarEmoji: "🛡️"),
        LeaderboardEntry(id: UUID(), userName: "MidfieldMaestro", xp: 7100, level: 14, rank: 6, avatarEmoji: "🎯"),
        LeaderboardEntry(id: UUID(), userName: "PressKing", xp: 6500, level: 13, rank: 7, avatarEmoji: "👑"),
        LeaderboardEntry(id: UUID(), userName: "OffsideTrap", xp: 5800, level: 12, rank: 8, avatarEmoji: "🏃"),
        LeaderboardEntry(id: UUID(), userName: "SetPiecePro", xp: 4200, level: 10, rank: 9, avatarEmoji: "🎪"),
        LeaderboardEntry(id: UUID(), userName: "MatchdayFan", xp: 3100, level: 8, rank: 10, avatarEmoji: "📺"),
    ]
    
    // MARK: - AI responses moved to FreddyResponses in AIGuideViewModel.swift
}
