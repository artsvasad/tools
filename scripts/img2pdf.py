import os
from PIL import Image

def batch_convert_images_to_pdf():
    # 1. Define the image extensions we want to look for
    valid_extensions = {".jpg", ".jpeg", ".png", ".bmp", ".gif", ".webp"}
    converted_count = 0

    print("🔍 Scanning current directory for images...\n")

    # 2. Loop through every file in the current directory
    for filename in os.listdir('.'):
        # Split the filename into the name and the extension
        name, ext = os.path.splitext(filename)
        
        # 3. Check if the file is an image based on its extension
        if ext.lower() in valid_extensions:
            pdf_filename = f"{name}.pdf"
            
            # Optional: Skip if a PDF with the same name already exists
            if os.path.exists(pdf_filename):
                print(f"⏭️ Skipped: '{pdf_filename}' already exists.")
                continue

            try:
                # 4. Open and process the image
                with Image.open(filename) as img:
                    # PDFs do not support transparency/alpha channels well directly
                    if img.mode in ("RGBA", "P"):
                        img = img.convert("RGB")
                    
                    # 5. Save it as a PDF
                    img.save(pdf_filename, "PDF", resolution=100.0)
                
                print(f"✅ Converted: '{filename}' -> '{pdf_filename}'")
                converted_count += 1
                
            except Exception as e:
                print(f"❌ Failed to convert '{filename}': {e}")

    # 6. Final summary
    print(f"\n🎉 Done! Successfully converted {converted_count} image(s) to PDF.")

if __name__ == "__main__":
    batch_convert_images_to_pdf()