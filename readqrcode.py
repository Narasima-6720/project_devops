import cv2
def qrread(image):
    img=cv2.imread(image)
    detector=cv2.QRCodeDetector()
    data , bbox , _ = detector.detectAndDecode(img)
    return data
print(qrread('QR Code.png'))
