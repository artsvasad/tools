import os, subprocess

def mirror():
    vids = [f for f in os.listdir('.') if f.endswith(('.mp4', '.avi', '.mov', '.mkv'))]
    if not vids: return
    
    if not os.path.exists('mirrored'): os.makedirs('mirrored')
    for v in vids:
        out = os.path.join('mirrored', f"mirrored_{v}")
        # -vf hflip flips horizontally; -c:a copy preserves original audio quality
        cmd = f'ffmpeg -i "{v}" -vf hflip -c:a copy "{out}" -y'
        subprocess.run(cmd, shell=True)
        print(f"Mirrored: {v}")

if __name__ == "__main__": mirror()