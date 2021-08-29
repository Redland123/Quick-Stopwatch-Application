import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    property var timer1: "00:00:00"
    property var timer2: "00:00:00"
    property var timer3: "00:00:00"
    property var timer4: "00:00:00"

    property var debug: false

    visible: true
    width: 700
    height: 450

    title: "Quick Timer"

    property var secondaryBackGroundColor: "#2B2B2B"
    property var mainBackGroundColor: "#1F1F1F"
    property var altAccentColor: "#494949"
    property var foreGroundColor: "White"
    property var accentColor: "Gray"

    property var iconFile: "../icons"

    color: mainBackGroundColor

    //flags: Qt.FramelessWindowHint

    RowLayout {
        anchors.fill: parent
        spacing: 10

        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10

         Rectangle {
            id: square
            width: 300
            height: 350

            color: secondaryBackGroundColor

            radius: width*0.1

            TextField {
                anchors.topMargin: 5

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                font.pixelSize: 20

                horizontalAlignment: TextInput.AlignHCenter 
                maximumLength: parent.width

                //Cant center so I had to do this:
                placeholderText: "  Timer Name"

                color: foreGroundColor

                background: Rectangle { 
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7

                    color: (parent.hovered ? accentColor : altAccentColor)

                    height: 2

                    }
            }


            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Rectangle {
                    //Debug Outline
                    visible: debug
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "red"
                    border.width: 1
                }

                Rectangle {
                    id: circle

                    property var mar: 30 

                    border.width: 15
                    radius: width*0.5

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: mar
                    anchors.rightMargin: mar

                    anchors.top: parent.top
                    anchors.topMargin: mar + 20

                    anchors.horizontalCenter: parent.horizontalCenter

                    width: parent.width
                    height: width

                    color: 'transparent'
                    border.color: accentColor

                    Text {
                        anchors.centerIn: parent
                        text: timer1
                        font.pixelSize: 35
                        color: foreGroundColor
                    }

                }

                Rectangle {
                    width: 100
                    height: 50

                    color: "transparent"

                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.top: circle.bottom 
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        //Debug Outline
                        visible: debug
                        color: "transparent"
                        border.color: "red"
                        border.width: 1

                        anchors.fill: parent
                    }

                    RoundButton {
                        anchors.right: parent.right
                        height: parent.height
                        width: parent.height

                        Image {
                            id: icon
                            anchors.centerIn: parent
                            anchors.fill: parent
                            anchors.margins: 7
                            source: "./icons/reset.png"
                        }
 
                        background: Rectangle {
                                color: parent.down ? foreGroundColor :
                                        (parent.hovered ? accentColor : altAccentColor)

                                radius: parent.width*0.5
                        }
                        
                    }
                    RoundButton {
                        id: test

                        property var buttonChecked: false

                        anchors.left: parent.left
                        height: parent.height
                        width: parent.height

                        Image {
                            id: icon2
                            anchors.centerIn: parent
                            anchors.fill: parent
                            anchors.margins: 7
                            source: "./icons/start.png"
                        }

                        onClicked: {
                            if (buttonChecked == true) {
                                icon2.source = "./icons/start.png" 
                                buttonChecked = false
                            } else {
                                icon2.source = "./icons/pause.png" 
                                buttonChecked = true
                            }
                        }

                        background: Rectangle {
                                color:(parent.hovered ? accentColor : altAccentColor)

                                radius: parent.width*0.5
                        }
                    }
                }
            }
        }
 

        Rectangle {
            width: 150
            height: 150

            color: 'gainsboro'

            border.color: "grey"
            border.width: 1
            radius: width*0.5

            Layout.fillWidth: false
        }
    }
} 