# Push Pilot

Push Pilot is a Python script that automates the creation of a GitHub repository and pushes local project files to the newly created repository. It helps streamline the process of initializing a new GitHub repository and pushing your project to GitHub with minimal effort.

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

## Usage

1. **Clone the script or copy it to your local machine.**

2. **Run the script:**
    ```bash
    python push_pilot.py
    ```

3. **Follow the prompts:**
    - **GitHub Token**: Enter your GitHub personal access token.
    - **Repository Name**: Enter the desired name for the new GitHub repository.
    - **Privacy Option**: Decide whether to make the repository private (`Y/N`).
    - **Create README**: Option to create a `README.md` file in the repository (`Y/N`).
    - **Project Directory**: Enter the path to the local directory containing the project files. If left empty, the script will use the current directory.

4. **The script will:**
    - Create a new GitHub repository.
    - Initialize a local Git repository (if not already initialized).
    - Commit and push your project files to GitHub.

5. **Check your new repository on GitHub!** The repository is now available at: `https://github.com/your-username/your-repo-name`.

## Example

### Output:
```bash
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
