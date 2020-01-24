//
//  ContentView.swift
//  OtusIOSHomework4_5
//
//  Created by Pavel on 22.01.2020.
//  Copyright © 2020 OtusCourse. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            HStack {
                viewModel.smileImage?.resizable()
                viewModel.sadImage?.resizable()
            }
            viewModel.normalImage?.resizable()
        }
        .onAppear {
            self.viewModel.loadImages()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentViewModel())
    }
}
