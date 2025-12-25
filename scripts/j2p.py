from PIL import Image
import os

def convert_and_resize():
    files = os.listdir('.')
    # Process standard images to PDF
    image_files = [f for f in files if f.lower().endswith(('.jpg', '.jpeg')) and f not in ['pic.jpg', 'pic.jpeg', 'sig.jpg', 'sig.jpeg', 'f.pic.jpg', 'f.pic.jpeg', 'm.pic.jpg', 'm.pic.jpeg']]
    
    for img_file in image_files:
        try:
            with Image.open(img_file) as img:
                img.convert('RGB').save(img_file.rsplit('.', 1)[0] + '.pdf')
                print(f"Converted {img_file} to PDF")
        except Exception as e: print(f"Error: {e}")

    # Resize specific ID files
    targets = {'pic.jpg': (300, 300), 'sig.jpg': (300, 100)}
    for name, size in targets.items():
        if os.path.exists(name):
            with Image.open(name) as img:
                img.resize(size).save(name)
                print(f"Resized {name} to {size}")

if __name__ == "__main__":
    convert_and_resize()