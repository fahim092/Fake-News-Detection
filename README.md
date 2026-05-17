# 📰 Fake News Detection using Machine Learning & Deep Learning (MATLAB)

![MATLAB](https://img.shields.io/badge/MATLAB-R2021b%2B-orange?logo=mathworks)
![License](https://img.shields.io/badge/License-MIT-blue)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

A complete MATLAB implementation of a **Fake News Detection System** that compares classical Machine Learning algorithms with a Deep Learning (BiLSTM) approach for binary text classification (Real vs Fake news).

---

## 📌 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [How to Run](#how-to-run)
- [Dataset](#dataset)
- [Models](#models)
- [Results](#results)
- [Screenshots](#screenshots)
- [Authors](#authors)

---

## Overview

This project detects fake news articles using three classical ML classifiers and one Deep Learning model trained on text features. The pipeline includes:

1. **Text Preprocessing** — lowercasing, punctuation removal, tokenization
2. **TF-IDF Feature Extraction** — converts text to numerical vectors
3. **ML Model Training** — Naive Bayes, SVM, Decision Tree
4. **Deep Learning** — Bidirectional LSTM (BiLSTM) network
5. **Evaluation & Visualization** — accuracy, precision, recall, F1, confusion matrices

---

## ✨ Features

- ✅ Clean modular code using MATLAB namespaces (`+src` package)
- ✅ Custom TF-IDF implementation (no external toolbox required for ML models)
- ✅ Three classical ML classifiers compared side-by-side
- ✅ BiLSTM deep learning model (requires Deep Learning Toolbox)
- ✅ Automatic synthetic dataset generation if no CSV is provided
- ✅ Saves trained models to `/models/` for reuse
- ✅ Generates publication-quality plots saved to `/results/`
- ✅ Interactive prediction demo script

---

## 📁 Project Structure

```
FakeNewsDetection/
│
├── main.m                    ← Run this first (full pipeline)
├── predict_demo.m            ← Run after main.m to test custom text
│
├── +src/                     ← MATLAB package (source functions)
│   ├── loadAndPreprocess.m   ← Load data, clean text, train/test split
│   ├── extractFeatures.m     ← TF-IDF feature extraction
│   ├── trainMLModels.m       ← Naive Bayes, SVM, Decision Tree
│   ├── trainDeepLearning.m   ← BiLSTM model training
│   └── evaluateAndVisualize.m← Plots, confusion matrices, CSV export
│
├── data/
│   └── news_dataset.csv      ← (Place your dataset here — see below)
│
├── models/                   ← Saved trained models (auto-created)
├── results/                  ← Output plots and CSV (auto-created)
│
└── README.md
```

---

## ⚙️ Requirements

| Requirement | Version |
|---|---|
| MATLAB | R2021b or newer |
| Statistics and Machine Learning Toolbox | Required for ML models |
| Deep Learning Toolbox | Required for LSTM only |

> **Note:** If the Deep Learning Toolbox is unavailable, the system skips LSTM training and runs ML models only.

---

## 🚀 How to Run

### Step 1 — Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/FakeNewsDetection.git
cd FakeNewsDetection
```

### Step 2 — (Optional) Add your dataset
Place a CSV file at `data/news_dataset.csv` with this format:

```
text,label
"Scientists confirm vaccine safety in new study",0
"SHOCKING government conspiracy exposed!",1
```
- `label = 0` → Real News  
- `label = 1` → Fake News

> If no dataset is found, the system auto-generates 1000 synthetic examples.

### Step 3 — Open MATLAB and run
```matlab
% In MATLAB Command Window:
cd('path/to/FakeNewsDetection')
main        % Runs the full pipeline
```

### Step 4 — Run prediction demo
```matlab
predict_demo   % Tests sample headlines after training
```

---

## 📊 Dataset

You can download a real dataset from:
- [Kaggle: Fake and Real News Dataset](https://www.kaggle.com/clmentbisaillon/fake-and-real-news-dataset)
- [LIAR Dataset](https://paperswithcode.com/dataset/liar)

Rename/format the CSV as described above and place it in `data/`.

---

## 🤖 Models

| Model | Type | Notes |
|---|---|---|
| **Naive Bayes** | Classical ML | Fast, probabilistic baseline |
| **SVM (Linear)** | Classical ML | Strong linear classifier |
| **Decision Tree** | Classical ML | Interpretable tree model |
| **BiLSTM** | Deep Learning | Captures sequential text patterns |

---

## 📈 Results

After running `main.m`, check the `results/` folder for:

| File | Description |
|---|---|
| `accuracy_comparison.png` | Bar chart of model accuracies |
| `metrics_comparison.png` | Grouped bar: Acc, Prec, Recall, F1 |
| `confusion_matrices.png` | Confusion matrix for each model |
| `summary_results.csv` | All metrics in CSV format |

---

## 📸 Screenshots

> *(After running main.m, add screenshots of your plots here)*

---

## 👤 Authors

- **[Your Name]** — [Your GitHub Profile](https://github.com/YOUR_USERNAME)

---

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
