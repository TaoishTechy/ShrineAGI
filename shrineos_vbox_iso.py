#!/usr/bin/env python3
import os
import shutil
import subprocess
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import platform
import time
import psutil
import re
import git  # For Git operations (install with `pip install GitPython`)
import sys  # For system-specific paths

try:
    from PIL import Image, ImageTk
except ImportError:
    print("Error: Pillow library is required. Install with: pip install Pillow")
    exit(1)

try:
    import git
except ImportError:
    print("Error: GitPython library is required. Install with: pip install GitPython")
    exit(1)

class TempleOSFusion:
    VERSION = "2.0.9" # Updated version to reflect changes and clarifications
    def __init__(self, root):
        self.root = root
        self.root.title("TempleOS Fusion Creator")
        self.root.geometry("800x700") # Increased height for new UI elements
        self.last_update_time = time.time()
        
        # Paths for the new workflow
        # The main repo is now TOS-AGI, but cloning it is primarily for reference.
        # The script still relies on a *pre-built* TempleOS C/ directory.
        self.templeos_repo_path = os.path.join(os.getcwd(), "TOS-AGI-git") # Cloned repo (source)
        self.templeos_build_output_path = "" # Path to the C/ directory from a *booted* TempleOS build
        self.additions_path = ""
        self.output_path = ""
        self.iso_label = "TempleOS_Fused"
        
        self.setup_ui()
        print(f"--- Application Initialized (v{self.VERSION}) ---")
        print(f"TempleOS AGI repository target path: {self.templeos_repo_path}")

    def setup_ui(self):
        # Header Frame
        header_frame = tk.Frame(self.root, bg="#2c3e50")
        header_frame.pack(fill="x")
        
        try:
            # Attempt to load logo, fallback to placeholder if not found or error
            if os.path.exists("templeos_logo.png"):
                img = Image.open("templeos_logo.png")
                img = img.resize((100, 50), Image.LANCZOS)
                self.logo = ImageTk.PhotoImage(img)
                logo_label = tk.Label(header_frame, image=self.logo, bg="#2c3e50")
                logo_label.pack(side="left", padx=10)
            else:
                self.logo = ImageTk.PhotoImage(Image.new('RGB', (100, 50), color='red'))
                logo_label = tk.Label(header_frame, image=self.logo, bg="#2c3e50")
                logo_label.pack(side="left", padx=10)
        except Exception as e:
            print(f"Error loading logo: {str(e)}. Using placeholder.")
            self.logo = ImageTk.PhotoImage(Image.new('RGB', (100, 50), color='red'))
            logo_label = tk.Label(header_frame, image=self.logo, bg="#2c3e50")
            logo_label.pack(side="left", padx=10)
        
        title_label = tk.Label(header_frame, text=f"TempleOS Fusion Creator v{self.VERSION}", font=("Arial", 16, "bold"), fg="white", bg="#2c3e50")
        title_label.pack(side="left", padx=10)

        # Main Frame for content
        main_frame = tk.Frame(self.root)
        main_frame.pack(fill="both", expand=True, padx=20, pady=20)

        # Instructions Frame
        instructions_frame = tk.LabelFrame(main_frame, text="Important: TempleOS Build Instructions", font=("Arial", 10, "bold"), fg="#c0392b")
        instructions_frame.pack(fill="x", pady=5)
        instructions_text = """
To build a TempleOS ISO, you MUST first:
1. Download 'TOS_Distro.ISO' from https://templeos.org/Downloads/TOS_Distro.ISO
2. Boot it in a virtual machine (e.g., QEMU, VirtualBox).
3. Inside TempleOS, run 'C/Make.HC' or 'C/DoDistro.HC' to build the OS structure.
4. Copy the *entire resulting 'C/' directory* from the VM back to your host machine.
   This 'C/' directory will contain 'ISOLINUX', 'BIN', 'ADAM', etc.
5. Select the copied 'C/' directory below as 'Pre-Built TempleOS Directory'.
        """
        tk.Label(instructions_frame, text=instructions_text, justify="left", wraplength=700).pack(anchor="w", padx=5, pady=5)


        # Pre-Built TempleOS Directory Selection
        templeos_build_frame = tk.LabelFrame(main_frame, text="Pre-Built TempleOS Directory", font=("Arial", 10, "bold"))
        templeos_build_frame.pack(fill="x", pady=5)
        tk.Label(templeos_build_frame, text="Select the 'C/' directory from your TempleOS VM build:").pack(anchor="w")
        self.templeos_build_entry = tk.Entry(templeos_build_frame, width=70)
        self.templeos_build_entry.pack(side="left", fill="x", expand=True, padx=5)
        tk.Button(templeos_build_frame, text="Browse", command=self.browse_templeos_build_output).pack(side="right", padx=5)


        # Additional Scripts Directory Selection
        add_frame = tk.LabelFrame(main_frame, text="Additional Scripts", font=("Arial", 10, "bold"))
        add_frame.pack(fill="x", pady=5)
        tk.Label(add_frame, text="Select directory containing your custom HolyC scripts (.HC files):").pack(anchor="w")
        self.add_entry = tk.Entry(add_frame, width=70)
        self.add_entry.pack(side="left", fill="x", expand=True, padx=5)
        tk.Button(add_frame, text="Browse", command=self.browse_additions).pack(side="right", padx=5)

        # Output Configuration
        out_frame = tk.LabelFrame(main_frame, text="Output Configuration", font=("Arial", 10, "bold"))
        out_frame.pack(fill="x", pady=5)
        
        tk.Label(out_frame, text="Output ISO filename:").grid(row=0, column=0, sticky="w")
        self.iso_entry = tk.Entry(out_frame, width=30)
        self.iso_entry.insert(0, "TempleOS_Fused")
        self.iso_entry.grid(row=0, column=1, sticky="w", padx=5)
        
        tk.Label(out_frame, text="Output directory:").grid(row=1, column=0, sticky="w")
        self.out_entry = tk.Entry(out_frame, width=70)
        self.out_entry.grid(row=1, column=1, sticky="w", padx=5)
        tk.Button(out_frame, text="Browse", command=self.browse_output).grid(row=1, column=2, padx=5)

        # Progress and Status
        self.progress = ttk.Progressbar(main_frame, orient="horizontal", length=400, mode="determinate")
        self.progress.pack(pady=20)
        self.status = tk.Label(main_frame, text="Ready", fg="blue")
        self.status.pack()

        # Buttons
        btn_frame = tk.Frame(main_frame)
        btn_frame.pack(pady=10)
        tk.Button(btn_frame, text="Create Fusion ISO", command=self.create_fusion, bg="#27ae60", fg="white", font=("Arial", 10, "bold")).pack(side="left", padx=10)
        tk.Button(btn_frame, text="Exit", command=self.root.quit, bg="#e74c3c", fg="white", font=("Arial", 10, "bold")).pack(side="right", padx=10)

    def browse_additions(self):
        """Opens a directory dialog for selecting the additional scripts."""
        path = filedialog.askdirectory(title="Select Additional Scripts Directory")
        if path:
            self.additions_path = path
            self.add_entry.delete(0, tk.END)
            self.add_entry.insert(0, path)
            print(f"Selected additions path: {self.additions_path}")

    def browse_output(self):
        """Opens a directory dialog for selecting the output directory."""
        path = filedialog.askdirectory(title="Select Output Directory")
        if path:
            self.output_path = path
            self.out_entry.delete(0, tk.END)
            self.out_entry.insert(0, path)
            print(f"Selected output path: {self.output_path}")

    def browse_templeos_build_output(self):
        """Opens a directory dialog for selecting the pre-built TempleOS 'C/' directory."""
        path = filedialog.askdirectory(title="Select Pre-Built TempleOS C/ Directory")
        if path:
            self.templeos_build_output_path = path
            self.templeos_build_entry.delete(0, tk.END)
            self.templeos_build_entry.insert(0, path)
            print(f"Selected pre-built TempleOS output path: {self.templeos_build_output_path}")

    def update_progress(self, value, message):
        """Updates the progress bar and status message in the UI."""
        self.progress['value'] = value
        self.status.config(text=message)
        # Update UI more frequently during long operations without freezing
        if (time.time() - self.last_update_time) > 0.1:
            self.root.update_idletasks()
            self.last_update_time = time.time()
        self.root.update_idletasks() # Ensure final update is rendered
        print(f"Progress ({value}%): {message}")

    def cleanup(self):
        """Placeholder for cleanup. No temp dir cleanup needed for cloned repo."""
        print("Cleanup function called. No temporary directory cleanup needed for TOS-AGI-git or build output.")

    def validate_paths(self):
        """Validates all necessary paths provided by the user."""
        self.additions_path = self.add_entry.get().strip()
        self.output_path = self.out_entry.get().strip()
        self.templeos_build_output_path = self.templeos_build_entry.get().strip()

        print(f"Validating paths: Pre-Built TempleOS='{self.templeos_build_output_path}', Additions='{self.additions_path}', Output='{self.output_path}'")

        if not all([self.templeos_build_output_path, self.additions_path, self.output_path]):
            messagebox.showerror("Error", "Please select all required paths (Pre-Built TempleOS, Additional Scripts, Output)!")
            return False
        
        # Convert to absolute paths for consistency
        self.templeos_build_output_path = os.path.abspath(self.templeos_build_output_path)
        self.additions_path = os.path.abspath(self.additions_path)
        self.output_path = os.path.abspath(self.output_path)

        print(f"Absolute pre-built TempleOS path: {self.templeos_build_output_path}")
        print(f"Absolute additions path: {self.additions_path}")
        print(f"Absolute output path: {self.output_path}")

        # Check if directories exist
        paths_to_check = [
            (self.templeos_build_output_path, "Pre-Built TempleOS"),
            (self.additions_path, "Additional scripts"),
            (self.output_path, "Output directory")
        ]
        
        for path, name in paths_to_check:
            if not os.path.isdir(path):
                messagebox.showerror("Error", f"{name} directory not found or inaccessible:\n{path}")
                print(f"Validation failed: {name} directory not found at {path}")
                return False
        
        # Specific check for the pre-built TempleOS directory structure
        # It should ideally contain ISOLINUX or BIN, ADAM folders
        expected_subdirs = ["ISOLINUX", "BIN", "ADAM"]
        found_expected = False
        for subdir in expected_subdirs:
            if os.path.isdir(os.path.join(self.templeos_build_output_path, subdir)):
                found_expected = True
                break
        
        if not found_expected:
            messagebox.showwarning("Warning", f"The selected 'Pre-Built TempleOS Directory' ({os.path.basename(self.templeos_build_output_path)}) does not appear to be a valid TempleOS 'C/' build output. It should contain subdirectories like ISOLINUX, BIN, ADAM. Please ensure you selected the correct directory.")
            print(f"Warning: Pre-built TempleOS path {self.templeos_build_output_path} lacks expected subdirectories.")
            # We don't return False here, as the user might know better, but it's a strong warning.

        print("Paths validated successfully.")
        return True

    def verify_boot_files_structure(self, base_dir):
        """Verifies the presence of essential boot files within the base_dir."""
        boot_bin_path = os.path.join(base_dir, "ISOLINUX", "ISOLINUX.BIN")
        boot_cat_path = os.path.join(base_dir, "ISOLINUX", "BOOT.CAT")
        
        print(f"Verifying boot file: {boot_bin_path}")
        if not os.path.isfile(boot_bin_path):
            messagebox.showerror("Error", f"Missing boot file for ISO creation:\n{boot_bin_path}\nPlease ensure the selected 'Pre-Built TempleOS Directory' is correct and contains a valid 'ISOLINUX' subdirectory with 'ISOLINUX.BIN'.")
            print(f"Verification failed: {boot_bin_path} not found.")
            return False
        
        print(f"Verifying boot catalog: {boot_cat_path}")
        if not os.path.isfile(boot_cat_path):
            messagebox.showerror("Error", f"Missing boot catalog for ISO creation:\n{boot_cat_path}\nPlease ensure the selected 'Pre-Built TempleOS Directory' is correct and contains a valid 'ISOLINUX' subdirectory with 'BOOT.CAT'.")
            print(f"Verification failed: {boot_cat_path} not found.")
            return False
        
        print("Boot files verified successfully.")
        return True

    def check_iso_tool(self):
        """Checks for the presence and version of mkisofs or genisoimage."""
        iso_tool = ""
        system = platform.system()
        self.update_progress(60, "Checking for ISO creation tool...")
        print("Attempting to find ISO creation tool...")
        
        try:
            result = None
            if system == "Windows":
                print("Detected Windows. Checking for 'mkisofs'...")
                result = subprocess.run(["mkisofs", "-version"], check=True, capture_output=True, text=True, creationflags=subprocess.CREATE_NO_WINDOW)
                iso_tool = "mkisofs"
                version_match = re.search(r"mkisofs (\d+\.\d+)", result.stdout)
            else:
                print(f"Detected {system}. Checking for 'genisoimage'...")
                result = subprocess.run(["genisoimage", "--version"], check=True, capture_output=True, text=True)
                iso_tool = "genisoimage"
                version_match = re.search(r"genisoimage (\d+\.\d+)", result.stdout)
            
            print(f"ISO tool '{iso_tool}' found. Version check output:\n{result.stdout.strip()}")
            if version_match:
                version_str = version_match.group(1)
                print(f"Parsed {iso_tool} version: {version_str}")
                try:
                    version_num = float(version_str)
                    if version_num < 1.1:
                        messagebox.showerror("Error", f"{iso_tool} version too old ({version_str}). Requires version 1.1 or later for compatibility.")
                        print(f"Error: {iso_tool} version {version_str} is too old. Required >= 1.1.")
                        return None, None
                except ValueError:
                    messagebox.showwarning("Warning", f"Could not parse {iso_tool} version: {version_str}")
                    print(f"Warning: Could not parse {iso_tool} version string '{version_str}'.")
            else:
                messagebox.showwarning("Warning", f"Could not determine {iso_tool} version from output.")
                print(f"Warning: Could not find version string in {iso_tool} output.")
        except FileNotFoundError:
            install_cmd = "Install cdrtools (e.g., via Chocolatey 'choco install cdrtools')" if system == "Windows" else "sudo apt install genisoimage" if system == "Linux" else "brew install genisoimage" if system == "Darwin" else ""
            messagebox.showerror("Error", f"ISO creation tool not found ({iso_tool})!\nPlease install it:\n{install_cmd}")
            print(f"Error: ISO creation tool '{iso_tool}' not found. Please install with: {install_cmd}")
            return None, None
        except subprocess.CalledProcessError as e:
            messagebox.showerror("Error", f"Error running ISO tool check: {e.stderr.strip()}")
            print(f"Error running '{iso_tool} --version' command. Exit code: {e.returncode}. Stderr: {e.stderr.strip()}")
            return None, None
        except Exception as e:
            messagebox.showerror("Error", f"An unexpected error occurred while checking ISO tool: {str(e)}")
            print(f"An unexpected error occurred while checking ISO tool: {str(e)}")
            return None, None
        
        print(f"ISO creation tool '{iso_tool}' successfully identified.")
        return iso_tool, None

    def clone_templeos_repo(self):
        """
        Clones or updates the TempleOS source repository.
        This now points to the main TOS-AGI repository for reference.
        The actual TempleOS build output (ISOLINUX, etc.) is still expected to be provided by the user
        from a manual build inside a VM.
        """
        # UPDATED REPO URL
        repo_url = "https://github.com/TaoishTechy/TOS-AGI.git"
        self.update_progress(5, f"Preparing TempleOS AGI source repository at '{self.templeos_repo_path}'...")
        print(f"Target repository path: {self.templeos_repo_path}")

        if os.path.exists(self.templeos_repo_path):
            if os.listdir(self.templeos_repo_path):
                try:
                    print(f"'{self.templeos_repo_path}' exists. Attempting to open as Git repository.")
                    repo = git.Repo(self.templeos_repo_path)
                    origin = repo.remotes.origin
                    self.update_progress(8, "Pulling latest changes from TempleOS AGI source repository...")
                    print("Performing 'git pull' on existing repository...")
                    origin.pull()
                    print("Git pull successful.")
                    self.update_progress(10, "Source Repository updated.")
                except git.InvalidGitRepositoryError:
                    print(f"'{self.templeos_repo_path}' is not a valid Git repository. Removing and re-cloning.")
                    messagebox.showwarning("Warning", f"'{self.templeos_repo_path}' is not a valid Git repository. It will be removed and re-cloned.")
                    shutil.rmtree(self.templeos_repo_path)
                    self.update_progress(10, "Cloning TempleOS AGI source repository (fresh clone)...")
                    print(f"Cloning '{repo_url}' to '{self.templeos_repo_path}'...")
                    git.Repo.clone_from(repo_url, self.templeos_repo_path)
                    print("Fresh clone successful.")
                except Exception as e:
                    print(f"Error during git pull: {str(e)}. Attempting to remove and re-clone.")
                    messagebox.showwarning("Warning", f"Failed to pull from '{self.templeos_repo_path}': {str(e)}. Attempting to remove and re-clone.")
                    shutil.rmtree(self.templeos_repo_path)
                    self.update_progress(10, "Cloning TempleOS AGI source repository (re-attempt)...")
                    print(f"Cloning '{repo_url}' to '{self.templeos_repo_path}'...")
                    git.Repo.clone_from(repo_url, self.templeos_repo_path)
                    print("Re-clone successful.")
            else:
                print(f"'{self.templeos_repo_path}' exists but is empty. Cloning into it.")
                self.update_progress(10, "Cloning TempleOS AGI source repository...")
                print(f"Cloning '{repo_url}' to '{self.templeos_repo_path}'...")
                git.Repo.clone_from(repo_url, self.templeos_repo_path)
                print("Clone successful into empty directory.")
        else:
            print(f"'{self.templeos_repo_path}' does not exist. Cloning repository.")
            self.update_progress(10, "Cloning TempleOS AGI source repository...")
            print(f"Cloning '{repo_url}' to '{self.templeos_repo_path}'...")
            git.Repo.clone_from(repo_url, self.templeos_repo_path)
            print("Fresh clone successful.")
        
        # Removed HolyC executable and main build script path checks
        # as host-side compilation is no longer performed.
        print(f"TempleOS AGI source repository cloned/updated successfully at {self.templeos_repo_path}.")
        self.update_progress(15, "Source Repository ready.")

    def copy_with_progress(self, src, dst, progress_start, progress_range):
        """
        Copies HolyC files from src to dst, updating progress.
        Only .hc files are copied to the "Additions" directory.
        """
        print(f"Starting copy from '{src}' to '{dst}' with progress range {progress_start}-{progress_start+progress_range}")
        
        # Basic memory check before starting large copy operations
        if psutil.virtual_memory().available < 500 * 1024 * 1024:
            print(f"Warning: Low system memory detected ({psutil.virtual_memory().available / (1024*1024):.2f}MB available).")
            if not messagebox.askyesno("Memory Warning", "Low system memory detected (<500MB available). Copying large directories might be slow or cause issues. Continue anyway?"):
                return False

        # Calculate total files for accurate progress bar
        total_files = sum(1 for root, _, files in os.walk(src) for file in files if file.lower().endswith(".hc"))
        if total_files == 0:
            print(f"No HolyC files found in '{src}' to copy.")
            return True
        print(f"Total HolyC files to copy: {total_files}")
        
        copied_files_count = 0
        for root, dirs, files in os.walk(src):
            relative_path = os.path.relpath(root, src)
            dest_dir = os.path.join(dst, relative_path)
            os.makedirs(dest_dir, exist_ok=True) # Ensure destination directory exists

            print(f"Processing directory for copy: {root} -> {dest_dir}")
            for file in files:
                src_file = os.path.join(root, file)
                dest_file = os.path.join(dest_dir, file)
                
                try:
                    # Only copy .hc files to the Additions directory
                    if file.lower().endswith(".hc"):
                        shutil.copy2(src_file, dest_file)
                        copied_files_count += 1
                        progress = progress_start + (copied_files_count / total_files) * progress_range
                        self.update_progress(min(progress, progress_start + progress_range), f"Copying {os.path.basename(file)} ({copied_files_count}/{total_files})")
                        print(f"Copied HolyC script: {src_file} to {dest_file}")
                    else:
                        print(f"Skipping non-.hc file in additions: {src_file}")
                except Exception as e:
                    messagebox.showerror("Error", f"Failed to copy {src_file}:\n{str(e)}")
                    print(f"Error copying '{src_file}': {str(e)}")
                    return False
        
        print(f"Finished copying files. Total copied HolyC files: {copied_files_count}")
        return True

    def create_fusion(self):
        """Main function to orchestrate the ISO creation process."""
        print("\n--- Starting TempleOS Fusion Creation Process ---")
        
        # Step 0: Validate User Input Paths
        if not self.validate_paths():
            print("Path validation failed. Aborting.")
            return

        self.iso_label = self.iso_entry.get().strip() or "TempleOS_Fused"
        iso_path = os.path.join(self.output_path, f"{self.iso_label}.iso")
        print(f"Output ISO will be generated at: {iso_path}")

        # Check for existing ISO and prompt for overwrite
        if os.path.exists(iso_path):
            print(f"Existing ISO detected at '{iso_path}'. Prompting user for overwrite.")
            if not messagebox.askyesno("Confirm", f"ISO file already exists:\n{iso_path}\nOverwrite?"):
                self.update_progress(0, "Cancelled by user.")
                print("User cancelled: ISO overwrite not permitted.")
                return
            else:
                print("User confirmed: Overwriting existing ISO.")
        
        try:
            # Step 1: Clone/Update TempleOS Source Repository (for reference, not host-side build)
            # This step is mostly for ensuring the TOS-AGI repo is available for general reference,
            # but the actual TempleOS build for ISO creation is expected from the user.
            print("\n--- Step 1: Cloning/Updating TempleOS AGI Source Repository (for reference) ---")
            self.clone_templeos_repo()
            print("TempleOS AGI source repository is ready (cloned/updated).")

            # Step 2: Use User-Provided Pre-Built TempleOS Output
            # This step is now manual for the user, and the script uses the result.
            final_iso_source_dir = self.templeos_build_output_path
            print(f"Using user-provided pre-built TempleOS directory as ISO source: {final_iso_source_dir}")

            # Step 3: Verifying Boot Files in the Pre-Built Structure
            self.update_progress(20, "Verifying boot files in pre-built TempleOS structure...")
            if not self.verify_boot_files_structure(final_iso_source_dir):
                print("Boot file verification failed in pre-built directory. Aborting.")
                messagebox.showerror("Error", "Boot files (ISOLINUX.BIN, BOOT.CAT) not found in the selected pre-built TempleOS directory. Please ensure you selected the correct 'C/' directory that was generated by a TempleOS VM build.")
                return
            print(f"Boot files confirmed present in pre-built TempleOS directory: {final_iso_source_dir}")

            # Step 4: Adding Additional Scripts
            self.update_progress(30, "Adding additional scripts...")
            # Determine the destination for user's additional scripts within the TempleOS structure
            # A common place is /Adam/Users/ or a new /Additions/ directory
            additions_dest = os.path.join(final_iso_source_dir, "ADAM", "USERS", "ADDITIONS") # Suggesting a common user script location
            os.makedirs(additions_dest, exist_ok=True) # Ensure the directory exists
            print(f"Additional scripts will be copied to: {additions_dest}")

            if not self.copy_with_progress(self.additions_path, additions_dest, 30, 40): # Adjust progress range
                print("Copying additional scripts failed. Aborting.")
                return
            self.update_progress(70, "Scripts added.") # Updated progress
            print("Additional scripts copied successfully.")

            # Step 5: Creating ISO Image
            self.update_progress(70, "Creating ISO image...") # Updated progress start
            iso_tool, _ = self.check_iso_tool()
            if not iso_tool:
                print("ISO creation tool not found or failed check. Aborting.")
                return
            
            # Construct relative paths for boot files
            boot_bin_rel = os.path.relpath(os.path.join(final_iso_source_dir, "ISOLINUX", "ISOLINUX.BIN"), final_iso_source_dir)
            boot_cat_rel = os.path.relpath(os.path.join(final_iso_source_dir, "ISOLINUX", "BOOT.CAT"), final_iso_source_dir)

            # ISO creation command. Ensure all paths are correct.
            cmd = [
                iso_tool,
                "-o", iso_path,
                "-b", boot_bin_rel, # Boot image path relative to final_iso_source_dir
                "-c", boot_cat_rel, # Boot catalog path relative to final_iso_source_dir
                "-no-emul-boot",
                "-boot-load-size", "4",
                "-boot-info-table",
                "-J", # Generate Joliet directory records
                "-r", # Generate Rock Ridge directory records
                "-V", self.iso_label, # Volume ID
                final_iso_source_dir # Source directory for the ISO
            ]
            
            self.status.config(text=f"Executing: {' '.join(cmd)}")
            print(f"\n--- ISO Creation Command Details ---")
            print(f"ISO Tool: {iso_tool}")
            print(f"Output ISO Path: {iso_path}")
            print(f"Relative Boot BIN Path: {boot_bin_rel}")
            print(f"Relative Boot CAT Path: {boot_cat_rel}")
            print(f"ISO Source Root (for {iso_tool}): {final_iso_source_dir}")
            print(f"Full command: {' '.join(cmd)}\n")

            # Execute ISO creation command with live output processing
            process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1)
            iso_creation_progress_start = 70 # Updated progress start
            iso_creation_progress_range = 30 # Updated progress range
            full_stdout = []
            full_stderr = []

            # Read stderr and stdout concurrently (important for some tools that use stderr for progress)
            # This loop reads line by line and updates progress if percentage is found
            for line in iter(process.stderr.readline, ''):
                full_stderr.append(line)
                match = re.search(r"(\d+\.\d+)%", line) # Look for percentage in output
                if match:
                    percent = float(match.group(1))
                    current_progress = iso_creation_progress_start + (percent / 100) * iso_creation_progress_range
                    self.update_progress(min(current_progress, 100), f"Creating ISO: {line.strip()}")
                else:
                    self.update_progress(self.progress['value'], f"Creating ISO: {line.strip()}")
                print(f"ISO Tool Output (stderr): {line.strip()}")

            for line in iter(process.stdout.readline, ''):
                full_stdout.append(line)
                print(f"ISO Tool Output (stdout): {line.strip()}")
            
            process.wait(timeout=600) # Wait for process to complete, with a timeout

            print(f"ISO creation process finished with return code: {process.returncode}")
            print(f"Final ISO creation STDOUT:\n{''.join(full_stdout).strip()}")
            print(f"Final ISO creation STDERR:\n{''.join(full_stderr).strip()}")

            if process.returncode != 0:
                error_msg = ''.join(full_stderr) or "Unknown error occurred during ISO creation."
                detailed_error = f"ISO creation failed with exit code {process.returncode}:\n{error_msg.strip()}\nStdout: {''.join(full_stdout).strip()}"
                raise Exception(detailed_error)

            self.update_progress(100, "Fusion complete!")
            messagebox.showinfo("Success", f"TempleOS Fusion ISO created successfully at:\n{iso_path}")
            print(f"SUCCESS: TempleOS Fusion ISO created at: {iso_path}")

        except subprocess.TimeoutExpired:
            print("Error: ISO creation timed out. Killing process.")
            if process.poll() is None: # Check if process is still running before killing
                process.kill()
            self.update_progress(0, "Failed: ISO creation timed out.")
            messagebox.showerror("Error", "ISO creation timed out. This might happen with very large directories or slow systems.")
        except Exception as e:
            print(f"General error during ISO creation: {str(e)}")
            messagebox.showerror("Error", f"Failed to create ISO:\n{str(e)}")
            self.update_progress(0, "Failed")
        finally:
            print("--- TempleOS Fusion Process Finished ---")
            self.cleanup() # Call cleanup regardless of success or failure
            self.progress['value'] = 0 # Reset progress bar
            self.status.config(text="Ready") # Reset status message

if __name__ == "__main__":
    root = tk.Tk()
    try:
        app = TempleOSFusion(root)
        root.mainloop()
    except Exception as e:
        messagebox.showerror("Fatal Error", f"Application crashed:\n{str(e)}\nCheck console for details.")
        import traceback
        traceback.print_exc()
