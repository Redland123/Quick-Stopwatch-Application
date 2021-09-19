import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings
import QtQuick.Controls.Material

ApplicationWindow {
    id: appWindow

    visible: true
    title: "Quick Stopwatch"

    width: 450
    height: 450

    Style {id: colors}

    signal editButtonToggleSignal()

    Rectangle {
        anchors.fill: parent
        color: colors.mainBackGroundColor
    }

    WheelHandler {
        target: mainPage
        property: "y" 
        rotationScale: 4
    }

    Rectangle {
        id: mainPage

        width: appWindow.width
        height: appWindow.height

        clip: false

        color: "Transparent"

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

            ListModel {
                id: timerList
                property var timerValues: ""
            }
        }
    }

    Loader {
        z: 10
        
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        anchors.bottomMargin: 5
        anchors.rightMargin: 5

        source: "Footer.qml"
        }

    Settings {
        id: windowSettings
        fileName: "../settings/settings.ini"

        category: "MainWindow"
        property alias x: appWindow.x
        property alias y: appWindow.y
        property alias width: appWindow.width
        property alias height: appWindow.height
    }

    Settings {
        id: componentSettings
        fileName: "../settings/settings.ini"

        category: "Components"
        property alias count: timerList.count
        property alias values: timerList.timerValues
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

    function updateSettings() {
        var newTimerString = ""
 
        for (let i = 0; i < timerList.count; i++){
            var currentTimer = timerList.get(i).timer

            //timerList.timerValues 
            
            newTimerString += "#" + currentTimer.getTimerName() + "&" + currentTimer.getTimerValue()
        }
        timerList.timerValues = newTimerString
    }

    onClosing: {updateSettings()}
} 