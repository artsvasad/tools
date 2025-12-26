from PIL import Image
import os

def convert_and_resize():
    files = os.listdir(".")
    
    # 1. Defined exclusion list for clarity
    excluded_files = {
        "pic.jpg", "pic.jpeg", 
        "sig.jpg", "sig.jpeg", 
        "f.pic.jpg", "f.pic.jpeg", 
        "m.pic.jpg", "m.pic.jpeg"
    }

    # Process standard images to PDF
    image_files = [
        f for f in files
        if f.lower().endswith((".jpg", ".jpeg"))
        and f not in excluded_files
    ]

    for img_file in image_files:
        try:
            with Image.open(img_file) as img:
                # remove extension and add .pdf
                new_name = os.path.splitext(img_file)[0] + ".pdf"
                img.convert("RGB").save(new_name)
                print(f"Converted {img_file} to PDF")
        except Exception as e:
            print(f"Error converting {img_file}: {e}")

    # 2. FIXED: Resize specific ID files
    # Map each specific file to its target size individually
    targets = {
        "f.pic.jpg": (300, 300),
        "m.pic.jpg": (300, 300),
        "pic.jpg":   (300, 300),
        "sig.jpg":   (300, 100)
    }

    for name, size in targets.items():
        if os.path.exists(name):
            try:
                with Image.open(name) as img:
                    # using LANCZOS for better quality resizing
                    img = img.resize(size, Image.Resampling.LANCZOS)
                    img.save(name)
                    print(f"Resized {name} to {size}")
            except Exception as e:
                print(f"Error resizing {name}: {e}")
        else:
            print(f"Skipping {name} (Not found)")

if __name__ == "__main__":
    convert_and_resize()