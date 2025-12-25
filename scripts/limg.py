import os
from PIL import Image
from concurrent.futures import ThreadPoolExecutor

def process_img(file_path, factor=5.0):
    try:
        with Image.open(file_path) as img:
            new_size = (int(img.width * factor), int(img.height * factor))
            img.resize(new_size, Image.LANCZOS).save(os.path.join("resized", os.path.basename(file_path)))
            print(f"Resized: {os.path.basename(file_path)}")
    except Exception as e: print(f"Error {file_path}: {e}")

def main():
    if not os.path.exists("resized"): os.makedirs("resized")
    files = [f for f in os.listdir('.') if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    with ThreadPoolExecutor() as exe:
        exe.map(process_img, files)

if __name__ == "__main__": main()