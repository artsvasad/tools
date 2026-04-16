import os
import fitz
import concurrent.futures
from multiprocessing import cpu_count

def process_page(args):
    """
    Atomic worker function for parallel page extraction.
    Ensures data isolation and prevents memory leaks.
    """
    pdf_path, page_num, mat, output_folder = args
    try:
        # Re-opening the doc in each process is safer for memory and thread-safety
        doc = fitz.open(pdf_path)
        page = doc.load_page(page_num)
        
        # High-fidelity rendering
        pix = page.get_pixmap(matrix=mat, alpha=False)
        
        pdf_name = os.path.splitext(os.path.basename(pdf_path))[0]
        target_name = f"{pdf_name}_page_{page_num + 1}.jpg"
        out_path = os.path.join(output_folder, target_name)
        
        pix.save(out_path)
        doc.close()
        return True
    except Exception as e:
        return f"Error on {pdf_path} page {page_num}: {e}"

def convert_pdf_to_jpeg_optimized():
    # Target all PDFs in the execution directory
    pdfs = [f for f in os.listdir('.') if f.lower().endswith(".pdf")]
    
    if not pdfs:
        print("[!] No PDF files found.")
        return

    output_folder = "pdf_images_high_speed"
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Resolution Matrix: 300 DPI calculation
    zoom = 300.0 / 72.0
    mat = fitz.Matrix(zoom, zoom)

    # Prepare task queue
    tasks = []
    for pdf_file in pdfs:
        doc = fitz.open(pdf_file)
        for page_num in range(len(doc)):
            tasks.append((pdf_file, page_num, mat, output_folder))
        doc.close()

    print(f"[*] Dispatching {len(tasks)} pages across {cpu_count()} CPU cores...")

    # Maximum Power Execution: Using ProcessPoolExecutor to bypass GIL
    # We use cpu_count() to ensure we are saturating the hardware without crashing
    with concurrent.futures.ProcessPoolExecutor(max_workers=cpu_count()) as executor:
        results = list(executor.map(process_page, tasks))

    # Reviewing execution integrity
    errors = [r for r in results if r is not True]
    if not errors:
        print(f"[+] Success: All pages converted with maximum leverage.")
    else:
        for err in errors:
            print(f"[-] Execution Gap: {err}")

if __name__ == "__main__":
    convert_pdf_to_jpeg_optimized()