from project_last import *
from PyQt5.QtWidgets import QMessageBox
import sys
import os
import re
from time import sleep

app = QtWidgets.QApplication(sys.argv)
MainWindow = QtWidgets.QMainWindow()
ui = Ui_MainWindow()
ui.setupUi(MainWindow)
MainWindow.show()


def is_valid_ip(ip):
    pattern = re.compile(
        r"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")
    if pattern.match(ip):
        return True
    return False


def reverse_ip_address(ip_address):
    octets = ip_address.split('.')
    octlen = len(octets)
    octets = octets[:octlen-1]
    octets.reverse()

    return ".".join(octets)


def last_digit_of_ip_address(ip_address):
    octets = ip_address.split('.')
    last_octet = octets[-1]
    return last_octet[-1]

def ddns_value():
    print("DDNS")
    file = open("values.txt", "w+")
    file.write("ipnet=" + ui.DDNSipnet.text() + "\n")
    file.write("mask=" + ui.DDNSmask.text() + "\n")
    file.write("ipnetrev=" + reverse_ip_address(ui.DDNSipnet.text()) + "\n")
    file.write("doname=" + ui.DDNSdoname.text() + "\n")
    file.write("serip=" + ui.DDNSserip.text() + "\n")
    file.write("sername=" + ui.DDNSsername.text() + "\n")
    file.write("serend=" + last_digit_of_ip_address(ui.DDNSserip.text()) + "\n")
    file.write("ranstart=" + ui.DDNSranstart.text() + "\n")
    file.write("ranend=" + ui.DDNSranend.text() + "\n")
    sleep(5)

def ssh_value():
    print("SSH")
    file = open("values.txt", "w+")
    file.write("uname=" + ui.SSHuname.text() + "\n")
    file.write("uip=" + ui.SSHuip.text() + "\n")
    file.write("pass=" + ui.SSHpass.text() + "\n")

def vpn_value():
    print("VPN")
    file = open("values.txt", "w+")
    file.write("uname=" + ui.VPNuname.text() + "\n")
    file.write("uip=" + ui.VPNuip.text() + "\n")
    file.write("ip_mask=" + ui.VPNip_mask.text() + "\n")
    file.write("nic=" + ui.VPNnic.text() + "\n")

def ip_not_corecct():
    neval = QMessageBox()
    neval.setWindowTitle("неверный IP адрес")
    neval.setText("Вы указали неверный IP адрес, помотрите ещё раз на правильность ввода IP.")
    neval.setIcon(QMessageBox.Warning)
    neval.exec_()

def ddns_umol():
        print("DDNS по умолчанию")
        file = open("values.txt", "w+")
        file.write("ipnet=192.168.0.0\n")
        file.write("mask=255.255.255.0\n")
        file.write("ipnetrev=0.168.192\n")
        file.write("doname=primer.ru\n")
        file.write("serip=192.168.0.1\n")
        file.write("sername=serviz\n")
        file.write("ranstart=192.168.0.10\n")
        file.write("ranend=192.168.0.101\n")

def checking_ip_ddns():
    bol = is_valid_ip(ui.DDNSipnet.text()) & is_valid_ip(ui.DDNSmask.text()) & is_valid_ip(ui.DDNSserip.text()) & is_valid_ip(ui.DDNSranstart.text())\
                    & is_valid_ip(ui.DDNSranend.text())
    return bol

def checking_ip_vpn():
    bolv = is_valid_ip(ui.VPNuip.text()) & is_valid_ip(ui.VPNip_mask)
    return bolv

def click():
    if ui.DDNS.isChecked():
        if ui.DDNSUmol.isChecked() == False:
            if checking_ip_ddns():
                ddns_value()
                os.system("./ddns.sh")
            else:
                ip_not_corecct()

        else:
            ddns_umol()
            os.system("./ddns.sh")


    if ui.SSH.isChecked():
        if is_valid_ip(ui.SSHuip.text()):
            ssh_value()
            os.system("./sshd.sh")
        else:
            ip_not_corecct()

    if ui.VPN.isChecked():
        if checking_ip_vpn():
            vpn_value()
            os.system("./ovpn.sh")
        else:
            ip_not_corecct()


    if ui.FW.isChecked():
        print("FIreWall")
        os.system("./fire.sh")


def can():
    sys.exit(app.exec_())


ui.setting.clicked.connect(click)
ui.cancl.clicked.connect(can)

sys.exit(app.exec_())