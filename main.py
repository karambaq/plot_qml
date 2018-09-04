import sys
import math
import numpy as np

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot


def generate_points(left_bound, right_bound, func):
    step = 0.005
    points = [[float(i), float(func(i))] for i in np.arange(left_bound, right_bound + step, step)]
    return points
 

class Plot(QObject):
    def __init__(self):
        QObject.__init__(self)
 
    updCanv = pyqtSignal(list, arguments=['upd'])
 
    @pyqtSlot(float, float, str)
    def upd(self, left_bound, right_bound, func):
        if func in ('cos', 'sin', 'tan'):
            points = generate_points(left_bound, right_bound, eval(f"math.{func}"))
        if func == 'sqrt':
            if left_bound >= 0:
                points = generate_points(left_bound, right_bound, math.sqrt)
            else:
                points = []
        if func == 'x^2':
            points = generate_points(left_bound, right_bound, lambda x: x * x)
        
        self.updCanv.emit(points)


if __name__ == "__main__":
    sys.argv += ['--style', 'material']
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    plot = Plot()
    engine.rootContext().setContextProperty("plot", plot)
    engine.load("main.qml")
    engine.quit.connect(app.quit)
    sys.exit(app.exec_())
