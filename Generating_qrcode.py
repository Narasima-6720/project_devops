#requirement modules

#pyqrcode
#opencv

#pip install PyQRCode
#pip install opencv-python
#pip install pypng

import pyqrcode

def qrcode(data):
    q = pyqrcode.create(data)
    q.png('QR Code.png', scale = 6)
    print("Qr code generated")

data="https://www.youtube.com/watch?v=mgvztGVhN-E"
qrcode(data)