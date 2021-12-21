import argparse
import pytesseract
import cv2
import numpy as np

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("video")
  args = parser.parse_args()
  capture = cv2.VideoCapture(args.video)
  ok,frame = capture.read()
  count=0
  while ok:
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    text = pytesseract.image_to_string(frame)
    _,val=text.strip().split('=')
    assert(count == int(val))
    ok,frame = capture.read()
    count+=1
    if count % 100 == 0:
      print(f"Processed {count} frames")



if __name__=="__main__":
  main()