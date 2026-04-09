import os
import sys
import yt_dlp
import ffmpeg

def print_header():
    print("\n================================================")
    print("          SOVEREIGN ARCHIVE INGESTION           ")
    print("================================================\n")

def get_input(prompt, valid_options=None):
    while True:
        choice = input(prompt).strip()
        if not valid_options or choice in valid_options:
            return choice
        print("[-] Invalid input. Re-engage.")

def execute_pipeline():
    print_header()
    
    url = input("[>] Enter Target URL: ").strip()
    if not url:
        print("[-] Abort: Target URL required.")
        sys.exit(1)

    print("\n[ Target Scope Matrix ]")
    print("  1. Entire Channel (Strict Archiving)")
    print("  2. Playlist (Strict Archiving)")
    print("  3. Single Video (Direct Ingestion)")
    t_choice = get_input("[>] Select Scope (1-3): ", ["1", "2", "3"])

    print("\n[ Extraction Protocol ]")
    print("  1. Ultra-Fidelity (8K Unlocked + Subtitles) [RESOURCE HEAVY]")
    print("  2. Maximum Efficiency (1080p Cap + Subtitles) [RECOMMENDED]")
    print("  3. Legacy Video (3GP)")
    print("  4. Audio Extraction (MP3)")
    print("  5. Audio Extraction (M4A)")
    q_choice = get_input("[>] Select Protocol (1-5): ", ["1", "2", "3", "4", "5"])

    # Base Configuration Options for yt-dlp
    ydl_opts = {
        'writethumbnail': True,
        'embed_metadata': True,
        'quiet': False,
        'no_warnings': True,
    }

    # Dynamic Output Architecture
    if t_choice in ["1", "2"]:
        ydl_opts['download_archive'] = 'Sovereign_Archive_Ledger.txt'
        if t_choice == "1":
            ydl_opts['outtmpl'] = 'Sovereign_Vault/Channels/%(uploader)s/%(title)s_%(id)s.%(ext)s'
        else:
            ydl_opts['outtmpl'] = 'Sovereign_Vault/Playlists/%(playlist)s/%(title)s_%(id)s.%(ext)s'
    else:
        ydl_opts['outtmpl'] = 'Sovereign_Vault/Singles/%(title)s_%(id)s.%(ext)s'

    # Format Injection and Post-Processing
    if q_choice in ["4", "5"]:
        audio_fmt = "mp3" if q_choice == "4" else "m4a"
        ydl_opts.update({
            'format': 'ba/b',
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': audio_fmt,
                'preferredquality': '192',
            }]
        })
        ext_msg = f"Audio ({audio_fmt.upper()})"

    elif q_choice == "3":
        ydl_opts['format'] = 'best[ext=3gp]/bestvideo[ext=3gp]+bestaudio[ext=m4a]/best'
        ext_msg = "Video (3GP)"

    else:
        print("\n[ Container Matrix ]")
        print("  1. MKV (Lossless Subtitle Embedding - Recommended)")
        print("  2. MP4 (Compatibility)")
        f_choice = get_input("[>] Select Container (1-2): ", ["1", "2"])
        container = "mkv" if f_choice == "1" else "mp4"

        format_code = "bv*+ba/b" if q_choice == "1" else "bv*[height<=1080]+ba/b"
        
        ydl_opts.update({
            'format': format_code,
            'merge_output_format': container,
            'writesubtitles': True,
            'subtitleslangs': ['en', 'bn'],
            'postprocessors': [
                {'key': 'FFmpegEmbedSubtitle'},
                {'key': 'FFmpegMetadata'},
            ]
        })
        ext_msg = f"Ultra-Fidelity ({container.upper()})" if q_choice == "1" else f"Efficiency ({container.upper()})"

    print(f"\n[+] Initiating {ext_msg} pipeline natively...")

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
        print("\n[+] Extraction Complete. Assets secured within the Vault.")
    except yt_dlp.utils.DownloadError as e:
        print(f"\n[-] Ingestion Failure: {e}")
    except Exception as e:
        print(f"\n[-] Critical System Error: {e}")

if __name__ == "__main__":
    execute_pipeline()