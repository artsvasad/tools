import sys
from pathlib import Path
import concurrent.futures
from multiprocessing import cpu_count

# Elite Dependency Audit
try:
    import fitz
    from tqdm import tqdm
except ImportError as e:
    print(f"\n[!] Systemic Failure: Missing dependency -> {e.name}")
    print("[!] Ensure deployment via Sovereign Launcher (run.ps1) with correct dependencies: PyMuPDF tqdm")
    sys.exit(1)

def extract_page(args_tuple):
    """Atomic worker function utilizing GIL-released thread execution."""
    pdf_path, page_num, zoom_factor, output_dir = args_tuple
    try:
        # Isolated read operation per thread
        doc = fitz.open(str(pdf_path))
        page = doc.load_page(page_num)
        
        # High-fidelity rendering (Sovereign Standard: 300 DPI)
        mat = fitz.Matrix(zoom_factor, zoom_factor)
        pix = page.get_pixmap(matrix=mat, alpha=False)
        
        target_name = f"{pdf_path.stem}_page_{page_num + 1}.jpg"
        out_path = output_dir / target_name
        
        pix.save(str(out_path))
        doc.close()
        return (True, None)
    except Exception as e:
        return (False, f"Target: {pdf_path.name} | Page {page_num + 1} | Error: {str(e)}")

def execute_sovereign_extraction():
    workspace = Path('.')
    pdfs = list(workspace.glob("*.pdf"))
    
    if not pdfs:
        print("[-] Zero PDF assets detected in current workspace.")
        return

    output_dir = workspace / "pdf_images_high_speed"
    output_dir.mkdir(exist_ok=True)

    # Standardize scale: 300 DPI
    zoom_factor = 300.0 / 72.0
    tasks = []

    print("[+] Auditing PDF assets for parallel thread deployment...")
    for pdf in pdfs:
        try:
            # Pre-flight check to secure page counts rapidly
            doc = fitz.open(str(pdf))
            page_count = len(doc)
            doc.close()
            for page_num in range(page_count):
                tasks.append((pdf, page_num, zoom_factor, output_dir))
        except Exception as e:
            print(f"[-] Asset Corruption Detected ({pdf.name}): {e}")

    total_tasks = len(tasks)
    if total_tasks == 0:
        return

    # Hyper-threading allocation (C-extension allows 2x core count safely)
    optimal_threads = cpu_count() * 2
    print(f"[*] Saturating hardware... Dispatching {total_tasks} operations across {optimal_threads} threads.")

    success_count = 0
    error_logs = []

    # ThreadPoolExecutor is vastly superior here due to PyMuPDF GIL release.
    with concurrent.futures.ThreadPoolExecutor(max_workers=optimal_threads) as executor:
        futures = [executor.submit(extract_page, task) for task in tasks]
        
        with tqdm(total=total_tasks, desc="Extraction Velocity", unit="pg", colour="green") as pbar:
            for future in concurrent.futures.as_completed(futures):
                success, error_msg = future.result()
                if success:
                    success_count += 1
                else:
                    error_logs.append(error_msg)
                pbar.update(1)

    print(f"\n[+] Operation Terminated. Yield: {success_count}/{total_tasks} pages secured.")
    
    if error_logs:
        print(f"\n[!] Systemic Gaps Detected ({len(error_logs)}):")
        for err in error_logs:
            print(f"    - {err}")

if __name__ == "__main__":
    execute_sovereign_extraction()