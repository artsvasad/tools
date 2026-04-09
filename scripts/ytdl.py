import os
import tkinter as tk
from tkinter import simpledialog, messagebox
import subprocess

def main():
    root = tk.Tk()
    root.withdraw()

    url = simpledialog.askstring("Sovereign Archive", "Enter Target URL:")
    if not url:
        return

    # Scope Matrix
    target_prompt = (
        "Select Target Scope:\n\n"
        "1. Entire Channel (Strict Archiving)\n"
        "2. Playlist (Strict Archiving)\n"
        "3. Single Video (Direct Ingestion)"
    )
    t_choice = simpledialog.askstring("Scope Matrix", target_prompt)
    if t_choice not in ["1", "2", "3"]:
        return

    # Quality Matrix: Upgraded for 8K and Strategic Fidelity
    quality_prompt = (
        "Select Extraction Protocol:\n\n"
        "1. Ultra-Fidelity (8K Unlocked + Subtitles) [RESOURCE HEAVY]\n"
        "2. Maximum Efficiency (1080p Cap + Subtitles) [RECOMMENDED]\n"
        "3. Legacy Video (3GP)\n"
        "4. Audio Extraction (MP3)\n"
        "5. Audio Extraction (M4A)"
    )
    q_choice = simpledialog.askstring("Quality Matrix", quality_prompt)
    if q_choice not in ["1", "2", "3", "4", "5"]:
        return

    # Base configuration
    cmd = ['yt-dlp', '--embed-metadata']

    # Dynamic Output Architecture based on Scope
    if t_choice in ["1", "2"]:
        cmd.extend(['--download-archive', 'Sovereign_Archive_Ledger.txt'])
        if t_choice == "1":
            cmd.extend(['-o', 'Sovereign_Vault/Channels/%(uploader)s/%(title)s_%(id)s.%(ext)s'])
        else:
            cmd.extend(['-o', 'Sovereign_Vault/Playlists/%(playlist)s/%(title)s_%(id)s.%(ext)s'])
    else:
        cmd.extend(['-o', 'Sovereign_Vault/Singles/%(title)s_%(id)s.%(ext)s'])

    # Format and Feature Injection
    if q_choice in ["4", "5"]:
        audio_fmt = "mp3" if q_choice == "4" else "m4a"
        cmd.extend(['-f', 'ba/b', '-x', '--audio-format', audio_fmt, url])
        ext_msg = f"Audio ({audio_fmt.upper()})"
        
    elif q_choice == "3":
        cmd.extend(['-f', 'best[ext=3gp]/bestvideo[ext=3gp]+bestaudio[ext=m4a]/best', url])
        ext_msg = "Video (3GP)"
        
    else:
        # ---------------------------------------------------------
        # ADVANCED FEATURES: Subtitles & FFmpeg Merging Protocol
        # ---------------------------------------------------------
        cmd.extend([
            '--write-subs',         # Download subtitles
            '--embed-subs',         # Inject into MKV/MP4 container
            '--sub-langs', 'en,bn', # Target English and Bengali
            '--compat-options', 'no-keep-subs' # Clean up standalone subtitle files after embedding
        ])
        
        format_prompt = "Select Archival Container:\n\n1. MKV (Lossless Subtitle Embedding - Recommended)\n2. MP4 (Compatibility)"
        f_choice = simpledialog.askstring("Container Matrix", format_prompt)
        container = "mkv" if f_choice == "1" else "mp4"
        
        # 8K uses bv* (best video of any resolution). Efficiency caps at 1080p.
        format_code = "bv*+ba/b" if q_choice == "1" else "bv*[height<=1080]+ba/b"
        cmd.extend(['-f', format_code, '--merge-output-format', container, url])
        
        ext_msg = f"Ultra-Fidelity ({container.upper()})" if q_choice == "1" else f"Efficiency ({container.upper()})"

    print(f"\n[+] Initiating {ext_msg} pipeline...")
    messagebox.showinfo("Execution", "Pipeline initiated. Check PowerShell terminal for FFmpeg merge status.")
    
    try:
        subprocess.run(cmd, check=True)
        print("\n[+] Extraction and Embedding Complete. Assets secured.")
    except subprocess.CalledProcessError:
        print("\n[-] Extraction Failed. Verify FFmpeg is installed and your network is stable.")

if __name__ == "__main__":
    main()