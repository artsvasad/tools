import os, requests, time, urllib3
from concurrent.futures import ThreadPoolExecutor

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def download_to_ram(url, session):
    try:
        r = session.get(url, stream=True, timeout=15, verify=False)
        return len(r.content) # Keeps content in RAM during the cycle
    except: return 0

def main():
    url = input("Enter URL: ").strip()
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})
    
    while True:
        print(f"Cycle starting... Downloading 9999 instances to RAM.")
        with ThreadPoolExecutor(max_workers=9999) as exe:
            results = list(exe.map(lambda u: download_to_ram(u, session), [url]*9999))
        
        print(f"Cycle Complete. Total RAM processed: {sum(results)} bytes.")
        time.sleep(1)

if __name__ == "__main__": main()
