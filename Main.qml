import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: appWindow

    Style {id: colors}
    Globals {id: globals}

    visible: true
    width: 700
    height: 450

    title: "Quick Timer"

    color: colors.mainBackGroundColor

    //flags: Qt.FramelessWindowHint

    RowLayout {
        id: mainLayout
        visible: true

        spacing: 20

        anchors.leftMargin: 10
        anchors.rightMargin: 10

        anchors.fill: parent
    }

    Rectangle {
        id: menu
        visible: true

        color: "transparent"

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.bottomMargin: 10
        anchors.rightMargin: 10

        width: 175
        height: 40

        RoundButton {
            height: parent.height
            width: 40

            anchors.left: parent.left

            Text {
                text: "Edit"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                    color: {
                        if (parent.down) {
                            colors.foreGroundColor
                        } else if (parent.hovered) {
                            colors.accentColor
                        } else {
                            colors.altAccentColor
                        }
                    }

                    radius: 5
            }
        }

        RoundButton {
            height: parent.height
            width: 125

            anchors.right: parent.right

            Text {
                text: "Add New Timer"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                var newTimer = Qt.createComponent("Timer.qml").createObject(mainLayout);
            }

            background: Rectangle {
                    color: {
                        if (parent.down) {
                            colors.foreGroundColor
                        } else if (parent.hovered) {
                            colors.accentColor
                        } else {
                            colors.altAccentColor
                        }
                    }

                    radius: 5
            }
        }
    } 
} 