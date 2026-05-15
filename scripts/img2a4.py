import os
from PIL import Image

def batch_convert_to_a4_pdf():
    # Define A4 dimensions in standard PDF points (72 DPI)
    A4_WIDTH, A4_HEIGHT = 595, 842
    
    valid_extensions = {".jpg", ".jpeg", ".png", ".bmp", ".gif", ".webp"}
    converted_count = 0

    print("🔍 Scanning current directory for images to convert to A4 PDF...\n")

    for filename in os.listdir('.'):
        name, ext = os.path.splitext(filename)
        
        if ext.lower() in valid_extensions:
            pdf_filename = f"{name}.pdf"
            
            if os.path.exists(pdf_filename):
                print(f"⏭️ Skipped: '{pdf_filename}' already exists.")
                continue

            try:
                with Image.open(filename) as img:
                    # Convert to standard RGB 
                    img = img.convert("RGB")
                    
                    # 1. Calculate how much we need to scale the image so it fits on A4
                    img_w, img_h = img.size
                    scale_ratio = min(A4_WIDTH / img_w, A4_HEIGHT / img_h)
                    
                    # Prevent scaling up if the image is smaller than A4 (optional)
                    # If you want small images to stretch to A4 size, remove the next two lines
                    if scale_ratio > 1:
                        scale_ratio = 1
                        
                    new_size = (int(img_w * scale_ratio), int(img_h * scale_ratio))
                    
                    # 2. Resize the image smoothly
                    resized_img = img.resize(new_size, Image.Resampling.LANCZOS)
                    
                    # 3. Create a blank white A4 canvas
                    a4_canvas = Image.new('RGB', (A4_WIDTH, A4_HEIGHT), 'white')
                    
                    # 4. Calculate X and Y coordinates to center the image on the canvas
                    x_offset = (A4_WIDTH - new_size[0]) // 2
                    y_offset = (A4_HEIGHT - new_size[1]) // 2
                    
                    # 5. Paste the image onto the center of the A4 canvas
                    a4_canvas.paste(resized_img, (x_offset, y_offset))
                    
                    # 6. Save the canvas as a PDF
                    a4_canvas.save(pdf_filename, "PDF", resolution=72.0)
                
                print(f"✅ Converted to A4: '{filename}' -> '{pdf_filename}'")
                converted_count += 1
                
            except Exception as e:
                print(f"❌ Failed to convert '{filename}': {e}")

    print(f"\n🎉 Done! Successfully converted {converted_count} image(s) to A4 PDF.")

if __name__ == "__main__":
    batch_convert_to_a4_pdf()