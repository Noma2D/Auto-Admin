# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'untitled.ui'
#
# Created by: PyQt5 UI code generator 5.15.7
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(722, 449)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.verticalLayoutWidget.setGeometry(QtCore.QRect(100, 0, 713, 91))
        self.verticalLayoutWidget.setObjectName("verticalLayoutWidget")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.verticalLayoutWidget)
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout.setObjectName("verticalLayout")
        self.label = QtWidgets.QLabel(self.verticalLayoutWidget)
        self.label.setStyleSheet("font: 16pt \"Tahoma\";")
        self.label.setTextFormat(QtCore.Qt.AutoText)
        self.label.setOpenExternalLinks(False)
        self.label.setObjectName("label")
        self.verticalLayout.addWidget(self.label)
        self.label_8 = QtWidgets.QLabel(self.verticalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(16)
        self.label_8.setFont(font)
        self.label_8.setStyleSheet("")
        self.label_8.setObjectName("label_8")
        self.verticalLayout.addWidget(self.label_8)
        self.horizontalLayoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.horizontalLayoutWidget.setGeometry(QtCore.QRect(490, 390, 231, 61))
        self.horizontalLayoutWidget.setObjectName("horizontalLayoutWidget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.horizontalLayoutWidget)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.setting = QtWidgets.QPushButton(self.horizontalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(10)
        self.setting.setFont(font)
        self.setting.setStyleSheet("background-color: rgb(95, 95, 95);\n""color: rgb(170, 0, 0);")
        self.setting.setObjectName("setting")
        self.horizontalLayout.addWidget(self.setting)
        self.cancl = QtWidgets.QPushButton(self.horizontalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(10)
        self.cancl.setFont(font)
        self.cancl.setStyleSheet("background-color: rgb(98, 98, 98);\n""color: rgb(170, 0, 0);")
        self.cancl.setObjectName("cancl")
        self.horizontalLayout.addWidget(self.cancl)
        self.line = QtWidgets.QFrame(self.centralwidget)
        self.line.setEnabled(True)
        self.line.setGeometry(QtCore.QRect(0, 375, 721, 5))
        self.line.setStyleSheet("color: rgb(170, 0, 0);\n""background-color: rgb(170, 0, 0);")
        self.line.setFrameShape(QtWidgets.QFrame.HLine)
        self.line.setFrameShadow(QtWidgets.QFrame.Sunken)
        self.line.setObjectName("line")
        self.formLayoutWidget = QtWidgets.QWidget(self.centralwidget)
        self.formLayoutWidget.setGeometry(QtCore.QRect(0, 90, 721, 291))
        self.formLayoutWidget.setObjectName("formLayoutWidget")
        self.formLayout = QtWidgets.QFormLayout(self.formLayoutWidget)
        self.formLayout.setContentsMargins(0, 0, 0, 0)
        self.formLayout.setObjectName("formLayout")
        self.txt = QtWidgets.QLabel(self.formLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(14)
        self.txt.setFont(font)
        self.txt.setObjectName("txt")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.SpanningRole, self.txt)
        self.TD = QtWidgets.QLabel(self.formLayoutWidget)
        self.TD.setEnabled(True)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(12)
        font.setBold(True)
        font.setWeight(75)
        self.TD.setFont(font)
        self.TD.setTextFormat(QtCore.Qt.AutoText)
        self.TD.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.TD.setWordWrap(False)
        self.TD.setObjectName("TD")
        self.formLayout.setWidget(4, QtWidgets.QFormLayout.LabelRole, self.TD)
        self.DDNS = QtWidgets.QCheckBox(self.formLayoutWidget)
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Shadow, brush)
        self.DDNS.setPalette(palette)
        self.DDNS.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.DDNS.setStyleSheet("")
        self.DDNS.setText("")
        self.DDNS.setTristate(False)
        self.DDNS.setObjectName("DDNS")
        self.formLayout.setWidget(4, QtWidgets.QFormLayout.FieldRole, self.DDNS)
        self.TSSH = QtWidgets.QLabel(self.formLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(12)
        font.setBold(True)
        font.setWeight(75)
        self.TSSH.setFont(font)
        self.TSSH.setObjectName("TSSH")
        self.formLayout.setWidget(5, QtWidgets.QFormLayout.LabelRole, self.TSSH)
        self.SSH = QtWidgets.QCheckBox(self.formLayoutWidget)
        self.SSH.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.SSH.setText("")
        self.SSH.setObjectName("SSH")
        self.formLayout.setWidget(5, QtWidgets.QFormLayout.FieldRole, self.SSH)
        self.TVPN = QtWidgets.QLabel(self.formLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(12)
        font.setBold(True)
        font.setWeight(75)
        self.TVPN.setFont(font)
        self.TVPN.setObjectName("TVPN")
        self.formLayout.setWidget(6, QtWidgets.QFormLayout.LabelRole, self.TVPN)
        self.VPN = QtWidgets.QCheckBox(self.formLayoutWidget)
        self.VPN.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.VPN.setText("")
        self.VPN.setObjectName("VPN")
        self.formLayout.setWidget(6, QtWidgets.QFormLayout.FieldRole, self.VPN)
        self.Twall = QtWidgets.QLabel(self.formLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(12)
        font.setBold(True)
        font.setWeight(75)
        self.Twall.setFont(font)
        self.Twall.setObjectName("Twall")
        self.formLayout.setWidget(7, QtWidgets.QFormLayout.LabelRole, self.Twall)
        self.FireWall = QtWidgets.QCheckBox(self.formLayoutWidget)
        self.FireWall.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.FireWall.setText("")
        self.FireWall.setObjectName("FireWall")
        self.formLayout.setWidget(7, QtWidgets.QFormLayout.FieldRole, self.FireWall)
        self.TS = QtWidgets.QLabel(self.formLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Tahoma")
        font.setPointSize(12)
        font.setBold(True)
        font.setWeight(75)
        self.TS.setFont(font)
        self.TS.setObjectName("TS")
        self.formLayout.setWidget(8, QtWidgets.QFormLayout.LabelRole, self.TS)
        self.Samba = QtWidgets.QCheckBox(self.formLayoutWidget)
        self.Samba.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.Samba.setText("")
        self.Samba.setObjectName("Samba")
        self.formLayout.setWidget(8, QtWidgets.QFormLayout.FieldRole, self.Samba)
        self.label_9 = QtWidgets.QLabel(self.centralwidget)
        self.label_9.setGeometry(QtCore.QRect(-4, -18, 731, 471))
        self.label_9.setStyleSheet("\n""background-color: rgb(86, 86, 86);")
        self.label_9.setText("")
        self.label_9.setObjectName("label_9")
        self.label_9.raise_()
        self.verticalLayoutWidget.raise_()
        self.horizontalLayoutWidget.raise_()
        self.line.raise_()
        self.formLayoutWidget.raise_()
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.label.setText(_translate("MainWindow", "Добро пожаловать в программу для автоматической"))
        self.label_8.setText(_translate("MainWindow", "настройки сервера."))
        self.setting.setText(_translate("MainWindow", "Настроить"))
        self.cancl.setText(_translate("MainWindow", "Отмена"))
        self.txt.setText(_translate("MainWindow", "Выберите интерисующие вас фунции:"))
        self.TD.setText(_translate("MainWindow", "DDNS"))
        self.TSSH.setText(_translate("MainWindow", "SSH-key"))
        self.TVPN.setText(_translate("MainWindow", "VPN"))
        self.Twall.setText(_translate("MainWindow", "Fire wall"))
        self.TS.setText(_translate("MainWindow", "Samba"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())