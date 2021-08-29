import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QTimer, QObject, Signal

from time import strftime, localtime

class Backend(QObject):
    # Signals:
    #Todo: Work on connecting qml to python
    update = Signal(str, arguments="time")

    def __init__(self):
        super().__init__()

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    eng = QQmlApplicationEngine()

    eng.quit.connect(app.quit)

    eng.load('Main.qml')

    #currentTime = strftime("%H:%M:%S", localtime())
    #eng.rootObjects()[0].setProperty('timer1', currentTime)

    sys.exit(app.exec_())