import argparse
import numpy as np
from PIL import Image, ImageDraw

# declare global variable
xc_cords = []
yc_cords = []

# input arguments
arg = argparse.ArgumentParser()
arg.add_argument("-i", "--input", required = True, help = "input file path")
arg.add_argument("-o", "--output", required = True, help = "output file name")
arg.add_argument("-x", "--xcord", required = True,  help = "x coordinates")
arg.add_argument("-y", "--ycord", required = True, help = "y coordinates")
args = vars(arg.parse_args())

# read an image
im = Image.open(args["input"]).convert("RGBA")
imArray = np.asarray(im) # convert to numpy (for convenience)

# set xc
for cord in args["xcord"].split(",") :
    xc_cords.append(float(cord))
left = int(min(xc_cords))
right = int(max(xc_cords))

# set yc
for cord in args["ycord"].split(",") :
    yc_cords.append(float(cord))
top = int(min(yc_cords))
bottom = int(max(yc_cords))

# set xy cords for cropping
width = left+(right-left)
height = top+(bottom-top)
xycrop = zip(xc_cords, yc_cords)

# create mask
maskIm = Image.new('L', (imArray.shape[1], imArray.shape[0]), 0)
ImageDraw.Draw(maskIm).polygon(xycrop, outline=1, fill=1)
mask = np.array(maskIm)
newImArray = np.empty(imArray.shape,dtype='uint8') #assemble new image (uint8: 0-255)
newImArray[:,:,:3] = imArray[:,:,:3] #colors (three first columns, RGB)
newImArray[:,:,3] = mask*255 # transparency (4th column)

# back to image by numpy
newIm = Image.fromarray(newImArray, "RGBA")
newIm.save(args["output"], "png")

# resize to fit cropped areas
cropImg = Image.open(args["output"]).convert("RGBA")
img = cropImg.crop((left, top, width, height))
img.save(args["output"], "png")
