from skimage import data, io, filters, morphology, img_as_ubyte

from cv2wrap import cv2
import numpy as np
from matplotlib import pyplot as plt

#Read and display Image (Change path as per your computer)

imag = cv2.imread('/Users/a10.11.5/Downloads/Road-Extraction-using-opencv-python-master/Image_Pics')
cv2.imshow(' Image',imag)
cv2.waitKey(0)

#COnvert to Grey, Binary

img = cv2.cvtColor(imag, cv2.COLOR_RGB2GRAY);


 
_ , img = cv2.threshold(img,100,255,cv2.THRESH_BINARY)
cv2.imshow('Binary Image',img)
cv2.waitKey(0)



# Expel objects with small sizes



img = morphology.binary_erosion(img,morphology.diamond(1))
img = img_as_ubyte(img)
cv2.imshow('Eroded Image', img)
cv2.waitKey(0)

img = morphology.binary_opening(img)
img = img_as_ubyte(img)
cv2.imshow('Opened Image', img)
cv2.waitKey(0) 

element = cv2.getStructuringElement(cv2.MORPH_CROSS, (3,3))
img = cv2.erode(img, element, iterations =10)
img = cv2.dilate(img, element, iterations =10)


ing = morphology.remove_small_objects(img,min_size=200,connectivity=2, in_place=True)
cv2.imshow('Remove Objects ',ing)


# Canny Detection

edges = cv2.Canny(ing,30,20)

cv2.imshow('Edges ', edges)
cv2.waitKey(0)
cv2.imwrite('Python_Edges.tif',edges)

# COntour Detection

#contours,hierarchy = cv2.findContours(edges, 1, 2)
#cnt = contours[0]

#hull = cv2.convexHull(cnt,returnPoints = False)
#cv2.imshow('COntour ', hull)
#cv2.waitKey(0)
#Line Detection using Hough Trnasform

lines = cv2.HoughLines(edges,1,np.pi/180,200)

for rho,theta in lines[0]:
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a*rho
    y0 = b*rho
    x1 = int(x0 + 1000*(-b))
    y1 = int(y0 + 1000*(a))
    x2 = int(x0 - 1000*(-b))
    y2 = int(y0 - 1000*(a))

cv2.line(edges,(x1,y1),(x2,y2),(255),2)
cv2.imshow(' Hough Line Detection', edges)
cv2.waitKey(0)

# Finding contours and CUrves

ret,thresh = cv2.threshold(imag,127,255,THRESH_GRAY)
print thresh.dtype
image,contours,hierarchy = cv2.findContours(thresh, 1, 2)
cnt = contours[0]
epsilon = 0.1*cv2.arcLength(cnt,True)
approx = cv2.approxPolyDP(cnt,epsilon,True)
cv2.imshow('COntour ', approx)
cv2.waitKey(0)

