import os
from PIL import Image

def convert_png_to_jpeg():
    # Only look for PNGs in the current directory
    files = [f for f in os.listdir('.') if f.lower().endswith(".png")]
    
    if not files:
        print("No PNG files found.")
        return

    # Output folder to keep the workspace clean
    output_folder = "output_images"
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    for filename in files:
        try:
            with Image.open(filename) as img:
                # JPEGs do not support transparency; convert to RGB
                if img.mode in ('RGBA', 'P'):
                    img = img.convert('RGB')
                
                target_name = os.path.splitext(filename)[0] + ".jpeg"
                img.save(os.path.join(output_folder, target_name), "JPEG")
                print(f"Converted: {filename} -> {target_name}")
        except Exception as e:
            print(f"Error converting {filename}: {e}")

if __name__ == "__main__":
    convert_png_to_jpeg()