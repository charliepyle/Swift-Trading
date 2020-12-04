//
//  NewsDetail.swift
//  hw9
//
//  Created by Charlie Pyle on 12/1/20.
//

import SwiftUI
import KingfisherSwiftUI

struct SpecialNewsRow: View {
    var news: News
    var publishedDate: String = ""
//    var rows: [GridItem] = [
//        GridItem(.fixed(240)),
//        GridItem(.fixed(60))
//    ]
    
    init(news: News) {
        self.news = news
        let receivedString = news.publishedAt
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let publishedDate = RFC3339DateFormatter.date(from: receivedString)!
        
        let today = Date()
        
        let diff = Int(today.timeIntervalSince1970 - publishedDate.timeIntervalSince1970)
        
        let days = diff/(3600*24)
        
        let hours = diff/3600
        
        let minutes = (diff - hours * 3600)/60
        
        
        var publishedDateString = RFC3339DateFormatter.string(from: publishedDate)
        
        if minutes < 60 {
            publishedDateString = "\(minutes) minutes ago."
        }
        else if hours < 24 {
            publishedDateString = "\(hours) hours ago."
        }
        else {
            publishedDateString = "\(days) days ago."
        }
        
        
        self.publishedDate = publishedDateString
        
    }
    
    var body: some View {

////        LazyHGrid(rows: rows) {
//        RoundedRectangle {
//
//        }
        ZStack {
//            RoundedRectangle(cornerRadius: 25, style: .continuous)
//                            .fill(Color.white)
//                            .frame(width: 400, height: 200)
            VStack() {
                VStack() {
                        KFImage(URL(string:news.urlToImage))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(20)
                            .frame( width: 360, height: 180)
                            .scaledToFill()
    //                }
                }
                Spacer()
                VStack() {
                    HStack {
                            Text(news.source)
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Text(self.publishedDate)
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                        }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(news.title)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )
        }.fixedSize(horizontal: false, vertical: true)
        
            
//                        .clipped()
    //                    .aspectRatio(1, contentMode: .fit)
                
    //                Spacer()
                        
//                }
//                GeometryReader {
                
//                }
                   
            //.clipped()
            
                
//
            
//        }.padding()
            
            
//        }
    }
}

struct SpecialNewsRow_Previews: PreviewProvider {
    static var previews: some View {
        let n:News =  News(
            url: "Google.com",
            title: "Microsoft will reported allow employees to work from home permanently, the latest tech giant to ",
            description: "desc",
            source: "google.com",
            urlToImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Golden_Retriever_Carlos_%2810581910556%29.jpg/440px-Golden_Retriever_Carlos_%2810581910556%29.jpg",
            publishedAt: "today"
        )
        Group {
            SpecialNewsRow(news: n)
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
