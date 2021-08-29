import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: timerBody

    property var iconFile: "../icons"

    Style {id: colors}
    Globals {id: globals}

    width: 300
    height: 350
    radius: width*0.1

    color: colors.secondaryBackGroundColor

    TextField {
        anchors.topMargin: 5

        anchors.horizontalCenter: timerBody.horizontalCenter
        anchors.top: timerBody.top


        font.pixelSize: 20

        horizontalAlignment: TextInput.AlignHCenter 
        maximumLength: parent.width

        //Cant center so I had to do this:
        placeholderText: "  Timer Name"

        color: colors.foreGroundColor

        background: Rectangle { 
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7

            color: {
                if (parent.hovered){
                    colors.accentColor
                } else {
                    colors.altAccentColor
                }
            }

            height: 2

            }
    }


    Rectangle {
        id: circle

        property var mar: 30 

        border.width: 15
        radius: width*0.5

        anchors.left: parent.left
        anchors.leftMargin: mar
        anchors.top: parent.top
        anchors.topMargin: mar + 20
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: width

        color: 'transparent'
        border.color: colors.accentColor

        Text {
            anchors.centerIn: parent
            text: "00:00:00"
            font.pixelSize: 35
            color: colors.foreGroundColor
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
                    color: {
                        if (parent.down){
                            colors.accentColor
                        } else {
                            colors.altAccentColor
                        }
                    }

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
                    color: {
                        if (parent.hovered){
                            colors.accentColor
                        } else {
                            colors.altAccentColor
                        }
                    }

                    radius: parent.width*0.5
            }
        }
    }
}