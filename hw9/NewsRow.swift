//
//  NewsDetail.swift
//  hw9
//
//  Created by Charlie Pyle on 12/1/20.
//

import SwiftUI
import KingfisherSwiftUI

struct NewsRow: View {
    var news: News
    var columns: [GridItem] = [
        GridItem(.fixed(240), alignment: .leading),
        GridItem(.fixed(60), alignment: .leading)
    ]
    
    var body: some View {

        LazyVGrid(columns: columns) {
            VStack(spacing:0) {
                HStack {
                    Text(news.source)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    Text(news.publishedAt)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                Text(news.title)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
//                Spacer()
            }
//
            VStack(spacing:0) {
                let url = URL(string:news.urlToImage)
//                GeometryReader {
                KFImage(url)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
//                    .scaledToFill()
//                    .frame(minHeight: 0, maxHeight: .infinity)
//                    .clipped()
                    .frame(minWidth: 0, maxWidth: .infinity)
//                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(20)
//                }
                   
            }.clipped()
        }//.padding()
            
            
//        }
    }
}

struct NewsRow_Previews: PreviewProvider {
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
            NewsRow(news: n)
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
