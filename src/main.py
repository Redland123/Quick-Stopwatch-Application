import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

class MainClass:
    def __init__(self):
        self.app = QGuiApplication(sys.argv)
        self.engine = QQmlApplicationEngine()

        self.app.setOrganizationName("CustomApplicatons")
        self.app.setApplicationName("QuickTimerApp")

        self.engine.load("Main.qml")

if __name__ == "__main__":
    newApplication = MainClass()

    sys.exit(newApplication.app.exec_())