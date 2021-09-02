import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

ApplicationWindow {
    id: appWindow

    visible: true
    title: "Quick Timer"

    width: 450
    height: 450

    color: colors.mainBackGroundColor

    Style {id: colors}
    Globals {id: globals}

    signal editButtonToggleSignal()

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

    GridLayout {
        id: mainLayout
        visible: true

        columnSpacing: 20
        rowSpacing: 20

        columns: {
            Math.floor(appWindow.width / 310)
        }

        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 50
        anchors.topMargin: 50

        anchors.fill: parent
        anchors.bottom: menuLayout.top

        ListModel {
            id: timerList
            property var timerValues: ""
        }
    }

    Rectangle {
        id: menuLayout
        visible: true

        width: 175
        height: 40

        color: "transparent"

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.bottomMargin: 10
        anchors.rightMargin: 10

        RoundButton {
            id: editButton
            property var oldWidth: 40

            width: 40
            height: parent.height

            anchors.left: parent.left

            Text {
                id: textField
                text: "Edit"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                radius: 5

                color: {
                    if (parent.down) colors.foreGroundColor
                    else if (parent.hovered) colors.accentColor
                    else colors.altAccentColor
                }
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
        }

        RoundButton {
            id: newTimerButton

            width: 125
            height: parent.height

            anchors.right: parent.right

            Text {
                text: "Add New Timer"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                radius: 5

                color: {
                    if (parent.down) {
                        colors.foreGroundColor
                    } else if (parent.hovered) {
                        colors.accentColor
                    } else {
                        colors.altAccentColor
                    }
                }
            }
            onClicked: createNewTimer()
        }
    } 

    Component.onCompleted: {
        for (let i = 0; i < componentSettings.value("count"); i++)
           createNewTimer()

        if (timerList.count) loadValues()
    }

    function loadValues() {
        var tmp = componentSettings.values.split("#")
        tmp.splice(0,1)

        for (let i = 0; i < tmp.length; i++){
            var x = tmp[i].split("&")

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
            for (let i = 0; i < timerList.count; i++)
                if (timerList.get(i).timer == newTimer) timerList.remove(i)
        })
    }

    onClosing: {
        var newTimerString = ""
 
        for (let i = 0; i < timerList.count; i++){
            var currentTimer = timerList.get(i).timer

            timerList.timerValues 
            
            newTimerString += "#" + currentTimer.getTimerName() + "&" + currentTimer.getTimerValue()
        }
        timerList.timerValues = newTimerString
    }
} 