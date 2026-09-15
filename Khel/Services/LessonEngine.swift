import Foundation

struct LessonEngine {
    
    static func personalizedTracks(for profile: UserProfile, allTracks: [LessonTrack]) -> [LessonTrack] {
        allTracks.filter { track in
            switch profile.knowledgeLevel {
            case .beginner:
                return true
            case .intermediate:
                return true
            case .advanced:
                return true
            }
        }.sorted { track1, track2 in
            // Prioritize tracks related to user's favorite clubs/leagues
            let relevance1 = trackRelevance(track1, for: profile)
            let relevance2 = trackRelevance(track2, for: profile)
            return relevance1 > relevance2
        }
    }
    
    static func trackRelevance(_ track: LessonTrack, for profile: UserProfile) -> Int {
        var score = 0
        for lesson in track.lessons {
            for leagueID in lesson.relatedLeagueIDs {
                if profile.favoriteLeagueIDs.contains(leagueID) { score += 1 }
            }
            for clubID in lesson.relatedClubIDs {
                if profile.favoriteClubIDs.contains(clubID) { score += 2 }
            }
        }
        // Boost difficulty-appropriate tracks
        if track.difficulty == profile.knowledgeLevel { score += 3 }
        return score
    }
    
    static func nextLesson(in track: LessonTrack, completedIDs: Set<String>) -> Lesson? {
        track.lessons.first { !completedIDs.contains($0.id) }
    }
    
    static func trackProgress(track: LessonTrack, completedIDs: Set<String>) -> Double {
        guard !track.lessons.isEmpty else { return 0 }
        let completed = track.lessons.filter { completedIDs.contains($0.id) }.count
        return Double(completed) / Double(track.lessons.count)
    }
    
    static func recommendedLessons(for profile: UserProfile, allTracks: [LessonTrack], limit: Int = 3) -> [Lesson] {
        let completedIDs = Set(profile.completedLessonIDs)
        var recommendations: [Lesson] = []
        
        let prioritizedTracks = personalizedTracks(for: profile, allTracks: allTracks)
        
        for track in prioritizedTracks {
            if let next = nextLesson(in: track, completedIDs: completedIDs) {
                recommendations.append(next)
                if recommendations.count >= limit { break }
            }
        }
        
        return recommendations
    }
    
    static func overallProgress(allTracks: [LessonTrack], completedIDs: Set<String>) -> Double {
        let totalLessons = allTracks.flatMap(\.lessons).count
        guard totalLessons > 0 else { return 0 }
        return Double(completedIDs.count) / Double(totalLessons)
    }
}
