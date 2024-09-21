import WidgetKit
import SwiftUI
import Alamofire
import NukeUI

struct NetworkImage: View {
    let url: URL?
    
    var body: some View {
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("bunny")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), petList: [PetModel(name: "我的爱宠", avatar: "bunny", description: "可爱的爱宠...")])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), petList: [PetModel(name: "我的爱宠", avatar: "bunny", description: "可爱的爱宠...")])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                if let petListData = try await fetchData().data {
                    let currentDate = Date()
                    let simpleData = SimpleEntry(date: currentDate, petList: petListData)
                    let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)! // 15 minutes
                    let timeline = Timeline(entries: [simpleData], policy: .after(nextUpdate))
                    completion(timeline)
                }
            } catch {
                // Handle error and create a placeholder entry
                print("Error fetching pet data: \(error)")
                let entry = SimpleEntry(date: Date(), petList: [PetModel(name: "Error", avatar: "bunny", description: "Error fetching data")])
                let timeline = Timeline(entries: [entry], policy: .never)
                completion(timeline)
            }
        }
    }
    
    // MARK: Fetching JSON Data
    func fetchData() async throws -> BaseResult<[PetModel]> {
        print("fetchData")
        var token = ""
        
        if let sharedDefaults = UserDefaults(suiteName: "group.pet.zzz.loveoss") {
            print("Shared Defaults: \(sharedDefaults)")
            if let sharedData = sharedDefaults.string(forKey: "token") {
                token = sharedData
                print("PetWidget token: \(token)")
            } else {
                print("Token not found in shared defaults.")
            }
        } else {
            print("Unable to access shared defaults.")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        do {
            let data = try await AF.request(Urls.GET_PET_LIST, headers: headers)
                .validate()
                .serializingDecodable(BaseResult<[PetModel]>.self)
                .value
            return data
        } catch {
            print("Failed to fetch pet data: \(error)")
            throw error
        }
    }
}

struct SimpleEntry: Codable, TimelineEntry {
    var date: Date
    var petList: [PetModel]
}

struct PetWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        if let pet = entry.petList.randomElement() {
            ZStack {
                switch widgetFamily {
                case .systemMedium:
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(content: {
                                NetworkImage(url: URL(string: pet.avatar))
                                    .scaledToFill()
                            })
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Spacer(minLength: 0)
                            HStack {
                                Text(pet.name)
                                    .font(.title2)
                                Spacer(minLength: 0)
                                if let emoji = pet.familyModel.cn.split(separator: " ").last {
                                    Text(emoji)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            Spacer(minLength: 0)
                            Text(GlobalParams.dateFormatter.string(from: pet.birthDate))
                            Spacer(minLength: 0)
                            Text(pet.description)
                                .font(.subheadline)
                                .minimumScaleFactor(0.7)
                            Spacer(minLength: 0)
                        }
                    }
                    .widgetURL(URL(string: "https://zzz.pet/loveoss/note?selectedPet=\(pet.id)"))
                    
                case .systemLarge:
                    NetworkImage(url: URL(string: pet.avatar))
                        .scaledToFill()
                        .padding(-20)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(pet.name)
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                        .padding(.trailing)
                    }
                    
                default:
                    NetworkImage(url: URL(string: pet.avatar))
                        .scaledToFill()
                        .padding(-20)
                }
            }
            .widgetURL(URL(string: "https://zzz.pet/loveoss/chat"))
        }
    }
}

struct PetWidget: Widget {
    let kind: String = "PetWidgetOss"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PetWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget oss")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PetWidget()
} timeline: {
    SimpleEntry(date: .now, petList: [])
}
