import os
import getpass
import subprocess
from github import Github

GREEN = "\033[0;32m"
RESET = "\033[0m"

ascii_art = r"""
$$$$$$$\                      $$\             $$$$$$$\  $$\ $$\            $$\     
$$  __$$\                     $$ |            $$  __$$\ \__|$$ |           $$ |    
$$ |  $$ |$$\   $$\  $$$$$$$\ $$$$$$$\        $$ |  $$ |$$\ $$ | $$$$$$\ $$$$$$\   
$$$$$$$  |$$ |  $$ |$$  _____|$$  __$$\       $$$$$$$  |$$ |$$ |$$  __$$\\_$$  _|  
$$  ____/ $$ |  $$ |\$$$$$$\  $$ |  $$ |      $$  ____/ $$ |$$ |$$ /  $$ | $$ |    
$$ |      $$ |  $$ | \____$$\ $$ |  $$ |      $$ |      $$ |$$ |$$ |  $$ | $$ |$$\ 
$$ |      \$$$$$$  |$$$$$$$  |$$ |  $$ |      $$ |      $$ |$$ |\$$$$$$  | \$$$$  |
\__|       \______/ \_______/ \__|  \__|      \__|      \__|\__| \______/   \____/ 
"""

print(f"{GREEN}{ascii_art}{RESET}")

# GitHub authentication
token = getpass.getpass("Enter your GitHub token: ")
g = Github(token)
user = g.get_user()

# Input details
repo_name = input("Enter the name of your repo (no spaces): ").strip()
private = input("Make it Private? [Y/N]: ").strip().lower() == 'y'
create_readme = input("Create a README.md file? [Y/N]: ").strip().lower() == 'y'
project_dir = input("Enter the full path to your local project directory: ").strip()

# Handle directory path
if project_dir:  # If directory is specified
    project_dir = os.path.expanduser(project_dir)  # Expand '~' to the full path
    if not os.path.isdir(project_dir):  # If the directory doesn't exist
        print(f"❌ The specified directory '{project_dir}' does not exist. Exiting without repo creation.")
        exit(1)
else:  # If no directory is specified, use current directory
    print("❗ No project directory specified. Using the current directory.")
    project_dir = os.getcwd()

# Check if directory is empty (only after we've determined it exists)
if not os.listdir(project_dir):  # If the directory is empty
    print(f"⚠️ The specified directory '{project_dir}' is empty. Proceeding anyway.")

# Create GitHub repo (only after all directory checks pass)
repo = user.create_repo(
    name=repo_name,
    private=private,
    auto_init=create_readme,
    description="Auto-created with script"
)
print(f"{GREEN}✅ Repo '{repo_name}' created: {repo.html_url}{RESET}")

# Initialize and push project files from the chosen directory
os.chdir(project_dir)
subprocess.run(["git", "init"])
subprocess.run(["git", "add", "."])
subprocess.run(["git", "commit", "-m", "Initial commit"])
subprocess.run(["git", "remote", "add", "origin", f"https://github.com/{user.login}/{repo_name}.git"])
subprocess.run(["git", "branch", "-M", "main"])

# Pull remote in case README or .gitignore was auto-created
print("🔄 Pulling remote changes to avoid push conflict...")
subprocess.run(["git", "pull", "--rebase", "origin", "main"])

# Push to GitHub
print("🚀 Pushing to GitHub...")
subprocess.run(["git", "push", "-u", "origin", "main"])

print(f"{GREEN}✅ Project files pushed to GitHub repo successfully!{RESET}")
print("#" * 100)
