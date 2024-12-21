//
//  WordTips.swift
//  LearnWord
//
//  Created by Rıfat on 4.12.2024.
//

import TipKit

struct AddWordTip: Tip {
    var title: Text = Text("Add Your Own Words")
    var message: Text? = Text("Tap + to add your custom word")
    var image: Image? = Image(systemName: "lightbulb")
}

struct WordListTip: Tip {
    var title: Text = Text("Tip")
    var message: Text? = Text("Tap here to see your own words")
    var image: Image? = Image(systemName: "lightbulb")
}

struct NextWordTip: Tip {
    var title: Text = Text("Tip")
    var message: Text? = Text("Drag left or right to see next word")
    var image: Image? = Image(systemName: "lightbulb")
}
struct MeaningTİp: Tip {
    var title: Text = Text("Tip")
    var message: Text? = Text("Tap on card for meaining")
    var image: Image? = Image(systemName: "lightbulb")
}
struct PraticTip: Tip {
    var title: Text = Text("Tip")
    var message: Text? = Text("Tap on word for delete")
    var image: Image? = Image(systemName: "lightbulb")
}
