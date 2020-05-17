//
//  ContentView.swift
//  KikurageProjectForiOS
//
//  Created by Shusuke Ota on 2020/5/16.
//  Copyright © 2020 shusuke. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.blue)
                Spacer()
                Text("今日のきくらげ")
                Spacer()
            }.padding()
            Text("Hello, World!")
            Text("今日のきんちゃん")
            Text("のどカラカラや！")
            Image("Normal-0")
                .padding()
            HStack {
                Text("")
                Text("温度")
                Text("湿度")
            }
            HStack {
                Text("現在")
                Text("24℃")
                Text("45%")
            }
            HStack {
                Text("理想")
                Text("20-25℃")
                Text("80%以上")
            }
            Spacer()
            HStack {
                Button(action: {
                    
                }) {
                    Text("さいばいきろく")
                }
                Button(action: {
                    
                }) {
                    Text("りょうりきろく")
                }
                Button(action: {
                    
                }) {
                    Text("みんなにそうだん")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
