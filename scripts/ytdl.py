import os
import tkinter as tk
from tkinter import simpledialog, messagebox
import subprocess
import sys

def main():
    # Initialize hidden root for UI dialogues
    root = tk.Tk()
    root.withdraw()

    url = simpledialog.askstring("Sovereign Archive", "Enter Target URL (Channel/Playlist/Video):")
    if not url:
        return

    quality_prompt = (
        "Select Extraction Protocol:\n\n"
        "1. Maximum Fidelity (Best Video + Audio)\n"
        "2. Standard Definition (1080p Cap)\n"
        "3. Audio Extraction Only (MP3)"
    )
    q_choice = simpledialog.askstring("Quality Matrix", quality_prompt)

    if q_choice not in ["1", "2", "3"]:
        print("[-] Invalid or canceled selection.")
        return

    # Base configuration ensuring stateful archiving and strict folder structure
    cmd = [
        'yt-dlp',
        '--download-archive', 'Sovereign_Archive_Ledger.txt',
        '--embed-metadata',
        '--embed-thumbnail',
        '-o', 'Sovereign_Vault/%(uploader)s/%(title)s_%(id)s.%(ext)s'
    ]

    if q_choice == "3":
        cmd.extend(['-f', 'ba/b', '-x', '--audio-format', 'mp3', url])
        ext_msg = "Audio (MP3)"
    else:
        format_prompt = "Select Archival Container:\n\n1. MKV (Lossless Merging - Recommended)\n2. MP4 (Maximum Compatibility)"
        f_choice = simpledialog.askstring("Container Matrix", format_prompt)
        
        container = "mkv" if f_choice == "1" else "mp4"
        format_code = "bv*+ba/b" if q_choice == "1" else "bv*[height<=1080]+ba/b"
        
        cmd.extend(['-f', format_code, '--merge-output-format', container, url])
        ext_msg = f"Video ({container.upper()})"

    print(f"\n[+] Initiating {ext_msg} extraction pipeline...")
    messagebox.showinfo("Execution", "Pipeline initiated. Monitor the PowerShell console for progress.")
    
    try:
        subprocess.run(cmd, check=True)
        print("\n[+] Extraction Complete. Assets secured in Sovereign_Vault.")
    except subprocess.CalledProcessError:
        print("\n[-] Extraction Failed. Verify network stability and yt-dlp installation.")

if __name__ == "__main__":
    main()