import bb.cascades 1.0

Page {
    property alias itemPageTitle: titlebar.title
    property alias listView: listView
    titleBar: TitleBar {
        id: titlebar
    }
    Container {
        ListView {
            id: listView
            dataModel: XmlDataModel {
                id: listModel
                source: "data.xml"
            }
        }
    }
}