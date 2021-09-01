import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

ApplicationWindow {
    id: appWindow

    Style {id: colors}
    Globals {id: globals}

    visible: true
    width: 1400
    height: 450

    title: "Quick Timer"

    color: colors.mainBackGroundColor

    signal editButtonToggleSignal()

    //flags: Qt.FramelessWindowHint

    onClosing: {
        console.log("Closing")
    }

    Settings {
        fileName: "./settings/settings.ini"

        category: "MainWindow"
        property alias x: appWindow.x
        property alias y: appWindow.y
        property alias width: appWindow.width
        property alias height: appWindow.height
    }

    RowLayout {
        id: mainLayout
        visible: true

        spacing: 20

        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 50

        anchors.fill: parent
        anchors.bottom: menu.top

        ListModel {
            id: timerList
        }

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
            id: editButton
            property var oldWidth: 40

            height: parent.height

            width: 40

            anchors.left: parent.left
            //anchors.rightMargin: 20

            Text {
                id: textField
                text: "Edit"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                appWindow.editButtonToggleSignal()

                if (textField.text == "Edit"){
                    textField.text = "Done"
                    newTimerButton.visible = false
                    anchors.left = undefined
                    anchors.right = parent.right
                }
                else {
                    textField.text = "Edit"
                    anchors.left = parent.left
                    anchors.right = undefined
                    width = oldWidth
                    newTimerButton.visible = true
                }
            }

            background: Rectangle {
                    color: {
                        if (parent.down)
                            colors.foreGroundColor
                        else if (parent.hovered)
                            colors.accentColor
                        else
                            colors.altAccentColor
                    }
                    radius: 5
            }
        }

        RoundButton {
            id: newTimerButton

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

                if (newTimer == null){
                    console.error("Error in Timer.qml")
                    return
                }

                appWindow.editButtonToggleSignal.connect(newTimer.toggleEditButton)
                
                newTimer.beingDeleted.connect(function(){
                    appWindow.editButtonToggleSignal.disconnect(newTimer.toggleEditButton)
                })
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