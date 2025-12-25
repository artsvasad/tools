import cv2
import os
from concurrent.futures import ThreadPoolExecutor

def extract():
    video = next((f for f in os.listdir('.') if f.endswith(('.mp4', '.avi', '.mov'))), None)
    if not video: return
    
    if not os.path.exists('frames'): os.makedirs('frames')
    cap = cv2.VideoCapture(video)
    count = 0
    
    with ThreadPoolExecutor() as exe:
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret: break
            path = os.path.join('frames', f"f_{str(count).zfill(5)}.png")
            exe.submit(cv2.imwrite, path, frame, [cv2.IMWRITE_PNG_COMPRESSION, 0])
            count += 1
    cap.release()
    print(f"Extracted {count} frames.")

if __name__ == "__main__": extract()