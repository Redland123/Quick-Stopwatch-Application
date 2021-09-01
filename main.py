import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QTimer, QObject, Signal

from time import strftime, localtime

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    eng = QQmlApplicationEngine()

    eng.quit.connect(app.quit)

    eng.load('Main.qml')

    sys.exit(app.exec_())