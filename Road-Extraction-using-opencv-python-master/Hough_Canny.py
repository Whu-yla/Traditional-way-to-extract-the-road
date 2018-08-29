from skimage import data, io, filters, morphology, img_as_ubyte

import cv2
import numpy as np
from matplotlib import pyplot as plt

#Read and display Image (Change path as per your computer)

img = cv2.imread('/Users/Sumanth/Desktop/GIS/neighborhood.tiff')
ing = cv2.imread('/Users/Sumanth/Desktop/GIS/edge.tiff')
cv2.imshow(' Image',img)
cv2.waitKey(0)
#img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY);

edges = cv2.Canny(img,50,150,apertureSize = 3)

cv2.imshow('Edges ', edges)
cv2.waitKey(0)
#cv2.imwrite('Python_Edges.tif',edges)

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
    cv2.line(ing,(x1,y1),(x2,y2),(0,0,255),2)
    
cv2.imshow(' Hough Line Detection', edges)
cv2.waitKey(0)


