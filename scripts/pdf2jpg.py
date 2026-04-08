import os
import fitz  # PyMuPDF

def convert_pdf_to_jpeg():
    # Target all PDFs in the execution directory
    pdfs = [f for f in os.listdir('.') if f.lower().endswith(".pdf")]
    
    if not pdfs:
        print("No PDF files found in the current directory.")
        return

    # Isolate outputs to maintain a clean workspace
    output_folder = "pdf_images"
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Calculate transformation matrix for 300 DPI high-quality output
    # Native PDF resolution is 72 DPI. (300 / 72 = 4.1666...)
    zoom = 300.0 / 72.0
    mat = fitz.Matrix(zoom, zoom)

    for pdf_file in pdfs:
        print(f"[*] Processing high-fidelity extraction for: {pdf_file}")
        try:
            doc = fitz.open(pdf_file)
            for page_num in range(len(doc)):
                page = doc.load_page(page_num)
                # Render the page to a pixel map (alpha=False ensures white background, no transparency)
                pix = page.get_pixmap(matrix=mat, alpha=False)
                
                target_name = f"{os.path.splitext(pdf_file)[0]}_page_{page_num + 1}.jpg"
                out_path = os.path.join(output_folder, target_name)
                
                pix.save(out_path)
            print(f"[+] Success: {pdf_file} converted.")
        except Exception as e:
            print(f"[-] Systemic error converting {pdf_file}: {e}")

if __name__ == "__main__":
    convert_pdf_to_jpeg()