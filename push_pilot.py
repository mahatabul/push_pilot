import os
import sys
import getpass
import subprocess
from github import Github
from time import sleep

# Color and styling constants
class Style:
    GREEN = "\033[0;32m"
    YELLOW = "\033[1;33m"
    RED = "\033[0;31m"
    BLUE = "\033[0;34m"
    CYAN = "\033[0;36m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"
    RESET = "\033[0m"

# ASCII Art with improved styling
ascii_art = rf"""
{Style.CYAN}{Style.BOLD}
$$$$$$$\                      $$\             $$$$$$$\  $$\ $$\            $$\     
$$  __$$\                     $$ |            $$  __$$\ \__|$$ |           $$ |    
$$ |  $$ |$$\   $$\  $$$$$$$\ $$$$$$$\        $$ |  $$ |$$\ $$ | $$$$$$\ $$$$$$\   
$$$$$$$  |$$ |  $$ |$$  _____|$$  __$$\       $$$$$$$  |$$ |$$ |$$  __$$\\_$$  _|  
$$  ____/ $$ |  $$ |\$$$$$$\  $$ |  $$ |      $$  ____/ $$ |$$ |$$ /  $$ | $$ |    
$$ |      $$ |  $$ | \____$$\ $$ |  $$ |      $$ |      $$ |$$ |$$ |  $$ | $$ |$$\ 
$$ |      \$$$$$$  |$$$$$$$  |$$ |  $$ |      $$ |      $$ |$$ |\$$$$$$  | \$$$$  |
\__|       \______/ \_______/ \__|  \__|      \__|      \__|\__| \______/   \____/ 
{Style.RESET}
"""

def clear_screen():
    """Clear the terminal screen"""
    os.system('cls' if os.name == 'nt' else 'clear')

def print_header():
    """Print the application header"""
    clear_screen()
    print(ascii_art)
    print(f"{Style.BLUE}{'='*80}{Style.RESET}\n")

def print_success(message):
    """Print a success message"""
    print(f"{Style.GREEN}✓ {message}{Style.RESET}")

def print_warning(message):
    """Print a warning message"""
    print(f"{Style.YELLOW}⚠ {message}{Style.RESET}")

def print_error(message):
    """Print an error message"""
    print(f"{Style.RED}✗ {message}{Style.RESET}")

def print_progress(message):
    """Print a progress message"""
    print(f"{Style.BLUE}↻ {message}...{Style.RESET}")

def validate_repo_name(name):
    """Validate repository name"""
    if not name:
        return "Repository name cannot be empty"
    if ' ' in name:
        return "Repository name cannot contain spaces"
    if not name.replace('-', '').replace('_', '').isalnum():
        return "Repository name can only contain alphanumeric characters, hyphens, and underscores"
    return None

def get_input(prompt, default=None, validator=None):
    """Get user input with optional default and validation"""
    while True:
        if default:
            response = input(f"{Style.BOLD}{prompt} [{default}]: {Style.RESET}").strip()
            if not response:
                response = default
        else:
            response = input(f"{Style.BOLD}{prompt}: {Style.RESET}").strip()
        
        if validator:
            error = validator(response)
            if error:
                print_error(error)
                continue
        return response

def get_yes_no(prompt, default=True):
    """Get yes/no input from user"""
    options = "Y/n" if default else "y/N"
    while True:
        response = input(f"{Style.BOLD}{prompt} [{options}]: {Style.RESET}").strip().lower()
        if not response:
            return default
        if response in ('y', 'yes'):
            return True
        if response in ('n', 'no'):
            return False
        print_error("Please enter 'y' or 'n'")

def spinning_cursor():
    """Yield a spinning cursor animation"""
    while True:
        for cursor in '|/-\\':
            yield cursor

def show_spinner(process_message, complete_message):
    """Show a spinner animation while processing"""
    spinner = spinning_cursor()
    print_progress(process_message)
    
    def spinner_thread():
        while not spinner_done:
            sys.stdout.write(next(spinner))
            sys.stdout.flush()
            sys.stdout.write('\b')
            sleep(0.1)
    
    spinner_done = False
    import threading
    t = threading.Thread(target=spinner_thread)
    t.start()
    
    try:
        yield
    finally:
        spinner_done = True
        t.join()
        sys.stdout.write(' \b')  # Clear the spinner
        print_success(complete_message)

def main():
    print_header()
    
    # GitHub authentication
    print(f"{Style.BOLD}GitHub Authentication{Style.RESET}")
    token = getpass.getpass(f"{Style.BOLD}Enter your GitHub token: {Style.RESET}")
    
    with show_spinner("Authenticating with GitHub", "Authentication successful"):
        try:
            g = Github(token)
            user = g.get_user()
        except Exception as e:
            print_error(f"Authentication failed: {str(e)}")
            return

    # Repository details
    print(f"\n{Style.BOLD}Repository Configuration{Style.RESET}")
    repo_name = get_input("Enter the name of your repo (no spaces)", validator=validate_repo_name)
    private = get_yes_no("Make it private?")
    create_readme = get_yes_no("Create a README.md file?")
    
    # Project directory
    project_dir = get_input("Enter the full path to your local project directory", default=os.getcwd())
    project_dir = os.path.expanduser(project_dir)
    
    if not os.path.isdir(project_dir):
        print_error(f"The specified directory '{project_dir}' does not exist")
        return
    
    if not os.listdir(project_dir):
        print_warning("The specified directory is empty")
        if not get_yes_no("Continue anyway?", default=False):
            return

    # Create repository
    with show_spinner("Creating GitHub repository", "Repository created successfully"):
        try:
            repo = user.create_repo(
                name=repo_name,
                private=private,
                auto_init=create_readme,
                description="Auto-created with Push Pilot"
            )
        except Exception as e:
            print_error(f"Failed to create repository: {str(e)}")
            return
    
    print(f"\n{Style.BOLD}Repository URL:{Style.RESET} {Style.UNDERLINE}{repo.html_url}{Style.RESET}\n")
    
    # Initialize and push project
    os.chdir(project_dir)
    
    commands = [
        (["git", "init"], "Initializing local git repository"),
        (["git", "add", "."], "Staging files"),
        (["git", "commit", "-m", "Initial commit"], "Creating initial commit"),
        (["git", "remote", "add", "origin", repo.clone_url], "Adding remote origin"),
        (["git", "branch", "-M", "main"], "Setting main branch")
    ]
    
    for cmd, message in commands:
        with show_spinner(message, f"{message} - Done"):
            try:
                subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            except subprocess.CalledProcessError as e:
                print_error(f"Command failed: {' '.join(cmd)}\nError: {e.stderr.decode().strip()}")
                return
    
    # Push to GitHub
    with show_spinner("Pushing to GitHub", "Push completed successfully"):
        try:
            subprocess.run(["git", "push", "-u", "origin", "main"], check=True, 
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            print_error(f"Push failed: {e.stderr.decode().strip()}")
            return
    
    print(f"\n{Style.GREEN}{Style.BOLD}✅ Success! Your project is now on GitHub.{Style.RESET}")
    print(f"{Style.BOLD}View your repository at:{Style.RESET} {Style.UNDERLINE}{repo.html_url}{Style.RESET}\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nOperation cancelled by user.")
        sys.exit(1)
