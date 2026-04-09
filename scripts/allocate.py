import sys

def create_sparse_file(filepath: str, size_in_gb: float) -> None:
    """Instantly allocates a large file using OS-level sparse allocation."""
    # Calculate bytes: GB * 1024 (MB) * 1024 (KB) * 1024 (Bytes)
    size_in_bytes = int(size_in_gb * 1024 * 1024 * 1024)
    
    try:
        with open(filepath, "wb") as f:
            # Seek to the target size minus one byte to establish the OS-level boundary
            f.seek(size_in_bytes - 1)
            f.write(b"\0")
            
        print(f"Strategic allocation complete: '{filepath}' stands ready at {size_in_gb}GB.")
    except Exception as e:
        print(f"System Fault: Failed to allocate file. {e}")
        sys.exit(1)

if __name__ == "__main__":
    try:
        # Halt execution and wait for user parameter
        user_input = input("Specify target file size in GBs: ")
        
        # Validate and cast the input to a float for precise allocation
        target_size = float(user_input.strip())
        
        if target_size <= 0:
            print("Execution Failure: Size must be a positive value.")
            sys.exit(1)
            
        filename = f"{target_size}GB_dump.bin"
        
        # Execute instant allocation
        create_sparse_file(filename, target_size)
        
    except ValueError:
        print("Execution Failure: Invalid input. System requires a precise numerical value.")
        sys.exit(1)
    except KeyboardInterrupt:
        # Gracefully handle the user pressing Ctrl+C to abort
        print("\nOperation aborted by operator. Returning to high-leverage tasks.")
        sys.exit(0)