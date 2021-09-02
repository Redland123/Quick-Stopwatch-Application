import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

ApplicationWindow {
    id: appWindow

    Style {id: colors}
    Globals {id: globals}

    visible: true
    width: 450
    height: 450

    title: "Quick Timer"

    color: colors.mainBackGroundColor

    signal editButtonToggleSignal()

    //flags: Qt.FramelessWindowHint

    Component.onCompleted: {
        for (let i = 0; i < componentSettings.value("count"); i++)
           createNewTimer()

        if (timerList.count)
            loadValues()
    }

    function loadValues() {
        var tmp = componentSettings.values.split("#")

        tmp.splice(0,1)

        for (let i = 0; i < tmp.length; i++){
            var x = tmp[i].split("&")

            console.log(x)

            timerList.get(i).timer.setTimerName(x[0])
            timerList.get(i).timer.setTimerValue(x[1])
        }
    }

    function createNewTimer() {
        var newTimer = Qt.createComponent("Timer.qml").createObject(mainLayout);

        timerList.append({"timer": newTimer})

        if (newTimer == null){
            console.error("Error in Timer.qml")
            return
        }

        appWindow.editButtonToggleSignal.connect(newTimer.toggleEditButton)
        
        newTimer.beingDeleted.connect(function(){
            appWindow.editButtonToggleSignal.disconnect(newTimer.toggleEditButton)

            //Finds the timer that's being deleted and removes it from the list
            for (let i = 0; i < timerList.count; i++){
                if (timerList.get(i).timer == newTimer)
                    timerList.remove(i)
            }
        })
    }

    onClosing: {
        console.log("Closing")

        var newTimerString = ""
 
        for (let i = 0; i < timerList.count; i++){
            var currentTimer = timerList.get(i).timer

            timerList.timerValues 
            
            newTimerString += "#" + currentTimer.getTimerName() + "&" + currentTimer.getTimerValue()
        }

        timerList.timerValues = newTimerString
    }

    Settings {
        id: windowSettings
        fileName: "./settings/settings.ini"

        category: "MainWindow"
        property alias x: appWindow.x
        property alias y: appWindow.y
        property alias width: appWindow.width
        property alias height: appWindow.height
    }

    Settings {
        id: componentSettings
        fileName: "./settings/settings.ini"

        category: "Components"
        property alias count: timerList.count
        property alias values: timerList.timerValues
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
            property var timerValues: ""
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
                createNewTimer()
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