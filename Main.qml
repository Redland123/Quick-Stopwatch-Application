import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

ApplicationWindow {
    id: appWindow

    visible: true
    title: "Quick Stopwatch"

    width: 450
    height: 450

    //color: "transparent"  

    //flags: Qt.FramelessWindowHint

    Style {id: colors}
    Globals {id: globals}

    signal editButtonToggleSignal()

    property var bw: 6

    Rectangle {
        anchors.margins: 4

        anchors.fill: parent
        color: colors.tertiaryBackGroundColor
        radius: 2
    }

    /*
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 10; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.NoButton // don't handle actual events
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            const b = bw + 10; // Increase the corner size slightly
            let e = 0;
            if (p.x < b) { e |= Qt.LeftEdge }
            if (p.x >= width - b) { e |= Qt.RightEdge }
            if (p.y < b) { e |= Qt.TopEdge }
            if (p.y >= height - b) { e |= Qt.BottomEdge }
            appWindow.startSystemResize(e);
        }
    }

    function toggleMaximized() {
        if (appWindow.visibility === ApplicationWindow.Maximized) {
            appWindow.showNormal();
        } else {
            appWindow.showMaximized();
        }
    }
    */

    Page {
        //header: Loader {source: "Header.qml"}

        //anchors.margins: appWindow.visibility === Window.Windowed ? 5 : 0
        anchors.fill: parent

        clip: true

        background: Rectangle {
            color: colors.mainBackGroundColor
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

            ListModel {
                id: timerList
                property var timerValues: ""
            }
        }

        footer: Loader {source: "Footer.qml"}
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