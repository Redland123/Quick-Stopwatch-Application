import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QSettings, QSize, QPoint

class MainClass:
    def __init__(self):
        self.app = QGuiApplication(sys.argv)
        self.engine = QQmlApplicationEngine()

        #self.readSettings()

        self.app.setOrganizationName("CustomApplicatons")
        self.app.setApplicationName("QuickTimerApp")

        self.engine.load("Main.qml")


        #self.app.lastWindowClosed.connect(self.writeSettings)
        #self.engine.saveSettingsSignal.connect(self.writeSettings)

    def testFunction(self):
        print("Closing signal caught")

if __name__ == "__main__":
    newApplication = MainClass()

    sys.exit(newApplication.app.exec_())