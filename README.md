```bash

                    $$$$$$$\                      $$\             $$$$$$$\  $$\ $$\            $$\     
                    $$  __$$\                     $$ |            $$  __$$\ \__|$$ |           $$ |    
                    $$ |  $$ |$$\   $$\  $$$$$$$\ $$$$$$$\        $$ |  $$ |$$\ $$ | $$$$$$\ $$$$$$\   
                    $$$$$$$  |$$ |  $$ |$$  _____|$$  __$$\       $$$$$$$  |$$ |$$ |$$  __$$\\_$$  _|  
                    $$  ____/ $$ |  $$ |\$$$$$$\  $$ |  $$ |      $$  ____/ $$ |$$ |$$ /  $$ | $$ |    
                    $$ |      $$ |  $$ | \____$$\ $$ |  $$ |      $$ |      $$ |$$ |$$ |  $$ | $$ |$$\ 
                    $$ |      \$$$$$$  |$$$$$$$  |$$ |  $$ |      $$ |      $$ |$$ |\$$$$$$  | \$$$$  |
                    \__|       \______/ \_______/ \__|  \__|      \__|      \__|\__| \______/   \____/ 
```

# Intro 🚀

Push Pilot is a script that automates the creation of a GitHub repository and pushes local project files to the newly created repository. It helps streamline the process of initializing a new GitHub repository and pushing your project to GitHub with minimal effort.

## Why Push Pilot? 🚀

There were many times when I worked on a project but **forgot to create a repository on GitHub**.  
My usual process looked something like this:

1. Go to my GitHub profile.
2. Create a new repository with the project name.
3. Clone the repo to my PC.
4. Copy-paste my project files into the cloned repo.
5. Run `git add`, `git commit`, and `git push`.

All of this felt **repetitive and like a hassle**, especially when done frequently.  
That’s why I created this script — **Push Pilot** — to automate the entire workflow so that everything can be done **directly from the terminal**.


## Features

- Create a new GitHub repository with a custom name.
- Optionally make the repository private.
- Optionally create a `README.md` file during repository creation.
- Initialize a local Git repository (if the directory is not already a Git repository).
- Commit local files and push them to the newly created GitHub repository.
- Handles empty or invalid directories gracefully by defaulting to the current working directory if no valid directory is provided.

## Requirements

- Python 3.x
- `github` library (`pip install github`)

# Installation and Usage

## Installation

1. Clone this repository to your PC using terminal:

    ```bash
    git clone https://github.com/mahatabul/push_pilot.git
    ```

2. Give execution permission to `install.sh`:

    ```bash
    chmod +x install.sh
    ```

3. Run the installer:
   - For system-wide installation (requires sudo):

        ```bash
        sudo ./install.sh
        ```

   - For local user installation:

        ```bash
        ./install.sh
        ```

## Usage

1. After installation, you can run the script from anywhere by typing:

```bash
push_pilot
```
2. **Follow the prompts:**
    - **GitHub Token**: Enter your GitHub personal access token.
    - **Repository Name**: Enter the desired name for the new GitHub repository.
    - **Privacy Option**: Decide whether to make the repository private (`Y/N`).
    - **Create README**: Option to create a `README.md` file in the repository (`Y/N`).
    - **Project Directory**: Enter the path to the local directory containing the project files. If left empty, the script will use the current directory.

3. **The script will:**
    - Create a new GitHub repository.
    - Initialize a local Git repository (if not already initialized).
    - Commit and push your project files to GitHub.

4. **Check your new repository on GitHub!** The repository is now available at: `https://github.com/your-username/your-repo-name`.

## Uninstallation

1. Navigate to the cloned repository directory:
   ```bash
   cd push_pilot
   ```
2. Make the uninstall script executable:
   ```bash
   chmod +x uninstall.sh
   ```
3. Run the appropriate uninstall command:

    For system-wide installations (used sudo during install):
    ```bash
   sudo ./uninstall.sh
    ```

    For user-local installations:
    ```bash
    ./uninstall.sh
    ```
Confirm uninstallation when prompted

## Example

### Output:
```bash


$$$$$$$\                      $$\             $$$$$$$\  $$\ $$\            $$\     
$$  __$$\                     $$ |            $$  __$$\ \__|$$ |           $$ |    
$$ |  $$ |$$\   $$\  $$$$$$$\ $$$$$$$\        $$ |  $$ |$$\ $$ | $$$$$$\ $$$$$$\   
$$$$$$$  |$$ |  $$ |$$  _____|$$  __$$\       $$$$$$$  |$$ |$$ |$$  __$$\\_$$  _|  
$$  ____/ $$ |  $$ |\$$$$$$\  $$ |  $$ |      $$  ____/ $$ |$$ |$$ /  $$ | $$ |    
$$ |      $$ |  $$ | \____$$\ $$ |  $$ |      $$ |      $$ |$$ |$$ |  $$ | $$ |$$\ 
$$ |      \$$$$$$  |$$$$$$$  |$$ |  $$ |      $$ |      $$ |$$ |\$$$$$$  | \$$$$  |
\__|       \______/ \_______/ \__|  \__|      \__|      \__|\__| \______/   \____/ 


Enter your GitHub token: ************
Enter the name of your repo (no spaces): MyNewRepo
Make it Private? [Y/N]: N
Create a README.md file? [Y/N]: Y
Enter the full path to your local project directory: /path/to/your/project

✅ Repo 'MyNewRepo' created: https://github.com/your-username/MyNewRepo
❗ No project directory specified. Using the current directory.
🚀 Pushing to GitHub...
✅ Project files pushed to GitHub repo successfully!
####################################################################################################
[✓] Done!
