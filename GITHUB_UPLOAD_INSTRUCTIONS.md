# 🚀 How to Upload This Project to GitHub

Follow these steps exactly. Takes about **10 minutes** if you're doing it for the first time.

---

## PART A — One-time Setup (skip if already done)

### Step 1: Create a GitHub Account
1. Go to **https://github.com**
2. Click **Sign up** → fill your email, password, username
3. Verify your email

### Step 2: Install Git on your computer
- **Windows:** Download from https://git-scm.com/download/win → install with default options
- **Mac:** Open Terminal, type `git --version` → if not installed, it will prompt you
- **Linux:** `sudo apt install git`

### Step 3: Configure Git (one time only)
Open **Git Bash** (Windows) or **Terminal** (Mac/Linux) and run:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## PART B — Create the GitHub Repository

1. Go to **https://github.com** and log in
2. Click the **"+"** icon (top-right) → **"New repository"**
3. Fill in:
   - **Repository name:** `FakeNewsDetection`
   - **Description:** `Fake News Detection using ML & Deep Learning in MATLAB`
   - **Visibility:** Public *(so your professor can access it)*
   - ✅ Check **"Add a README file"** → **NO** (we already have one)
   - Leave everything else default
4. Click **"Create repository"**
5. **Copy the repository URL** shown on screen — it looks like:
   ```
   https://github.com/YOUR_USERNAME/FakeNewsDetection.git
   ```

---

## PART C — Upload Your Files

### Option 1: Using Git Command Line (Recommended)

Open **Git Bash / Terminal**, navigate to your project folder:

```bash
# 1. Go to the project folder
cd path/to/FakeNewsDetection
# Example Windows: cd C:/Users/YourName/Downloads/FakeNewsDetection
# Example Mac:     cd ~/Downloads/FakeNewsDetection

# 2. Initialize git
git init

# 3. Add all files
git add .

# 4. Commit
git commit -m "Initial commit: Fake News Detection MATLAB project"

# 5. Connect to GitHub (paste YOUR repo URL here)
git remote add origin https://github.com/YOUR_USERNAME/FakeNewsDetection.git

# 6. Push to GitHub
git branch -M main
git push -u origin main
```

When prompted, enter your **GitHub username** and **password** (or Personal Access Token).

> **Note on Password:** GitHub no longer accepts plain passwords for push.
> Use a **Personal Access Token** instead:
> 1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
> 2. Click "Generate new token" → check **repo** scope → copy the token
> 3. Use that token as your password when Git asks

---

### Option 2: Using GitHub Desktop (Easier for Beginners)

1. Download **GitHub Desktop** from https://desktop.github.com
2. Install and log in with your GitHub account
3. Click **"Add"** → **"Add existing repository"**
4. Browse to your `FakeNewsDetection` folder
5. Click **"Publish repository"** → make it **Public** → click Publish
6. Done! ✅

---

### Option 3: Direct Upload on GitHub Website (Simplest)

1. On your new empty repository page, click **"uploading an existing file"**
2. Drag and drop ALL files and folders from your `FakeNewsDetection/` folder
3. Scroll down → write commit message: `"Add MATLAB project files"`
4. Click **"Commit changes"**

> ⚠️ GitHub web upload doesn't support uploading folders with subfolders well.
> For the `+src/` folder, you may need to upload files one by one.
> **Recommended: Use Option 1 or 2 instead.**

---

## PART D — Share the Link with Your Professor

After uploading, your project link will be:
```
https://github.com/YOUR_USERNAME/FakeNewsDetection
```

**Example:**
```
https://github.com/john_doe/FakeNewsDetection
```

Submit this link to your professor. They can:
- Browse all files online
- Read the README
- Download the project with `git clone`

---

## PART E — Making Changes Later

If you update any files:
```bash
git add .
git commit -m "Update: describe what you changed"
git push
```

---

## ✅ Final Checklist Before Submitting

- [ ] Repository is **Public**
- [ ] `main.m` is visible in the root
- [ ] `+src/` folder has all 5 function files
- [ ] `README.md` looks good on the GitHub page
- [ ] Your **name** is updated in README.md
- [ ] Link opens correctly in a browser (incognito mode to test)

---

*Good luck with your project! 🎓*
